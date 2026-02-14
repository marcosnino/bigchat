import { getIO } from "../../libs/socket";
import Message from "../../models/Message";
import Ticket from "../../models/Ticket";
import Whatsapp from "../../models/Whatsapp";
import MessageSemaphoreService from "./MessageSemaphoreService";

interface MessageData {
  id: string;
  ticketId: number;
  body: string;
  contactId?: number;
  fromMe?: boolean;
  read?: boolean;
  mediaType?: string;
  mediaUrl?: string;
  ack?: number;
  queueId?: number;
}
interface Request {
  messageData: MessageData;
  companyId: number;
}

const CreateMessageService = async ({
  messageData,
  companyId
}: Request): Promise<Message> => {
  try {
    // Tentar fazer upsert - insere ou atualiza a mensagem
    await Message.upsert({ ...messageData, companyId });
  } catch (error: any) {
    // Se houver erro de constraint única duplicada, apenas continua 
    // (a mensagem já foi processada)
    if (error.name === "SequelizeUniqueConstraintError") {
      console.warn(`[CreateMessageService] Mensagem ${messageData.id} já existe, atualizando...`);
      // Tentar atualizar os campos importantes se a mensagem já existe
      try {
        await Message.update(
          { 
            body: messageData.body,
            ack: messageData.ack,
            read: messageData.read || false,
            queueId: messageData.queueId,
            mediaType: messageData.mediaType,
            mediaUrl: messageData.mediaUrl
          },
          { 
            where: { id: messageData.id } 
          }
        );
      } catch (updateError) {
        console.error(`[CreateMessageService] Erro ao atualizar mensagem ${messageData.id}:`, updateError);
      }
    } else {
      throw error;
    }
  }

  const message = await Message.findByPk(messageData.id, {
    include: [
      "contact",
      {
        model: Ticket,
        as: "ticket",
        include: [
          "contact",
          "queue",
          {
            model: Whatsapp,
            as: "whatsapp",
            attributes: ["name"]
          }
        ]
      },
      {
        model: Message,
        as: "quotedMsg",
        include: ["contact"]
      }
    ]
  });

  if (message && message.ticket.queueId !== null && message.queueId === null) {
    await message.update({ queueId: message.ticket.queueId });
  }

  if (!message) {
    throw new Error("ERR_CREATING_MESSAGE");
  }

  const io = getIO();
  io.to(message.ticketId.toString())
    .to(`company-${companyId}-${message.ticket.status}`)
    .to(`company-${companyId}-notification`)
    .to(`queue-${message.ticket.queueId}-${message.ticket.status}`)
    .to(`queue-${message.ticket.queueId}-notification`)
    .emit(`company-${companyId}-appMessage`, {
      action: "create",
      message,
      ticket: message.ticket,
      contact: message.ticket.contact
    });

  // Processar sistema de semáforo
  try {
    await MessageSemaphoreService.processMessage({
      messageId: message.id,
      ticketId: message.ticketId,
      fromMe: message.fromMe || false,
      companyId
    });
  } catch (error) {
    console.error('Erro no sistema de semáforo:', error);
    // Não bloquear o fluxo principal em caso de erro
  }

  return message;
};

export default CreateMessageService;
