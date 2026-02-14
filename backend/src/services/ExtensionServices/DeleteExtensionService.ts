import Extension from "../../models/Extension";
import AppError from "../../errors/AppError";

const DeleteExtensionService = async (
  id: string | number,
  companyId: number
): Promise<void> => {
  const extension = await Extension.findOne({
    where: { id, companyId }
  });

  if (!extension) {
    throw new AppError("ERR_EXTENSION_NOT_FOUND", 404);
  }

  await extension.destroy();
};

export default DeleteExtensionService;
