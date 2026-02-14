import { getWbot, WWJSSession } from "../libs/wbot-wwjs";
import GetDefaultWhatsApp from "./GetDefaultWhatsApp";
import Ticket from "../models/Ticket";

const GetTicketWbot = async (ticket: Ticket): Promise<WWJSSession> => {
  if (!ticket.whatsappId) {
    const defaultWhatsapp = await GetDefaultWhatsApp(ticket.user.id);

    await ticket.$set("whatsapp", defaultWhatsapp);
  }

  const wbot = await getWbot(ticket.whatsappId);
  if (!wbot) {
    throw new Error("Sessão do WhatsApp não encontrada");
  }
  return wbot;
};

export default GetTicketWbot;
