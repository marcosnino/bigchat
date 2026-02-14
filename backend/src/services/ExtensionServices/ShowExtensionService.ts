import Extension from "../../models/Extension";
import Asterisk from "../../models/Asterisk";
import User from "../../models/User";
import AppError from "../../errors/AppError";

const ShowExtensionService = async (
  id: string | number,
  companyId: number
): Promise<Extension> => {
  const extension = await Extension.findOne({
    where: { id, companyId },
    include: [
      { model: Asterisk, as: "asterisk", attributes: ["id", "name", "host"] },
      { model: User, as: "user", attributes: ["id", "name"] }
    ]
  });

  if (!extension) {
    throw new AppError("ERR_EXTENSION_NOT_FOUND", 404);
  }

  return extension;
};

export default ShowExtensionService;
