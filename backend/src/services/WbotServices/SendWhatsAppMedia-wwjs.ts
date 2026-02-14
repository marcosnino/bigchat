/**
 * SendWhatsAppMedia — Versão Completa
 *
 * Suporte a todos os tipos de mídia:
 * - Imagens com caption
 * - Áudio como PTT (voice note) — sendAudioAsVoice
 * - Vídeo com caption
 * - Documentos preservando nome original — sendMediaAsDocument
 * - Stickers (WebP) — sendMediaAsSticker
 * - Envio de mídia via URL
 * - Fallback: se envio inline falha, tenta como documento
 *
 * @version 3.0.0
 */

import path from "path";
import fs from "fs";
import { MessageMedia, MessageSendOptions } from "whatsapp-web.js";
import { getWbot } from "../../libs/wbot-wwjs";
import Ticket from "../../models/Ticket";
import Message from "../../models/Message";
import Contact from "../../models/Contact";
import { logger } from "../../utils/logger";
import CreateMessageService from "../MessageServices/CreateMessageService";
import formatBody from "../../helpers/Mustache";

const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");

// ─── Interface compatível com MessageController ────────────────
interface MediaData {
  media: Express.Multer.File;
  ticket: Ticket;
  body?: string;
}

// ─── Formatar número ──────────────────────────────────────────
const formatNumber = (number: string): string => {
  let formatted = number.replace(/[^\d]/g, "");
  if (!formatted.startsWith("55")) {
    formatted = `55${formatted}`;
  }
  return `${formatted}@c.us`;
};

// ─── Determinar tipo de mídia ─────────────────────────────────
const getMediaType = (mimetype: string): string => {
  if (mimetype.startsWith("image/") && mimetype !== "image/webp") return "image";
  if (mimetype === "image/webp") return "sticker";
  if (mimetype.startsWith("video/")) return "video";
  if (mimetype.startsWith("audio/")) return "audio";
  return "document";
};

// ─── Determinar opções de envio corretas ──────────────────────
const getMediaOptions = (
  mimetype: string,
  caption?: string
): MessageSendOptions => {
  const options: MessageSendOptions = {};

  // Áudio: enviar como voice note (bolinha verde no WhatsApp)
  if (mimetype.startsWith("audio/")) {
    options.sendAudioAsVoice = true;
    return options;
  }

  // Sticker (WebP)
  if (mimetype === "image/webp") {
    options.sendMediaAsSticker = true;
    return options;
  }

  // Imagem / Vídeo: enviar inline com caption
  if (mimetype.startsWith("image/") || mimetype.startsWith("video/")) {
    if (caption) options.caption = caption;
    return options;
  }

  // Demais: enviar como documento (preserva nome do arquivo)
  options.sendMediaAsDocument = true;
  if (caption) options.caption = caption;
  return options;
};

// ═══════════════════════════════════════════════════════════════
// ENVIO DE MÍDIA (chamado pelo MessageController)
// ═══════════════════════════════════════════════════════════════

const SendWhatsAppMedia = async ({
  media,
  ticket,
  body
}: MediaData): Promise<Message> => {
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

  // Localizar arquivo — multer grava em media.path (caminho absoluto)
  // Fallback: tentar media.path → publicFolder/filename → publicFolder/companyX/filename
  let filePath = media.path;

  if (!filePath || !fs.existsSync(filePath)) {
    filePath = path.join(publicFolder, media.filename);
  }
  if (!fs.existsSync(filePath)) {
    filePath = path.join(publicFolder, `company${ticket.companyId}`, media.filename);
  }
  if (!fs.existsSync(filePath)) {
    throw new Error(`Arquivo não encontrado. Tentou: ${media.path}, ${publicFolder}/${media.filename}`);
  }

  const mimetype = media.mimetype || "application/octet-stream";
  const mediaType = getMediaType(mimetype);

  // Criar MessageMedia do whatsapp-web.js
  const messageMedia = MessageMedia.fromFilePath(filePath);

  // Corrigir mimetype para áudios gravados (OGG/Opus)
  if (mimetype.includes("ogg") || mimetype.includes("opus")) {
    messageMedia.mimetype = "audio/ogg; codecs=opus";
  }

  // Caption formatado
  const caption = body ? formatBody(body, contact) : undefined;

  // Opções baseadas no tipo
  const options = getMediaOptions(mimetype, caption);

  logger.info(`[SendMedia] Enviando ${mediaType} (${mimetype}) para ${chatId}`);

  // ─── Enviar ────────────────────────────────────────
  let sentMessage;
  try {
    sentMessage = await wbot.sendMessage(chatId, messageMedia, options);
  } catch (err: any) {
    logger.warn(`[SendMedia] Falha no envio inline: ${err.message}`);

    // Fallback: tentar como documento
    if (!options.sendMediaAsDocument) {
      logger.info(`[SendMedia] Tentando fallback como documento...`);
      sentMessage = await wbot.sendMessage(chatId, messageMedia, {
        sendMediaAsDocument: true,
        caption: caption || media.originalname
      });
    } else {
      throw err;
    }
  }

  // ─── Criar registro no banco ───────────────────────
  const messageData = {
    id: sentMessage.id.id,
    ticketId: ticket.id,
    contactId: contact.id,
    body: body || media.originalname || mediaType,
    fromMe: true,
    read: true,
    mediaType,
    mediaUrl: media.filename,
    ack: sentMessage.ack || 0,
    companyId: ticket.companyId
  };

  const newMessage = await CreateMessageService({
    messageData,
    companyId: ticket.companyId
  });

  logger.info(`[SendMedia] Mídia enviada: ${newMessage.id} (${mediaType})`);

  return newMessage;
};

// ═══════════════════════════════════════════════════════════════
// ENVIO DE MÍDIA VIA URL
// ═══════════════════════════════════════════════════════════════

export const SendWhatsAppMediaFromUrl = async ({
  url,
  ticket,
  caption,
  filename
}: {
  url: string;
  ticket: Ticket;
  caption?: string;
  filename?: string;
}): Promise<Message> => {
  const wbot = getWbot(ticket.whatsappId);

  const contact = await Contact.findByPk(ticket.contactId);
  if (!contact) {
    throw new Error("Contato não encontrado");
  }

  const chatId = contact.isGroup
    ? `${contact.number}@g.us`
    : formatNumber(contact.number);

  // Baixar mídia da URL
  const messageMedia = await MessageMedia.fromUrl(url, {
    unsafeMime: true,
    filename
  });

  const formattedCaption = caption ? formatBody(caption, contact) : undefined;

  const options: MessageSendOptions = {
    caption: formattedCaption
  };

  logger.info(`[SendMediaUrl] Enviando mídia de URL para ${chatId}`);

  const sentMessage = await wbot.sendMessage(chatId, messageMedia, options);

  const mediaType = getMediaType(messageMedia.mimetype || "application/octet-stream");

  const messageData = {
    id: sentMessage.id.id,
    ticketId: ticket.id,
    contactId: contact.id,
    body: caption || filename || "Mídia",
    fromMe: true,
    read: true,
    mediaType,
    ack: sentMessage.ack || 0,
    companyId: ticket.companyId
  };

  const newMessage = await CreateMessageService({
    messageData,
    companyId: ticket.companyId
  });

  return newMessage;
};

export default SendWhatsAppMedia;
