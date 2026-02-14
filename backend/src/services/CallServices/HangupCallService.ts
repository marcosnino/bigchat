import asteriskManager from "../../libs/asterisk";
import Call from "../../models/Call";
import AppError from "../../errors/AppError";

interface Request {
  callId: number;
  companyId: number;
}

const HangupCallService = async ({
  callId,
  companyId
}: Request): Promise<void> => {
  const call = await Call.findOne({
    where: { id: callId, companyId }
  });

  if (!call) {
    throw new AppError("ERR_NO_CALL_FOUND", 404);
  }

  if (call.status === "completed" || call.status === "failed") {
    throw new AppError("Chamada já finalizada", 400);
  }

  await asteriskManager.hangup(call.asteriskId, call.uniqueId);
};

export default HangupCallService;
