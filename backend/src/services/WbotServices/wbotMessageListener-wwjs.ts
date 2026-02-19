/**
 * WhatsApp Web.js Message Listener — Versão Completa
 *
 * Suporte total a:
 * - Texto, imagens, áudio/PTT, vídeo, documentos, stickers
 * - vCards, localização, mensagens citadas (reply)
 * - Confirmação de entrega (ACK ✓✓✓)
 * - Mensagens revogadas/apagadas
 * - Reações a mensagens
 * - Mensagens enviadas por mim (message_create fromMe)
 * - Grupos com filtro configurável
 * - Download de mídia com retry e backoff
 * - Importação de histórico de conversas
 * - Proteção contra duplicatas (upsert)
 * - Fallback robusto para contatos LID/inexistentes
 *
 * @version 3.0.0
 */

import path from "path";
import { promisify } from "util";
import { writeFile, mkdir } from "fs";
import fs from "fs";
import * as Sentry from "@sentry/node";
import {
  Message,
  MessageMedia,
  Chat,
  Contact as WWJSContact
} from "whatsapp-web.js";
import { extension as mimeExtension } from "mime-types";

import { WWJSSession } from "../../libs/wbot-wwjs";
import Contact from "../../models/Contact";
import Ticket from "../../models/Ticket";
import MessageModel from "../../models/Message";
import Setting from "../../models/Setting";

import { getIO } from "../../libs/socket";
import CreateMessageService from "../MessageServices/CreateMessageService";
import { logger } from "../../utils/logger";
import CreateOrUpdateContactService from "../ContactServices/CreateOrUpdateContactService";
import FindOrCreateTicketService from "../TicketServices/FindOrCreateTicketService";
import ShowWhatsAppService from "../WhatsappService/ShowWhatsAppService";
import FindOrCreateATicketTrakingService from "../TicketServices/FindOrCreateATicketTrakingService";
import formatBody from "../../helpers/Mustache";
import MessageSemaphoreService from "../MessageServices/MessageSemaphoreService";

const writeFileAsync = promisify(writeFile);
const mkdirAsync = promisify(mkdir);
const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");

// Set para rastrear mensagens sendo processadas (evita race conditions)
const processingMessages = new Set<string>();

export const isNumeric = (value: string): boolean => /^-?\d+$/.test(value);

// ═══════════════════════════════════════════════════════════════
// DOWNLOAD DE MÍDIA COM RETRY
// ═══════════════════════════════════════════════════════════════

const downloadMediaWithRetry = async (
  msg: Message,
  maxRetries: number = 3
): Promise<MessageMedia | null> => {
  let lastError: Error | null = null;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const media = await msg.downloadMedia();
      if (media) {
        logger.info(
          `[WWJS] Mídia baixada: ${media.mimetype} ` +
          `(${Math.round((media.data?.length || 0) / 1024)}KB) - tentativa ${attempt}`
        );
        return media;
      }
    } catch (err: any) {
      lastError = err;
      logger.warn(`[WWJS] Download mídia tentativa ${attempt}/${maxRetries}: ${err.message}`);

      if (attempt < maxRetries) {
        await new Promise(r => setTimeout(r, 1500 * attempt)); // backoff
      }
    }
  }

  logger.error(`[WWJS] Falha ao baixar mídia após ${maxRetries} tentativas: ${lastError?.message}`);
  return null;
};

// ═══════════════════════════════════════════════════════════════
// SALVAR MÍDIA NO DISCO
// ═══════════════════════════════════════════════════════════════

const saveMedia = async (
  media: MessageMedia,
  msgId: string,
  companyId: number
): Promise<{ savedFileName: string; mediaType: string }> => {
  // Determinar extensão
  let ext = mimeExtension(media.mimetype) || "bin";
  const mimetype = media.mimetype || "";

  // Correções específicas
  if (mimetype.includes("ogg") || mimetype.includes("opus")) {
    ext = "ogg";
  } else if (mimetype === "image/webp") {
    ext = "webp";
  }

  // Tipo de mídia
  let mediaType = "document";
  if (mimetype.startsWith("image/") && mimetype !== "image/webp") mediaType = "image";
  else if (mimetype === "image/webp") mediaType = "sticker";
  else if (mimetype.startsWith("video/")) mediaType = "video";
  else if (mimetype.startsWith("audio/")) mediaType = "audio";

  // Nome preservando original quando disponível
  const originalName = media.filename;
  const savedFileName = originalName
    ? `${Date.now()}-${originalName}`
    : `${Date.now()}-${msgId.substring(0, 12)}.${ext}`;

  // Criar pasta da empresa
  const companyDir = path.join(publicFolder, `company${companyId}`);
  if (!fs.existsSync(companyDir)) {
    await mkdirAsync(companyDir, { recursive: true });
  }

  const filePath = path.join(companyDir, savedFileName);
  await writeFileAsync(filePath, Buffer.from(media.data, "base64"));

  logger.info(`[WWJS] Mídia salva: ${savedFileName} (${mediaType})`);

  return { savedFileName, mediaType };
};

