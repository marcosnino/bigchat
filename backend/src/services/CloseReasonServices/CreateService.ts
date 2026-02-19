import * as Yup from "yup";

import AppError from "../../errors/AppError";
import CloseReason from "../../models/CloseReason";

interface Request {
  name: string;
  description?: string;
  companyId: number;
  isActive?: boolean;
}

const CreateService = async ({
  name,
  description,
  companyId,
  isActive = true
}: Request): Promise<CloseReason> => {
  const schema = Yup.object().shape({
    name: Yup.string().required().min(2)
  });

  try {
    await schema.validate({ name });
  } catch (err: any) {
    throw new AppError(err.message);
  }

  const reason = await CloseReason.create({
    name,
    description,
    queueId: null,
    companyId,
    isActive
  });

  await reason.reload();

  return reason;
};

export default CreateService;
