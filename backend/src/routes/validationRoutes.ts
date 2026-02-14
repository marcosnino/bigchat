import express from "express";
import isAuth from "../middleware/isAuth";
import * as WhatsAppQueueValidationController from "../controllers/WhatsAppQueueValidationController";

const validationRoutes = express.Router();

// Validar vinculações entre WhatsApps e filas
validationRoutes.get(
  "/validation/whatsapp-queue", 
  isAuth, 
  WhatsAppQueueValidationController.validateConnections
);

// Relatório de WhatsApps e suas filas
validationRoutes.get(
  "/validation/whatsapp-queue/report/whatsapps", 
  isAuth, 
  WhatsAppQueueValidationController.getWhatsAppQueuesReport
);

// Relatório de filas e seus WhatsApps
validationRoutes.get(
  "/validation/whatsapp-queue/report/queues", 
  isAuth, 
  WhatsAppQueueValidationController.getQueuesWhatsAppReport
);

// Corrigir automaticamente vinculações básicas
validationRoutes.post(
  "/validation/whatsapp-queue/autofix", 
  isAuth, 
  WhatsAppQueueValidationController.autoFixConnections
);

// Remover vinculações órfãs
validationRoutes.delete(
  "/validation/whatsapp-queue/cleanup", 
  isAuth, 
  WhatsAppQueueValidationController.cleanupOrphanConnections
);

export default validationRoutes;