import { getWbot, WWJSSession } from "../libs/wbot-wwjs";
import Whatsapp from "../models/Whatsapp";

const GetWhatsappWbot = async (whatsapp: Whatsapp): Promise<WWJSSession | undefined> => {
  const wbot = await getWbot(whatsapp.id);
  return wbot;
};

export default GetWhatsappWbot;
