import { Request, Response } from "express";
import { getIO } from "../libs/socket";

import CreateService from "../services/CloseReasonServices/CreateService";
import ListService from "../services/CloseReasonServices/ListService";
import UpdateService from "../services/CloseReasonServices/UpdateService";
import ShowService from "../services/CloseReasonServices/ShowService";
import DeleteService from "../services/CloseReasonServices/DeleteService";

export const index = async (req: Request, res: Response): Promise<Response> => {
  const { pageNumber, searchParam, includeInactive } = req.query;
  const { companyId } = req.user;

  const { reasons, count, hasMore } = await ListService({
    companyId,
    pageNumber: pageNumber as string,
    searchParam: searchParam as string,
    includeInactive: includeInactive !== "false"
  });

  return res.json({ reasons, count, hasMore });
};

export const show = async (req: Request, res: Response): Promise<Response> => {
  const { closeReasonId } = req.params;
  const { companyId } = req.user;

  const reason = await ShowService(closeReasonId, companyId);
  return res.status(200).json(reason);
};

export const store = async (req: Request, res: Response): Promise<Response> => {
  const { name, description, isActive } = req.body;
  const { companyId } = req.user;

  const reason = await CreateService({
    name,
    description,
    companyId,
    isActive
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit("closeReason", {
    action: "create",
    reason
  });

  return res.status(200).json(reason);
};

export const update = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { closeReasonId } = req.params;
  const { companyId } = req.user;

  const reason = await UpdateService({
    closeReasonData: req.body,
    id: closeReasonId,
    companyId
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit("closeReason", {
    action: "update",
    reason
  });

  return res.status(200).json(reason);
};

export const remove = async (req: Request, res: Response): Promise<Response> => {
  const { closeReasonId } = req.params;
  const { companyId } = req.user;

  await DeleteService(closeReasonId, companyId);

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit("closeReason", {
    action: "delete",
    closeReasonId
  });

  return res.status(200).json({ message: "Close reason deleted" });
};
