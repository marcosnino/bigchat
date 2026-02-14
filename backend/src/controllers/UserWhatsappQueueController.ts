/**
 * UserWhatsappQueueController
 * Controlador para gerenciar vinculações de usuário-whatsapp-fila
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import { Request, Response } from "express";
import UserWhatsappQueueService from "../services/UserServices/UserWhatsappQueueService";
import AppError from "../errors/AppError";

/**
 * Criar nova vinculação
 * POST /user-whatsapp-queue
 */
export const store = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    const { userId, whatsappId, queueId, notes } = req.body;

    // Validações básicas
    if (!userId || !whatsappId || !queueId) {
      return res.status(400).json({
        success: false,
        message: "Usuário, Número WhatsApp e Fila são obrigatórios"
      });
    }

    const userWhatsappQueue = await UserWhatsappQueueService.create({
      userId: Number(userId),
      whatsappId: Number(whatsappId),
      queueId: Number(queueId),
      notes: notes || undefined,
      companyId
    });

    return res.status(201).json({
      success: true,
      message: "Vinculação criada com sucesso",
      data: userWhatsappQueue
    });

  } catch (error) {
    const message = error instanceof AppError 
      ? error.message 
      : "Erro ao criar vinculação";
    
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    
    return res.status(statusCode).json({
      success: false,
      message,
      error: error.message
    });
  }
};

/**
 * Listar vinculações com filtros
 * GET /user-whatsapp-queue
 */
export const index = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    const { userId, whatsappId, queueId, isActive } = req.query;

    const filters: any = { companyId };

    if (userId) filters.userId = Number(userId);
    if (whatsappId) filters.whatsappId = Number(whatsappId);
    if (queueId) filters.queueId = Number(queueId);
    if (typeof isActive !== "undefined") filters.isActive = isActive === "true";

    const userWhatsappQueues = await UserWhatsappQueueService.list(filters);

    return res.status(200).json({
      success: true,
      count: userWhatsappQueues.length,
      data: userWhatsappQueues
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao listar vinculações",
      error: error.message
    });
  }
};

/**
 * Obter uma vinculação específica
 * GET /user-whatsapp-queue/:id
 */
export const show = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id } = req.params;
    const { companyId } = req.user;

    const userWhatsappQueue = await UserWhatsappQueueService.findByUser(
      Number(id),
      companyId
    );

    return res.status(200).json({
      success: true,
      data: userWhatsappQueue
    });

  } catch (error) {
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    return res.status(statusCode).json({
      success: false,
      message: "Erro ao buscar vinculações",
      error: error.message
    });
  }
};

/**
 * Atualizar uma vinculação
 * PUT /user-whatsapp-queue/:id
 */
export const update = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id } = req.params;
    const { companyId } = req.user;
    const { isActive, notes } = req.body;

    const userWhatsappQueue = await UserWhatsappQueueService.update(
      Number(id),
      { isActive, notes },
      companyId
    );

    return res.status(200).json({
      success: true,
      message: "Vinculação atualizada com sucesso",
      data: userWhatsappQueue
    });

  } catch (error) {
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    return res.status(statusCode).json({
      success: false,
      message: "Erro ao atualizar vinculação",
      error: error.message
    });
  }
};

/**
 * Deletar uma vinculação
 * DELETE /user-whatsapp-queue/:id
 */
export const remove = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { id } = req.params;
    const { companyId } = req.user;

    await UserWhatsappQueueService.delete(Number(id), companyId);

    return res.status(200).json({
      success: true,
      message: "Vinculação deletada com sucesso"
    });

  } catch (error) {
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    return res.status(statusCode).json({
      success: false,
      message: "Erro ao deletar vinculação",
      error: error.message
    });
  }
};

/**
 * Obter usuários disponíveis para um número/fila
 * GET /user-whatsapp-queue/available/:whatsappId/:queueId
 */
export const getAvailableUsers = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { whatsappId, queueId } = req.params;
    const { companyId } = req.user;

    const users = await UserWhatsappQueueService.findAvailableUsers(
      Number(whatsappId),
      Number(queueId),
      companyId
    );

    return res.status(200).json({
      success: true,
      count: users.length,
      data: users
    });

  } catch (error) {
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    return res.status(statusCode).json({
      success: false,
      message: "Erro ao buscar usuários disponíveis",
      error: error.message
    });
  }
};

/**
 * Desativar vinculações de um usuário em uma fila
 * DELETE /user-whatsapp-queue/user/:userId/queue/:queueId
 */
export const deactivateUserQueue = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { userId, queueId } = req.params;
    const { companyId } = req.user;

    const updated = await UserWhatsappQueueService.deactivateUserQueueLinks(
      Number(userId),
      Number(queueId),
      companyId
    );

    return res.status(200).json({
      success: true,
      message: `${updated} vinculação(ões) desativada(s)`,
      data: { updated }
    });

  } catch (error) {
    const statusCode = error instanceof AppError ? error.statusCode : 500;
    return res.status(statusCode).json({
      success: false,
      message: "Erro ao desativar vinculações",
      error: error.message
    });
  }
};

/**
 * Verificar números desconectados com usuários atribuídos
 * GET /user-whatsapp-queue/warnings
 */
export const getWarnings = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;

    const disconnected = await UserWhatsappQueueService.checkDisconnectedWhatsApps(companyId);

    return res.status(200).json({
      success: true,
      count: disconnected.length,
      message: disconnected.length > 0 
        ? `${disconnected.length} usuário(s) atribuído(s) a número(s) desconectado(s)`
        : "Nenhum aviso",
      data: disconnected
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao buscar avisos",
      error: error.message
    });
  }
};

/**
 * Obter estatísticas
 * GET /user-whatsapp-queue/statistics
 */
export const getStatistics = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;

    const stats = await UserWhatsappQueueService.getStatistics(companyId);

    return res.status(200).json({
      success: true,
      data: stats
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao obter estatísticas",
      error: error.message
    });
  }
};
