import { Request, Response } from "express";
import { getWbot, removeWbot } from "../libs/wbot-wwjs";
import ShowWhatsAppService from "../services/WhatsappService/ShowWhatsAppService";
import StartWhatsAppSession from "../services/WbotServices/StartWhatsAppSession-wwjs";
import UpdateWhatsAppService from "../services/WhatsappService/UpdateWhatsAppService";

const store = async (req: Request, res: Response): Promise<Response> => {
  const { whatsappId } = req.params;
  const { companyId } = req.user;

  const whatsapp = await ShowWhatsAppService(whatsappId, companyId);
  await StartWhatsAppSession(whatsapp);

  return res.status(200).json({ message: "Starting session." });
};

const update = async (req: Request, res: Response): Promise<Response> => {
  const { whatsappId } = req.params;
  const { companyId } = req.user;

  const { whatsapp } = await UpdateWhatsAppService({
    whatsappId,
    companyId,
    whatsappData: { session: "" }
  });

  await StartWhatsAppSession(whatsapp);

  return res.status(200).json({ message: "Starting session." });
};

const remove = async (req: Request, res: Response): Promise<Response> => {
  const { whatsappId } = req.params;
  const { companyId } = req.user;
  const whatsapp = await ShowWhatsAppService(whatsappId, companyId);

  // Para conexões Meta, apenas atualiza o status
  if (whatsapp.provider === "meta") {
    await whatsapp.update({ status: "DISCONNECTED" });
    return res.status(200).json({ message: "Session disconnected." });
  }

  // Para conexões WhatsApp Web (whatsapp-web.js)
  await removeWbot(whatsapp.id, true);
  await whatsapp.update({ status: "DISCONNECTED", session: "" });

  return res.status(200).json({ message: "Session disconnected." });
};

export default { store, remove, update };
