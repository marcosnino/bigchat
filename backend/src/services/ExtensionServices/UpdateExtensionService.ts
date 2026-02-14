import Extension from "../../models/Extension";
import Asterisk from "../../models/Asterisk";
import User from "../../models/User";
import AppError from "../../errors/AppError";

interface Request {
  id: number;
  exten?: string;
  password?: string;
  callerIdName?: string;
  callerIdNumber?: string;
  asteriskId?: number;
  userId?: number | null;
  companyId: number;
  webrtcEnabled?: boolean;
  context?: string;
  transport?: string;
  codecs?: string;
  maxContacts?: number;
  notes?: string;
  status?: string;
}

const UpdateExtensionService = async ({
  id,
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
  status
}: Request): Promise<Extension> => {
  const extension = await Extension.findOne({
    where: { id, companyId }
  });

  if (!extension) {
    throw new AppError("ERR_EXTENSION_NOT_FOUND", 404);
  }

  // Check if new exten conflicts with existing
  if (exten && exten !== extension.exten) {
    const existingExtension = await Extension.findOne({
      where: { exten, asteriskId: asteriskId || extension.asteriskId }
    });

    if (existingExtension && existingExtension.id !== id) {
      throw new AppError("ERR_EXTENSION_ALREADY_EXISTS", 400);
    }
  }

  await extension.update({
    exten: exten !== undefined ? exten : extension.exten,
    password: password !== undefined ? password : extension.password,
    callerIdName: callerIdName !== undefined ? callerIdName : extension.callerIdName,
    callerIdNumber: callerIdNumber !== undefined ? callerIdNumber : extension.callerIdNumber,
    asteriskId: asteriskId !== undefined ? asteriskId : extension.asteriskId,
    userId: userId !== undefined ? userId : extension.userId,
    webrtcEnabled: webrtcEnabled !== undefined ? webrtcEnabled : extension.webrtcEnabled,
    context: context !== undefined ? context : extension.context,
    transport: transport !== undefined ? transport : extension.transport,
    codecs: codecs !== undefined ? codecs : extension.codecs,
    maxContacts: maxContacts !== undefined ? maxContacts : extension.maxContacts,
    notes: notes !== undefined ? notes : extension.notes,
    status: status !== undefined ? status : extension.status
  });

  const result = await Extension.findByPk(extension.id, {
    include: [
      { model: Asterisk, as: "asterisk", attributes: ["id", "name", "host"] },
      { model: User, as: "user", attributes: ["id", "name"] }
    ]
  });

  return result!;
};

export default UpdateExtensionService;