// ═══════════════════════════════════════════════════════════════
// EXTRAIR NÚMERO DE UM JID
// ═══════════════════════════════════════════════════════════════

const getContactNumber = (jid: string): string => {
  return jid
    .replace("@c.us", "")
    .replace("@g.us", "")
    .replace("@s.whatsapp.net", "")
    .replace("@lid", "");
};

const isGroupJid = (jid: string): boolean => {
  return jid?.endsWith("@g.us") === true;
};

// ═══════════════════════════════════════════════════════════════
// GERAR BODY LEGÍVEL PARA DIFERENTES TIPOS
// ═══════════════════════════════════════════════════════════════

const getReadableBody = (msg: Message): string => {
  if (msg.body) return msg.body;

  switch (msg.type) {
    case "vcard":
    case "multi_vcard": {
      const vCards = (msg as any).vCards || [];
      const firstCard = vCards[0] || (msg as any).body || "";
      const nameMatch = firstCard.match(/FN:(.*)/);
      const telMatch = firstCard.match(/TEL[^:]*:([\d+]+)/);
      return `📇 Contato: ${nameMatch?.[1] || "Contato"} ${telMatch?.[1] || ""}`;
    }
    case "location":
    case "live_location": {
      const loc = msg.location;
      if (loc) {
        const desc = (loc as any).description || `${loc.latitude}, ${loc.longitude}`;
        const mapLink = `https://maps.google.com/maps?q=${loc.latitude}%2C${loc.longitude}&z=17&hl=pt-BR`;
        // Formato pipe-delimited compatível com o frontend: image|link|description
        return `|${mapLink}|${desc}`;
      }
      return "📍 Localização compartilhada";
    }
    case "sticker":
      return "🏷️ Sticker";
    case "ptt":
    case "audio":
      return "🎵 Áudio";
    case "image":
      return "📷 Imagem";
    case "video":
      return "🎥 Vídeo";
    case "document":
      return "📄 Documento";
    default:
      return "";
  }
};

// ═══════════════════════════════════════════════════════════════
// VERIFICAR / CRIAR CONTATO
// ═══════════════════════════════════════════════════════════════

const verifyContact = async (
  rawContact: WWJSContact,
  companyId: number
): Promise<Contact> => {
  // Proteção contra contato inválido (LID, null, etc.)
  if (!rawContact?.id?._serialized) {
    throw new Error("Contact object is invalid or missing _serialized");
  }

  // Tentar obter foto do perfil silenciosamente
  let profilePicUrl = "";
  try {
    profilePicUrl = await rawContact.getProfilePicUrl() || "";
  } catch (e) {
    // Perfil privado — ignorar
  }

  const number = getContactNumber(rawContact.id._serialized);

  const contactData = {
    name: rawContact.pushname || rawContact.name || number,
    number,
    profilePicUrl,
    isGroup: rawContact.isGroup || false,
    companyId
  };

  return await CreateOrUpdateContactService(contactData);
};

const verifyGroupContact = async (
  chat: Chat,
  companyId: number
): Promise<Contact> => {
  let profilePicUrl = "";
  try {
    // getProfilePicUrl pode não existir em todos os types de Chat
    profilePicUrl = await (chat as any).getProfilePicUrl?.() || "";
  } catch (e) {}

  const contactData = {
    name: chat.name || `Grupo ${chat.id._serialized}`,
    number: getContactNumber(chat.id._serialized),
    profilePicUrl,
    isGroup: true,
    companyId
  };

  return await CreateOrUpdateContactService(contactData);
};

