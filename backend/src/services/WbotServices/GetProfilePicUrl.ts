import GetDefaultWhatsApp from "../../helpers/GetDefaultWhatsApp";
import { getWbot } from "../../libs/wbot-wwjs";

const GetProfilePicUrl = async (
  number: string,
  companyId: number
): Promise<string> => {
  const defaultWhatsapp = await GetDefaultWhatsApp(companyId);

  let wbot;
  try {
    wbot = getWbot(defaultWhatsapp.id);
  } catch (e) {
    return `${process.env.FRONTEND_URL}/nopicture.png`;
  }

  let profilePicUrl: string;
  try {
    const formattedNumber = number.replace(/[^\d]/g, "");
    const contactId = `${formattedNumber}@c.us`;
    profilePicUrl = await wbot.getProfilePicUrl(contactId);
  } catch (error) {
    profilePicUrl = `${process.env.FRONTEND_URL}/nopicture.png`;
  }

  return profilePicUrl;
};

export default GetProfilePicUrl;
