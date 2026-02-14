import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";

interface Request {
  companyId: number;
  searchParam?: string;
  pageNumber?: string;
}

interface Response {
  asterisks: Asterisk[];
  count: number;
  hasMore: boolean;
}

const ListAsteriskService = async ({
  companyId,
  searchParam = "",
  pageNumber = "1"
}: Request): Promise<Response> => {
  const limit = 20;
  const offset = limit * (+pageNumber - 1);

  const { count, rows: asterisks } = await Asterisk.findAndCountAll({
    where: { companyId },
    limit,
    offset,
    order: [["name", "ASC"]]
  });

  const hasMore = count > offset + asterisks.length;

  return {
    asterisks,
    count,
    hasMore
  };
};

export default ListAsteriskService;
