import AppError from "../../errors/AppError";
import FlowChat from "../../models/FlowChat";

const ShowFlowChatService = async (id: string | number): Promise<FlowChat> => {
  const record = await FlowChat.findByPk(id);

  if (!record) {
    throw new AppError("ERR_NO_FLOW_FOUND", 404);
  }

  return record;
};

export default ShowFlowChatService;
