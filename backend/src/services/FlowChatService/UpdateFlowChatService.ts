import * as Yup from "yup";
import AppError from "../../errors/AppError";
import FlowChat from "../../models/FlowChat";

interface FlowChatData {
  id: number;
  name?: string;
  status?: string;
  trigger?: string;
  triggerCondition?: any;
  nodes?: any;
  edges?: any;
}

const UpdateFlowChatService = async (data: FlowChatData): Promise<FlowChat> => {
  const { id } = data;

  const schema = Yup.object().shape({
    name: Yup.string().min(2)
  });

  try {
    await schema.validate(data);
  } catch (err: any) {
    throw new AppError(err.message);
  }

  const record = await FlowChat.findByPk(id);

  if (!record) {
    throw new AppError("ERR_NO_FLOW_FOUND", 404);
  }

  await record.update(data);
  await record.reload();

  return record;
};

export default UpdateFlowChatService;
