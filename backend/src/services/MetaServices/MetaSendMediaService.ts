import path from "path";
import fs from "fs";
import Whatsapp from "../../models/Whatsapp";
import Ticket from "../../models/Ticket";
import Message from "../../models/Message";
import MetaApiClient from "../../helpers/MetaApiClient";
import CreateMessageService from "../MessageServices/CreateMessageService";
import { getIO } from "../../libs/socket";
import { logger } from "../../utils/logger";
import AppError from "../../errors/AppError";
import mime from "mime-types";

interface SendMediaParams {
  media: Express.Multer.File;
  ticket: Ticket;
  body?: string;
}

interface SendMediaResult {
  message: Message;
  metaMessageId: string;
}

/**
 * Determina o tipo de mídia para a API Meta
 */
const getMediaType = (mimeType: string): "image" | "video" | "audio" | "document" | "sticker" => {
  if (mimeType.startsWith("image/")) {
    if (mimeType === "image/webp") return "sticker";
    return "image";
  }
  if (mimeType.startsWith("video/")) return "video";
  if (mimeType.startsWith("audio/")) return "audio";
  return "document";
};

/**
 * Serviço para enviar mídia via WhatsApp Cloud API (Meta)
 */
const MetaSendMediaService = async ({
  media,
  ticket,
  body,
}: SendMediaParams): Promise<SendMediaResult> => {
  const whatsapp = await Whatsapp.findByPk(ticket.whatsappId);

  if (!whatsapp) {
    throw new AppError("ERR_NO_WHATSAPP_FOUND", 404);
  }

  if (whatsapp.provider !== "meta") {
    throw new AppError("ERR_WHATSAPP_NOT_META_PROVIDER", 400);
  }

  if (!whatsapp.phoneNumberId || !whatsapp.accessToken) {
    throw new AppError("ERR_META_CONFIG_MISSING", 400);
  }

  // Criar cliente da API Meta
  const metaClient = new MetaApiClient({
    accessToken: whatsapp.accessToken,
    phoneNumberId: whatsapp.phoneNumberId,
    apiVersion: whatsapp.metaApiVersion || "v18.0",
  });

  // Formatar número do contato
  const contactNumber = ticket.contact.number.replace(/\D/g, "");

  // Determinar tipo de mídia
  const mimeType = media.mimetype || mime.lookup(media.originalname) || "application/octet-stream";
  const mediaType = getMediaType(mimeType);

  try {
    // Fazer upload da mídia para a Meta
    const uploadResponse = await metaClient.uploadMedia(media.path, mimeType);
    const mediaId = uploadResponse.id;

    logger.info(`[Meta] Mídia uploaded: ${mediaId} (${mediaType})`);

    // Enviar mensagem com mídia
    const response = await metaClient.sendMediaMessage({
      to: contactNumber,
      type: mediaType,
      mediaId,
      caption: body,
      filename: mediaType === "document" ? media.originalname : undefined,
    });

    const metaMessageId = response.messages[0]?.id;

    if (!metaMessageId) {
      throw new AppError("ERR_META_SEND_MEDIA_FAILED", 500);
    }

    logger.info(`[Meta] Mídia enviada: ${metaMessageId} para ${contactNumber}`);

    // Salvar arquivo localmente
    const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");
    const companyFolder = path.join(publicFolder, `company${ticket.companyId}`);

    if (!fs.existsSync(companyFolder)) {
      fs.mkdirSync(companyFolder, { recursive: true });
    }

    const extension = path.extname(media.originalname) || `.${mime.extension(mimeType)}`;
    const filename = `${metaMessageId}${extension}`;
    const destPath = path.join(companyFolder, filename);

    // Copiar arquivo para pasta pública
    fs.copyFileSync(media.path, destPath);

    const mediaUrl = `public/company${ticket.companyId}/${filename}`;

    // Criar mensagem no banco de dados
    const messageBody = body || getMediaPlaceholder(mediaType, media.originalname);
    const message = await CreateMessageService({
      messageData: {
        id: metaMessageId,
        body: messageBody,
        fromMe: true,
        read: true,
        mediaUrl,
        mediaType,
        ticketId: ticket.id,
        contactId: ticket.contactId,
        ack: 1, // sent
      },
      companyId: ticket.companyId,
    });

    // Atualizar última mensagem do ticket
    await ticket.update({
      lastMessage: messageBody.substring(0, 255),
    });

    // Emitir via Socket.IO
    const io = getIO();
    io.to(ticket.id.toString())
      .to(`company-${ticket.companyId}-mainchannel`)
      .emit(`company-${ticket.companyId}-appMessage`, {
        action: "create",
        message,
        ticket,
        contact: ticket.contact,
      });

    return {
      message,
      metaMessageId,
    };
  } catch (error: any) {
    logger.error("[Meta] Erro ao enviar mídia:", error.message);
    throw new AppError(`ERR_META_SEND_MEDIA: ${error.message}`, 500);
  }
};

/**
 * Retorna placeholder para tipo de mídia
 */
const getMediaPlaceholder = (type: string, filename?: string): string => {
  const placeholders: Record<string, string> = {
    image: "📷 Imagem",
    video: "🎥 Vídeo",
    audio: "🎵 Áudio",
    document: `📄 ${filename || "Documento"}`,
    sticker: "🎨 Figurinha",
  };
  return placeholders[type] || "📎 Arquivo";
};

export default MetaSendMediaService;
