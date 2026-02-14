import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";

const ShowAsteriskService = async (
  id: string | number,
  companyId: number
): Promise<Asterisk> => {
  const asterisk = await Asterisk.findOne({
    where: { id, companyId }
  });

  if (!asterisk) {
    throw new AppError("ERR_NO_ASTERISK_FOUND", 404);
  }

  return asterisk;
};

export default ShowAsteriskService;
