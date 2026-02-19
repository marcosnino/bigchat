/**
 * ClosedTicketHistoryController
 * Controller para gerenciar endpoint de histórico de tickets/chats fechados
 * Fornece filtros, estatísticas e exportação
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import { Request, Response } from "express";
import ClosedTicketHistoryService from "../services/TicketServices/ClosedTicketHistoryService";
import ClosureReportService from "../services/TicketServices/ClosureReportService";
import AppError from "../errors/AppError";
import { logger } from "../utils/logger";

class ClosedTicketHistoryController {
  /**
   * GET /closed-tickets/history
   * Listar histórico com filtros
   */
  async index(req: Request, res: Response): Promise<void> {
    try {
      const { companyId } = req.user;
      const {
        startDate,
        endDate,
        startOpenDate,
        endOpenDate,
        whatsappId,
        queueId,
        userId,
        rating,
        page = 1,
        limit = 50,
        sortBy = "ticketClosedAt",
        order = "DESC"
      } = req.query;

      const filters: any = {
        companyId,
        page: parseInt(page as string) || 1,
        limit: Math.min(parseInt(limit as string) || 50, 500),
        sortBy: sortBy as string,
        order: (order as string).toUpperCase() as "ASC" | "DESC"
      };

      // Parsear datas
      if (startDate) {
        filters.startDate = new Date(startDate as string);
      }
      if (endDate) {
        filters.endDate = new Date(endDate as string);
      }
      if (startOpenDate) {
        filters.startOpenDate = new Date(startOpenDate as string);
      }
      if (endOpenDate) {
        filters.endOpenDate = new Date(endOpenDate as string);
      }

      // Filtros numéricos
      if (whatsappId) filters.whatsappId = parseInt(whatsappId as string);
      if (queueId) filters.queueId = parseInt(queueId as string);
      if (userId) filters.userId = parseInt(userId as string);
      if (rating) filters.rating = parseInt(rating as string);

      const result = await ClosedTicketHistoryService.findClosed(filters);

      res.status(200).json({
        success: true,
        data: result.data,
        pagination: {
          page: result.page,
          pages: result.pages,
          total: result.total,
          limit: filters.limit
        }
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro na listagem:", error);
      throw error;
    }
  }

  /**
   * GET /closed-tickets/:id
   * Obter detalhes de um ticket fechado
   */
  async show(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { companyId } = req.user;

      const closedTicket = await ClosedTicketHistoryService.findById(
        parseInt(id),
        companyId
      );

      res.status(200).json({
        success: true,
        data: closedTicket
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao obter detalhes:", error);
      if (error instanceof AppError) {
        throw error;
      }
      throw new AppError("Erro ao obter detalhes", 500);
    }
  }

  /**
   * GET /closed-tickets/by-contact/:contactId
   * Obter histórico completo de um contato (handoff history)
   */
  async byContact(req: Request, res: Response): Promise<void> {
    try {
      const { contactId } = req.params;
      const { companyId } = req.user;

      const records = await ClosedTicketHistoryService.findByContact(
        parseInt(contactId),
        companyId
      );

      res.status(200).json({
        success: true,
        data: records
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao buscar por contato:", error);
      if (error instanceof AppError) {
        throw error;
      }
      throw new AppError("Erro ao buscar histórico do contato", 500);
    }
  }

  /**
   * GET /closed-tickets/by-ticket/:ticketId
   * Obter histórico de fechamentos de um ticket específico
   */
  async byTicket(req: Request, res: Response): Promise<void> {
    try {
      const { ticketId } = req.params;
      const { companyId } = req.user;

      const records = await ClosedTicketHistoryService.findByTicket(
        parseInt(ticketId),
        companyId
      );

      res.status(200).json({
        success: true,
        data: records
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao buscar por ticket:", error);
      if (error instanceof AppError) {
        throw error;
      }
      throw new AppError("Erro ao buscar histórico do ticket", 500);
    }
  }

  /**
   * GET /closed-tickets/stats
   * Obter estatísticas
   */
  async stats(req: Request, res: Response): Promise<void> {
    try {
      const { companyId } = req.user;
      const {
        startDate,
        endDate,
        startOpenDate,
        endOpenDate,
        whatsappId,
        queueId,
        userId
      } = req.query;

      const filters: any = { companyId };

      if (startDate) filters.startDate = new Date(startDate as string);
      if (endDate) filters.endDate = new Date(endDate as string);
      if (startOpenDate) filters.startOpenDate = new Date(startOpenDate as string);
      if (endOpenDate) filters.endOpenDate = new Date(endOpenDate as string);
      if (whatsappId) filters.whatsappId = parseInt(whatsappId as string);
      if (queueId) filters.queueId = parseInt(queueId as string);
      if (userId) filters.userId = parseInt(userId as string);

      const stats = await ClosedTicketHistoryService.getClosedStats(filters);

      res.status(200).json({
        success: true,
        data: stats
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao obter estatísticas:", error);
      throw error;
    }
  }

  /**
   * GET /closed-tickets/export/csv
   * Exportar como CSV
   */
  async exportCSV(req: Request, res: Response): Promise<void> {
    try {
      const { companyId } = req.user;
      const {
        startDate,
        endDate,
        startOpenDate,
        endOpenDate,
        whatsappId,
        queueId,
        userId,
        rating
      } = req.query;

      const filters: any = { companyId };

      if (startDate) filters.startDate = new Date(startDate as string);
      if (endDate) filters.endDate = new Date(endDate as string);
      if (startOpenDate) filters.startOpenDate = new Date(startOpenDate as string);
      if (endOpenDate) filters.endOpenDate = new Date(endOpenDate as string);
      if (whatsappId) filters.whatsappId = parseInt(whatsappId as string);
      if (queueId) filters.queueId = parseInt(queueId as string);
      if (userId) filters.userId = parseInt(userId as string);
      if (rating) filters.rating = parseInt(rating as string);

      const csv = await ClosedTicketHistoryService.exportToCSV(filters);

      res.setHeader("Content-Type", "text/csv; charset=utf-8");
      res.setHeader(
        "Content-Disposition",
        `attachment; filename=closed-tickets-${new Date().toISOString().split("T")[0]}.csv`
      );
      res.send(csv);

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao exportar CSV:", error);
      throw error;
    }
  }

  /**
   * POST /closed-tickets/cleanup
   * Limpar registros antigos (admin only)
   */
  async cleanup(req: Request, res: Response): Promise<void> {
    try {
      const { companyId, profile } = req.user;

      if (profile !== "admin") {
        throw new AppError("Apenas administradores podem fazer limpeza", 403);
      }

      const { daysToKeep = 90 } = req.body;

      const deleted = await ClosedTicketHistoryService.cleanupOldRecords(
        companyId,
        daysToKeep
      );

      res.status(200).json({
        success: true,
        message: `${deleted} registros removidos`,
        deletedCount: deleted
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao limpar registros:", error);
      if (error instanceof AppError) {
        throw error;
      }
      throw new AppError("Erro ao limpar registros", 500);
    }
  }

  /**
   * GET /closed-tickets/report
   * Relatório detalhado de fechamentos com estatísticas
   */
  async report(req: Request, res: Response): Promise<void> {
    try {
      const { companyId } = req.user;
      const {
        startDate,
        endDate,
        queueId,
        userId,
        whatsappId,
        closeReasonId,
        page = 1,
        limit = 50
      } = req.query;

      const filters: any = { companyId };

      if (startDate) filters.startDate = new Date(startDate as string);
      if (endDate) filters.endDate = new Date(endDate as string);
      if (queueId) filters.queueId = parseInt(queueId as string);
      if (userId) filters.userId = parseInt(userId as string);
      if (whatsappId) filters.whatsappId = parseInt(whatsappId as string);
      if (closeReasonId) filters.closeReasonId = parseInt(closeReasonId as string);
      
      filters.page = parseInt(page as string) || 1;
      filters.limit = Math.min(parseInt(limit as string) || 50, 500);

      const result = await ClosureReportService.generateReport(filters);

      res.status(200).json({
        success: true,
        data: result.data,
        summary: result.summary,
        pagination: {
          page: result.page,
          pages: result.pages,
          total: result.total,
          limit: filters.limit
        }
      });

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao gerar relatório:", error);
      throw error;
    }
  }

  /**
   * GET /closed-tickets/report/export
   * Exportar relatório para CSV
   */
  async reportExport(req: Request, res: Response): Promise<void> {
    try {
      const { companyId } = req.user;
      const {
        startDate,
        endDate,
        queueId,
        userId,
        whatsappId,
        closeReasonId
      } = req.query;

      const filters: any = { companyId };

      if (startDate) filters.startDate = new Date(startDate as string);
      if (endDate) filters.endDate = new Date(endDate as string);
      if (queueId) filters.queueId = parseInt(queueId as string);
      if (userId) filters.userId = parseInt(userId as string);
      if (whatsappId) filters.whatsappId = parseInt(whatsappId as string);
      if (closeReasonId) filters.closeReasonId = parseInt(closeReasonId as string);

      const csv = await ClosureReportService.exportToCSV(filters);

      res.setHeader("Content-Type", "text/csv; charset=utf-8");
      res.setHeader(
        "Content-Disposition",
        `attachment; filename=relatorio-fechamentos-${new Date().toISOString().split("T")[0]}.csv`
      );
      res.send(csv);

    } catch (error) {
      logger.error("[ClosedTicketHistoryController] Erro ao exportar relatório:", error);
      throw error;
    }
  }
}

export default new ClosedTicketHistoryController();
