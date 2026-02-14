import Whatsapp from "../../models/Whatsapp";
import Ticket from "../../models/Ticket";
import Message from "../../models/Message";
import MetaApiClient from "../../helpers/MetaApiClient";
import CreateMessageService from "../MessageServices/CreateMessageService";
import { getIO } from "../../libs/socket";
import { logger } from "../../utils/logger";
import formatBody from "../../helpers/Mustache";
import AppError from "../../errors/AppError";

interface SendMessageParams {
  body: string;
  ticket: Ticket;
  quotedMsgId?: string;
}

interface SendMessageResult {
  message: Message;
  metaMessageId: string;
}

/**
 * Serviço para enviar mensagens de texto via WhatsApp Cloud API (Meta)
 */
const MetaSendMessageService = async ({
  body,
  ticket,
  quotedMsgId,
}: SendMessageParams): Promise<SendMessageResult> => {
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

  // Formatar corpo da mensagem com variáveis
  const formattedBody = formatBody(body, ticket.contact);

  // Formatar número do contato
  const contactNumber = ticket.contact.number.replace(/\D/g, "");

  try {
    // Enviar mensagem via API Meta
    const response = await metaClient.sendTextMessage({
      to: contactNumber,
      text: formattedBody,
      previewUrl: true,
    });

    const metaMessageId = response.messages[0]?.id;

    if (!metaMessageId) {
      throw new AppError("ERR_META_SEND_MESSAGE_FAILED", 500);
    }

    logger.info(`[Meta] Mensagem enviada: ${metaMessageId} para ${contactNumber}`);

    // Criar mensagem no banco de dados
    const message = await CreateMessageService({
      messageData: {
        id: metaMessageId,
        body: formattedBody,
        fromMe: true,
        read: true,
        ticketId: ticket.id,
        contactId: ticket.contactId,
        ack: 1, // sent
      },
      companyId: ticket.companyId,
    });

    // Atualizar última mensagem do ticket
    await ticket.update({
      lastMessage: formattedBody.substring(0, 255),
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
    logger.error("[Meta] Erro ao enviar mensagem:", error.message);
    throw new AppError(`ERR_META_SEND_MESSAGE: ${error.message}`, 500);
  }
};

export default MetaSendMessageService;
