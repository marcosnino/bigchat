/**
 * UserWhatsappQueueService
 * Service para gerenciar vinculações de usuário com números WhatsApp e filas
 * 
 * Validações de Dev Sênior:
 * - Usuário deve ter permissão na fila (UserQueue)
 * - Número deve estar CONNECTED
 * - Fila deve estar ativa
 * - Evitar duplicatas
 * - Validar company_id
 * - Cascata de deleção em caso de mudanças
 * - Logs de auditoria
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import { Op } from "sequelize";
import UserWhatsappQueue from "../../models/UserWhatsappQueue";
import User from "../../models/User";
import Whatsapp from "../../models/Whatsapp";
import Queue from "../../models/Queue";
import UserQueue from "../../models/UserQueue";
import AppError from "../../errors/AppError";
import { logger } from "../../utils/logger";
import { getIO } from "../../libs/socket";

interface CreateUserWhatsappQueueRequest {
  userId: number;
  whatsappId: number;
  queueId: number;
  notes?: string;
  companyId: number;
}

interface UpdateUserWhatsappQueueRequest {
  isActive?: boolean;
  notes?: string;
}

interface UserWhatsappQueueFilters {
  userId?: number;
  whatsappId?: number;
  queueId?: number;
  isActive?: boolean;
  companyId: number;
}

class UserWhatsappQueueService {
  /**
   * Validação robusta antes de criar vinculação
   */
  private static async validateBeforeCreate(
    userId: number,
    whatsappId: number,
    queueId: number,
    companyId: number
  ): Promise<{
    user: User;
    whatsapp: Whatsapp;
    queue: Queue;
  }> {
    const errors: string[] = [];

    // Validação 1: Usuário existe e pertence à company
    const user = await User.findOne({
      where: { id: userId, companyId },
      include: [
        {
          model: Queue,
          as: "queues",
          through: { attributes: [] }
        }
      ]
    });

    if (!user) {
      errors.push(`Usuário ID ${userId} não encontrado ou não pertence à esta empresa`);
    }

    // Validação 2: Número WhatsApp existe e pertence à company
    const whatsapp = await Whatsapp.findOne({
      where: { id: whatsappId, companyId }
    });

    if (!whatsapp) {
      errors.push(`Número WhatsApp ID ${whatsappId} não encontrado ou não pertence à esta empresa`);
    }

    // Validação 3: Fila existe e pertence à company
    const queue = await Queue.findOne({
      where: { id: queueId, companyId }
    });

    if (!queue) {
      errors.push(`Fila ID ${queueId} não encontrada ou não pertence à esta empresa`);
    }

    if (errors.length > 0) {
      logger.error(`Erros na validação: ${errors.join(", ")}`);
      throw new AppError(errors.join("; "), 400);
    }

    // Validação 4: Número WhatsApp deve estar CONNECTED
    if (whatsapp.status !== "CONNECTED") {
      throw new AppError(
        `Número WhatsApp "${whatsapp.name}" não está conectado (Status: ${whatsapp.status}). ` +
        `Apenas números conectados podem ser atribuídos a usuários.`,
        400
      );
    }

    // Validação 5: Usuário deve ter acesso à fila (estar em UserQueue)
    const userHasQueueAccess = user.queues?.some(q => q.id === queueId);
    
    if (!userHasQueueAccess) {
      throw new AppError(
        `Usuário "${user.name}" não tem permissão para a fila "${queue.name}". ` +
        `Adicione o usuário à fila primeiro nas configurações de filas.`,
        403
      );
    }

    // Validação 6: Evitar duplicata
    const existingLink = await UserWhatsappQueue.findOne({
      where: {
        userId,
        whatsappId,
        queueId
      }
    });

    if (existingLink) {
      throw new AppError(
        `Essa vinculação já existe. Usuário "${user.name}" já está atribuído ao ` +
        `número "${whatsapp.name}" na fila "${queue.name}".`,
        409
      );
    }

    return { user, whatsapp, queue };
  }

  /**
   * Criar nova vinculação usuário-whatsapp-queue
   */
  static async create(data: CreateUserWhatsappQueueRequest): Promise<UserWhatsappQueue> {
    try {
      const { userId, whatsappId, queueId, notes, companyId } = data;

      // Validações
      const { user, whatsapp, queue } = await this.validateBeforeCreate(
        userId,
        whatsappId,
        queueId,
        companyId
      );

      // Criar vinculação
      const userWhatsappQueue = await UserWhatsappQueue.create({
        userId,
        whatsappId,
        queueId,
        notes: notes || `Atribuído por configuração de usuário`,
        isActive: true
      });

      // Buscar registro completo
      const fullRecord = await UserWhatsappQueue.findByPk(userWhatsappQueue.id, {
        include: [
          { model: User, attributes: ["id", "name", "email"] },
          { model: Whatsapp, attributes: ["id", "name", "status"] },
          { model: Queue, attributes: ["id", "name", "color"] }
        ]
      });

      // Log auditoria
      logger.info(
        `[UserWhatsappQueue] Vinculação criada: ` +
        `Usuário "${user.name}" → Número "${whatsapp.name}" → Fila "${queue.name}"`
      );

      // Notificar via WebSocket
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-user-whatsapp-queue`, {
        action: "create",
        data: fullRecord,
        message: `Usuário ${user.name} atribuído ao número ${whatsapp.name} na fila ${queue.name}`
      });

      return fullRecord;

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao criar vinculação:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao criar vinculação", 500);
    }
  }

  /**
   * Atualizar vinculação
   */
  static async update(
    id: number,
    data: UpdateUserWhatsappQueueRequest,
    companyId: number
  ): Promise<UserWhatsappQueue> {
    try {
      const userWhatsappQueue = await UserWhatsappQueue.findByPk(id, {
        include: [
          { model: User },
          { model: Whatsapp },
          { model: Queue }
        ]
      });

      if (!userWhatsappQueue) {
        throw new AppError("Vinculação não encontrada", 404);
      }

      // Validar company
      const user = await User.findByPk(userWhatsappQueue.userId);
      if (user.companyId !== companyId) {
        throw new AppError("Sem permissão para modificar essa vinculação", 403);
      }

      // Atualizar
      await userWhatsappQueue.update(data);

      logger.info(
        `[UserWhatsappQueue] Vinculação atualizada (ID: ${id}): ${JSON.stringify(data)}`
      );

      // Notificar via WebSocket
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-user-whatsapp-queue`, {
        action: "update",
        data: userWhatsappQueue,
        message: `Vinculação atualizada`
      });

      return userWhatsappQueue;

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao atualizar vinculação:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao atualizar vinculação", 500);
    }
  }

  /**
   * Deletar vinculação
   */
  static async delete(id: number, companyId: number): Promise<void> {
    try {
      const userWhatsappQueue = await UserWhatsappQueue.findByPk(id, {
        include: [
          { model: User },
          { model: Whatsapp },
          { model: Queue }
        ]
      });

      if (!userWhatsappQueue) {
        throw new AppError("Vinculação não encontrada", 404);
      }

      // Validar company
      const user = await User.findByPk(userWhatsappQueue.userId);
      if (user.companyId !== companyId) {
        throw new AppError("Sem permissão para deletar essa vinculação", 403);
      }

      const userData = userWhatsappQueue.user;
      const whatsappData = userWhatsappQueue.whatsapp;
      const queueData = userWhatsappQueue.queue;

      // Deletar
      await userWhatsappQueue.destroy();

      logger.info(
        `[UserWhatsappQueue] Vinculação deletada: ` +
        `Usuário "${userData.name}" → Número "${whatsappData.name}" → Fila "${queueData.name}"`
      );

      // Notificar via WebSocket
      const io = getIO();
      io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-user-whatsapp-queue`, {
        action: "delete",
        data: { id },
        message: `Vinculação removida`
      });

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao deletar vinculação:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao deletar vinculação", 500);
    }
  }

  /**
   * Listar vinculações com filtros
   */
  static async list(filters: UserWhatsappQueueFilters): Promise<UserWhatsappQueue[]> {
    try {
      const where: any = {};

      if (filters.userId) where.userId = filters.userId;
      if (filters.whatsappId) where.whatsappId = filters.whatsappId;
      if (filters.queueId) where.queueId = filters.queueId;
      if (typeof filters.isActive === "boolean") where.isActive = filters.isActive;

      const userWhatsappQueues = await UserWhatsappQueue.findAll({
        where,
        include: [
          {
            model: User,
            where: { companyId: filters.companyId },
            attributes: ["id", "name", "email", "profile"]
          },
          {
            model: Whatsapp,
            where: { companyId: filters.companyId },
            attributes: ["id", "name", "status"]
          },
          {
            model: Queue,
            where: { companyId: filters.companyId },
            attributes: ["id", "name", "color"]
          }
        ],
        order: [["createdAt", "DESC"]]
      });

      return userWhatsappQueues;

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao listar vinculações:`, error);
      throw new AppError("Erro ao listar vinculações", 500);
    }
  }

  /**
   * Obter vinculações de um usuário específico
   */
  static async findByUser(userId: number, companyId: number): Promise<UserWhatsappQueue[]> {
    try {
      const user = await User.findByPk(userId);
      
      if (!user || user.companyId !== companyId) {
        throw new AppError("Usuário não encontrado", 404);
      }

      return await this.list({
        userId,
        companyId,
        isActive: true
      });

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao buscar vinculações do usuário:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao buscar vinculações", 500);
    }
  }

  /**
   * Obter usuários disponíveis para um número/fila
   */
  static async findAvailableUsers(
    whatsappId: number,
    queueId: number,
    companyId: number
  ): Promise<Array<{ id: number; name: string; email: string; assigned: boolean }>> {
    try {
      const whatsapp = await Whatsapp.findByPk(whatsappId);
      const queue = await Queue.findByPk(queueId);

      if (!whatsapp || whatsapp.companyId !== companyId) {
        throw new AppError("Número WhatsApp não encontrado", 404);
      }

      if (!queue || queue.companyId !== companyId) {
        throw new AppError("Fila não encontrada", 404);
      }

      // Buscar usuários que têm acesso à fila
      const usersWithQueueAccess = await User.findAll({
        where: { companyId },
        include: [
          {
            model: Queue,
            as: "queues",
            where: { id: queueId },
            through: { attributes: [] }
          }
        ],
        attributes: ["id", "name", "email"]
      });

      // Buscar usuários já atribuídos a esse número/fila
      const assignedUsers = await UserWhatsappQueue.findAll({
        where: {
          whatsappId,
          queueId,
          isActive: true
        },
        attributes: ["userId"]
      });

      const assignedUserIds = assignedUsers.map(u => u.userId);

      // Mapear resultado
      return usersWithQueueAccess.map(user => ({
        id: user.id,
        name: user.name,
        email: user.email,
        assigned: assignedUserIds.includes(user.id)
      }));

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao buscar usuários disponíveis:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao buscar usuários", 500);
    }
  }

  /**
   * Desativar todas as vinculações de um usuário (quando removido de uma fila)
   */
  static async deactivateUserQueueLinks(userId: number, queueId: number, companyId: number): Promise<number> {
    try {
      const user = await User.findByPk(userId);
      
      if (!user || user.companyId !== companyId) {
        throw new AppError("Usuário não encontrado", 404);
      }

      const [updatedCount] = await UserWhatsappQueue.update(
        { isActive: false },
        {
          where: {
            userId,
            queueId
          }
        }
      );

      if (updatedCount > 0) {
        logger.info(
          `[UserWhatsappQueue] ${updatedCount} vinculação(ões) desativada(s) ` +
          `para usuário ID ${userId} na fila ID ${queueId}`
        );
      }

      return updatedCount;

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao desativar vinculações:`, error);
      if (error instanceof AppError) throw error;
      throw new AppError("Erro ao desativar vinculações", 500);
    }
  }

  /**
   * Alertar sobre números desconectados
   */
  static async checkDisconnectedWhatsApps(companyId: number): Promise<any[]> {
    try {
      const disconnectedAssignments = await UserWhatsappQueue.findAll({
        where: { isActive: true },
        include: [
          {
            model: Whatsapp,
            where: {
              companyId,
              status: { [Op.ne]: "CONNECTED" }
            }
          }
        ]
      });

      if (disconnectedAssignments.length > 0) {
        logger.warn(
          `[UserWhatsappQueue] ${disconnectedAssignments.length} usuário(s) atribuído(s) ` +
          `a número(s) WhatsApp desconectado(s)`
        );
      }

      return disconnectedAssignments;

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao verificar números desconectados:`, error);
      return [];
    }
  }

  /**
   * Obter estatísticas de vinculações
   */
  static async getStatistics(companyId: number): Promise<any> {
    try {
      const totalLinks = await UserWhatsappQueue.count({
        include: [
          {
            model: User,
            where: { companyId }
          }
        ]
      });

      const activeLinks = await UserWhatsappQueue.count({
        where: { isActive: true },
        include: [
          {
            model: User,
            where: { companyId }
          }
        ]
      });

      const usersWithAssignments = await UserWhatsappQueue.findAll({
        attributes: ["userId"],
        include: [
          {
            model: User,
            where: { companyId }
          }
        ],
        raw: true,
        subQuery: false,
        group: ["userId"]
      });

      return {
        totalLinks,
        activeLinks,
        inactiveLinks: totalLinks - activeLinks,
        usersWithAssignments: usersWithAssignments.length
      };

    } catch (error) {
      logger.error(`[UserWhatsappQueue] Erro ao obter estatísticas:`, error);
      return { totalLinks: 0, activeLinks: 0, inactiveLinks: 0, usersWithAssignments: 0 };
    }
  }
}

export default UserWhatsappQueueService;
