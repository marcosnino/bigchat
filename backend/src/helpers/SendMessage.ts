import Whatsapp from "../models/Whatsapp";
import GetWhatsappWbot from "./GetWhatsappWbot";
import MetaApiClient from "./MetaApiClient";
import fs from "fs";
import path from "path";
import mime from "mime-types";

import { getMessageOptions } from "../services/WbotServices/SendWhatsAppMedia";

export type MessageData = {
  number: number | string;
  body: string;
  mediaPath?: string;
  fileName?: string;
};

/**
 * Envia mensagem via Baileys (WhatsApp Web não-oficial)
 */
const sendViaBaileys = async (
  whatsapp: Whatsapp,
  messageData: MessageData
): Promise<any> => {
  const wbot = await GetWhatsappWbot(whatsapp);
  const chatId = `${messageData.number}@s.whatsapp.net`;

  let message;

  if (messageData.mediaPath) {
    const options = await getMessageOptions(
      messageData.fileName,
      messageData.mediaPath,
      messageData.body
    );
    if (options) {
      const body = fs.readFileSync(messageData.mediaPath);
      message = await wbot.sendMessage(chatId, {
        ...options
      });
    }
  } else {
    const body = `\u200e ${messageData.body}`;
    message = await wbot.sendMessage(chatId, body);
  }

  return message;
};

/**
 * Envia mensagem via Meta WhatsApp Cloud API
 */
const sendViaMeta = async (
  whatsapp: Whatsapp,
  messageData: MessageData
): Promise<any> => {
  if (!whatsapp.phoneNumberId || !whatsapp.accessToken) {
    throw new Error("Meta API credentials not configured");
  }

  const metaClient = new MetaApiClient({
    accessToken: whatsapp.accessToken,
    phoneNumberId: whatsapp.phoneNumberId,
    apiVersion: whatsapp.metaApiVersion || "v18.0",
  });

  const contactNumber = String(messageData.number).replace(/\D/g, "");

  if (messageData.mediaPath) {
    // Enviar mídia
    const mimeType = mime.lookup(messageData.mediaPath) || "application/octet-stream";
    
    // Determinar tipo de mídia
    let mediaType: "image" | "video" | "audio" | "document" | "sticker" = "document";
    if (mimeType.startsWith("image/")) {
      mediaType = mimeType === "image/webp" ? "sticker" : "image";
    } else if (mimeType.startsWith("video/")) {
      mediaType = "video";
    } else if (mimeType.startsWith("audio/")) {
      mediaType = "audio";
    }

    // Upload da mídia
    const uploadResponse = await metaClient.uploadMedia(messageData.mediaPath, mimeType);
    
    // Enviar mensagem com mídia
    const response = await metaClient.sendMediaMessage({
      to: contactNumber,
      type: mediaType,
      mediaId: uploadResponse.id,
      caption: messageData.body,
      filename: messageData.fileName,
    });

    return response;
  } else {
    // Enviar texto
    const response = await metaClient.sendTextMessage({
      to: contactNumber,
      text: messageData.body,
      previewUrl: true,
    });

    return response;
  }
};

/**
 * Envia mensagem roteando automaticamente entre Baileys e Meta
 */
export const SendMessage = async (
  whatsapp: Whatsapp,
  messageData: MessageData
): Promise<any> => {
  try {
    // Rotear baseado no provider
    if (whatsapp.provider === "meta") {
      return await sendViaMeta(whatsapp, messageData);
    } else {
      // Default: Baileys (stable, baileys, ou vazio)
      return await sendViaBaileys(whatsapp, messageData);
    }
  } catch (err: any) {
    throw new Error(err);
  }
};
