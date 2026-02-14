import Extension from "../../models/Extension";
import Asterisk from "../../models/Asterisk";
import User from "../../models/User";
import AppError from "../../errors/AppError";

interface Request {
  exten: string;
  password: string;
  callerIdName?: string;
  callerIdNumber?: string;
  asteriskId: number;
  userId?: number;
  companyId: number;
  webrtcEnabled?: boolean;
  context?: string;
  transport?: string;
  codecs?: string;
  maxContacts?: number;
  notes?: string;
}

const CreateExtensionService = async ({
  exten,
  password,
  callerIdName,
  callerIdNumber,
  asteriskId,
  userId,
  companyId,
  webrtcEnabled = true,
  context = "from-internal",
  transport = "udp,ws,wss",
  codecs = "ulaw,alaw,g729,opus",
  maxContacts = 1,
  notes
}: Request): Promise<Extension> => {
  // Verify asterisk exists
  const asterisk = await Asterisk.findOne({
    where: { id: asteriskId, companyId }
  });

  if (!asterisk) {
    throw new AppError("ERR_ASTERISK_NOT_FOUND", 404);
  }

  // Check if extension already exists
  const existingExtension = await Extension.findOne({
    where: { exten, asteriskId }
  });

  if (existingExtension) {
    throw new AppError("ERR_EXTENSION_ALREADY_EXISTS", 400);
  }

  const extension = await Extension.create({
    exten,
    password,
    callerIdName,
    callerIdNumber,
    asteriskId,
    userId,
    companyId,
    webrtcEnabled,
    context,
    transport,
    codecs,
    maxContacts,
    notes,
    status: "DISCONNECTED"
  });

  const result = await Extension.findByPk(extension.id, {
    include: [
      { model: Asterisk, as: "asterisk", attributes: ["id", "name", "host"] },
      { model: User, as: "user", attributes: ["id", "name"] }
    ]
  });

  return result!;
};

export default CreateExtensionService;
