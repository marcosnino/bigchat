import * as Sentry from "@sentry/node";
import Whatsapp from "../../models/Whatsapp";
import Contact from "../../models/Contact";
import Message from "../../models/Message";
import Ticket from "../../models/Ticket";
import { getIO } from "../../libs/socket";
import CreateOrUpdateContactService from "../ContactServices/CreateOrUpdateContactService";
import FindOrCreateTicketService from "../TicketServices/FindOrCreateTicketService";
import CreateMessageService from "../MessageServices/CreateMessageService";
import UpdateTicketService from "../TicketServices/UpdateTicketService";
import FindOrCreateATicketTrakingService from "../TicketServices/FindOrCreateATicketTrakingService";
import MetaApiClient from "../../helpers/MetaApiClient";
import { logger } from "../../utils/logger";
import path from "path";
import fs from "fs";

interface MetaMessage {
  id: string;
  from: string;
  timestamp: string;
  type: string;
  text?: { body: string };
  image?: { id: string; caption?: string; mime_type?: string; sha256?: string };
  video?: { id: string; caption?: string; mime_type?: string; sha256?: string };
  audio?: { id: string; mime_type?: string; sha256?: string };
  document?: { id: string; filename?: string; caption?: string; mime_type?: string; sha256?: string };
  sticker?: { id: string; mime_type?: string; sha256?: string };
  location?: { latitude: number; longitude: number; name?: string; address?: string };
  contacts?: Array<{
    name: { formatted_name: string; first_name?: string; last_name?: string };
    phones: Array<{ phone: string; type: string }>;
  }>;
  button?: { text: string; payload: string };
  interactive?: {
    type: string;
    button_reply?: { id: string; title: string };
    list_reply?: { id: string; title: string; description?: string };
  };
  context?: { from: string; id: string };
  reaction?: { message_id: string; emoji: string };
}

interface MetaContact {
  profile: { name: string };
  wa_id: string;
}

interface MetaStatus {
  id: string;
  status: "sent" | "delivered" | "read" | "failed";
  timestamp: string;
  recipient_id: string;
  conversation?: {
    id: string;
    origin: { type: string };
    expiration_timestamp?: string;
  };
  errors?: Array<{ code: number; title: string; message: string }>;
}

interface HandleIncomingMessageParams {
  whatsapp: Whatsapp;
  message: MetaMessage;
  contacts?: MetaContact[];
}

interface HandleStatusUpdateParams {
  whatsapp: Whatsapp;
  status: MetaStatus;
}

/**
 * Serviço para processar eventos recebidos via webhook da Meta
 */
class MetaWebhookService {
  /**
   * Processa mensagem recebida
   */
  static async handleIncomingMessage(params: HandleIncomingMessageParams): Promise<void> {
    const { whatsapp, message, contacts } = params;

    try {
      logger.info(`[Meta] Mensagem recebida: ${message.type} de ${message.from}`);

      // Ignorar mensagens de grupos por enquanto
      if (message.from.includes("@g.us")) {
        logger.info("[Meta] Mensagem de grupo ignorada");
        return;
      }

      // Obter dados do contato
      const contactData = contacts?.find((c) => c.wa_id === message.from);
      const contactName = contactData?.profile?.name || message.from;

      // Criar ou atualizar contato
      const contact = await this.verifyContact(
        message.from,
        contactName,
        whatsapp.companyId,
        whatsapp.id
      );

      // Buscar ou criar ticket
      const ticket = await FindOrCreateTicketService(
        contact,
        whatsapp.id,
        0, // unreadMessages
        whatsapp.companyId
      );

      // Extrair corpo da mensagem
      const body = this.extractMessageBody(message);

      // Verificar se é mídia
      const mediaData = await this.handleMediaMessage(message, whatsapp);

      // Verificar mensagem citada
      const quotedMsgId = message.context?.id || null;
      let quotedMsg: Message | null = null;
      if (quotedMsgId) {
        quotedMsg = await Message.findOne({ where: { id: quotedMsgId } });
      }

      // Criar mensagem no banco
      const newMessage = await CreateMessageService({
        messageData: {
          id: message.id,
          body,
          fromMe: false,
          read: false,
          mediaUrl: mediaData?.mediaUrl,
          mediaType: mediaData?.mediaType,
          ticketId: ticket.id,
          contactId: contact.id,
        },
        companyId: whatsapp.companyId,
      });

      // Atualizar ticket
      await ticket.update({
        lastMessage: body.substring(0, 255),
        unreadMessages: ticket.unreadMessages + 1,
      });

      // Emit via Socket.IO
      const io = getIO();
      io.to(ticket.id.toString())
        .to(`company-${whatsapp.companyId}-mainchannel`)
        .emit(`company-${whatsapp.companyId}-appMessage`, {
          action: "create",
          message: newMessage,
          ticket,
          contact,
        });

      // Criar tracking se necessário
      await FindOrCreateATicketTrakingService({
        ticketId: ticket.id,
        companyId: whatsapp.companyId,
        whatsappId: whatsapp.id,
      });

      logger.info(`[Meta] Mensagem ${message.id} processada para ticket ${ticket.id}`);
    } catch (error) {
      Sentry.captureException(error);
      logger.error("[Meta] Erro ao processar mensagem:", error);
    }
  }

