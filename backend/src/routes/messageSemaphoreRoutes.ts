import express from "express";
import isAuth from "../middleware/isAuth";
import * as MessageSemaphoreController from "../controllers/MessageSemaphoreController";

const messageSemaphoreRoutes = express.Router();

// Obter estatísticas do semáforo para um ticket
messageSemaphoreRoutes.get(
  "/tickets/:ticketId/semaphore/stats",
  isAuth,
  MessageSemaphoreController.getTicketSemaphoreStats
);

// Obter estatísticas globais do semáforo para a empresa  
messageSemaphoreRoutes.get(
  "/semaphore/stats", 
  isAuth,
  MessageSemaphoreController.getCompanySemaphoreStats
);

// Marcar mensagens como respondidas manualmente
messageSemaphoreRoutes.put(
  "/tickets/:ticketId/semaphore/mark-replied",
  isAuth, 
  MessageSemaphoreController.markMessagesAsReplied
);

// Reset do semáforo para um ticket
messageSemaphoreRoutes.put(
  "/tickets/:ticketId/semaphore/reset",
  isAuth,
  MessageSemaphoreController.resetTicketSemaphore
);

export default messageSemaphoreRoutes;