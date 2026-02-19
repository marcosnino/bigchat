import AppError from "../../errors/AppError";
import CheckContactOpenTickets from "../../helpers/CheckContactOpenTickets";
import GetDefaultWhatsApp from "../../helpers/GetDefaultWhatsApp";
import Ticket from "../../models/Ticket";
import ShowContactService from "../ContactServices/ShowContactService";
import { getIO } from "../../libs/socket";
import GetDefaultWhatsAppByUser from "../../helpers/GetDefaultWhatsAppByUser";
import ShowWhatsAppService from "../WhatsappService/ShowWhatsAppService";
import getNextQueueUser from "../../helpers/GetNextQueueUser";

interface Request {
  contactId: number;
  status: string;
  userId: number;
  companyId: number;
  queueId?: number;
  whatsappId?: string;
}

const CreateTicketService = async ({
  contactId,
  status,
  userId,
  queueId,
  companyId,
  whatsappId
}: Request): Promise<Ticket> => {
  let whatsapp;
  let assignedUserId = userId;

  if (whatsappId !== undefined && whatsappId !== null && whatsappId !==  "") {
    whatsapp = await ShowWhatsAppService(whatsappId, companyId)
  }
  
  let defaultWhatsapp = await GetDefaultWhatsAppByUser(userId);

  if (whatsapp) {
    defaultWhatsapp = whatsapp;
  }
  if (!defaultWhatsapp)
    defaultWhatsapp = await GetDefaultWhatsApp(companyId);

  await CheckContactOpenTickets(contactId, whatsappId);

  const { isGroup } = await ShowContactService(contactId, companyId);

  if (!assignedUserId && queueId) {
    const whatsappQueueId = whatsappId && !Number.isNaN(Number(whatsappId))
      ? Number(whatsappId)
      : undefined;
    assignedUserId = await getNextQueueUser(queueId, whatsappQueueId);
  }

  const [{ id }] = await Ticket.findOrCreate({
    where: {
      contactId,
      companyId,
      whatsappId
    },
    defaults: {
      contactId,
      companyId,
      whatsappId: defaultWhatsapp.id,
      status,
      isGroup,
      userId: assignedUserId
    }
  });

  await Ticket.update(
    {
      companyId,
      queueId,
      userId: assignedUserId,
      whatsappId: defaultWhatsapp.id,
      status: "open"
    },
    { where: { id } }
  );

  const ticket = await Ticket.findByPk(id, { include: ["contact", "queue"] });

  if (!ticket) {
    throw new AppError("ERR_CREATING_TICKET");
  }

  const io = getIO();

  io.to(ticket.id.toString()).emit("ticket", {
    action: "update",
    ticket
  });

  return ticket;
};

export default CreateTicketService;
