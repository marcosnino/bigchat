import Call from "../../models/Call";
import User from "../../models/User";
import Contact from "../../models/Contact";
import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";

const ShowCallService = async (
  id: string | number,
  companyId: number
): Promise<Call> => {
  const call = await Call.findOne({
    where: { id, companyId },
    include: [
      { model: User, as: "user", attributes: ["id", "name", "email"] },
      { model: Contact, as: "contact", attributes: ["id", "name", "number"] },
      { model: Asterisk, as: "asterisk", attributes: ["id", "name"] }
    ]
  });

  if (!call) {
    throw new AppError("ERR_NO_CALL_FOUND", 404);
  }

  return call;
};

export default ShowCallService;
