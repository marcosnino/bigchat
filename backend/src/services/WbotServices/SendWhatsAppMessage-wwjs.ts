/**
 * SendWhatsAppMessage — Versão Completa
 *
 * Suporte a:
 * - Texto simples e formatado
 * - Reply / citação de mensagem (quotedMessageId)
 * - Formatação Mustache ({{name}}, {{firstName}}, etc.)
 * - Validação de número
 *
 * @version 3.0.0
 */

import { MessageSendOptions } from "whatsapp-web.js";
import { getWbot } from "../../libs/wbot-wwjs";
import Ticket from "../../models/Ticket";
import Message from "../../models/Message";
import Contact from "../../models/Contact";
import { logger } from "../../utils/logger";
import CreateMessageService from "../MessageServices/CreateMessageService";
import formatBody from "../../helpers/Mustache";

// ─── Formatar número para envio ───────────────────────────────
const formatNumber = (number: string): string => {
  let formatted = number.replace(/[^\d]/g, "");
  if (!formatted.startsWith("55")) {
    formatted = `55${formatted}`;
  }
  return `${formatted}@c.us`;
};

// ═══════════════════════════════════════════════════════════════
// ENVIAR MENSAGEM DE TEXTO
// ═══════════════════════════════════════════════════════════════

const SendWhatsAppMessage = async ({
  body,
  ticket,
  quotedMsg
}: {
  body: string;
  ticket: Ticket;
  quotedMsg?: Message;
}): Promise<Message> => {
  const wbot = getWbot(ticket.whatsappId);

  // Obter contato
  const contact = await Contact.findByPk(ticket.contactId);
  if (!contact) {
    throw new Error("Contato não encontrado");
  }

  // Formatar chatId
  const chatId = contact.isGroup
    ? `${contact.number}@g.us`
    : formatNumber(contact.number);

  // Formatar corpo com Mustache
  const formattedBody = formatBody(body, contact);

  // Opções da mensagem
  const options: MessageSendOptions = {};

  // ─── Reply / Citação ───────────────────────────────
  if (quotedMsg) {
    try {
      // Método 1: usar quotedMessageId do dataJson
      if (quotedMsg.dataJson) {
        const quotedData = JSON.parse(quotedMsg.dataJson);
        if (quotedData.id) {
          options.quotedMessageId = quotedData.id._serialized || quotedData.id.id;
        }
      }

      // Método 2: fallback usando id direto (se dataJson não existe)
      if (!options.quotedMessageId && quotedMsg.id) {
        options.quotedMessageId = quotedMsg.id;
      }
    } catch (err) {
      logger.warn(`[SendMessage] Não foi possível citar mensagem: ${err}`);
    }
  }

  logger.info(`[SendMessage] Enviando para ${chatId}: "${formattedBody.substring(0, 50)}"`);

  // ─── Enviar ────────────────────────────────────────
  let sentMessage;
  try {
    sentMessage = await wbot.sendMessage(chatId, formattedBody, options);
  } catch (err: any) {
    logger.error(`[SendMessage] Erro ao enviar para ${chatId}: ${err.message}`);

    // Número não registrado
    if (err.message?.includes("number is not registered")) {
      throw new Error("ERR_WAPP_INVALID_CONTACT");
    }
    throw err;
  }

  // ─── Criar registro no banco ───────────────────────
  const messageData = {
    id: sentMessage.id.id,
    ticketId: ticket.id,
    contactId: contact.id,
    body: formattedBody,
    fromMe: true,
    read: true,
    mediaType: "chat",
    ack: sentMessage.ack || 0,
    companyId: ticket.companyId
  };

  const newMessage = await CreateMessageService({
    messageData,
    companyId: ticket.companyId
  });

  // Atualizar última mensagem do ticket
  await ticket.update({
    lastMessage: formattedBody.substring(0, 255)
  });

  logger.info(`[SendMessage] Mensagem enviada: ${newMessage.id}`);

  return newMessage;
};

export default SendWhatsAppMessage;
