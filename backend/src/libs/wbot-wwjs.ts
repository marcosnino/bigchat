/**
 * WhatsApp Web.js Session Engine — Versão Completa
 * 
 * Gerenciamento profissional de sessões com:
 * - Multi-device nativo (LocalAuth)
 * - Reconexão automática com backoff exponencial
 * - Cleanup completo de Chromium/Puppeteer
 * - QR Code handling robusto
 * - Gerenciamento de estado via Socket.IO
 * - Proteção contra memory leaks
 * - Lock file cleanup para evitar "browser already running"
 * 
 * @version 3.0.0
 */

import {
  Client,
  LocalAuth,
  WAState
} from "whatsapp-web.js";
import * as Sentry from "@sentry/node";
import path from "path";
import fs from "fs";

import Whatsapp from "../models/Whatsapp";
import { logger } from "../utils/logger";
import { getIO } from "./socket";
import AppError from "../errors/AppError";

// ─── Constantes ─────────────────────────────────────────────────
const SESSIONS_PATH = path.resolve(__dirname, "..", "..", ".sessions");
const QR_MAX_RETRIES = 8;
const RECONNECT_BASE_DELAY_MS = 5000;
const RECONNECT_MAX_DELAY_MS = 60000;
const CLIENT_INIT_TIMEOUT_MS = 120000;

// Garantir diretório de sessões
if (!fs.existsSync(SESSIONS_PATH)) {
  fs.mkdirSync(SESSIONS_PATH, { recursive: true });
}

// ─── Interface de sessão ────────────────────────────────────────
export interface WWJSSession extends Client {
  id?: number;
  companyId?: number;
  isReady?: boolean;
}

// ─── Estado interno ─────────────────────────────────────────────
const sessions: Map<number, WWJSSession> = new Map();
const qrRetries: Map<number, number> = new Map();
const reconnectAttempts: Map<number, number> = new Map();
const reconnectTimers: Map<number, ReturnType<typeof setTimeout>> = new Map();

// ─── Puppeteer args otimizados ──────────────────────────────────
const PUPPETEER_ARGS = [
  "--no-sandbox",
  "--disable-setuid-sandbox",
  "--disable-dev-shm-usage",
  "--disable-accelerated-2d-canvas",
  "--no-first-run",
  "--no-zygote",
  "--single-process",
  "--disable-gpu",
  "--disable-extensions",
  "--disable-software-rasterizer",
  "--ignore-certificate-errors",
  "--disable-background-timer-throttling",
  "--disable-backgrounding-occluded-windows",
  "--disable-renderer-backgrounding"
];

// ═══════════════════════════════════════════════════════════════
// FUNÇÕES PÚBLICAS
// ═══════════════════════════════════════════════════════════════

/**
 * Obtém sessão ativa do WhatsApp.
 * Lança erro se não encontrada (compatível com controllers).
 */
export const getWbot = (whatsappId: number): WWJSSession => {
  const session = sessions.get(whatsappId);

  if (!session) {
    throw new AppError("ERR_WAPP_NOT_INITIALIZED", 404);
  }

  return session;
};

/**
 * Verifica se sessão está ativa e pronta
 */
export const isSessionActive = (whatsappId: number): boolean => {
  const session = sessions.get(whatsappId);
  return !!(session?.isReady);
};

/**
 * Remove uma sessão do WhatsApp de forma segura.
 * 
 * @param whatsappId ID da conexão
 * @param destroySession Se true, remove arquivos de sessão (logout completo)
 */
export const removeWbot = async (
  whatsappId: number,
  destroySession: boolean = false
): Promise<void> => {
  try {
    // Cancelar timer de reconexão pendente
    const timer = reconnectTimers.get(whatsappId);
    if (timer) {
      clearTimeout(timer);
      reconnectTimers.delete(whatsappId);
    }

    const session = sessions.get(whatsappId);

    if (session) {
      // Remover todos os listeners para evitar memory leaks
      (session as any).removeAllListeners();

      if (destroySession) {
        try {
          await session.logout();
        } catch (e) {
          logger.debug(`[WWJS] Erro ao fazer logout ${whatsappId}: ${e}`);
        }
      }

      try {
        await session.destroy();
      } catch (e) {
        logger.debug(`[WWJS] Erro ao destruir client ${whatsappId}: ${e}`);
      }

      sessions.delete(whatsappId);
    }

    // Limpar arquivos de sessão ou lock files
    if (destroySession) {
      cleanSessionFiles(whatsappId, true);
    } else {
      cleanSessionFiles(whatsappId, false);
    }

    qrRetries.delete(whatsappId);
    reconnectAttempts.delete(whatsappId);

    logger.info(`[WWJS] Sessão ${whatsappId} removida (destroy=${destroySession})`);
  } catch (err) {
    logger.error(`[WWJS] Erro ao remover sessão ${whatsappId}: ${err}`);
    Sentry.captureException(err);
  }
};

