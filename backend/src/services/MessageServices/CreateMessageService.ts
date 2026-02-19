import { getIO } from "../../libs/socket";
import Message from "../../models/Message";
import Ticket from "../../models/Ticket";
import Contact from "../../models/Contact";
import Queue from "../../models/Queue";
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
    // Isso ajuda a prevenir erros de duplicata em race conditions
    await Message.upsert({ ...messageData, companyId });
  } catch (error: any) {
    // Se houver erro de constraint única duplicada, apenas continua 
    // (a mensagem já foi processada por outro processo)
    if (error.name === "SequelizeUniqueConstraintError") {
      console.warn(`[CreateMessageService] Mensagem ${messageData.id} duplicada detectada, atualizando campos...`);
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
      } catch (updateError: any) {
        console.error(`[CreateMessageService] Erro ao atualizar mensagem ${messageData.id}:`, updateError.message);
      }
    } else {
      // Re-lançar erro se não for duplicata
      console.error(`[CreateMessageService] Erro ao criar mensagem ${messageData.id}:`, error.message);
      throw error;
    }
  }

  // Buscar mensagem com includes simples (sem nested) para evitar 
  // "FOR UPDATE cannot be applied to nullable side of outer join"
  const message = await Message.findByPk(messageData.id, {
    include: [
      { 
        model: Contact,
        as: "contact",
        attributes: ["id", "name", "number", "email", "profilePicUrl"]
      },
      {
        model: Ticket,
        as: "ticket",
        attributes: ["id", "status", "contactId", "whatsappId", "queueId", "userId", "companyId"],
        include: [
          { 
            model: Contact,
            as: "contact",
            attributes: ["id", "name", "number", "email", "profilePicUrl"]
          },
          { 
            model: Queue,
            as: "queue",
            attributes: ["id", "name", "color"]
          },
          {
            model: Whatsapp,
            as: "whatsapp",
            attributes: ["id", "name"]
          }
        ]
      },
      {
        model: Message,
        as: "quotedMsg",
        attributes: ["id", "body", "fromMe", "read", "mediaType", "mediaUrl", "createdAt"],
        include: [
          {
            model: Contact,
            as: "contact",
            attributes: ["id", "name", "number"]
          }
        ]
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
