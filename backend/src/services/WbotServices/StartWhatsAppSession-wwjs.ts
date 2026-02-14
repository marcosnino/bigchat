/**
 * StartWhatsAppSession — WhatsApp Web.js
 * Inicia sessão com QR Code e registra listener de mensagens UMA VEZ.
 *
 * @version 3.0.0
 */

import * as Sentry from "@sentry/node";
import { initWASocket, removeWbot } from "../../libs/wbot-wwjs";
import Whatsapp from "../../models/Whatsapp";
import { logger } from "../../utils/logger";
import { getIO } from "../../libs/socket";
import wbotMessageListener from "./wbotMessageListener-wwjs";

/**
 * Inicia sessão do WhatsApp.
 * O initWASocket resolve APENAS quando o client fica ready,
 * então podemos registrar o listener imediatamente após.
 */
const StartWhatsAppSession = async (whatsapp: Whatsapp): Promise<void> => {
  try {
    logger.info(`[StartSession] Iniciando: ${whatsapp.name} (ID: ${whatsapp.id})`);

    // Atualizar status
    await whatsapp.update({
      status: "OPENING",
      qrcode: "",
      retries: 0
    });

    const io = getIO();
    io.to(`company-${whatsapp.companyId}-mainchannel`).emit(
      `company-${whatsapp.companyId}-whatsappSession`,
      { action: "update", session: whatsapp }
    );

    // Inicializar conexão (resolve quando ready)
    const wbot = await initWASocket(whatsapp);

    // Registrar listener de mensagens UMA VEZ
    wbotMessageListener(wbot, whatsapp.companyId);

    logger.info(`[StartSession] ✅ ${whatsapp.name} inicializada com sucesso`);

  } catch (err) {
    logger.error(`[StartSession] ❌ Erro ao iniciar ${whatsapp.name}: ${err}`);
    Sentry.captureException(err);
    throw err;
  }
};

/**
 * Reinicia sessão do WhatsApp
 */
export const RestartWhatsAppSession = async (whatsapp: Whatsapp): Promise<void> => {
  try {
    logger.info(`[RestartSession] Reiniciando: ${whatsapp.name}`);

    await removeWbot(whatsapp.id, false);

    // Aguardar Chromium fechar completamente
    await new Promise(resolve => setTimeout(resolve, 3000));

    await StartWhatsAppSession(whatsapp);

    logger.info(`[RestartSession] ✅ ${whatsapp.name} reiniciada`);
  } catch (err) {
    logger.error(`[RestartSession] Erro: ${err}`);
    Sentry.captureException(err);
    throw err;
  }
};

/**
 * Desconecta sessão do WhatsApp
 */
export const DisconnectWhatsAppSession = async (
  whatsapp: Whatsapp,
  logout: boolean = true
): Promise<void> => {
  try {
    logger.info(`[DisconnectSession] Desconectando: ${whatsapp.name}`);

    await removeWbot(whatsapp.id, logout);

    await whatsapp.update({
      status: "DISCONNECTED",
      session: ""
    });

    const io = getIO();
    io.to(`company-${whatsapp.companyId}-mainchannel`).emit(
      `company-${whatsapp.companyId}-whatsappSession`,
      { action: "update", session: whatsapp }
    );

    logger.info(`[DisconnectSession] ✅ ${whatsapp.name} desconectada`);
  } catch (err) {
    logger.error(`[DisconnectSession] Erro: ${err}`);
    Sentry.captureException(err);
    throw err;
  }
};

export default StartWhatsAppSession;
