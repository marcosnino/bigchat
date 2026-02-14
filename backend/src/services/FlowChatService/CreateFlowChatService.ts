import * as Yup from "yup";
import AppError from "../../errors/AppError";
import FlowChat from "../../models/FlowChat";

interface FlowChatData {
  name: string;
  status?: string;
  trigger?: string;
  triggerCondition?: any;
  nodes?: any;
  edges?: any;
  companyId: number;
}

const CreateFlowChatService = async (data: FlowChatData): Promise<FlowChat> => {
  const schema = Yup.object().shape({
    name: Yup.string().required().min(2)
  });

  try {
    await schema.validate(data);
  } catch (err: any) {
    throw new AppError(err.message);
  }

  const record = await FlowChat.create(data);
  await record.reload();

  return record;
};

export default CreateFlowChatService;
