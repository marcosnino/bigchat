import asteriskManager from "../../libs/asterisk";
import Call from "../../models/Call";
import AppError from "../../errors/AppError";

interface Request {
  callId: number;
  destination: string;
  companyId: number;
}

const TransferCallService = async ({
  callId,
  destination,
  companyId
}: Request): Promise<void> => {
  const call = await Call.findOne({
    where: { id: callId, companyId }
  });

  if (!call) {
    throw new AppError("ERR_NO_CALL_FOUND", 404);
  }

  if (call.status !== "answered") {
    throw new AppError("Chamada não está em andamento", 400);
  }

  await asteriskManager.transfer(call.asteriskId, call.uniqueId, destination);
};

export default TransferCallService;