// ═══════════════════════════════════════════════════════════════
// OBTER CONTATO DE FORMA SEGURA (com fallback)
// ═══════════════════════════════════════════════════════════════

const getContactSafe = async (
  msg: Message
): Promise<WWJSContact | null> => {
  try {
    const contact = await msg.getContact();
    if (contact?.id?._serialized) return contact;
  } catch (err) {
    logger.warn(`[WWJS] getContact() falhou: ${err}`);
  }

  // Fallback: construir contato sintético a partir de msg.from
  if (msg.from) {
    const number = getContactNumber(msg.from);
    if (number) {
      return {
        id: { _serialized: msg.from, user: number, server: "c.us" },
        pushname: (msg as any)._data?.notifyName || number,
        name: (msg as any)._data?.notifyName || number,
        number,
        isGroup: isGroupJid(msg.from),
        isMyContact: false,
        isUser: true,
        isWAContact: true,
        getProfilePicUrl: async () => ""
      } as unknown as WWJSContact;
    }
  }

  return null;
};

// ═══════════════════════════════════════════════════════════════
// CRIAR MENSAGEM NO BANCO
// ═══════════════════════════════════════════════════════════════

const createMessage = async (
  msg: Message,
  ticket: Ticket,
  contact: Contact,
  companyId: number,
  mediaFileName?: string,
  mediaType?: string
): Promise<MessageModel | null> => {
  const body = getReadableBody(msg);

  // Buscar quoted message ID se existir
  let quotedMsgId: string | undefined;
  if (msg.hasQuotedMsg) {
    try {
      const quoted = await msg.getQuotedMessage();
      if (quoted?.id?.id) {
        const existing = await MessageModel.findOne({ where: { id: quoted.id.id } });
        if (existing) quotedMsgId = quoted.id.id;
      }
    } catch (e) {
      logger.debug(`[WWJS] Erro ao obter quoted msg: ${e}`);
    }
  }

  // Incluir prefixo da pasta da empresa no mediaUrl para que o getter
  // do modelo construa a URL correta: BACKEND_URL/public/company{id}/file
  const fullMediaUrl = mediaFileName
    ? `company${companyId}/${mediaFileName}`
    : undefined;

  const messageData = {
    id: msg.id.id,
    ticketId: ticket.id,
    contactId: msg.fromMe ? undefined : contact.id,
    body: body || (mediaFileName ? mediaFileName : ""),
    fromMe: msg.fromMe,
    read: msg.fromMe,
    mediaType: mediaType || (() => {
      if (msg.type === "location" || msg.type === "live_location") return "locationMessage";
      return msg.type || "chat";
    })(),
    mediaUrl: fullMediaUrl,
    ack: msg.ack,
    queueId: ticket.queueId || undefined
  };

  try {
    const created = await CreateMessageService({
      messageData,
      companyId
    });
    logger.info(`[WWJS | MESSAGE] Mensagem criada no banco: ${msg.id.id} - Tipo: ${messageData.mediaType} - fromMe: ${msg.fromMe}`);
    return created;
  } catch (err: any) {
    // SequelizeUniqueConstraintError → mensagem duplicada, ignorar
    if (err.name === "SequelizeUniqueConstraintError") {
      logger.warn(`[WWJS | MESSAGE] Mensagem ${msg.id.id} duplicada detectada, atualizando ACK apenas`);
      // Atualizar ACK se mudou
      await MessageModel.update(
        { ack: msg.ack },
        { where: { id: msg.id.id } }
      );
      return null;
    }
    throw err;
  }
};

// ═══════════════════════════════════════════════════════════════
// HANDLER PRINCIPAL DE MENSAGENS
// ═══════════════════════════════════════════════════════════════

