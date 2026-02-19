import AppError from "../../errors/AppError";
import CloseReason from "../../models/CloseReason";

const ShowService = async (
  id: string | number,
  companyId: number
): Promise<CloseReason> => {
  const reason = await CloseReason.findOne({
    where: { id, companyId }
  });

  if (!reason) {
    throw new AppError("ERR_CLOSE_REASON_NOT_FOUND", 404);
  }

  return reason;
};

export default ShowService;
