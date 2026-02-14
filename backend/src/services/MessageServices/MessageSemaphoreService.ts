import Message from "../../models/Message";
import Ticket from "../../models/Ticket";
import Whatsapp from "../../models/Whatsapp";
import Queue from "../../models/Queue";
import { getIO } from "../../libs/socket";
import { logger } from "../../utils/logger";
import WhatsAppQueueValidationService from "../ValidationServices/WhatsAppQueueValidationService";

interface MessageSemaphoreData {
  messageId: string;
  ticketId: number;
  fromMe: boolean;
  companyId: number;
}

/**
 * Sistema de Semáforo para Mensagens WhatsApp
 * 
 * Status das mensagens:
 * - GREEN (new): Mensagem nova do cliente, ainda não respondida
 * - RED (waiting): Mensagem do cliente aguardando resposta (passou do tempo limite)
 * - NORMAL (replied): Mensagem foi respondida pelo agente
 * 
 * Logica:
 * - Mensagem do cliente -> Status "new" (verde)
 * - Resposta do agente -> Marca mensagens anteriores como "replied"
 * - Após 5 minutos sem resposta -> Status "waiting" (vermelho)
 */
class MessageSemaphoreService {
  
  /**
   * Processa uma nova mensagem no sistema de semáforo
   */
  static async processMessage({
    messageId,
    ticketId, 
    fromMe,
    companyId
  }: MessageSemaphoreData): Promise<void> {
    try {
      logger.info(`[Semáforo] Processando mensagem ${messageId} - fromMe: ${fromMe}`);
      
      const ticket = await Ticket.findByPk(ticketId, {
        include: [
          {
            model: Whatsapp,
            include: [
              {
                model: Queue,
                as: "queues"
              }
            ]
          }
        ]
      });
      
      if (!ticket) {
        logger.error(`[Semáforo] Ticket ${ticketId} não encontrado`);
        return;
      }

      // Validar vinculação WhatsApp-Queue
      if (!await this.validateWhatsAppQueueConnection(ticket)) {
        logger.warn(`[Semáforo] WhatsApp ${ticket.whatsappId} sem filas vinculadas - Ticket ${ticketId}`);
        // Continua processamento mas registra o problema
      }

      const now = new Date();

      if (fromMe) {
        // Mensagem do agente - marcar mensagens pendentes como respondidas
        await this.markPendingMessagesAsReplied(ticketId);
        
        // Atualizar ticket
        await ticket.update({
          lastAgentMessageAt: now,
          pendingClientMessages: 0
        });

        logger.info(`[Semáforo] Mensagens pendentes marcadas como respondidas - Ticket ${ticketId}`);
        
      } else {
        // Mensagem do cliente - marcar como nova
        const message = await Message.findByPk(messageId);
        if (message) {
          await message.update({ messageStatus: "new" });
        }

        // Atualizar ticket
        await ticket.update({
          lastClientMessageAt: now,
          pendingClientMessages: ticket.pendingClientMessages + 1
        });

        logger.info(`[Semáforo] Nova mensagem do cliente - Ticket ${ticketId}`);
        
        // Agendar verificação de timeout (5 minutos)
        setTimeout(() => {
          this.checkMessageTimeout(messageId, ticketId);
        }, 5 * 60 * 1000); // 5 minutos
      }

      // Emitir atualização para o frontend
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`)
        .to(`ticket-${ticketId}`)
        .emit(`company-${companyId}-message-semaphore`, {
          action: "update",
          ticketId,
          messageId,
          fromMe
        });

    } catch (error) {
      logger.error(`[Semáforo] Erro ao processar mensagem ${messageId}:`, error);
    }
  }

  /**
   * Marca mensagens pendentes como respondidas
   */
  static async markPendingMessagesAsReplied(ticketId: number): Promise<void> {
    try {
      await Message.update(
        { 
          messageStatus: "replied",
          responseTime: new Date()
        },
        {
          where: {
            ticketId,
            fromMe: false,
            messageStatus: ["new", "waiting"]
          }
        }
      );

      logger.info(`[Semáforo] Mensagens do ticket ${ticketId} marcadas como respondidas`);
      
    } catch (error) {
      logger.error(`[Semáforo] Erro ao marcar mensagens como respondidas:`, error);
    }
  }

  /**
   * Verifica timeout de mensagem não respondida
   */
  static async checkMessageTimeout(messageId: string, ticketId: number): Promise<void> {
    try {
      const message = await Message.findByPk(messageId);
      
      if (!message || message.fromMe) {
        return;
      }

      // Se ainda está como "new", marcar como "waiting"
      if (message.messageStatus === "new") {
        await message.update({ messageStatus: "waiting" });
        
        logger.warn(`[Semáforo] Mensagem ${messageId} marcada como aguardando resposta (TIMEOUT)`);

        // Emitir alerta para o frontend
        const io = getIO();
        const ticket = await Ticket.findByPk(ticketId, {
          include: ['company']
        });
        
        if (ticket) {
          io.to(`company-${ticket.companyId}-mainchannel`)
            .emit(`company-${ticket.companyId}-message-timeout`, {
              action: "timeout",
              ticketId,
              messageId,
              message: "Mensagem aguardando resposta há mais de 5 minutos"
            });
        }
      }
      
    } catch (error) {
      logger.error(`[Semáforo] Erro ao verificar timeout da mensagem ${messageId}:`, error);
    }
  }

  /**
   * Obtém estatísticas do semáforo para um ticket
   */
  static async getTicketSemaphoreStats(ticketId: number): Promise<{
    newMessages: number;
    waitingMessages: number;
    repliedMessages: number;
    averageResponseTime: number | null;
  }> {
    try {
      const stats = await Message.findAll({
        attributes: [
          'messageStatus',
          [Message.sequelize!.fn('COUNT', Message.sequelize!.col('id')), 'count']
        ],
        where: {
          ticketId,
          fromMe: false
        },
        group: ['messageStatus'],
        raw: true
      });

      const result = {
        newMessages: 0,
        waitingMessages: 0,
        repliedMessages: 0,
        averageResponseTime: null as number | null
      };

      stats.forEach((stat: any) => {
        const count = parseInt(stat.count);
        switch (stat.messageStatus) {
          case 'new':
            result.newMessages = count;
            break;
          case 'waiting':
            result.waitingMessages = count;
            break;
          case 'replied':
            result.repliedMessages = count;
            break;
        }
      });

      // Calcular tempo médio de resposta
      const repliedMessages = await Message.findAll({
        attributes: ['createdAt', 'responseTime'],
        where: {
          ticketId,
          fromMe: false,
          messageStatus: 'replied',
          responseTime: { [Message.sequelize!.Op.not]: null }
        }
      });

      if (repliedMessages.length > 0) {
        const totalTime = repliedMessages.reduce((sum, msg) => {
          const responseTime = new Date(msg.responseTime!).getTime() - new Date(msg.createdAt).getTime();
          return sum + responseTime;
        }, 0);
        
        result.averageResponseTime = Math.round(totalTime / repliedMessages.length / 1000); // em segundos
      }

      return result;

    } catch (error) {
      logger.error(`[Semáforo] Erro ao obter estatísticas do ticket ${ticketId}:`, error);
      return {
        newMessages: 0,
        waitingMessages: 0, 
        repliedMessages: 0,
        averageResponseTime: null
      };
    }
  }

  /**
   * Obtém estatísticas globais do semáforo para uma empresa
   */
  static async getCompanySemaphoreStats(companyId: number): Promise<{
    totalNewMessages: number;
    totalWaitingMessages: number;
    totalRepliedMessages: number;
    ticketsWithPendingMessages: number;
    averageResponseTime: number | null;
  }> {
    try {
      // Contar mensagens por status
      const messageStats = await Message.findAll({
        attributes: [
          'messageStatus',
          [Message.sequelize!.fn('COUNT', Message.sequelize!.col('id')), 'count']
        ],
        where: {
          companyId,
          fromMe: false
        },
        group: ['messageStatus'],
        raw: true
      });

      // Contar tickets com mensagens pendentes
      const ticketsWithPending = await Ticket.count({
        where: {
          companyId,
          pendingClientMessages: { [Ticket.sequelize!.Op.gt]: 0 }
        }
      });

      const result = {
        totalNewMessages: 0,
        totalWaitingMessages: 0,
        totalRepliedMessages: 0,
        ticketsWithPendingMessages: ticketsWithPending,
        averageResponseTime: null as number | null
      };

      messageStats.forEach((stat: any) => {
        const count = parseInt(stat.count);
        switch (stat.messageStatus) {
          case 'new':
            result.totalNewMessages = count;
            break;
          case 'waiting':
            result.totalWaitingMessages = count;
            break;
          case 'replied':
            result.totalRepliedMessages = count;
            break;
        }
      });

      // Calcular tempo médio de resposta
      const repliedMessages = await Message.findAll({
        attributes: ['createdAt', 'responseTime'],
        where: {
          companyId,
          fromMe: false,
          messageStatus: 'replied',
          responseTime: { [Message.sequelize!.Op.not]: null }
        },
        limit: 1000, // Limitar para performance
        order: [['createdAt', 'DESC']]
      });

      if (repliedMessages.length > 0) {
        const totalTime = repliedMessages.reduce((sum, msg) => {
          const responseTime = new Date(msg.responseTime!).getTime() - new Date(msg.createdAt).getTime();
          return sum + responseTime;
        }, 0);
        
        result.averageResponseTime = Math.round(totalTime / repliedMessages.length / 1000); // em segundos
      }

      return result;

    } catch (error) {
      logger.error(`[Semáforo] Erro ao obter estatísticas da empresa ${companyId}:`, error);
      return {
        totalNewMessages: 0,
        totalWaitingMessages: 0,
        totalRepliedMessages: 0,
        ticketsWithPendingMessages: 0,
        averageResponseTime: null
      };
    }
  }

  /**
   * Valida se o WhatsApp do ticket possui filas vinculadas
   */
  private static async validateWhatsAppQueueConnection(ticket: any): Promise<boolean> {
    try {
      if (!ticket.whatsapp) {
        logger.warn(`[Semáforo] Ticket ${ticket.id} sem WhatsApp associado`);
        return false;
      }

      if (!ticket.whatsapp.queues || ticket.whatsapp.queues.length === 0) {
        logger.warn(`[Semáforo] WhatsApp ${ticket.whatsapp.name} (ID: ${ticket.whatsapp.id}) sem filas vinculadas`);
        
        // Notificar via WebSocket sobre problema de configuração
        const io = getIO();
        io.to(`company-${ticket.companyId}-mainchannel`).emit(`company-${ticket.companyId}-whatsapp-queue-validation`, {
          type: "warning",
          whatsappId: ticket.whatsapp.id,
          whatsappName: ticket.whatsapp.name,
          ticketId: ticket.id,
          message: "WhatsApp sem filas vinculadas - Configure a vinculação no painel de conexões"
        });

        return false;
      }

      return true;

    } catch (error) {
      logger.error(`[Semáforo] Erro na validação WhatsApp-Queue:`, error);
      return false;
    }
  }

  /**
   * Reset do semáforo para um ticket (usado quando ticket é fechado)
   */
  static async resetTicketSemaphore(ticketId: number): Promise<void> {
    try {
      await Message.update(
        { messageStatus: "replied" },
        {
          where: {
            ticketId,
            messageStatus: ["new", "waiting"]
          }
        }
      );

      await Ticket.update(
        { pendingClientMessages: 0 },
        { where: { id: ticketId } }
      );

      logger.info(`[Semáforo] Reset realizado para ticket ${ticketId}`);

    } catch (error) {
      logger.error(`[Semáforo] Erro ao resetar semáforo do ticket ${ticketId}:`, error);
    }
  }
}

export default MessageSemaphoreService;