const handleMessage = async (
  msg: Message,
  wbot: WWJSSession,
  companyId: number
): Promise<void> => {
  try {
    logger.info(`[WWJS | HANDLER] 📥 Nova mensagem recebida: ${msg.id.id} | From: ${msg.from} | Type: ${msg.type} | fromMe: ${msg.fromMe}`);
    
    // ─── Filtros iniciais ────────────────────────────
    if (
      msg.from === "status@broadcast" ||
      (msg as any).isStatus ||
      msg.type === "e2e_notification" ||
      msg.type === "notification_template" ||
      msg.type === "call_log" ||
      msg.type === "notification"
    ) {
      logger.debug(`[WWJS | HANDLER] ⏭️  Mensagem filtrada (tipo: ${msg.type})`);
      return;
    }

    // ─── Prevenir race condition com lock em memória ────
    const msgId = msg.id.id;
    if (processingMessages.has(msgId)) {
      logger.warn(`[WWJS | HANDLER] ⚠️  Mensagem ${msgId} já está sendo processada (race condition), ignorando`);
      return;
    }
    processingMessages.add(msgId);
    logger.debug(`[WWJS | HANDLER] 🔒 Lock adquirido para mensagem ${msgId}`);

    // Filtrar grupos
    const isGroup = isGroupJid(msg.from);
    if (isGroup) {
      logger.debug(`[WWJS | HANDLER] 👥 Mensagem de grupo detectada: ${msg.from}`);
      const groupSetting = await Setting.findOne({
        where: { companyId, key: "acceptGroupMessages" }
      });
      if (!groupSetting || groupSetting.value === "disabled") {
        logger.info(`[WWJS | HANDLER] ❌ Mensagens de grupo desabilitadas, ignorando`);
        return;
      }
    }

    // Verificar duplicata
    const existingMsg = await MessageModel.findOne({
      where: { id: msg.id.id }
    });
    if (existingMsg) {
      logger.warn(`[WWJS | HANDLER] ⚠️  Mensagem ${msg.id.id} duplicada no banco, ignorando`);
      return;
    }

    // ─── Obter WhatsApp do banco ─────────────────────
    let whatsapp;
    try {
      whatsapp = await ShowWhatsAppService(wbot.id!, companyId);
      logger.info(`[WWJS | HANDLER] 📱 WhatsApp encontrado: ${whatsapp.name} (ID: ${whatsapp.id})`);
    } catch (err) {
      logger.error(`[WWJS | HANDLER] ❌ WhatsApp ${wbot.id} não encontrado no banco`);
      return;
    }

    // ─── Obter contato ───────────────────────────────
    // Para mensagens fromMe, o contato relevante é o DESTINATÁRIO (msg.to)
    // Para mensagens recebidas, o contato relevante é o REMETENTE (msg.from)
    // Resolve LID (@lid) para número real via wbot.getContactById
    let msgContact: WWJSContact | null;

    if (msg.fromMe && !isGroup) {
      logger.info(`[WWJS | HANDLER] fromMe=true, buscando contato do destinatario: ${msg.to}`);
      
      // Tentar resolver via wbot.getContactById (resolve LID -> número real)
      try {
        const resolvedContact = await wbot.getContactById(msg.to);
        if (resolvedContact?.id?._serialized) {
          msgContact = resolvedContact;
          logger.info(`[WWJS | HANDLER] Contato resolvido via getContactById: ${resolvedContact.id._serialized} (${resolvedContact.pushname || resolvedContact.name || 'sem nome'})`);
        } else {
          msgContact = null;
        }
      } catch (err: any) {
        logger.warn(`[WWJS | HANDLER] getContactById falhou para ${msg.to}: ${err.message}`);
        msgContact = null;
      }

      // Fallback: tentar obter do chat
      if (!msgContact) {
        try {
          const chatForContact = await msg.getChat();
          const chatContact = (chatForContact as any)?.contact;
          if (chatContact?.id?._serialized) {
            msgContact = chatContact;
            logger.info(`[WWJS | HANDLER] Contato obtido via chat.contact: ${chatContact.id._serialized}`);
          }
        } catch (err2: any) {
          logger.warn(`[WWJS | HANDLER] chat.contact falhou: ${err2.message}`);
        }
      }

      // Último fallback: contato sintético
      if (!msgContact) {
        const toNumber = getContactNumber(msg.to);
        msgContact = {
          id: { _serialized: msg.to, user: toNumber, server: "c.us" },
          pushname: toNumber,
          name: toNumber,
          number: toNumber,
          isGroup: false,
          isMyContact: false,
          isUser: true,
          isWAContact: true,
          getProfilePicUrl: async () => ""
        } as unknown as WWJSContact;
        logger.info(`[WWJS | HANDLER] Usando contato sintetico: ${toNumber}`);
      }
    } else {
      msgContact = await getContactSafe(msg);
    }

    if (!msgContact) {
      logger.error(`[WWJS] Impossível obter contato de ${msg.fromMe ? msg.to : msg.from}, ignorando`);
      return;
    }

    // ─── Verificar/criar contato no banco ────────────
    let contact: Contact;
    let groupContact: Contact | undefined;

    if (isGroup) {
      const chat = await msg.getChat();
      groupContact = await verifyGroupContact(chat, companyId);
      contact = await verifyContact(msgContact, companyId);
    } else {
      contact = await verifyContact(msgContact, companyId);
    }

    // ─── Encontrar/criar ticket ──────────────────────
    const unreadCount = msg.fromMe ? 0 : 1;
    const ticket = await FindOrCreateTicketService(
      contact,
      whatsapp.id,
      unreadCount,
      companyId,
      groupContact
    );

    // ─── Tracking ────────────────────────────────────
    await FindOrCreateATicketTrakingService({
      ticketId: ticket.id,
      companyId,
      whatsappId: whatsapp.id
    });

    // ─── Saudação automática (novo ticket, mensagem do cliente) ──
    if (!msg.fromMe && !isGroup) {
      // Verificar se é ticket recém-criado (sem mensagens anteriores)
      const msgCount = await MessageModel.count({ where: { ticketId: ticket.id } });
      if (msgCount === 0 && whatsapp.greetingMessage && whatsapp.greetingMessage.trim()) {
        try {
          const formatted = formatBody(whatsapp.greetingMessage, contact);
          await wbot.sendMessage(msg.from, formatted);
        } catch (greetErr) {
          logger.warn(`[WWJS] Erro ao enviar saudação: ${greetErr}`);
        }
      }
    }

    // ─── Processar mídia ─────────────────────────────
    let mediaFileName: string | undefined;
    let mediaType: string | undefined;

    if (
      msg.hasMedia &&
      msg.type !== "vcard" &&
      msg.type !== "multi_vcard"
    ) {
      logger.info(`[WWJS | HANDLER] 📎 Baixando mídia (tipo: ${msg.type})...`);
      const media = await downloadMediaWithRetry(msg, 3);

      if (media) {
        const saved = await saveMedia(media, msg.id.id, companyId);
        mediaFileName = saved.savedFileName;
        mediaType = saved.mediaType;
        logger.info(`[WWJS | HANDLER] ✓ Mídia salva: ${mediaFileName} (${mediaType})`);
      } else {
        logger.warn(`[WWJS | HANDLER] ⚠️  Falha ao baixar mídia após 3 tentativas`);
      }
    }

    // ─── Criar mensagem no banco ─────────────────────
    const createdMessage = await createMessage(msg, ticket, contact, companyId, mediaFileName, mediaType);

    // ─── Processar semáforo (indicadores visuais) ────
    if (createdMessage) {
      logger.info(`[WWJS | SEMÁFORO] Processando mensagem ${createdMessage.id} - fromMe: ${msg.fromMe} - Ticket: ${ticket.id}`);
      await MessageSemaphoreService.processMessage({
        messageId: createdMessage.id,
        ticketId: ticket.id,
        fromMe: msg.fromMe,
        companyId
      }).catch(semErr => {
        logger.error(`[WWJS | SEMÁFORO] Erro ao processar semáforo: ${semErr.message}`);
        // Não bloqueia o fluxo se o semáforo falhar
      });
    }

    // ─── Atualizar ticket ────────────────────────────
    const lastMsg = getReadableBody(msg).substring(0, 255) ||
      (mediaFileName ? mediaFileName : "Mensagem");

    await ticket.update({
      lastMessage: lastMsg,
      unreadMessages: msg.fromMe
        ? ticket.unreadMessages
        : (ticket.unreadMessages || 0) + 1
    });

    // ─── Emitir via Socket.IO ────────────────────────
    const io = getIO();
    io.to(ticket.status)
      .to(`company-${companyId}-${ticket.id.toString()}`)
      .to(`company-${companyId}-mainchannel`)
      .emit(`company-${companyId}-ticket`, {
        action: "update",
        ticket
      });

    // ─── Marcar como lida no WhatsApp ────────────────
    if (!msg.fromMe) {
      try {
        const chat = await msg.getChat();
        await (chat as any).sendSeen();
      } catch (e) {
        // Ignorar
      }
    }

  } catch (err: any) {
    logger.error(`[WWJS] Erro ao processar mensagem: ${err.message}`);
    logger.error(`[WWJS] Stack: ${err.stack}`);
    Sentry.captureException(err);
  } finally {
    // Remover lock de processamento
    processingMessages.delete(msg.id.id);
  }
};

