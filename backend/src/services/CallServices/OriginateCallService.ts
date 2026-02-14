import asteriskManager from "../../libs/asterisk";
import AppError from "../../errors/AppError";
import Call from "../../models/Call";

interface Request {
  asteriskId: number;
  extension: string;
  destination: string;
  callerId?: string;
  userId?: number;
  contactId?: number;
  ticketId?: number;
  companyId: number;
}

const OriginateCallService = async ({
  asteriskId,
  extension,
  destination,
  callerId,
  userId,
  contactId,
  ticketId,
  companyId
}: Request): Promise<Call> => {
  if (!asteriskManager.isConnected(asteriskId)) {
    throw new AppError("Asterisk não está conectado", 400);
  }

  const call = await asteriskManager.originate(
    asteriskId,
    extension,
    destination,
    callerId
  );

  // Update additional fields
  if (userId || contactId || ticketId) {
    await call.update({
      userId,
      contactId,
      ticketId
    });
  }

  return call;
};

export default OriginateCallService;
