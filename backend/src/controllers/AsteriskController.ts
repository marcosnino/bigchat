import { Request, Response } from "express";
import { getIO } from "../libs/socket";
import asteriskManager from "../libs/asterisk";

import CreateAsteriskService from "../services/AsteriskServices/CreateAsteriskService";
import ListAsteriskService from "../services/AsteriskServices/ListAsteriskService";
import ShowAsteriskService from "../services/AsteriskServices/ShowAsteriskService";
import UpdateAsteriskService from "../services/AsteriskServices/UpdateAsteriskService";
import DeleteAsteriskService from "../services/AsteriskServices/DeleteAsteriskService";
import TestAsteriskConnectionService from "../services/AsteriskServices/TestAsteriskConnectionService";

interface AsteriskData {
  name: string;
  host: string;
  ariPort?: number;
  sipPort?: number;
  wsPort?: number;
  ariUser: string;
  ariPassword: string;
  ariApplication?: string;
  isActive?: boolean;
  useSSL?: boolean;
  sipDomain?: string;
  outboundContext?: string;
  inboundContext?: string;
  notes?: string;
}

export const index = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const { searchParam, pageNumber } = req.query as {
    searchParam?: string;
    pageNumber?: string;
  };

  const { asterisks, count, hasMore } = await ListAsteriskService({
    companyId,
    searchParam,
    pageNumber
  });

  return res.status(200).json({ asterisks, count, hasMore });
};

export const store = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const asteriskData: AsteriskData = req.body;

  const asterisk = await CreateAsteriskService({
    ...asteriskData,
    companyId
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-asterisk`,
    {
      action: "create",
      asterisk
    }
  );

  return res.status(201).json(asterisk);
};

export const show = async (req: Request, res: Response): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;

  const asterisk = await ShowAsteriskService(asteriskId, companyId);

  return res.status(200).json(asterisk);
};

export const update = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;
  const asteriskData: AsteriskData = req.body;

  const asterisk = await UpdateAsteriskService(
    asteriskId,
    companyId,
    asteriskData
  );

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-asterisk`,
    {
      action: "update",
      asterisk
    }
  );

  return res.status(200).json(asterisk);
};

export const remove = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;

  await DeleteAsteriskService(asteriskId, companyId);

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-asterisk`,
    {
      action: "delete",
      asteriskId: +asteriskId
    }
  );

  return res.status(200).json({ message: "Asterisk deleted" });
};

export const testConnection = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;

  const result = await TestAsteriskConnectionService(asteriskId, companyId);

  return res.status(200).json(result);
};

export const connect = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;

  const asterisk = await ShowAsteriskService(asteriskId, companyId);

  try {
    await asteriskManager.connect(asterisk);
    return res.status(200).json({ message: "Connected", status: "CONNECTED" });
  } catch (error) {
    return res.status(400).json({ message: `${error}`, status: "ERROR" });
  }
};

export const disconnect = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;

  await ShowAsteriskService(asteriskId, companyId);
  await asteriskManager.disconnect(+asteriskId);

  return res.status(200).json({ message: "Disconnected", status: "DISCONNECTED" });
};

export const getStatus = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { asteriskId } = req.params;
  const { companyId } = req.user;

  const asterisk = await ShowAsteriskService(asteriskId, companyId);
  const isConnected = asteriskManager.isConnected(asterisk.id);

  return res.status(200).json({
    status: asterisk.status,
    isConnected
  });
};
