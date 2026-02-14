/**
 * StartWhatsAppSession Service
 * Inicia sessão do WhatsApp usando whatsapp-web.js
 * 
 * @author BigChat Development Team
 * @version 2.0.0
 */

import { initWASocket } from "../../libs/wbot-wwjs";
import Whatsapp from "../../models/Whatsapp";
import wbotMessageListener from "./wbotMessageListener-wwjs";
import { getIO } from "../../libs/socket";
import { logger } from "../../utils/logger";
import * as Sentry from "@sentry/node";

export const StartWhatsAppSession = async (
  whatsapp: Whatsapp,
  companyId: number
): Promise<void> => {
  const io = getIO();

  // Se for conexão via API Meta, não precisa de sessão WebSocket
  if (whatsapp.provider === "meta") {
    // Verifica se os campos obrigatórios estão preenchidos
    if (!whatsapp.phoneNumberId || !whatsapp.accessToken) {
      await whatsapp.update({ status: "DISCONNECTED" });
      io.to(`company-${whatsapp.companyId}-mainchannel`).emit(`company-${whatsapp.companyId}-whatsappSession`, {
        action: "update",
        session: whatsapp
      });
      throw new Error("Phone Number ID e Access Token são obrigatórios para conexão via API Meta");
    }

    await whatsapp.update({ status: "CONNECTED" });
    io.to(`company-${whatsapp.companyId}-mainchannel`).emit(`company-${whatsapp.companyId}-whatsappSession`, {
      action: "update",
      session: whatsapp
    });
    
    logger.info(`WhatsApp ${whatsapp.name} conectado via API Meta`);
    return;
  }

  // Conexão via WhatsApp Web (whatsapp-web.js)
  logger.info(`[StartSession] Iniciando sessão WhatsApp: ${whatsapp.name} (ID: ${whatsapp.id})`);
  
  await whatsapp.update({ status: "OPENING" });

  io.to(`company-${whatsapp.companyId}-mainchannel`).emit(`company-${whatsapp.companyId}-whatsappSession`, {
    action: "update",
    session: whatsapp
  });

  try {
    const wbot = await initWASocket(whatsapp);
    
    // Configurar listener de mensagens quando pronto
    if (wbot && wbot.isReady) {
      wbotMessageListener(wbot, companyId);
    }
    
    // Esperar evento ready para iniciar o listener
    wbot.on("ready", () => {
      wbotMessageListener(wbot, companyId);
    });
    
    logger.info(`[StartSession] Sessão ${whatsapp.name} inicializada com sucesso`);
  } catch (err) {
    Sentry.captureException(err);
    logger.error(`[StartSession] Erro ao iniciar sessão ${whatsapp.name}: ${err}`);
  }
};