/**
 * Inicializa sessão do WhatsApp Web.js.
 *
 * Suporte completo a:
 * - Multi-device (LocalAuth)
 * - QR Code com retries
 * - Reconexão automática com backoff
 * - Emissão de estado via Socket.IO
 */
export const initWASocket = async (whatsapp: Whatsapp): Promise<WWJSSession> => {
  return new Promise(async (resolve, reject) => {
    try {
      const io = getIO();
      const { id, name, companyId } = whatsapp;

      logger.info(`[WWJS] Iniciando sessão "${name}" (ID: ${id})`);

      // Se já existe sessão ativa, retornar
      if (sessions.has(id)) {
        const existing = sessions.get(id)!;
        if (existing.isReady) {
          logger.info(`[WWJS] Sessão ${id} já ativa, reutilizando`);
          return resolve(existing);
        }
        await removeWbot(id, false);
      }

      // Reset contadores
      qrRetries.set(id, 0);
      reconnectAttempts.set(id, 0);

      // Limpar lock files antes de iniciar
      cleanSessionFiles(id, false);

      // ─── Criar client ─────────────────────────────
      const clientOptions: any = {
        authStrategy: new LocalAuth({
          clientId: `wpp-${id}`,
          dataPath: SESSIONS_PATH
        }),
        puppeteer: {
          headless: true,
          executablePath: process.env.CHROME_BIN || process.env.PUPPETEER_EXECUTABLE_PATH || undefined,
          args: PUPPETEER_ARGS
        },
        webVersionCache: {
          type: "remote",
          remotePath:
            "https://raw.githubusercontent.com/nicokant/nicokant.github.io/main/AltWWebJS/versionCache/"
        }
      };

      const client = new Client(clientOptions) as WWJSSession;

      client.id = id;
      client.companyId = companyId;
      client.isReady = false;

      // Guardar referência imediata
      sessions.set(id, client);

      // ─── Timeout de inicialização ─────────────────
      const initTimeout = setTimeout(async () => {
        if (!client.isReady) {
          logger.error(`[WWJS] Timeout ao inicializar sessão "${name}" (${CLIENT_INIT_TIMEOUT_MS}ms)`);
          await removeWbot(id, false);
          reject(new Error(`Timeout inicializando sessão ${id}`));
        }
      }, CLIENT_INIT_TIMEOUT_MS + 10000);

      // ═════════════ EVENT HANDLERS ═════════════════

      // ─── QR Code ──────────────────────────────────
      client.on("qr", async (qr: string) => {
        const retries = (qrRetries.get(id) || 0) + 1;
        qrRetries.set(id, retries);

        logger.info(`[WWJS] QR Code para "${name}" (tentativa ${retries}/${QR_MAX_RETRIES})`);

        if (retries > QR_MAX_RETRIES) {
          logger.warn(`[WWJS] Max tentativas QR atingido para "${name}"`);

          try {
            await whatsapp.update({
              status: "DISCONNECTED",
              qrcode: "",
              retries
            });
          } catch (e) {
            logger.debug(`[WWJS] Erro ao atualizar status: ${e}`);
          }

          emitSession(io, companyId, whatsapp);
          await removeWbot(id, false);
          clearTimeout(initTimeout);
          return;
        }

        try {
          // Salvar QR como texto puro — frontend usa qrcode.react para renderizar
          await whatsapp.update({
            qrcode: qr,
            status: "qrcode",
            retries
          });

          const fresh = await Whatsapp.findByPk(id);
          if (fresh) {
            io.to(`company-${companyId}-mainchannel`).emit(
              `company-${companyId}-whatsappSession`,
              { action: "update", session: fresh }
            );
          }
        } catch (e) {
          logger.error(`[WWJS] Erro ao emitir QR: ${e}`);
        }
      });

      // ─── Autenticado ──────────────────────────────
      client.on("authenticated", () => {
        logger.info(`[WWJS] ✅ Sessão "${name}" autenticada`);
        qrRetries.set(id, 0);
      });

      // ─── Falha na autenticação ────────────────────
      client.on("auth_failure", async (message: string) => {
        logger.error(`[WWJS] ❌ Auth failure "${name}": ${message}`);
        Sentry.captureMessage(`WWJS Auth Failure: ${name} - ${message}`);

        try {
          await whatsapp.update({
            status: "DISCONNECTED",
            qrcode: "",
            session: ""
          });
        } catch (e) {}

        emitSession(io, companyId, whatsapp);
        clearTimeout(initTimeout);

        await removeWbot(id, true);
        reject(new Error(`Auth failure: ${message}`));
      });

      // ─── Ready ────────────────────────────────────
      client.on("ready", async () => {
        logger.info(`[WWJS] 🟢 Sessão "${name}" PRONTA (multi-device)`);

        client.isReady = true;
        sessions.set(id, client);
        qrRetries.set(id, 0);
        reconnectAttempts.set(id, 0);

        clearTimeout(initTimeout);

        try {
          const info = client.info;
          const wid = info?.wid;

          await whatsapp.update({
            status: "CONNECTED",
            qrcode: "",
            retries: 0,
            number: wid?.user || wid?._serialized?.replace("@c.us", "") || "",
            session: JSON.stringify({
              pushname: info?.pushname,
              wid,
              platform: info?.platform
            })
          });
        } catch (e) {
          logger.warn(`[WWJS] Erro ao atualizar info da sessão: ${e}`);
        }

        emitSession(io, companyId, whatsapp);
        resolve(client);
      });

      // ─── Mudança de estado ────────────────────────
      client.on("change_state", async (state: WAState) => {
        logger.info(`[WWJS] Estado de "${name}": ${state}`);

        const statusMap: Record<string, string> = {
          [WAState.CONNECTED]: "CONNECTED",
          [WAState.OPENING]: "OPENING",
          [WAState.PAIRING]: "qrcode",
          [WAState.TIMEOUT]: "TIMEOUT",
          [WAState.CONFLICT]: "CONFLICT",
          [WAState.DEPRECATED_VERSION]: "DEPRECATED",
          [WAState.PROXYBLOCK]: "BLOCKED",
          [WAState.SMB_TOS_BLOCK]: "BLOCKED",
          [WAState.TOS_BLOCK]: "BLOCKED",
          [WAState.UNLAUNCHED]: "DISCONNECTED",
          [WAState.UNPAIRED]: "DISCONNECTED",
          [WAState.UNPAIRED_IDLE]: "DISCONNECTED"
        };

        const newStatus = statusMap[state] || "DISCONNECTED";

        if (newStatus !== "CONNECTED" && newStatus !== "OPENING") {
          client.isReady = false;
        }

        try {
          await whatsapp.update({ status: newStatus });
          emitSession(io, companyId, whatsapp);
        } catch (e) {
          logger.debug(`[WWJS] Erro ao atualizar estado: ${e}`);
        }
      });

      // ─── Desconectado ─────────────────────────────
      client.on("disconnected", async (reason: string) => {
        logger.warn(`[WWJS] 🔴 Sessão "${name}" desconectada: ${reason}`);

        client.isReady = false;

        try {
          await whatsapp.update({ status: "DISCONNECTED", qrcode: "" });
          emitSession(io, companyId, whatsapp);
        } catch (e) {}

        clearTimeout(initTimeout);

        // Limpar client para liberar Chromium
        try {
          (client as any).removeAllListeners();
          await client.destroy();
        } catch (e) {
          logger.debug(`[WWJS] Erro ao destruir client na desconexão: ${e}`);
        }
        sessions.delete(id);

        if (reason === "LOGOUT") {
          logger.info(`[WWJS] Logout manual de "${name}", limpando sessão`);
          cleanSessionFiles(id, true);
          return;
        }

        // Reconexão automática com backoff
        scheduleReconnect(id, companyId, name);
      });

      // ─── Loading screen ───────────────────────────
      client.on("loading_screen", (percent: number, message: string) => {
        logger.debug(`[WWJS] "${name}" carregando: ${percent}% — ${message}`);
      });

      // ─── Iniciar ──────────────────────────────────
      logger.info(`[WWJS] Inicializando Chromium para "${name}"...`);
      await client.initialize();

    } catch (error) {
      logger.error(`[WWJS] Erro fatal ao inicializar sessão: ${error}`);
      Sentry.captureException(error);
      reject(error);
    }
  });
};

