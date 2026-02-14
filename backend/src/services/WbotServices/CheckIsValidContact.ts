import AppError from "../../errors/AppError";
import GetDefaultWhatsApp from "../../helpers/GetDefaultWhatsApp";
import { getWbot } from "../../libs/wbot-wwjs";

const CheckIsValidContact = async (
  number: string,
  companyId: number
): Promise<void> => {
  const defaultWhatsapp = await GetDefaultWhatsApp(companyId);

  const wbot = await getWbot(defaultWhatsapp.id);
  
  if (!wbot) {
    throw new AppError("ERR_WAPP_NOT_INITIALIZED");
  }

  try {
    const formattedNumber = number.replace(/[^\d]/g, "");
    const numberId = await wbot.getNumberId(formattedNumber);
    
    if (!numberId) {
      throw new AppError("invalidNumber");
    }
  } catch (err: any) {
    if (err.message === "invalidNumber") {
      throw new AppError("ERR_WAPP_INVALID_CONTACT");
    }
    throw new AppError("ERR_WAPP_CHECK_CONTACT");
  }
};

export default CheckIsValidContact;
