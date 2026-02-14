import AppError from "../../errors/AppError";
import GetTicketWbot from "../../helpers/GetTicketWbot";
import Message from "../../models/Message";
import Ticket from "../../models/Ticket";
import { logger } from "../../utils/logger";

const DeleteWhatsAppMessage = async (messageId: string): Promise<Message> => {
  const message = await Message.findByPk(messageId, {
    include: [
      {
        model: Ticket,
        as: "ticket",
        include: ["contact"]
      }
    ]
  });

  if (!message) {
    throw new AppError("No message found with this ID.");
  }

  const { ticket } = message;

  try {
    const wbot = await GetTicketWbot(ticket);
    
    if (!wbot) {
      throw new AppError("ERR_WAPP_NOT_INITIALIZED");
    }

    // Obter a mensagem do chat para deletar
    const dataJson = message.dataJson ? JSON.parse(message.dataJson) : null;
    
    if (dataJson?.id?._serialized) {
      // Obter o chat
      const contact = ticket.contact;
      const chatId = contact.isGroup 
        ? `${contact.number}@g.us` 
        : `${contact.number}@c.us`;
      
      const chat = await wbot.getChatById(chatId);
      const messages = await chat.fetchMessages({ limit: 50 });
      
      // Encontrar a mensagem pelo ID
      const msgToDelete = messages.find((m: any) => m.id.id === messageId || m.id._serialized === dataJson.id._serialized);
      
      if (msgToDelete) {
        await msgToDelete.delete(true); // true = para todos
        logger.info(`Mensagem ${messageId} deletada com sucesso`);
      }
    }

  } catch (err) {
    logger.error(`Erro ao deletar mensagem: ${err}`);
    throw new AppError("ERR_DELETE_WAPP_MSG");
  }
  
  await message.update({ isDeleted: true });

  return message;
};

export default DeleteWhatsAppMessage;
