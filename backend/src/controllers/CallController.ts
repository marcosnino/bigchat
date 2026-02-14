import { Request, Response } from "express";
import { getIO } from "../libs/socket";

import ListCallsService from "../services/CallServices/ListCallsService";
import ShowCallService from "../services/CallServices/ShowCallService";
import OriginateCallService from "../services/CallServices/OriginateCallService";
import HangupCallService from "../services/CallServices/HangupCallService";
import TransferCallService from "../services/CallServices/TransferCallService";
import GetCallStatsService from "../services/CallServices/GetCallStatsService";

interface CallQueryParams {
  searchParam?: string;
  pageNumber?: string;
  status?: string;
  direction?: string;
  startDate?: string;
  endDate?: string;
  userId?: string;
}

export const index = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const {
    searchParam,
    pageNumber,
    status,
    direction,
    startDate,
    endDate,
    userId
  } = req.query as CallQueryParams;

  const { calls, count, hasMore } = await ListCallsService({
    companyId,
    searchParam,
    pageNumber,
    status,
    direction,
    startDate,
    endDate,
    userId: userId ? +userId : undefined
  });

  return res.status(200).json({ calls, count, hasMore });
};

export const show = async (req: Request, res: Response): Promise<Response> => {
  const { callId } = req.params;
  const { companyId } = req.user;

  const call = await ShowCallService(callId, companyId);

  return res.status(200).json(call);
};

export const originate = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { companyId, id: userId } = req.user;
  const { asteriskId, extension, destination, callerId, contactId, ticketId } =
    req.body;

  const call = await OriginateCallService({
    asteriskId,
    extension,
    destination,
    callerId,
    userId: Number(userId),
    contactId,
    ticketId,
    companyId
  });

  const io = getIO();
  io.to(`company-${companyId}-mainchannel`).emit(
    `company-${companyId}-call`,
    {
      action: "create",
      call
    }
  );

  return res.status(201).json(call);
};

export const hangup = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { callId } = req.params;
  const { companyId } = req.user;

  await HangupCallService({
    callId: +callId,
    companyId
  });

  return res.status(200).json({ message: "Call ended" });
};

export const transfer = async (
  req: Request,
  res: Response
): Promise<Response> => {
  const { callId } = req.params;
  const { destination } = req.body;
  const { companyId } = req.user;

  await TransferCallService({
    callId: +callId,
    destination,
    companyId
  });

  return res.status(200).json({ message: "Call transferred" });
};

export const stats = async (req: Request, res: Response): Promise<Response> => {
  const { companyId } = req.user;
  const { startDate, endDate, userId } = req.query as {
    startDate?: string;
    endDate?: string;
    userId?: string;
  };

  const statistics = await GetCallStatsService({
    companyId,
    startDate,
    endDate,
    userId: userId ? +userId : undefined
  });

  return res.status(200).json(statistics);
};