/**
 * Retorna todas as sessões ativas
 */
export const getAllSessions = (): WWJSSession[] => {
  return Array.from(sessions.values());
};

/**
 * Encerra todas as sessões (shutdown graceful)
 */
export const closeAllSessions = async (): Promise<void> => {
  logger.info("[WWJS] Encerrando todas as sessões...");

  const ids = Array.from(sessions.keys());
  for (const id of ids) {
    try {
      await removeWbot(id, false);
    } catch (e) {
      logger.error(`[WWJS] Erro ao encerrar sessão ${id}: ${e}`);
    }
  }

  logger.info("[WWJS] Todas as sessões encerradas");
};

// ═══════════════════════════════════════════════════════════════
// FUNÇÕES INTERNAS
// ═══════════════════════════════════════════════════════════════

/**
 * Emite atualização de sessão via Socket.IO
 */
const emitSession = async (
  io: ReturnType<typeof getIO>,
  companyId: number,
  whatsapp: Whatsapp
): Promise<void> => {
  try {
    const fresh = await Whatsapp.findByPk(whatsapp.id);
    if (fresh) {
      io.to(`company-${companyId}-mainchannel`).emit(
        `company-${companyId}-whatsappSession`,
        { action: "update", session: fresh }
      );
    }
  } catch (e) {
    logger.debug(`[WWJS] Erro ao emitir sessão: ${e}`);
  }
};

