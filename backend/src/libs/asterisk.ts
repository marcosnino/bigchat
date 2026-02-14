import Ari from "ari-client";
import { EventEmitter } from "events";
import { getIO } from "./socket";
import Asterisk from "../models/Asterisk";
import Call from "../models/Call";
import AppError from "../errors/AppError";
import { logger } from "../utils/logger";

interface AriConnection {
  client: any;
  asteriskId: number;
  companyId: number;
}

class AsteriskManager extends EventEmitter {
  private connections: Map<number, AriConnection> = new Map();
  private reconnectAttempts: Map<number, number> = new Map();
  private maxReconnectAttempts = 5;
  private reconnectDelay = 5000;

  async connect(asterisk: Asterisk): Promise<any> {
    if (this.connections.has(asterisk.id)) {
      logger.info(`Asterisk ${asterisk.id} already connected`);
      return this.connections.get(asterisk.id)!.client;
    }

    const protocol = asterisk.useSSL ? "https" : "http";
    const url = `${protocol}://${asterisk.host}:${asterisk.ariPort}`;

    try {
      logger.info(`Connecting to Asterisk ARI: ${url}`);

      const client = await Ari.connect(
        url,
        asterisk.ariUser,
        asterisk.ariPassword
      );

      this.connections.set(asterisk.id, {
        client,
        asteriskId: asterisk.id,
        companyId: asterisk.companyId
      });

      this.reconnectAttempts.set(asterisk.id, 0);

      // Register event handlers
      this.setupEventHandlers(client, asterisk);

      // Start Stasis application
      if (asterisk.ariApplication) {
        client.start(asterisk.ariApplication);
      }

      // Update status
      await asterisk.update({ status: "CONNECTED" });
      this.emitStatusChange(asterisk.companyId, asterisk.id, "CONNECTED");

      logger.info(`Asterisk ${asterisk.id} connected successfully`);
      return client;
    } catch (error) {
      logger.error(`Failed to connect to Asterisk ${asterisk.id}: ${error}`);
      await asterisk.update({ status: "ERROR" });
      this.emitStatusChange(asterisk.companyId, asterisk.id, "ERROR");
      throw new AppError(`Falha ao conectar no Asterisk: ${error}`, 500);
    }
  }

  private setupEventHandlers(client: any, asterisk: Asterisk): void {
    // Handle Stasis start (incoming call)
    client.on("StasisStart", async (event: any, channel: any) => {
      logger.info(`StasisStart: ${channel.id} - ${channel.caller.number} -> ${channel.dialplan?.exten}`);

      try {
        const call = await Call.create({
          uniqueId: channel.id,
          caller: channel.caller.number || "unknown",
          called: channel.dialplan?.exten || "unknown",
          callerName: channel.caller.name,
          direction: "inbound",
          status: "ringing",
          startedAt: new Date(),
          channel: channel.name,
          asteriskId: asterisk.id,
          companyId: asterisk.companyId
        });

        this.emitNewCall(asterisk.companyId, call);

        // Answer the channel
        await channel.answer();
        await call.update({ status: "answered", answeredAt: new Date() });
        this.emitCallUpdate(asterisk.companyId, call);
      } catch (error) {
        logger.error(`Error handling StasisStart: ${error}`);
      }
    });

    // Handle Stasis end (call ended)
    client.on("StasisEnd", async (event: any, channel: any) => {
      logger.info(`StasisEnd: ${channel.id}`);

      try {
        const call = await Call.findOne({
          where: { uniqueId: channel.id }
        });

        if (call) {
          const endedAt = new Date();
          const duration = call.answeredAt
            ? Math.floor((endedAt.getTime() - call.answeredAt.getTime()) / 1000)
            : 0;

          await call.update({
            status: "completed",
            endedAt,
            duration,
            billableSeconds: duration
          });

          this.emitCallUpdate(asterisk.companyId, call);
        }
      } catch (error) {
        logger.error(`Error handling StasisEnd: ${error}`);
      }
    });

    // Handle channel state change
    client.on("ChannelStateChange", async (event: any, channel: any) => {
      logger.debug(`ChannelStateChange: ${channel.id} - ${channel.state}`);
    });

    // Handle channel destroyed
    client.on("ChannelDestroyed", async (event: any, channel: any) => {
      logger.info(`ChannelDestroyed: ${channel.id}`);

      try {
        const call = await Call.findOne({
          where: { uniqueId: channel.id }
        });

        if (call && call.status !== "completed") {
          const endedAt = new Date();
          const duration = call.answeredAt
            ? Math.floor((endedAt.getTime() - call.answeredAt.getTime()) / 1000)
            : 0;

          await call.update({
            status: call.answeredAt ? "completed" : "no-answer",
            endedAt,
            duration,
            hangupCause: event.cause_txt,
            hangupCode: event.cause
          });

          this.emitCallUpdate(asterisk.companyId, call);
        }
      } catch (error) {
        logger.error(`Error handling ChannelDestroyed: ${error}`);
      }
    });

    // Handle connection close
    client.on("WebSocketReconnecting", () => {
      logger.warn(`Asterisk ${asterisk.id} WebSocket reconnecting...`);
      this.emitStatusChange(asterisk.companyId, asterisk.id, "RECONNECTING");
    });

    client.on("WebSocketMaxRetries", () => {
      logger.error(`Asterisk ${asterisk.id} WebSocket max retries reached`);
      this.handleDisconnect(asterisk);
    });
  }

