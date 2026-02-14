import AppError from "../../errors/AppError";
import FlowChat from "../../models/FlowChat";

const DeleteFlowChatService = async (id: string): Promise<void> => {
  const record = await FlowChat.findOne({ where: { id } });

  if (!record) {
    throw new AppError("ERR_NO_FLOW_FOUND", 404);
  }

  await record.destroy();
};

export default DeleteFlowChatService;