/**
 * Limpa arquivos de sessão e/ou lock files
 */
const cleanSessionFiles = (whatsappId: number, removeAll: boolean): void => {
  const patterns = [
    `session-wpp-${whatsappId}`,
    `session-session-${whatsappId}`,
    `session-${whatsappId}`
  ];

  for (const dir of patterns) {
    const fullPath = path.join(SESSIONS_PATH, dir);

    if (removeAll) {
      if (fs.existsSync(fullPath)) {
        try {
          fs.rmSync(fullPath, { recursive: true, force: true });
          logger.info(`[WWJS] Removido diretório: ${dir}`);
        } catch (e) {
          logger.debug(`[WWJS] Erro ao remover ${dir}: ${e}`);
        }
      }
    } else {
      const lockFile = path.join(fullPath, "SingletonLock");
      if (fs.existsSync(lockFile)) {
        try {
          fs.rmSync(lockFile, { force: true });
          logger.info(`[WWJS] Lock removido: ${dir}/SingletonLock`);
        } catch (e) {
          logger.debug(`[WWJS] Erro ao remover lock: ${e}`);
        }
      }
    }
  }
};

/**
 * Agenda reconexão com backoff exponencial
 */
const scheduleReconnect = (
  whatsappId: number,
  companyId: number,
  name: string
): void => {
  const attempt = (reconnectAttempts.get(whatsappId) || 0) + 1;
  reconnectAttempts.set(whatsappId, attempt);

  if (attempt > 10) {
    logger.error(`[WWJS] Máximo de reconexões atingido para "${name}" (${attempt}). Desistindo.`);
    return;
  }

  const delay = Math.min(
    RECONNECT_BASE_DELAY_MS * Math.pow(2, attempt - 1),
    RECONNECT_MAX_DELAY_MS
  );

  logger.info(`[WWJS] 🔄 Reconexão de "${name}" em ${delay / 1000}s (tentativa ${attempt})`);

  const oldTimer = reconnectTimers.get(whatsappId);
  if (oldTimer) clearTimeout(oldTimer);

  const timer = setTimeout(async () => {
    reconnectTimers.delete(whatsappId);

    try {
      const freshWhatsapp = await Whatsapp.findByPk(whatsappId);
      if (!freshWhatsapp) {
        logger.warn(`[WWJS] WhatsApp ${whatsappId} não existe mais no banco`);
        return;
      }

      if (freshWhatsapp.status === "CONNECTED") {
        logger.info(`[WWJS] "${name}" já CONNECTED, cancelando reconexão`);
        return;
      }

      const StartWhatsAppSession = (
        await import("../services/WbotServices/StartWhatsAppSession-wwjs")
      ).default;

      await StartWhatsAppSession(freshWhatsapp);
    } catch (err) {
      logger.error(`[WWJS] Falha na reconexão de "${name}": ${err}`);
      scheduleReconnect(whatsappId, companyId, name);
    }
  }, delay);

  reconnectTimers.set(whatsappId, timer);
};

export default {
  getWbot,
  removeWbot,
  initWASocket,
  isSessionActive,
  getAllSessions,
  closeAllSessions
};
