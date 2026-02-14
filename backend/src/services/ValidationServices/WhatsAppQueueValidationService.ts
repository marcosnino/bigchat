/**
 * WhatsAppQueueValidationService
 * Serviço para validar vinculação entre números WhatsApp e filas
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import Whatsapp from "../../models/Whatsapp";
import Queue from "../../models/Queue";
import WhatsappQueue from "../../models/WhatsappQueue";
import { logger } from "../../utils/logger";
import AppError from "../../errors/AppError";

interface ValidationResult {
  isValid: boolean;
  errors: string[];
  warnings: string[];
  statistics: {
    totalWhatsApps: number;
    totalQueues: number;
    whatsAppsWithoutQueues: number;
    queuesWithoutWhatsApps: number;
    validConnections: number;
  };
}

interface WhatsAppQueueReport {
  whatsAppId: number;
  whatsAppName: string;
  status: string;
  queues: Array<{
    id: number;
    name: string;
    color: string;
  }>;
}

interface QueueWhatsAppReport {
  queueId: number;
  queueName: string;
  color: string;
  whatsApps: Array<{
    id: number;
    name: string;
    status: string;
  }>;
}

class WhatsAppQueueValidationService {
  /**
   * Valida a vinculação entre números WhatsApp e filas
   */
  public static async validateConnections(companyId: number): Promise<ValidationResult> {
    try {
      const result: ValidationResult = {
        isValid: true,
        errors: [],
        warnings: [],
        statistics: {
          totalWhatsApps: 0,
          totalQueues: 0,
          whatsAppsWithoutQueues: 0,
          queuesWithoutWhatsApps: 0,
          validConnections: 0
        }
      };

      // Buscar todos os WhatsApps da empresa
      const whatsApps = await Whatsapp.findAll({
        where: { companyId },
        include: [
          {
            model: Queue,
            as: "queues",
            through: { attributes: [] }
          }
        ]
      });

      // Buscar todas as filas da empresa
      const queues = await Queue.findAll({
        where: { companyId },
        include: [
          {
            model: Whatsapp,
            as: "whatsapps",
            through: { attributes: [] }
          }
        ]
      });

      result.statistics.totalWhatsApps = whatsApps.length;
      result.statistics.totalQueues = queues.length;

      // Validar WhatsApps sem filas
      const whatsAppsWithoutQueues = whatsApps.filter(wa => 
        !wa.queues || wa.queues.length === 0
      );

      if (whatsAppsWithoutQueues.length > 0) {
        result.isValid = false;
        result.statistics.whatsAppsWithoutQueues = whatsAppsWithoutQueues.length;
        
        whatsAppsWithoutQueues.forEach(wa => {
          result.errors.push(
            `WhatsApp "${wa.name}" (ID: ${wa.id}) não possui filas vinculadas`
          );
        });
      }

      // Validar filas sem WhatsApps
      const queuesWithoutWhatsApps = queues.filter(queue => 
        !queue.whatsapps || queue.whatsapps.length === 0
      );

      if (queuesWithoutWhatsApps.length > 0) {
        result.isValid = false;
        result.statistics.queuesWithoutWhatsApps = queuesWithoutWhatsApps.length;
        
        queuesWithoutWhatsApps.forEach(queue => {
          result.errors.push(
            `Fila "${queue.name}" (ID: ${queue.id}) não possui números WhatsApp vinculados`
          );
        });
      }

      // Contar conexões válidas
      result.statistics.validConnections = await WhatsappQueue.count({
        where: {},
        include: [
          {
            model: Whatsapp,
            where: { companyId }
          }
        ]
      });

      // Adicionar warnings para WhatsApps desconectados
      const disconnectedWhatsApps = whatsApps.filter(wa => 
        wa.status !== "CONNECTED" && wa.queues && wa.queues.length > 0
      );

      disconnectedWhatsApps.forEach(wa => {
        result.warnings.push(
          `WhatsApp "${wa.name}" está ${wa.status} mas possui filas vinculadas`
        );
      });

      if (result.isValid) {
        logger.info(`✅ Validação WhatsApp-Queue concluída para empresa ${companyId}: Todas as vinculações estão corretas`);
      } else {
        logger.warn(`⚠️ Validação WhatsApp-Queue encontrou problemas para empresa ${companyId}: ${result.errors.length} erros`);
      }

      return result;

    } catch (error) {
      logger.error("Erro na validação WhatsApp-Queue:", error);
      throw new AppError("Erro interno na validação de vinculações", 500);
    }
  }

  /**
   * Gera relatório detalhado de WhatsApps e suas filas
   */
  public static async getWhatsAppQueuesReport(companyId: number): Promise<WhatsAppQueueReport[]> {
    try {
      const whatsApps = await Whatsapp.findAll({
        where: { companyId },
        include: [
          {
            model: Queue,
            as: "queues",
            through: { attributes: [] }
          }
        ],
        order: [['id', 'ASC']]
      });

      return whatsApps.map(wa => ({
        whatsAppId: wa.id,
        whatsAppName: wa.name,
        status: wa.status,
        queues: wa.queues ? wa.queues.map(queue => ({
          id: queue.id,
          name: queue.name,
          color: queue.color
        })) : []
      }));

    } catch (error) {
      logger.error("Erro ao gerar relatório WhatsApp-Queues:", error);
      throw new AppError("Erro interno ao gerar relatório", 500);
    }
  }

  /**
   * Gera relatório detalhado de filas e seus WhatsApps
   */
  public static async getQueuesWhatsAppReport(companyId: number): Promise<QueueWhatsAppReport[]> {
    try {
      const queues = await Queue.findAll({
        where: { companyId },
        include: [
          {
            model: Whatsapp,
            as: "whatsapps",
            through: { attributes: [] }
          }
        ],
        order: [['id', 'ASC']]
      });

      return queues.map(queue => ({
        queueId: queue.id,
        queueName: queue.name,
        color: queue.color,
        whatsApps: queue.whatsapps ? queue.whatsapps.map(wa => ({
          id: wa.id,
          name: wa.name,
          status: wa.status
        })) : []
      }));

    } catch (error) {
      logger.error("Erro ao gerar relatório Queue-WhatsApps:", error);
      throw new AppError("Erro interno ao gerar relatório", 500);
    }
  }

  /**
   * Corrige automaticamente vinculações básicas
   * Associa WhatsApps sem fila à primeira fila disponível
   */
  public static async autoFixBasicConnections(companyId: number): Promise<{
    fixed: number;
    errors: string[];
  }> {
    try {
      const result = {
        fixed: 0,
        errors: []
      };

      // Buscar WhatsApps sem filas
      const whatsAppsWithoutQueues = await Whatsapp.findAll({
        where: { companyId },
        include: [
          {
            model: Queue,
            as: "queues",
            through: { attributes: [] }
          }
        ]
      });

      const unlinkedWhatsApps = whatsAppsWithoutQueues.filter(wa => 
        !wa.queues || wa.queues.length === 0
      );

      if (unlinkedWhatsApps.length === 0) {
        return result;
      }

      // Buscar primeira fila disponível
      const firstQueue = await Queue.findOne({
        where: { companyId },
        order: [['id', 'ASC']]
      });

      if (!firstQueue) {
        result.errors.push("Nenhuma fila encontrada para associar aos WhatsApps");
        return result;
      }

      // Associar cada WhatsApp à primeira fila
      for (const whatsApp of unlinkedWhatsApps) {
        try {
          await WhatsappQueue.create({
            whatsappId: whatsApp.id,
            queueId: firstQueue.id
          });
          
          result.fixed++;
          logger.info(`✅ WhatsApp "${whatsApp.name}" associado à fila "${firstQueue.name}"`);
          
        } catch (error) {
          const errorMsg = `Erro ao associar WhatsApp "${whatsApp.name}" à fila "${firstQueue.name}": ${error.message}`;
          result.errors.push(errorMsg);
          logger.error(errorMsg);
        }
      }

      return result;

    } catch (error) {
      logger.error("Erro na correção automática de vinculações:", error);
      throw new AppError("Erro interno na correção automática", 500);
    }
  }

  /**
   * Remove vinculações órfãs (registros na WhatsappQueue que não existem mais)
   */
  public static async cleanupOrphanConnections(companyId: number): Promise<{
    removed: number;
    errors: string[];
  }> {
    try {
      const result = {
        removed: 0,
        errors: []
      };

      // Buscar vinculações órfãs
      const orphanConnections = await WhatsappQueue.findAll({
        include: [
          {
            model: Whatsapp,
            where: { companyId },
            required: false
          },
          {
            model: Queue,
            where: { companyId },
            required: false
          }
        ]
      });

      for (const connection of orphanConnections) {
        if (!connection.Whatsapp || !connection.Queue) {
          try {
            await connection.destroy();
            result.removed++;
            logger.info(`🗑️ Vinculação órfã removida: WhatsApp ${connection.whatsappId} <-> Queue ${connection.queueId}`);
          } catch (error) {
            const errorMsg = `Erro ao remover vinculação órfã ${connection.whatsappId}-${connection.queueId}: ${error.message}`;
            result.errors.push(errorMsg);
            logger.error(errorMsg);
          }
        }
      }

      return result;

    } catch (error) {
      logger.error("Erro na limpeza de vinculações órfãs:", error);
      throw new AppError("Erro interno na limpeza", 500);
    }
  }
}

export default WhatsAppQueueValidationService;