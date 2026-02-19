/**
 * ClosureReportService
 * Serviço para relatórios detalhados de fechamentos de tickets
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import { Op, fn, col, literal } from "sequelize";
import ClosedTicketHistory from "../../models/ClosedTicketHistory";
import Contact from "../../models/Contact";
import User from "../../models/User";
import Queue from "../../models/Queue";
import Whatsapp from "../../models/Whatsapp";
import CloseReason from "../../models/CloseReason";
import { logger } from "../../utils/logger";

interface ReportFilters {
  companyId: number;
  startDate?: Date;
  endDate?: Date;
  queueId?: number;
  userId?: number;
  whatsappId?: number;
  closeReasonId?: number;
  page?: number;
  limit?: number;
}

interface ReportData {
  id: number;
  ticketId: number;
  contactName: string;
  contactNumber: string;
  userName: string | null;
  queueName: string | null;
  whatsappName: string;
  closeReason: string | null;
  ticketOpenedAt: Date;
  ticketClosedAt: Date;
  durationSeconds: number;
  durationFormatted: string;
  totalMessages: number;
  rating: number | null;
}

interface ReportSummary {
  totalTickets: number;
  averageDuration: number;
  averageDurationFormatted: string;
  totalMessages: number;
  averageRating: number | null;
  byQueue: Array<{
    queueName: string;
    count: number;
    percentage: number;
  }>;
  byCloseReason: Array<{
    reason: string;
    count: number;
    percentage: number;
  }>;
  byUser: Array<{
    userName: string;
    count: number;
    percentage: number;
  }>;
}

class ClosureReportService {
  /**
   * Formata duração em segundos para HH:MM:SS
   */
  private static formatDuration(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    
    return `${hours.toString().padStart(2, "0")}:${minutes
      .toString()
      .padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
  }

  /**
   * Gera relatório detalhado de fechamentos
   */
  static async generateReport(
    filters: ReportFilters
  ): Promise<{ data: ReportData[]; summary: ReportSummary; total: number; page: number; pages: number }> {
    try {
      const {
        companyId,
        startDate,
        endDate,
        queueId,
        userId,
        whatsappId,
        closeReasonId,
        page = 1,
        limit = 50
      } = filters;

      // Limitar paginação a no máximo 500 registros
      const safeLimit = Math.min(limit, 500);

      // Construir where condition
      const whereCondition: any = { companyId };

      // Filtro de data de fechamento
      if (startDate || endDate) {
        whereCondition.ticketClosedAt = {};
        if (startDate) {
          whereCondition.ticketClosedAt[Op.gte] = startDate;
        }
        if (endDate) {
          // Adicionar 23:59:59 para incluir o dia inteiro
          const endOfDay = new Date(endDate);
          endOfDay.setHours(23, 59, 59, 999);
          whereCondition.ticketClosedAt[Op.lte] = endOfDay;
        }
      }

      if (queueId) whereCondition.queueId = queueId;
      if (userId) whereCondition.userId = userId;
      if (whatsappId) whereCondition.whatsappId = whatsappId;

      // Filtro por motivo de fechamento
      if (closeReasonId) {
        whereCondition.closureReason = {
          [Op.like]: `%"id":${closeReasonId}%`
        };
      }

      // Buscar dados paginados
      const offset = (page - 1) * safeLimit;
      const { rows, count } = await ClosedTicketHistory.findAndCountAll({
        where: whereCondition,
        include: [
          {
            model: Contact,
            attributes: ["name", "number"],
            required: false
          },
          {
            model: User,
            attributes: ["name"],
            required: false
          },
          {
            model: Queue,
            attributes: ["name", "color"],
            required: false
          },
          {
            model: Whatsapp,
            attributes: ["name"],
            required: false
          }
        ],
        order: [["ticketClosedAt", "DESC"]],
        limit: safeLimit,
        offset
      });

      // Formatar dados
      const data: ReportData[] = rows.map(record => {
        let closeReasonText = null;
        if (record.closureReason) {
          try {
            const parsed = JSON.parse(record.closureReason);
            closeReasonText = parsed.name || null;
          } catch {
            closeReasonText = null;
          }
        }

        return {
          id: record.id,
          ticketId: record.ticketId,
          contactName: record.contact?.name || "N/A",
          contactNumber: record.contact?.number || "N/A",
          userName: record.user?.name || null,
          queueName: record.queue?.name || null,
          whatsappName: record.whatsapp?.name || "N/A",
          closeReason: closeReasonText,
          ticketOpenedAt: record.ticketOpenedAt,
          ticketClosedAt: record.ticketClosedAt,
          durationSeconds: record.durationSeconds,
          durationFormatted: this.formatDuration(record.durationSeconds),
          totalMessages: record.totalMessages,
          rating: record.rating
        };
      });

      // Buscar dados para sumário (sem paginação)
      const allRecords = await ClosedTicketHistory.findAll({
        where: whereCondition,
        include: [
          {
            model: User,
            attributes: ["name"],
            required: false
          },
          {
            model: Queue,
            attributes: ["name"],
            required: false
          }
        ]
      });

      // Calcular sumário
      const summary = this.calculateSummary(allRecords);

      const pages = Math.ceil(count / limit);

      return { data, summary, total: count, page, pages };
    } catch (error) {
      logger.error("[ClosureReportService] Erro ao gerar relatório:", error);
      throw error;
    }
  }

  /**
   * Calcula sumário estatístico
   */
  private static calculateSummary(records: ClosedTicketHistory[]): ReportSummary {
    const totalTickets = records.length;
    const totalDuration = records.reduce((sum, r) => sum + r.durationSeconds, 0);
    const totalMessages = records.reduce((sum, r) => sum + r.totalMessages, 0);
    
    const withRating = records.filter(r => r.rating !== null && r.rating !== undefined);
    const totalRating = withRating.reduce((sum, r) => sum + (r.rating || 0), 0);
    const averageRating = withRating.length > 0 ? totalRating / withRating.length : null;

    const averageDuration = totalTickets > 0 ? Math.floor(totalDuration / totalTickets) : 0;

    // Agrupar por fila
    const queueMap = new Map<string, number>();
    records.forEach(r => {
      const queueName = r.queue?.name || "Sem fila";
      queueMap.set(queueName, (queueMap.get(queueName) || 0) + 1);
    });

    const byQueue = Array.from(queueMap.entries())
      .map(([queueName, count]) => ({
        queueName,
        count,
        percentage: totalTickets > 0 ? (count / totalTickets) * 100 : 0
      }))
      .sort((a, b) => b.count - a.count);

    // Agrupar por motivo de fechamento
    const reasonMap = new Map<string, number>();
    records.forEach(r => {
      let reason = "Sem motivo";
      if (r.closureReason) {
        try {
          const parsed = JSON.parse(r.closureReason);
          reason = parsed.name || "Sem motivo";
        } catch {
          reason = "Sem motivo";
        }
      }
      reasonMap.set(reason, (reasonMap.get(reason) || 0) + 1);
    });

    const byCloseReason = Array.from(reasonMap.entries())
      .map(([reason, count]) => ({
        reason,
        count,
        percentage: totalTickets > 0 ? (count / totalTickets) * 100 : 0
      }))
      .sort((a, b) => b.count - a.count);

    // Agrupar por usuário
    const userMap = new Map<string, number>();
    records.forEach(r => {
      const userName = r.user?.name || "Sem usuário";
      userMap.set(userName, (userMap.get(userName) || 0) + 1);
    });

    const byUser = Array.from(userMap.entries())
      .map(([userName, count]) => ({
        userName,
        count,
        percentage: totalTickets > 0 ? (count / totalTickets) * 100 : 0
      }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 10); // Top 10 usuários

    return {
      totalTickets,
      averageDuration,
      averageDurationFormatted: this.formatDuration(averageDuration),
      totalMessages,
      averageRating,
      byQueue,
      byCloseReason,
      byUser
    };
  }

  /**
   * Exporta relatório para CSV
   */
  static async exportToCSV(filters: ReportFilters): Promise<string> {
    try {
      const { data } = await this.generateReport({ ...filters, limit: 10000, page: 1 });

      // Cabeçalho CSV
      const headers = [
        "ID",
        "Ticket ID",
        "Contato",
        "Número",
        "Usuário",
        "Fila",
        "WhatsApp",
        "Motivo Fechamento",
        "Data Abertura",
        "Data Fechamento",
        "Tempo Atendimento",
        "Total Mensagens",
        "Avaliação"
      ];

      const rows = data.map(record => [
        record.id,
        record.ticketId,
        record.contactName,
        record.contactNumber,
        record.userName || "",
        record.queueName || "",
        record.whatsappName,
        record.closeReason || "",
        new Date(record.ticketOpenedAt).toLocaleString("pt-BR"),
        new Date(record.ticketClosedAt).toLocaleString("pt-BR"),
        record.durationFormatted,
        record.totalMessages,
        record.rating !== null ? record.rating : ""
      ]);

      // Gerar CSV com BOM UTF-8 para compatibilidade com Excel
      const BOM = "\ufeff";
      const csvContent = [
        headers.join(";"),
        ...rows.map(row => row.map(cell => `"${cell}"`).join(";"))
      ].join("\n");

      return BOM + csvContent;
    } catch (error) {
      logger.error("[ClosureReportService] Erro ao exportar CSV:", error);
      throw error;
    }
  }
}

export default ClosureReportService;