  /**
   * Processa atualização de status de mensagem
   */
  static async handleStatusUpdate(params: HandleStatusUpdateParams): Promise<void> {
    const { whatsapp, status } = params;

    try {
      logger.info(`[Meta] Status update: ${status.id} -> ${status.status}`);

      // Mapear status da Meta para ACK do sistema
      const ackMap: Record<string, number> = {
        sent: 1,
        delivered: 2,
        read: 3,
        failed: -1,
      };

      const ack = ackMap[status.status] ?? 0;

      // Atualizar mensagem
      const message = await Message.findOne({
        where: { id: status.id },
      });

      if (message) {
        await message.update({ ack });

        // Emit via Socket.IO
        const io = getIO();
        io.to(message.ticketId.toString())
          .to(`company-${whatsapp.companyId}-mainchannel`)
          .emit(`company-${whatsapp.companyId}-appMessage`, {
            action: "update",
            message,
          });

        logger.info(`[Meta] Mensagem ${status.id} atualizada para ack=${ack}`);
      }

      // Log de erro se falhou
      if (status.status === "failed" && status.errors) {
        for (const error of status.errors) {
          logger.error(`[Meta] Erro de envio: ${error.code} - ${error.title}: ${error.message}`);
        }
      }
    } catch (error) {
      Sentry.captureException(error);
      logger.error("[Meta] Erro ao processar status:", error);
    }
  }

  /**
   * Cria ou atualiza contato
   */
  private static async verifyContact(
    number: string,
    name: string,
    companyId: number,
    whatsappId: number
  ): Promise<Contact> {
    const profilePicUrl = `${process.env.FRONTEND_URL}/nopicture.png`;

    const contactData = {
      name: name || number,
      number: number.replace(/\D/g, ""),
      profilePicUrl,
      isGroup: false,
      companyId,
      whatsappId,
    };

    const contact = await CreateOrUpdateContactService(contactData);
    return contact;
  }

  /**
   * Extrai o corpo da mensagem baseado no tipo
   */
  private static extractMessageBody(message: MetaMessage): string {
    switch (message.type) {
      case "text":
        return message.text?.body || "";

      case "image":
        return message.image?.caption || "📷 Imagem";

      case "video":
        return message.video?.caption || "🎥 Vídeo";

      case "audio":
        return "🎵 Áudio";

      case "document":
        return message.document?.caption || `📄 ${message.document?.filename || "Documento"}`;

      case "sticker":
        return "🎨 Figurinha";

      case "location":
        return `📍 Localização: ${message.location?.name || ""} ${message.location?.address || ""}`.trim();

      case "contacts":
        const contactNames = message.contacts?.map((c) => c.name.formatted_name).join(", ");
        return `👤 Contato: ${contactNames}`;

      case "button":
        return message.button?.text || "";

      case "interactive":
        if (message.interactive?.button_reply) {
          return message.interactive.button_reply.title;
        }
        if (message.interactive?.list_reply) {
          return message.interactive.list_reply.title;
        }
        return "";

      case "reaction":
        return `Reação: ${message.reaction?.emoji}`;

      default:
        return "";
    }
  }

  /**
   * Processa mensagens de mídia (download e salva)
   */
  private static async handleMediaMessage(
    message: MetaMessage,
    whatsapp: Whatsapp
  ): Promise<{ mediaUrl: string; mediaType: string } | null> {
    const mediaTypes = ["image", "video", "audio", "document", "sticker"];

    if (!mediaTypes.includes(message.type)) {
      return null;
    }

    try {
      const mediaInfo = (message as any)[message.type];
      if (!mediaInfo?.id) return null;

      // Criar cliente da API Meta
      const metaClient = new MetaApiClient({
        accessToken: whatsapp.accessToken,
        phoneNumberId: whatsapp.phoneNumberId,
        apiVersion: whatsapp.metaApiVersion,
      });

      // Obter URL de download
      const mediaDetails = await metaClient.getMediaUrl(mediaInfo.id);

      // Fazer download
      const mediaBuffer = await metaClient.downloadMedia(
        mediaDetails.url,
        whatsapp.accessToken
      );

      // Determinar extensão
      const mimeType = mediaInfo.mime_type || mediaDetails.mime_type;
      const extension = this.getExtensionFromMimeType(mimeType);

      // Salvar arquivo
      const filename = `${message.id}.${extension}`;
      const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");
      const companyFolder = path.join(publicFolder, `company${whatsapp.companyId}`);

      // Criar pasta da empresa se não existir
      if (!fs.existsSync(companyFolder)) {
        fs.mkdirSync(companyFolder, { recursive: true });
      }

      const filePath = path.join(companyFolder, filename);
      fs.writeFileSync(filePath, mediaBuffer);

      const mediaUrl = `company${whatsapp.companyId}/${filename}`;

      return {
        mediaUrl,
        mediaType: message.type,
      };
    } catch (error) {
      logger.error("[Meta] Erro ao processar mídia:", error);
      return null;
    }
  }

  /**
   * Obtém extensão de arquivo a partir do mime type
   */
  private static getExtensionFromMimeType(mimeType: string): string {
    const mimeMap: Record<string, string> = {
      "image/jpeg": "jpg",
      "image/png": "png",
      "image/gif": "gif",
      "image/webp": "webp",
      "video/mp4": "mp4",
      "video/3gpp": "3gp",
      "audio/ogg": "ogg",
      "audio/mpeg": "mp3",
      "audio/amr": "amr",
      "audio/aac": "aac",
      "application/pdf": "pdf",
      "application/vnd.ms-excel": "xls",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "xlsx",
      "application/msword": "doc",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "docx",
    };

    return mimeMap[mimeType] || "bin";
  }
}

export default MetaWebhookService;
