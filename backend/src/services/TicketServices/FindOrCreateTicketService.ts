import { subHours } from "date-fns";
import { Op } from "sequelize";
import Contact from "../../models/Contact";
import Ticket from "../../models/Ticket";
import ShowTicketService from "./ShowTicketService";
import FindOrCreateATicketTrakingService from "./FindOrCreateATicketTrakingService";
import Setting from "../../models/Setting";
import Whatsapp from "../../models/Whatsapp";
import getNextQueueUser from "../../helpers/GetNextQueueUser";
import Queue from "../../models/Queue";
import User from "../../models/User";
import Tag from "../../models/Tag";
import { getIO } from "../../libs/socket";
import { logger } from "../../utils/logger";

interface TicketData {
  status?: string;
  companyId?: number;
  unreadMessages?: number;
}

const FindOrCreateTicketService = async (
  contact: Contact,
  whatsappId: number,
  unreadMessages: number,
  companyId: number,
  groupContact?: Contact
): Promise<Ticket> => {
  // Flag para controlar se o ticket foi reaberto de "closed"
  // Tickets reabertos DEVEM ficar em "pending" (aba Aguardando) para triagem manual
  let wasReopenedFromClosed = false;

  let ticket = await Ticket.findOne({
    where: {
      status: {
        [Op.or]: ["open", "pending", "closed"]
      },
      contactId: groupContact ? groupContact.id : contact.id,
      companyId,
      whatsappId
    },
    order: [["id", "DESC"]]
  });

  if (ticket) {
    await ticket.update({ unreadMessages, whatsappId });
  }

  if (ticket?.status === "closed") {
    wasReopenedFromClosed = true;
    let previousQueueId = ticket.queueId;
    if (!previousQueueId) {
      const reopenWhatsapp = await Whatsapp.findOne({ where: { id: whatsappId } });
      if (reopenWhatsapp) {
        const whatsappQueues = await reopenWhatsapp.$get("queues");
        previousQueueId = whatsappQueues?.[0]?.id || null;
      }
    }

    // Reabrir como "pending" (Aguardando) sem atribuir usuário
    // O agente vai ver na aba Aguardando e pode pegar o atendimento manualmente
    await ticket.update({ status: "pending", queueId: previousQueueId, userId: null });
    await FindOrCreateATicketTrakingService({
      ticketId: ticket.id,
      companyId,
      whatsappId: ticket.whatsappId,
      userId: null
    });

    // Emitir eventos de socket para transição closed → pending
    // Sem isso, o frontend não move o ticket para a aba "Aguardando"
    try {
      const io = getIO();
      // Remover da lista de fechados
      io.to(`company-${companyId}-closed`)
        .to(`queue-${previousQueueId}-closed`)
        .emit(`company-${companyId}-ticket`, {
          action: "delete",
          ticketId: ticket.id
        });

      // Adicionar na lista de pendentes (Aguardando)
      io.to(`company-${companyId}-pending`)
        .to(`company-${companyId}-notification`)
        .to(`queue-${previousQueueId}-pending`)
        .to(`queue-${previousQueueId}-notification`)
        .to(ticket.id.toString())
        .emit(`company-${companyId}-ticket`, {
          action: "update",
          ticket
        });
      logger.info(`[FindOrCreateTicket] Ticket ${ticket.id} reaberto: closed → pending (aguardando)`);
    } catch (socketErr) {
      logger.warn(`[FindOrCreateTicket] Erro ao emitir socket para ticket ${ticket.id}: ${socketErr}`);
    }
  }

  if (!ticket && groupContact) {
    ticket = await Ticket.findOne({
      where: {
        contactId: groupContact.id
      },
      order: [["updatedAt", "DESC"]]
    });

    if (ticket) {
      await ticket.update({
        status: "pending",
        userId: null,
        unreadMessages,
        queueId: ticket.queueId,
        companyId
      });
      await FindOrCreateATicketTrakingService({
        ticketId: ticket.id,
        companyId,
        whatsappId: ticket.whatsappId,
        userId: ticket.userId
      });
    }
    const msgIsGroupBlock = await Setting.findOne({
      where: { key: "timeCreateNewTicket" }
    });

    const value = msgIsGroupBlock ? parseInt(msgIsGroupBlock.value, 10) : 7200;
  }

  if (!ticket && !groupContact) {
    ticket = await Ticket.findOne({
      where: {
        updatedAt: {
          [Op.between]: [+subHours(new Date(), 2), +new Date()]
        },
        contactId: contact.id,
        companyId,
        whatsappId
      },
      order: [["updatedAt", "DESC"]]
    });

    if (ticket) {
      await ticket.update({
        status: "pending",
        userId: null,
        unreadMessages,
        queueId: ticket.queueId,
        companyId
      });
      await FindOrCreateATicketTrakingService({
        ticketId: ticket.id,
        companyId,
        whatsappId: ticket.whatsappId,
        userId: ticket.userId
      });
    }
  }

    const whatsapp = await Whatsapp.findOne({
    where: { id: whatsappId }
  });

  if (!ticket) {
    // Buscar fila padrão do WhatsApp
    let defaultQueueId = null;
    if (whatsapp) {
      const whatsappQueues = await whatsapp.$get("queues");
      defaultQueueId = whatsappQueues?.[0]?.id || null;
    }
    
    ticket = await Ticket.create({
      contactId: groupContact ? groupContact.id : contact.id,
      status: "pending",
      isGroup: !!groupContact,
      unreadMessages,
      whatsappId,
      whatsapp,
      companyId,
      queueId: defaultQueueId
    });
    
    await FindOrCreateATicketTrakingService({
      ticketId: ticket.id,
      companyId,
      whatsappId,
      userId: ticket.userId
    });
  }

  // Só auto-atribuir para tickets NOVOS (não reabertos e não grupos pendentes)
  // Tickets reabertos de "closed" ficam em "pending" para triagem manual
  if (ticket.queueId && !ticket.userId && !wasReopenedFromClosed) {
    const nextUserId = await getNextQueueUser(ticket.queueId, whatsappId);
    if (nextUserId) {
      // Segurança extra: verificar se o usuário selecionado NÃO é admin
      const assignedUser = await User.findByPk(nextUserId, { attributes: ["id", "profile"] });
      if (assignedUser && assignedUser.profile?.toLowerCase() !== "admin") {
        await ticket.update({ userId: nextUserId, status: "open" });
      } else {
        logger.warn(`[FindOrCreateTicket] Bloqueado auto-atribuição ao admin (userId: ${nextUserId}) - ticket ${ticket.id} fica em pending`);
      }
    }
  }

  // Reload com includes necessários (sem usar ShowTicketService para evitar LOCK em LEFT JOIN)
  await ticket.reload({
    include: [
      {
        model: Contact,
        as: "contact",
        attributes: ["id", "name", "number", "email", "profilePicUrl"],
        include: ["extraInfo"]
      },
      {
        model: User,
        as: "user",
        attributes: ["id", "name"]
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
      },
      {
        model: Tag,
        as: "tags",
        attributes: ["id", "name", "color"]
      }
    ]
  });

  return ticket;
};

export default FindOrCreateTicketService;
