import { Op } from "sequelize";
import CloseReason from "../../models/CloseReason";

interface Request {
  companyId: number;
  searchParam?: string;
  pageNumber?: string | number;
  includeInactive?: boolean;
}

interface Response {
  reasons: CloseReason[];
  count: number;
  hasMore: boolean;
}

const ListService = async ({
  companyId,
  searchParam,
  pageNumber = "1",
  includeInactive = true
}: Request): Promise<Response> => {
  const limit = 5000;
  const offset = limit * (+pageNumber - 1);

  const whereCondition: any = { companyId };

  if (!includeInactive) {
    whereCondition.isActive = true;
  }

  if (searchParam) {
    whereCondition[Op.or] = [
      { name: { [Op.like]: `%${searchParam}%` } },
      { description: { [Op.like]: `%${searchParam}%` } }
    ];
  }

  const { count, rows } = await CloseReason.findAndCountAll({
    where: whereCondition,
    limit,
    offset,
    order: [["name", "ASC"]]
  });

  const hasMore = count > offset + rows.length;

  return { reasons: rows, count, hasMore };
};

export default ListService;
