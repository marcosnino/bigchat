import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";
import asteriskManager from "../../libs/asterisk";

interface UpdateAsteriskData {
  name?: string;
  host?: string;
  ariPort?: number;
  sipPort?: number;
  wsPort?: number;
  ariUser?: string;
  ariPassword?: string;
  ariApplication?: string;
  isActive?: boolean;
  useSSL?: boolean;
  sipDomain?: string;
  outboundContext?: string;
  inboundContext?: string;
  notes?: string;
}

const UpdateAsteriskService = async (
  id: string | number,
  companyId: number,
  data: UpdateAsteriskData
): Promise<Asterisk> => {
  const asterisk = await Asterisk.findOne({
    where: { id, companyId }
  });

  if (!asterisk) {
    throw new AppError("ERR_NO_ASTERISK_FOUND", 404);
  }

  const wasActive = asterisk.isActive;
  const isNowActive = data.isActive !== undefined ? data.isActive : wasActive;

  await asterisk.update(data);

  // Handle connection changes
  if (wasActive && !isNowActive) {
    await asteriskManager.disconnect(asterisk.id);
  } else if (!wasActive && isNowActive) {
    try {
      await asteriskManager.connect(asterisk);
    } catch (error) {
      console.error(`Failed to connect Asterisk: ${error}`);
    }
  } else if (isNowActive && asteriskManager.isConnected(asterisk.id)) {
    // Reconnect if config changed
    await asteriskManager.disconnect(asterisk.id);
    try {
      await asteriskManager.connect(asterisk);
    } catch (error) {
      console.error(`Failed to reconnect Asterisk: ${error}`);
    }
  }

  return asterisk;
};

export default UpdateAsteriskService;
