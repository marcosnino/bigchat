import { Op } from "sequelize";
import { Sequelize } from "sequelize-typescript";
import Call from "../../models/Call";

interface Request {
  companyId: number;
  startDate?: string;
  endDate?: string;
  userId?: number;
}

interface CallStats {
  totalCalls: number;
  answeredCalls: number;
  missedCalls: number;
  totalDuration: number;
  avgDuration: number;
  inboundCalls: number;
  outboundCalls: number;
  callsByStatus: Record<string, number>;
  callsByHour: { hour: number; count: number }[];
}

const GetCallStatsService = async ({
  companyId,
  startDate,
  endDate,
  userId
}: Request): Promise<CallStats> => {
  const whereCondition: any = { companyId };

  if (userId) {
    whereCondition.userId = userId;
  }

  if (startDate && endDate) {
    whereCondition.startedAt = {
      [Op.between]: [new Date(startDate), new Date(endDate)]
    };
  }

  const calls = await Call.findAll({
    where: whereCondition,
    attributes: ["status", "direction", "duration", "startedAt"]
  });

  const totalCalls = calls.length;
  const answeredCalls = calls.filter(c => c.status === "completed" || c.status === "answered").length;
  const missedCalls = calls.filter(c => c.status === "no-answer" || c.status === "canceled").length;
  const totalDuration = calls.reduce((sum, c) => sum + (c.duration || 0), 0);
  const avgDuration = answeredCalls > 0 ? Math.round(totalDuration / answeredCalls) : 0;
  const inboundCalls = calls.filter(c => c.direction === "inbound").length;
  const outboundCalls = calls.filter(c => c.direction === "outbound").length;

  // Calls by status
  const callsByStatus: Record<string, number> = {};
  calls.forEach(c => {
    callsByStatus[c.status] = (callsByStatus[c.status] || 0) + 1;
  });

  // Calls by hour
  const hourCounts: Record<number, number> = {};
  calls.forEach(c => {
    if (c.startedAt) {
      const hour = new Date(c.startedAt).getHours();
      hourCounts[hour] = (hourCounts[hour] || 0) + 1;
    }
  });

  const callsByHour = Array.from({ length: 24 }, (_, i) => ({
    hour: i,
    count: hourCounts[i] || 0
  }));

  return {
    totalCalls,
    answeredCalls,
    missedCalls,
    totalDuration,
    avgDuration,
    inboundCalls,
    outboundCalls,
    callsByStatus,
    callsByHour
  };
};

export default GetCallStatsService;
