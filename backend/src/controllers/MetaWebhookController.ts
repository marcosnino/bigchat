import { Request, Response } from "express";
import crypto from "crypto";
import Whatsapp from "../models/Whatsapp";
import MetaWebhookService from "../services/MetaServices/MetaWebhookService";

/**
 * Controller para receber webhooks da API WhatsApp Cloud (Meta)
 */

// Valida a assinatura do webhook
const validateSignature = (
  payload: string,
  signature: string,
  appSecret: string
): boolean => {
  if (!signature || !appSecret) return false;

  const expectedSignature = crypto
    .createHmac("sha256", appSecret)
    .update(payload)
    .digest("hex");

  const signatureHash = signature.replace("sha256=", "");
  return crypto.timingSafeEqual(
    Buffer.from(signatureHash),
    Buffer.from(expectedSignature)
  );
};

/**
 * GET - Verificação do webhook (challenge)
 * A Meta envia um GET para verificar o endpoint
 */
export const verifyWebhook = async (
  req: Request,
  res: Response
): Promise<Response> => {
  try {
    const mode = req.query["hub.mode"];
    const token = req.query["hub.verify_token"];
    const challenge = req.query["hub.challenge"];

    console.log("[Meta Webhook] Verificação recebida:", { mode, token });

    if (mode !== "subscribe") {
      console.log("[Meta Webhook] Mode inválido:", mode);
      return res.status(403).send("Forbidden");
    }

    // Buscar whatsapp pelo verify token
    const whatsapp = await Whatsapp.findOne({
      where: {
        webhookVerifyToken: token,
        provider: "meta",
      },
    });

    if (!whatsapp) {
      console.log("[Meta Webhook] Token não encontrado:", token);
      return res.status(403).send("Forbidden - Invalid verify token");
    }

    console.log("[Meta Webhook] Verificação OK para:", whatsapp.name);
    return res.status(200).send(challenge);
  } catch (error) {
    console.error("[Meta Webhook] Erro na verificação:", error);
    return res.status(500).send("Internal Server Error");
  }
};

/**
 * POST - Recebimento de mensagens e status
 */
export const receiveWebhook = async (
  req: Request,
  res: Response
): Promise<Response> => {
  try {
    // Responder imediatamente com 200 (requerido pela Meta)
    res.status(200).send("EVENT_RECEIVED");

    const body = req.body;

    // Validar estrutura básica
    if (body.object !== "whatsapp_business_account") {
      console.log("[Meta Webhook] Object inválido:", body.object);
      return;
    }

    // Processar cada entry
    for (const entry of body.entry || []) {
      const businessAccountId = entry.id;

      for (const change of entry.changes || []) {
        if (change.field !== "messages") continue;

        const value = change.value;
        const phoneNumberId = value.metadata?.phone_number_id;
        const displayPhoneNumber = value.metadata?.display_phone_number;

        // Buscar conexão WhatsApp pelo phoneNumberId
        const whatsapp = await Whatsapp.findOne({
          where: {
            phoneNumberId,
            provider: "meta",
          },
        });

        if (!whatsapp) {
          console.log(
            "[Meta Webhook] WhatsApp não encontrado para phoneNumberId:",
            phoneNumberId
          );
          continue;
        }

        // Processar mensagens recebidas
        if (value.messages && value.messages.length > 0) {
          for (const message of value.messages) {
            await MetaWebhookService.handleIncomingMessage({
              whatsapp,
              message,
              contacts: value.contacts,
            });
          }
        }

        // Processar atualizações de status
        if (value.statuses && value.statuses.length > 0) {
          for (const status of value.statuses) {
            await MetaWebhookService.handleStatusUpdate({
              whatsapp,
              status,
            });
          }
        }
      }
    }
  } catch (error) {
    console.error("[Meta Webhook] Erro ao processar webhook:", error);
  }

  return;
};

export default {
  verifyWebhook,
  receiveWebhook,
};
