/**
 * closedTicketHistoryRoutes
 * Rotas para histórico de tickets/chats fechados
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import { Router } from "express";
import isAuth from "../middleware/isAuth";
import ClosedTicketHistoryController from "../controllers/ClosedTicketHistoryController";

const router = Router();

/**
 * GET /closed-tickets/history
 * Lista histórico com filtros avançados
 * Query params:
 *   - startDate: Data início do fechamento (ISO)
 *   - endDate: Data fim do fechamento (ISO)
 *   - startOpenDate: Data início da abertura (ISO)
 *   - endOpenDate: Data fim da abertura (ISO)
 *   - whatsappId: Filtrar por número
 *   - queueId: Filtrar por fila
 *   - userId: Filtrar por agente
 *   - rating: Filtrar por rating
 *   - page: Página (default: 1)
 *   - limit: Itens por página (default: 50, máx: 500)
 *   - sortBy: Campo para ordenar (default: ticketClosedAt)
 *   - order: ASC ou DESC (default: DESC)
 */
router.get("/closed-tickets/history", isAuth, ClosedTicketHistoryController.index);

/**
 * GET /closed-tickets/report
 * Relatório detalhado de fechamentos com estatísticas agrupadas
 * Query params:
 *   - startDate: Data início (ISO)
 *   - endDate: Data fim (ISO)
 *   - queueId: Filtrar por fila
 *   - userId: Filtrar por usuário
 *   - whatsappId: Filtrar por WhatsApp
 *   - closeReasonId: Filtrar por motivo de fechamento
 *   - page: Página (default: 1)
 *   - limit: Itens por página (default: 50, máx: 500)
 */
router.get("/closed-tickets/report", isAuth, ClosedTicketHistoryController.report);

/**
 * GET /closed-tickets/report/export
 * Exportar relatório de fechamentos em CSV
 * Aceita mesmos filtros que /report
 */
router.get("/closed-tickets/report/export", isAuth, ClosedTicketHistoryController.reportExport);

/**
 * GET /closed-tickets/stats
 * Obter estatísticas de tickets fechados
 * Retorna: total, tempo médio, mensagens, rating, grafos por fila/número/usuário
 */
router.get("/closed-tickets/stats", isAuth, ClosedTicketHistoryController.stats);

/**
 * GET /closed-tickets/export/csv
 * Exportar histórico em CSV
 * Aceita mesmos filtros que /history
 */
router.get("/closed-tickets/export/csv", isAuth, ClosedTicketHistoryController.exportCSV);

/**
 * GET /closed-tickets/by-contact/:contactId
 * Obter histórico completo de um contato (handoff history)
 */
router.get("/closed-tickets/by-contact/:contactId", isAuth, ClosedTicketHistoryController.byContact);

/**
 * GET /closed-tickets/by-ticket/:ticketId
 * Obter histórico de fechamentos de um ticket específico
 */
router.get("/closed-tickets/by-ticket/:ticketId", isAuth, ClosedTicketHistoryController.byTicket);

/**
 * GET /closed-tickets/:id
 * Obter detalhes de um ticket fechado
 */
router.get("/closed-tickets/:id", isAuth, ClosedTicketHistoryController.show);

/**
 * POST /closed-tickets/cleanup
 * Limpar registros antigos (admin only)
 * Body: { daysToKeep: 90 }
 */
router.post("/closed-tickets/cleanup", isAuth, ClosedTicketHistoryController.cleanup);

export default router;