  private async handleDisconnect(asterisk: Asterisk): Promise<void> {
    this.connections.delete(asterisk.id);
    await asterisk.update({ status: "DISCONNECTED" });
    this.emitStatusChange(asterisk.companyId, asterisk.id, "DISCONNECTED");

    const attempts = (this.reconnectAttempts.get(asterisk.id) || 0) + 1;
    this.reconnectAttempts.set(asterisk.id, attempts);

    if (attempts <= this.maxReconnectAttempts && asterisk.isActive) {
      logger.info(`Attempting to reconnect Asterisk ${asterisk.id} (attempt ${attempts})`);
      setTimeout(() => this.connect(asterisk), this.reconnectDelay * attempts);
    }
  }

  async disconnect(asteriskId: number): Promise<void> {
    const connection = this.connections.get(asteriskId);
    if (connection) {
      try {
        // No direct close method in ari-client, just remove from map
        this.connections.delete(asteriskId);
        logger.info(`Asterisk ${asteriskId} disconnected`);

        const asterisk = await Asterisk.findByPk(asteriskId);
        if (asterisk) {
          await asterisk.update({ status: "DISCONNECTED" });
          this.emitStatusChange(asterisk.companyId, asteriskId, "DISCONNECTED");
        }
      } catch (error) {
        logger.error(`Error disconnecting Asterisk ${asteriskId}: ${error}`);
      }
    }
  }

  getConnection(asteriskId: number): AriConnection | undefined {
    return this.connections.get(asteriskId);
  }

  isConnected(asteriskId: number): boolean {
    return this.connections.has(asteriskId);
  }

  async originate(
    asteriskId: number,
    extension: string,
    destination: string,
    callerId?: string
  ): Promise<Call> {
    const connection = this.connections.get(asteriskId);
    if (!connection) {
      throw new AppError("Asterisk não está conectado", 400);
    }

    const asterisk = await Asterisk.findByPk(asteriskId);
    if (!asterisk) {
      throw new AppError("Configuração do Asterisk não encontrada", 404);
    }

    const channelId = `bigchat-${Date.now()}`;
    const endpoint = `PJSIP/${extension}`;
    const context = asterisk.outboundContext || "from-internal";

    try {
      const channel = await connection.client.channels.originate({
        endpoint,
        extension: destination,
        context,
        priority: 1,
        callerId: callerId || extension,
        timeout: 30,
        channelId
      });

      const call = await Call.create({
        uniqueId: channel.id,
        caller: extension,
        called: destination,
        direction: "outbound",
        status: "ringing",
        startedAt: new Date(),
        channel: channel.name,
        extension,
        asteriskId,
        companyId: asterisk.companyId
      });

      this.emitNewCall(asterisk.companyId, call);

      return call;
    } catch (error) {
      logger.error(`Error originating call: ${error}`);
      throw new AppError(`Falha ao originar chamada: ${error}`, 500);
    }
  }

  async hangup(asteriskId: number, channelId: string): Promise<void> {
    const connection = this.connections.get(asteriskId);
    if (!connection) {
      throw new AppError("Asterisk não está conectado", 400);
    }

    try {
      const channel = connection.client.Channel(undefined, channelId);
      await channel.hangup();
    } catch (error) {
      logger.error(`Error hanging up channel ${channelId}: ${error}`);
      throw new AppError(`Falha ao desligar chamada: ${error}`, 500);
    }
  }

  async transfer(
    asteriskId: number,
    channelId: string,
    destination: string
  ): Promise<void> {
    const connection = this.connections.get(asteriskId);
    if (!connection) {
      throw new AppError("Asterisk não está conectado", 400);
    }

    const asterisk = await Asterisk.findByPk(asteriskId);
    if (!asterisk) {
      throw new AppError("Configuração do Asterisk não encontrada", 404);
    }

    try {
      const channel = connection.client.Channel(undefined, channelId);
      await channel.continueInDialplan({
        context: asterisk.inboundContext,
        extension: destination,
        priority: 1
      });
    } catch (error) {
      logger.error(`Error transferring channel ${channelId}: ${error}`);
      throw new AppError(`Falha ao transferir chamada: ${error}`, 500);
    }
  }

  private emitStatusChange(
    companyId: number,
    asteriskId: number,
    status: string
  ): void {
    try {
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`).emit(
        `company-${companyId}-asterisk`,
        {
          action: "status",
          asteriskId,
          status
        }
      );
    } catch (error) {
      logger.error(`Error emitting status change: ${error}`);
    }
  }

  private emitNewCall(companyId: number, call: Call): void {
    try {
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`).emit(
        `company-${companyId}-call`,
        {
          action: "new",
          call
        }
      );
    } catch (error) {
      logger.error(`Error emitting new call: ${error}`);
    }
  }

  private emitCallUpdate(companyId: number, call: Call): void {
    try {
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`).emit(
        `company-${companyId}-call`,
        {
          action: "update",
          call
        }
      );
    } catch (error) {
      logger.error(`Error emitting call update: ${error}`);
    }
  }

  async initializeAll(): Promise<void> {
    try {
      const asterisks = await Asterisk.findAll({
        where: { isActive: true }
      });

      logger.info(`Initializing ${asterisks.length} Asterisk connections...`);

      for (const asterisk of asterisks) {
        try {
          await this.connect(asterisk);
        } catch (error) {
          logger.error(`Failed to initialize Asterisk ${asterisk.id}: ${error}`);
        }
      }
    } catch (error) {
      logger.error(`Error initializing Asterisk connections: ${error}`);
    }
  }
}

export const asteriskManager = new AsteriskManager();
export default asteriskManager;
