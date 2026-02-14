import { Router } from "express";
import * as MetaWebhookController from "../controllers/MetaWebhookController";

const metaWebhookRoutes = Router();

/**
 * Rotas para webhook da WhatsApp Cloud API (Meta)
 * 
 * IMPORTANTE: Estas rotas são públicas (sem autenticação)
 * pois a Meta precisa acessá-las diretamente
 */

// GET - Verificação do webhook (challenge)
metaWebhookRoutes.get("/webhook/meta", MetaWebhookController.verifyWebhook);

// POST - Recebimento de mensagens e eventos
metaWebhookRoutes.post("/webhook/meta", MetaWebhookController.receiveWebhook);

export default metaWebhookRoutes;
