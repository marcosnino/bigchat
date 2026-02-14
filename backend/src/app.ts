import "./bootstrap";
import "reflect-metadata";
import "express-async-errors";
import express, { Request, Response, NextFunction } from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import * as Sentry from "@sentry/node";
import multer from "multer";

import "./database";
import uploadConfig from "./config/upload";
import AppError from "./errors/AppError";
import routes from "./routes";
import { logger } from "./utils/logger";
import { messageQueue, sendScheduledMessages } from "./queues";
import bodyParser from 'body-parser';

Sentry.init({ dsn: process.env.SENTRY_DSN });

const app = express();

app.set("queues", {
  messageQueue,
  sendScheduledMessages
});

const bodyparser = require('body-parser');
app.use(bodyParser.json({ limit: '10mb' }));

app.use(
  cors({
    credentials: true,
    origin: process.env.FRONTEND_URL
  })
);
app.use(cookieParser());
app.use(express.json());
app.use(Sentry.Handlers.requestHandler());
app.use("/public", express.static(uploadConfig.directory));

// Health check endpoint
app.get("/health", (req: Request, res: Response) => {
  res.status(200).json({ status: "ok", timestamp: new Date().toISOString() });
});

app.use(routes);

app.use(Sentry.Handlers.errorHandler());

app.use(async (err: Error, req: Request, res: Response, _: NextFunction) => {
  // Tratamento de erros do Multer (upload de arquivos)
  if (err instanceof multer.MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      logger.warn(`Upload rejeitado: arquivo muito grande`);
      return res.status(413).json({ 
        error: "Arquivo muito grande. O tamanho máximo permitido é 16MB." 
      });
    }
    if (err.code === "LIMIT_FILE_COUNT") {
      logger.warn(`Upload rejeitado: muitos arquivos`);
      return res.status(400).json({ 
        error: "Muitos arquivos. O máximo permitido é 10 arquivos por vez." 
      });
    }
    logger.warn(`Erro de upload: ${err.message}`);
    return res.status(400).json({ error: `Erro no upload: ${err.message}` });
  }

  // Tratamento de erro de tipo de arquivo não permitido (fileFilter)
  if (err.message && err.message.includes("Tipo de arquivo não permitido")) {
    logger.warn(`Upload rejeitado: ${err.message}`);
    return res.status(415).json({ error: err.message });
  }

  if (err instanceof AppError) {
    logger.warn(err);
    return res.status(err.statusCode).json({ error: err.message });
  }

  logger.error(err);
  return res.status(500).json({ error: "ERR_INTERNAL_SERVER_ERROR" });
});

export default app;
