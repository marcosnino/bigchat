import { Request, Response } from "express";
import * as Yup from "yup";
import AppError from "../errors/AppError";
import ListFlowChatsService from "../services/FlowChatService/ListFlowChatsService";
import CreateFlowChatService from "../services/FlowChatService/CreateFlowChatService";
import ShowFlowChatService from "../services/FlowChatService/ShowFlowChatService";
import UpdateFlowChatService from "../services/FlowChatService/UpdateFlowChatService";
import DeleteFlowChatService from "../services/FlowChatService/DeleteFlowChatService";
import { getIO } from "../libs/socket";

type IndexQuery = {
  searchParam: string;
  pageNumber: string;
  companyId: string | number;
};

export const index = async (req: Request, res: Response): Promise<Response> => {
  const { searchParam, pageNumber } = req.query as IndexQuery;
  const { companyId } = req.user;

  const { records, count, hasMore } = await ListFlowChatsService({
    searchParam,
    pageNumber,
    companyId
  });

  return res.json({ records, count, hasMore });
};

export const store = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const data = req.body;

  const schema = Yup.object().shape({
    name: Yup.string().required()
  });

  try {
    await schema.validate(data);
  } catch (err: any) {
    throw new AppError(err.message);
  }

  const record = await CreateFlowChatService({
    ...data,
    companyId
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-flow`,
    {
      action: "create",
      record
    }
  );

  return res.status(200).json(record);
};

export const show = async (req: Request, res: Response): Promise<Response> => {
  const { id } = req.params;

  const record = await ShowFlowChatService(id);

  return res.status(200).json(record);
};

export const update = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const data = req.body;
  const { id } = req.params;

  const record = await UpdateFlowChatService({
    ...data,
    id: +id
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-flow`,
    {
      action: "update",
      record
    }
  );

  return res.status(200).json(record);
};

export const remove = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const { id } = req.params;

  await DeleteFlowChatService(id);

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-flow`,
    {
      action: "delete",
      id: +id
    }
  );

  return res.status(200).json({ message: "Flow deleted" });
};

export const duplicate = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const { id } = req.params;

  const original = await ShowFlowChatService(id);

  const record = await CreateFlowChatService({
    name: `${original.name} (cópia)`,
    status: "inactive",
    trigger: original.trigger,
    triggerCondition: original.triggerCondition,
    nodes: original.nodes,
    edges: original.edges,
    companyId
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-flow`,
    {
      action: "create",
      record
    }
  );

  return res.status(200).json(record);
};
