import { Op } from "sequelize";
import Call from "../../models/Call";
import User from "../../models/User";
import Contact from "../../models/Contact";
import Asterisk from "../../models/Asterisk";

interface Request {
  companyId: number;
  searchParam?: string;
  pageNumber?: string;
  status?: string;
  direction?: string;
  startDate?: string;
  endDate?: string;
  userId?: number;
}

interface Response {
  calls: Call[];
  count: number;
  hasMore: boolean;
}

const ListCallsService = async ({
  companyId,
  searchParam = "",
  pageNumber = "1",
  status,
  direction,
  startDate,
  endDate,
  userId
}: Request): Promise<Response> => {
  const limit = 20;
  const offset = limit * (+pageNumber - 1);

  const whereCondition: any = { companyId };

  if (status) {
    whereCondition.status = status;
  }

  if (direction) {
    whereCondition.direction = direction;
  }

  if (userId) {
    whereCondition.userId = userId;
  }

  if (startDate && endDate) {
    whereCondition.startedAt = {
      [Op.between]: [new Date(startDate), new Date(endDate)]
    };
  }

  if (searchParam) {
    whereCondition[Op.or] = [
      { caller: { [Op.iLike]: `%${searchParam}%` } },
      { called: { [Op.iLike]: `%${searchParam}%` } },
      { callerName: { [Op.iLike]: `%${searchParam}%` } }
    ];
  }

  const { count, rows: calls } = await Call.findAndCountAll({
    where: whereCondition,
    include: [
      { model: User, as: "user", attributes: ["id", "name", "email"] },
      { model: Contact, as: "contact", attributes: ["id", "name", "number"] },
      { model: Asterisk, as: "asterisk", attributes: ["id", "name"] }
    ],
    limit,
    offset,
    order: [["startedAt", "DESC"]]
  });

  const hasMore = count > offset + calls.length;

  return {
    calls,
    count,
    hasMore
  };
};

export default ListCallsService;
