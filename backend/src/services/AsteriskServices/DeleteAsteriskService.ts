import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";
import asteriskManager from "../../libs/asterisk";

const DeleteAsteriskService = async (
  id: string | number,
  companyId: number
): Promise<void> => {
  const asterisk = await Asterisk.findOne({
    where: { id, companyId }
  });

  if (!asterisk) {
    throw new AppError("ERR_NO_ASTERISK_FOUND", 404);
  }

  // Disconnect if connected
  if (asteriskManager.isConnected(asterisk.id)) {
    await asteriskManager.disconnect(asterisk.id);
  }

  await asterisk.destroy();
};

export default DeleteAsteriskService;
