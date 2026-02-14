/**
 * ClosedTicketHistoryService
 * Service para gerenciar histórico de tickets/chats fechados
 * Suporta filtros por data, número, fila, usuário, etc.
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import { Op, fn, col } from "sequelize";
import ClosedTicketHistory from "../../models/ClosedTicketHistory";
import User from "../../models/User";
import Contact from "../../models/Contact";
import Whatsapp from "../../models/Whatsapp";
import Queue from "../../models/Queue";
import AppError from "../../errors/AppError";
import { logger } from "../../utils/logger";
import * as Sentry from "@sentry/node";

interface ClosedTicketFilter {
  companyId: number;
  startDate?: Date;
  endDate?: Date;
  startOpenDate?: Date;
  endOpenDate?: Date;
  whatsappId?: number;
  queueId?: number;
  userId?: number;
  rating?: number;
  page?: number;
  limit?: number;
  sortBy?: string;
  order?: "ASC" | "DESC";
}

interface ClosedTicketStats {
  totalClosed: number;
  totalTime: number;
  averageTime: number;
  totalMessages: number;
  averageRating: number;
  byQueue: any[];
  byWhatsapp: any[];
  byUser: any[];
  byDay: any[];
}

class ClosedTicketHistoryService {
  /**
   * Registrar fechamento de ticket no histórico
   */
  static async recordTicketClosure(
    ticketId: number,
    ticketData: any,
    companyId: number
  ): Promise<ClosedTicketHistory> {
    try {
      const now = new Date();
      const openedAt = new Date(ticketData.createdAt);
      const durationSeconds = Math.floor((now.getTime() - openedAt.getTime()) / 1000);

      // Contar mensagens do ticket
      const messageCount = ticketData.messages?.length || 0;

      // Extrair dados de semáforo se disponível
      let semaphoreData = null;
      if (ticketData.pendingClientMessages !== undefined) {
        semaphoreData = {
          totalNewMessages: ticketData.pendingClientMessages || 0,
          totalWaitingMessages: 0,
          totalRepliedMessages: messageCount - (ticketData.pendingClientMessages || 0)
        };
      }

      const closedTicketHistory = await ClosedTicketHistory.create({
        ticketId,
        userId: ticketData.userId,
        contactId: ticketData.contactId,
        whatsappId: ticketData.whatsappId,
        queueId: ticketData.queueId,
        ticketOpenedAt: openedAt,
        ticketClosedAt: now,
        durationSeconds,
        finalStatus: ticketData.status || "closed",
        closureReason: ticketData.closureReason || null,
        totalMessages: messageCount,
        rating: ticketData.rating || null,
        feedback: ticketData.feedback || null,
        tags: ticketData.tags || [],
        closedByUserId: ticketData.closedByUserId || ticketData.userId,
        semaphoreData,
        companyId
      });

      logger.info(
        `[ClosedTicketHistory] Ticket ${ticketId} registrado como fechado (${durationSeconds}s)`
      );

      return closedTicketHistory;

    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao registrar fechamento:`, error);
      Sentry.captureException(error);
      throw new AppError("Erro ao registrar fechamento", 500);
    }
  }

  /**
   * Buscar histórico com filtros avançados
   */
  static async findClosed(filters: ClosedTicketFilter): Promise<{
    data: ClosedTicketHistory[];
    total: number;
    page: number;
    pages: number;
  }> {
    try {
      const where: any = { companyId: filters.companyId };

      // Filtro de data de fechamento
      if (filters.startDate || filters.endDate) {
        where.ticketClosedAt = {};

        if (filters.startDate) {
          where.ticketClosedAt[Op.gte] = filters.startDate;
        }
        if (filters.endDate) {
          where.ticketClosedAt[Op.lte] = filters.endDate;
        }
      }

      // Filtro de data de abertura
      if (filters.startOpenDate || filters.endOpenDate) {
        where.ticketOpenedAt = {};

        if (filters.startOpenDate) {
          where.ticketOpenedAt[Op.gte] = filters.startOpenDate;
        }
        if (filters.endOpenDate) {
          where.ticketOpenedAt[Op.lte] = filters.endOpenDate;
        }
      }

      // Filtro por número WhatsApp
      if (filters.whatsappId) {
        where.whatsappId = filters.whatsappId;
      }

      // Filtro por fila
      if (filters.queueId) {
        where.queueId = filters.queueId;
      }

      // Filtro por usuário
      if (filters.userId) {
        where.userId = filters.userId;
      }

      // Filtro por rating
      if (filters.rating !== undefined) {
        where.rating = filters.rating;
      }

      // Paginação
      const page = filters.page || 1;
      const limit = Math.min(filters.limit || 50, 500);
      const offset = (page - 1) * limit;

      // Ordenação
      const sortBy = filters.sortBy || "ticketClosedAt";
      const order = filters.order || "DESC";
      const orderBy: any = [[sortBy, order]];

      // Buscar dados
      const { count, rows } = await ClosedTicketHistory.findAndCountAll({
        where,
        include: [
          {
            model: User,
            attributes: ["id", "name", "email"],
            required: false
          },
          {
            model: Contact,
            attributes: ["id", "name", "number"],
            required: false
          },
          {
            model: Whatsapp,
            attributes: ["id", "name", "status"],
            required: false
          },
          {
            model: Queue,
            attributes: ["id", "name", "color"],
            required: false
          }
        ],
        order: orderBy,
        limit,
        offset
      });

      const pages = Math.ceil(count / limit);

      logger.info(
        `[ClosedTicketHistory] Buscados ${rows.length} tickets fechados (página ${page}/${pages})`
      );

      return {
        data: rows,
        total: count,
        page,
        pages
      };

    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao buscar histórico:`, error);
      throw new AppError("Erro ao buscar histórico", 500);
    }
  }

  /**
   * Obter estatísticas de tickets fechados
   */
  static async getClosedStats(filters: Omit<ClosedTicketFilter, 'page' | 'limit'>): Promise<ClosedTicketStats> {
    try {
      const where: any = { companyId: filters.companyId };

      if (filters.startDate || filters.endDate) {
        where.ticketClosedAt = {};
        if (filters.startDate) where.ticketClosedAt[Op.gte] = filters.startDate;
        if (filters.endDate) where.ticketClosedAt[Op.lte] = filters.endDate;
      }

      if (filters.whatsappId) where.whatsappId = filters.whatsappId;
      if (filters.queueId) where.queueId = filters.queueId;
      if (filters.userId) where.userId = filters.userId;

      // Total e estatísticas gerais
      const total = await ClosedTicketHistory.count({ where });

      const [totalTime, messageCount, avgRating] = await Promise.all([
        ClosedTicketHistory.sum("durationSeconds", { where }),
        ClosedTicketHistory.sum("totalMessages", { where }),
        ClosedTicketHistory.findAll({
          attributes: [
            [fn("AVG", col("rating")), "avgRating"]
          ],
          where,
          raw: true
        })
      ]);

      // Por fila
      const byQueue = await ClosedTicketHistory.findAll({
        attributes: [
          "queueId",
          [fn("COUNT", col("id")), "total"],
          [fn("AVG", col("durationSeconds")), "avgTime"]
        ],
        where,
        include: [
          {
            model: Queue,
            attributes: ["id", "name", "color"],
            required: false
          }
        ],
        group: ["queueId"],
        raw: false,
        subQuery: false
      });

      // Por número
      const byWhatsapp = await ClosedTicketHistory.findAll({
        attributes: [
          "whatsappId",
          [fn("COUNT", col("id")), "total"],
          [fn("AVG", col("durationSeconds")), "avgTime"]
        ],
        where,
        include: [
          {
            model: Whatsapp,
            attributes: ["id", "name"],
            required: false
          }
        ],
        group: ["whatsappId"],
        raw: false,
        subQuery: false
      });

      // Por usuário
      const byUser = await ClosedTicketHistory.findAll({
        attributes: [
          "userId",
          [fn("COUNT", col("id")), "total"],
          [fn("AVG", col("durationSeconds")), "avgTime"]
        ],
        where,
        include: [
          {
            model: User,
            attributes: ["id", "name"],
            required: false
          }
        ],
        group: ["userId"],
        raw: false,
        subQuery: false
      });

      // Por dia (últimos 30 dias)
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      const byDay = await ClosedTicketHistory.findAll({
        attributes: [
          [fn("DATE", col("ticketClosedAt")), "date"],
          [fn("COUNT", col("id")), "total"]
        ],
        where: {
          ...where,
          ticketClosedAt: {
            [Op.gte]: thirtyDaysAgo
          }
        },
        group: [fn("DATE", col("ticketClosedAt"))],
        order: [[fn("DATE", col("ticketClosedAt")), "ASC"]],
        raw: true,
        subQuery: false
      });

      return {
        totalClosed: total,
        totalTime: totalTime || 0,
        averageTime: total > 0 ? Math.floor((totalTime || 0) / total) : 0,
        totalMessages: messageCount || 0,
        averageRating: (avgRating as any)?.[0]?.avgRating || 0,
        byQueue,
        byWhatsapp,
        byUser,
        byDay
      };

    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao obter estatísticas:`, error);
      Sentry.captureException(error);
      return {
        totalClosed: 0,
        totalTime: 0,
        averageTime: 0,
        totalMessages: 0,
        averageRating: 0,
        byQueue: [],
        byWhatsapp: [],
        byUser: [],
        byDay: []
      };
    }
  }

  /**
   * Buscar por ID
   */
  static async findById(id: number, companyId: number): Promise<ClosedTicketHistory> {
    try {
      const closedTicket = await ClosedTicketHistory.findOne({
        where: { id, companyId },
        include: [
          { model: User },
          { model: Contact },
          { model: Whatsapp },
          { model: Queue }
        ]
      });

      if (!closedTicket) {
        throw new AppError("Registro não encontrado", 404);
      }

      return closedTicket;

    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao buscar por ID:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao buscar registro", 500);
    }
  }

  /**
   * Exportar CSV
   */
  static async exportToCSV(filters: ClosedTicketFilter): Promise<string> {
    try {
      const { data } = await this.findClosed({ ...filters, limit: 10000 });

      const headers = [
        "ID",
        "Ticket ID",
        "Número",
        "Fila",
        "Agente",
        "Contato",
        "Data Abertura",
        "Data Fechamento",
        "Duração (min)",
        "Mensagens",
        "Rating",
        "Status"
      ];

      const rows = data.map(item => [
        item.id,
        item.ticketId,
        item.whatsapp?.name || "-",
        item.queue?.name || "-",
        item.user?.name || "-",
        item.contact?.name || "-",
        new Date(item.ticketOpenedAt).toLocaleString(),
        new Date(item.ticketClosedAt).toLocaleString(),
        Math.floor(item.durationSeconds / 60),
        item.totalMessages,
        item.rating || "-",
        item.finalStatus
      ]);

      let csv = headers.join(",") + "\n";
      rows.forEach(row => {
        csv += row.map(cell => `"${cell}"`).join(",") + "\n";
      });

      logger.info(`[ClosedTicketHistory] Exportados ${data.length} registros para CSV`);

      return csv;

    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao exportar CSV:`, error);
      throw new AppError("Erro ao exportar", 500);
    }
  }

  /**
   * Buscar histórico por contactId (todo o histórico de um contato)
   */
  static async findByContact(
    contactId: number,
    companyId: number
  ): Promise<ClosedTicketHistory[]> {
    try {
      const records = await ClosedTicketHistory.findAll({
        where: { contactId, companyId },
        include: [
          {
            model: User,
            attributes: ["id", "name", "email"],
            required: false
          },
          {
            model: Contact,
            attributes: ["id", "name", "number"],
            required: false
          },
          {
            model: Whatsapp,
            attributes: ["id", "name", "status"],
            required: false
          },
          {
            model: Queue,
            attributes: ["id", "name", "color"],
            required: false
          }
        ],
        order: [["ticketClosedAt", "DESC"]]
      });

      return records;
    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao buscar por contato:`, error);
      throw new AppError("Erro ao buscar histórico do contato", 500);
    }
  }

  /**
   * Buscar histórico por ticketId
   */
  static async findByTicket(
    ticketId: number,
    companyId: number
  ): Promise<ClosedTicketHistory[]> {
    try {
      const records = await ClosedTicketHistory.findAll({
        where: { ticketId, companyId },
        include: [
          {
            model: User,
            attributes: ["id", "name", "email"],
            required: false
          },
          {
            model: Contact,
            attributes: ["id", "name", "number"],
            required: false
          },
          {
            model: Whatsapp,
            attributes: ["id", "name", "status"],
            required: false
          },
          {
            model: Queue,
            attributes: ["id", "name", "color"],
            required: false
          }
        ],
        order: [["ticketClosedAt", "DESC"]]
      });

      return records;
    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao buscar por ticket:`, error);
      throw new AppError("Erro ao buscar histórico do ticket", 500);
    }
  }

  /**
   * Limpar histórico antigo (> 90 dias)
   */
  static async cleanupOldRecords(companyId: number, daysToKeep: number = 90): Promise<number> {
    try {
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - daysToKeep);

      const deleted = await ClosedTicketHistory.destroy({
        where: {
          companyId,
          ticketClosedAt: { [Op.lt]: cutoffDate }
        }
      });

      logger.info(
        `[ClosedTicketHistory] ${deleted} registros antigos removidos (> ${daysToKeep} dias)`
      );

      return deleted;

    } catch (error) {
      logger.error(`[ClosedTicketHistory] Erro ao limpar histórico:`, error);
      Sentry.captureException(error);
      return 0;
    }
  }
}

export default ClosedTicketHistoryService;
