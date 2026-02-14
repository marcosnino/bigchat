import { Request, Response } from "express";
import MessageSemaphoreService from "../services/MessageServices/MessageSemaphoreService";

/**
 * Controller para gerenciar o sistema de semáforo de mensagens
 */

/**
 * Obter estatísticas do semáforo para um ticket específico
 */
export const getTicketSemaphoreStats = async (
  req: Request,
  res: Response
): Promise<Response> => {
  try {
    const { ticketId } = req.params;
    const { companyId } = req.user;

    const stats = await MessageSemaphoreService.getTicketSemaphoreStats(
      parseInt(ticketId)
    );

    return res.status(200).json(stats);
  } catch (error) {
    console.error("Erro ao obter estatísticas do semáforo:", error);
    return res.status(500).json({ 
      error: "Erro interno do servidor",
      message: error.message 
    });
  }
};

/**
 * Obter estatísticas globais do semáforo para a empresa
 */
export const getCompanySemaphoreStats = async (
  req: Request,
  res: Response
): Promise<Response> => {
  try {
    const { companyId } = req.user;

    const stats = await MessageSemaphoreService.getCompanySemaphoreStats(
      companyId
    );

    return res.status(200).json(stats);
  } catch (error) {
    console.error("Erro ao obter estatísticas globais do semáforo:", error);
    return res.status(500).json({ 
      error: "Erro interno do servidor",
      message: error.message 
    });
  }
};

/**
 * Marcar mensagens de um ticket como respondidas manualmente
 */
export const markMessagesAsReplied = async (
  req: Request,
  res: Response
): Promise<Response> => {
  try {
    const { ticketId } = req.params;
    const { companyId } = req.user;

    await MessageSemaphoreService.markPendingMessagesAsReplied(
      parseInt(ticketId)
    );

    return res.status(200).json({ 
      message: "Mensagens marcadas como respondidas com sucesso" 
    });
  } catch (error) {
    console.error("Erro ao marcar mensagens como respondidas:", error);
    return res.status(500).json({ 
      error: "Erro interno do servidor",
      message: error.message 
    });
  }
};

/**
 * Reset do sistema de semáforo para um ticket
 */
export const resetTicketSemaphore = async (
  req: Request,
  res: Response
): Promise<Response> => {
  try {
    const { ticketId } = req.params;
    const { companyId } = req.user;

    await MessageSemaphoreService.resetTicketSemaphore(parseInt(ticketId));

    return res.status(200).json({ 
      message: "Semáforo do ticket resetado com sucesso" 
    });
  } catch (error) {
    console.error("Erro ao resetar semáforo do ticket:", error);
    return res.status(500).json({ 
      error: "Erro interno do servidor",
      message: error.message 
    });
  }
};