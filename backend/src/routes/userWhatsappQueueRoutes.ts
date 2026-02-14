import express from "express";
import isAuth from "../middleware/isAuth";
import * as UserWhatsappQueueController from "../controllers/UserWhatsappQueueController";

const userWhatsappQueueRoutes = express.Router();

// CRUD básico
userWhatsappQueueRoutes.post(
  "/user-whatsapp-queue",
  isAuth,
  UserWhatsappQueueController.store
);

userWhatsappQueueRoutes.get(
  "/user-whatsapp-queue",
  isAuth,
  UserWhatsappQueueController.index
);

userWhatsappQueueRoutes.get(
  "/user-whatsapp-queue/user/:id",
  isAuth,
  UserWhatsappQueueController.show
);

userWhatsappQueueRoutes.put(
  "/user-whatsapp-queue/:id",
  isAuth,
  UserWhatsappQueueController.update
);

userWhatsappQueueRoutes.delete(
  "/user-whatsapp-queue/:id",
  isAuth,
  UserWhatsappQueueController.remove
);

// Endpoints especiais
userWhatsappQueueRoutes.get(
  "/user-whatsapp-queue/available/:whatsappId/:queueId",
  isAuth,
  UserWhatsappQueueController.getAvailableUsers
);

userWhatsappQueueRoutes.delete(
  "/user-whatsapp-queue/user/:userId/queue/:queueId",
  isAuth,
  UserWhatsappQueueController.deactivateUserQueue
);

userWhatsappQueueRoutes.get(
  "/user-whatsapp-queue/warnings",
  isAuth,
  UserWhatsappQueueController.getWarnings
);

userWhatsappQueueRoutes.get(
  "/user-whatsapp-queue/statistics",
  isAuth,
  UserWhatsappQueueController.getStatistics
);

export default userWhatsappQueueRoutes;
