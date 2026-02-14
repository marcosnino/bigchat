import { Request, Response } from "express";
import CreateExtensionService from "../services/ExtensionServices/CreateExtensionService";
import ListExtensionsService from "../services/ExtensionServices/ListExtensionsService";
import ShowExtensionService from "../services/ExtensionServices/ShowExtensionService";
import UpdateExtensionService from "../services/ExtensionServices/UpdateExtensionService";
import DeleteExtensionService from "../services/ExtensionServices/DeleteExtensionService";
import { getIO } from "../libs/socket";

export const index = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const { asteriskId, userId, searchParam } = req.query;

  const { extensions, count } = await ListExtensionsService({
    companyId,
    asteriskId: asteriskId ? Number(asteriskId) : undefined,
    userId: userId ? Number(userId) : undefined,
    searchParam: searchParam as string
  });

  return res.json({ extensions, count });
};

export const store = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const {
    exten,
    password,
    callerIdName,
    callerIdNumber,
    asteriskId,
    userId,
    webrtcEnabled,
    context,
    transport,
    codecs,
    maxContacts,
    notes
  } = req.body;

  const extension = await CreateExtensionService({
    exten,
    password,
    callerIdName,
    callerIdNumber,
    asteriskId,
    userId,
    companyId,
    webrtcEnabled,
    context,
    transport,
    codecs,
    maxContacts,
    notes
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-extension`, {
    action: "create",
    extension
  });

  return res.status(201).json(extension);
};

export const show = async (req: Request, res: Response): Promise<Response> => {
  const { extensionId } = req.params;
  const { companyId } = req.user;

  const extension = await ShowExtensionService(extensionId, companyId);

  return res.json(extension);
};

export const update = async (req: Request, res: Response): Promise<Response> => {
  const { extensionId } = req.params;
  const { companyId } = req.user;
  const extensionData = req.body;

  const extension = await UpdateExtensionService({
    id: Number(extensionId),
    companyId,
    ...extensionData
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-extension`, {
    action: "update",
    extension
  });

  return res.json(extension);
};

export const remove = async (req: Request, res: Response): Promise<Response> => {
  const { extensionId } = req.params;
  const { companyId } = req.user;

  await DeleteExtensionService(extensionId, companyId);

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-extension`, {
    action: "delete",
    extensionId
  });

  return res.status(200).json({ message: "Extension deleted" });
};
