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
    let previousQueueId = ticket.queueId;
    if (!previousQueueId) {
      const reopenWhatsapp = await Whatsapp.findOne({ where: { id: whatsappId } });
      if (reopenWhatsapp) {
        const whatsappQueues = await reopenWhatsapp.$get("queues");
        previousQueueId = whatsappQueues?.[0]?.id || null;
      }
    }

    await ticket.update({ status: "pending", queueId: previousQueueId, userId: null });
    await FindOrCreateATicketTrakingService({
      ticketId: ticket.id,
      companyId,
      whatsappId: ticket.whatsappId,
      userId: ticket.userId
    });
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
    
    // Verificar se deve aceitar automaticamente o ticket
    const autoAcceptSetting = await Setting.findOne({
      where: {
        companyId,
        key: "autoAcceptTickets"
      }
    });
    
    // Se não há configuração, aceitar automaticamente por padrão
    if (!autoAcceptSetting || autoAcceptSetting.value !== "disabled") {
      await ticket.update({
        status: "open",
        userId: null
      });
    }
    
    await FindOrCreateATicketTrakingService({
      ticketId: ticket.id,
      companyId,
      whatsappId,
      userId: ticket.userId
    });
  }

  if (ticket.queueId && !ticket.userId) {
    const nextUserId = await getNextQueueUser(ticket.queueId, whatsappId);
    if (nextUserId) {
      await ticket.update({ userId: nextUserId, status: "open" });
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
