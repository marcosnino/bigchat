import { Op } from "sequelize";
import path from "path";
import fs from "fs";
import Message from "../../models/Message";
import Ticket from "../../models/Ticket";
import ShowTicketService from "../TicketServices/ShowTicketService";
import AppError from "../../errors/AppError";
import { logger } from "../../utils/logger";

interface Request {
  ticketId: string;
  companyId: number;
}

/**
 * Remove todas as mensagens de um ticket (apenas do banco/tela).
 * Também limpa os arquivos de mídia associados do disco.
 */
const ClearTicketMessagesService = async ({
  ticketId,
  companyId
}: Request): Promise<{ deletedCount: number }> => {
  const ticket = await ShowTicketService(ticketId, companyId);

  if (!ticket) {
    throw new AppError("ERR_NO_TICKET_FOUND", 404);
  }

  // Buscar mensagens com mídia para limpar arquivos do disco
  const messagesWithMedia = await Message.findAll({
    where: {
      ticketId,
      companyId,
      mediaUrl: { [Op.ne]: null }
    },
    attributes: ["id", "mediaUrl"]
  });

  // Remover arquivos de mídia do disco
  const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");
  for (const msg of messagesWithMedia) {
    try {
      const rawMediaUrl = msg.getDataValue("mediaUrl");
      if (rawMediaUrl) {
        const filePath = path.join(publicFolder, rawMediaUrl);
        if (fs.existsSync(filePath)) {
          fs.unlinkSync(filePath);
          logger.info(`[ClearHistory] Arquivo removido: ${rawMediaUrl}`);
        }
      }
    } catch (err) {
      logger.warn(`[ClearHistory] Erro ao remover arquivo: ${err}`);
    }
  }

  // Deletar todas as mensagens do ticket
  const deletedCount = await Message.destroy({
    where: {
      ticketId,
      companyId
    }
  });

  // Atualizar lastMessage do ticket
  await ticket.update({
    lastMessage: ""
  });

  logger.info(
    `[ClearHistory] ${deletedCount} mensagens removidas do ticket ${ticketId} (company ${companyId})`
  );

  return { deletedCount };
};

export default ClearTicketMessagesService;
