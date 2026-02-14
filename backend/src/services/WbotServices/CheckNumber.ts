import AppError from "../../errors/AppError";
import GetDefaultWhatsApp from "../../helpers/GetDefaultWhatsApp";
import { getWbot, WWJSSession } from "../../libs/wbot-wwjs";
import { logger } from "../../utils/logger";

interface IOnWhatsapp {
  jid: string;
  exists: boolean;
}

/**
 * Verifica se um número existe no WhatsApp
 */
const checker = async (number: string, wbot: WWJSSession): Promise<IOnWhatsapp | null> => {
  try {
    const formattedNumber = number.replace(/[^\d]/g, "");
    const numberId = await wbot.getNumberId(formattedNumber);
    
    if (numberId) {
      return {
        jid: numberId._serialized,
        exists: true
      };
    }
    return null;
  } catch (err) {
    logger.error(`Erro ao verificar número ${number}: ${err}`);
    return null;
  }
};

const CheckContactNumber = async (
  number: string,
  companyId: number
): Promise<IOnWhatsapp> => {
  const defaultWhatsapp = await GetDefaultWhatsApp(companyId);

  const wbot = await getWbot(defaultWhatsapp.id);
  if (!wbot) {
    throw new AppError("ERR_WAPP_NOT_INITIALIZED");
  }
  
  const isNumberExit = await checker(number, wbot);

  if (!isNumberExit) {
    throw new AppError("ERR_CHECK_NUMBER");
  }
  return isNumberExit;
};

export default CheckContactNumber;