// ═══════════════════════════════════════════════════════════════
// HANDLER DE ACK (✓ ✓✓ ✓✓✓)
// ═══════════════════════════════════════════════════════════════

const handleMessageAck = async (msg: Message, ack: number): Promise<void> => {
  try {
    // ACK: -1=ERROR, 0=PENDING, 1=SENT, 2=RECEIVED, 3=READ, 4=PLAYED
    const [affected] = await MessageModel.update(
      { ack },
      { where: { id: msg.id.id } }
    );

    if (affected > 0) {
      const updatedMsg = await MessageModel.findOne({
        where: { id: msg.id.id },
        include: [
          { model: Ticket, as: "ticket" },
          { model: Contact, as: "contact" }
        ]
      });

      if (updatedMsg?.ticket) {
        const io = getIO();
        io.to(updatedMsg.ticket.id.toString())
          .to(`company-${updatedMsg.companyId}-mainchannel`)
          .emit(`company-${updatedMsg.companyId}-appMessage`, {
            action: "update",
            message: updatedMsg
          });
      }
    }
  } catch (err) {
    // Ignorar se mensagem não existe
  }
};

// ═══════════════════════════════════════════════════════════════
// HANDLER DE MENSAGEM REVOGADA / APAGADA
// ═══════════════════════════════════════════════════════════════

