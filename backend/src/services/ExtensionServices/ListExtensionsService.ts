import { Op } from "sequelize";
import Extension from "../../models/Extension";
import Asterisk from "../../models/Asterisk";
import User from "../../models/User";

interface Request {
  companyId: number;
  asteriskId?: number;
  userId?: number;
  searchParam?: string;
}

interface Response {
  extensions: Extension[];
  count: number;
}

const ListExtensionsService = async ({
  companyId,
  asteriskId,
  userId,
  searchParam
}: Request): Promise<Response> => {
  const whereCondition: any = { companyId };

  if (asteriskId) {
    whereCondition.asteriskId = asteriskId;
  }

  if (userId) {
    whereCondition.userId = userId;
  }

  if (searchParam) {
    whereCondition[Op.or] = [
      { exten: { [Op.like]: `%${searchParam}%` } },
      { callerIdName: { [Op.like]: `%${searchParam}%` } }
    ];
  }

  const { count, rows: extensions } = await Extension.findAndCountAll({
    where: whereCondition,
    include: [
      { model: Asterisk, as: "asterisk", attributes: ["id", "name", "host"] },
      { model: User, as: "user", attributes: ["id", "name"] }
    ],
    order: [["exten", "ASC"]]
  });

  return { extensions, count };
};

export default ListExtensionsService;
