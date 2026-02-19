import * as Yup from "yup";

import AppError from "../../errors/AppError";
import CloseReason from "../../models/CloseReason";
import ShowService from "./ShowService";

interface CloseReasonData {
  name?: string;
  description?: string;
  isActive?: boolean;
}

interface Request {
  closeReasonData: CloseReasonData;
  id: string | number;
  companyId: number;
}

const UpdateService = async ({
  closeReasonData,
  id,
  companyId
}: Request): Promise<CloseReason> => {
  const schema = Yup.object().shape({
    name: Yup.string().min(2)
  });

  try {
    await schema.validate({
      name: closeReasonData.name
    });
  } catch (err: any) {
    throw new AppError(err.message);
  }

  const reason = await ShowService(id, companyId);

  await reason.update({
    name: closeReasonData.name,
    description: closeReasonData.description,
    queueId: null,
    isActive: closeReasonData.isActive
  });

  await reason.reload();

  return reason;
};

export default UpdateService;