const handleMessageRevoke = async (
  revokedMsg: Message,
  _oldMsg: Message
): Promise<void> => {
  try {
    if (!revokedMsg?.id?.id) return;

    await MessageModel.update(
      {
        isDeleted: true,
        body: "🚫 Mensagem apagada"
      },
      { where: { id: revokedMsg.id.id } }
    );

    const message = await MessageModel.findOne({
      where: { id: revokedMsg.id.id },
      include: [{ model: Ticket, as: "ticket" }]
    });

    if (message?.ticket) {
      const io = getIO();
      io.to(message.ticket.id.toString())
        .to(`company-${message.companyId}-mainchannel`)
        .emit(`company-${message.companyId}-appMessage`, {
          action: "update",
          message
        });
    }

    logger.info(`[WWJS] Mensagem ${revokedMsg.id.id} marcada como apagada`);
  } catch (err) {
    logger.error(`[WWJS] Erro ao processar mensagem revogada: ${err}`);
  }
};

// ═══════════════════════════════════════════════════════════════
// HANDLER DE REAÇÃO
// ═══════════════════════════════════════════════════════════════

const handleMessageReaction = async (reaction: any): Promise<void> => {
  try {
    const msgId = reaction?.msgId?.id || reaction?.id?.id;
    if (!msgId) return;

    const message = await MessageModel.findOne({
      where: { id: msgId },
      include: [{ model: Ticket, as: "ticket" }]
    });

    if (message?.ticket) {
      const io = getIO();
      io.to(message.ticket.id.toString())
        .to(`company-${message.companyId}-mainchannel`)
        .emit(`company-${message.companyId}-appMessage`, {
          action: "update",
          message,
          reaction: reaction.reaction,
          senderId: reaction.senderId
        });

      logger.info(`[WWJS] Reação "${reaction.reaction}" na msg ${msgId}`);
    }
  } catch (err) {
    logger.debug(`[WWJS] Erro ao processar reação: ${err}`);
  }
};

// ═══════════════════════════════════════════════════════════════
// IMPORTAÇÃO DE HISTÓRICO
// ═══════════════════════════════════════════════════════════════

