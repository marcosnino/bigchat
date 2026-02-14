import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";
import asteriskManager from "../../libs/asterisk";

const TestAsteriskConnectionService = async (
  id: string | number,
  companyId: number
): Promise<{ success: boolean; message: string }> => {
  const asterisk = await Asterisk.findOne({
    where: { id, companyId }
  });

  if (!asterisk) {
    throw new AppError("ERR_NO_ASTERISK_FOUND", 404);
  }

  try {
    await asteriskManager.connect(asterisk);
    return {
      success: true,
      message: "Conexão com Asterisk estabelecida com sucesso"
    };
  } catch (error) {
    return {
      success: false,
      message: `Falha na conexão: ${error}`
    };
  }
};

export default TestAsteriskConnectionService;