const importChatHistory = async (
  wbot: WWJSSession,
  companyId: number,
  maxChats: number = 30,
  maxMsgsPerChat: number = 15
): Promise<void> => {
  try {
    logger.info(`[WWJS] Iniciando importação de histórico para sessão ${wbot.id}`);

    const chats = await wbot.getChats();

    // Ordenar por atividade recente
    const sortedChats = chats
      .filter(c => !c.id._serialized.includes("status@broadcast"))
      .sort((a, b) => (b.timestamp || 0) - (a.timestamp || 0))
      .slice(0, maxChats);

    logger.info(`[WWJS] Processando ${sortedChats.length} chats`);

    let importedCount = 0;
    let processedChats = 0;

    for (const chat of sortedChats) {
      try {
        // Filtrar grupos se configuração pedir
        if (chat.isGroup) {
          const setting = await Setting.findOne({
            where: { companyId, key: "acceptGroupMessages" }
          });
          if (!setting || setting.value === "disabled") continue;
        }

        const messages = await chat.fetchMessages({ limit: maxMsgsPerChat });
        if (!messages.length) continue;

        // Da mais antiga para mais recente
        const sorted = messages.sort((a, b) => a.timestamp - b.timestamp);

        for (const msg of sorted) {
          try {
            if (msg.from === "status@broadcast" || (msg as any).isStatus) continue;

            // Verificar se já existe
            const exists = await MessageModel.findOne({ where: { id: msg.id.id } });
            if (exists) continue;

            await handleMessage(msg, wbot, companyId);
            importedCount++;
          } catch (msgErr) {
            logger.debug(`[WWJS] Erro ao importar msg ${msg.id.id}: ${msgErr}`);
          }
        }

        processedChats++;

        // sendSeen silencioso
        try {
          await (chat as any).sendSeen?.();
        } catch (e) {}
      } catch (chatErr) {
        logger.debug(`[WWJS] Erro ao processar chat: ${chatErr}`);
      }
    }

    logger.info(
      `[WWJS] Importação concluída: ${importedCount} mensagens de ${processedChats} chats`
    );
  } catch (err) {
    logger.error(`[WWJS] Erro na importação de histórico: ${err}`);
  }
};

// ═══════════════════════════════════════════════════════════════
// INICIALIZAR LISTENER (PONTO DE ENTRADA)
// ═══════════════════════════════════════════════════════════════

const wbotMessageListener = (
  wbot: WWJSSession,
  companyId: number
): void => {
  logger.info(`[WWJS] 🎧 Registrando listeners para sessão ${wbot.id}`);

  // ─── Remover listeners anteriores para evitar duplicação ────
  (wbot as any).removeAllListeners("message");
  (wbot as any).removeAllListeners("message_create");
  (wbot as any).removeAllListeners("message_ack");
  (wbot as any).removeAllListeners("message_revoke_everyone");
  (wbot as any).removeAllListeners("message_reaction");
  (wbot as any).removeAllListeners("group_join");
  (wbot as any).removeAllListeners("group_leave");
  logger.info(`[WWJS] 🧹 Listeners anteriores removidos`);

  // ─── Importar histórico ────────────────────────────
  importChatHistory(wbot, companyId, 30, 15).catch(err => {
    logger.error(`[WWJS] Erro ao importar histórico: ${err}`);
  });

  // ─── Mensagens recebidas ───────────────────────────
  wbot.on("message", async (msg: Message) => {
    logger.info(
      `[WWJS] 📩 msg recebida: type=${msg.type} from=${msg.from} ` +
      `body=${msg.body?.substring(0, 40) || "(mídia)"}`
    );
    await handleMessage(msg, wbot, companyId);
  });

  // ─── Mensagens criadas (inclui fromMe) ─────────────
  wbot.on("message_create", async (msg: Message) => {
    if (msg.fromMe) {
      logger.info(`[WWJS] 📤 msg enviada: type=${msg.type} to=${msg.to}`);
      await handleMessage(msg, wbot, companyId);
    }
  });

  // ─── ACK (confirmação de entrega) ──────────────────
  wbot.on("message_ack", async (msg: Message, ack: number) => {
    await handleMessageAck(msg, ack);
  });

  // ─── Mensagem revogada ─────────────────────────────
  wbot.on("message_revoke_everyone", async (revokedMsg: Message, oldMsg: Message) => {
    await handleMessageRevoke(revokedMsg, oldMsg);
  });

  // ─── Reação (wwjs >= 1.23) ─────────────────────────
  (wbot as any).on("message_reaction", async (reaction: any) => {
    await handleMessageReaction(reaction);
  });

  // ─── Grupo: participante ───────────────────────────
  (wbot as any).on("group_join", async (notification: any) => {
    logger.info(`[WWJS] Participante entrou: ${notification?.chatId}`);
  });

  (wbot as any).on("group_leave", async (notification: any) => {
    logger.info(`[WWJS] Participante saiu: ${notification?.chatId}`);
  });

  logger.info(`[WWJS] ✅ Todos os listeners registrados para sessão ${wbot.id}`);
};

export default wbotMessageListener;
