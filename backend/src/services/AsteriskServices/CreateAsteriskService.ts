import Asterisk from "../../models/Asterisk";
import AppError from "../../errors/AppError";
import asteriskManager from "../../libs/asterisk";

interface CreateAsteriskData {
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
  companyId: number;
}

const CreateAsteriskService = async (
  data: CreateAsteriskData
): Promise<Asterisk> => {
  const {
    name,
    host,
    ariPort = 8088,
    sipPort = 5060,
    wsPort = 8089,
    ariUser,
    ariPassword,
    ariApplication,
    isActive = false,
    useSSL = false,
    sipDomain,
    outboundContext,
    inboundContext = "from-internal",
    notes,
    companyId
  } = data;

  const asterisk = await Asterisk.create({
    name,
    host,
    ariPort,
    sipPort,
    wsPort,
    ariUser,
    ariPassword,
    ariApplication,
    isActive,
    useSSL,
    sipDomain,
    outboundContext,
    inboundContext,
    notes,
    companyId,
    status: "DISCONNECTED"
  });

  // Auto-connect if active
  if (isActive) {
    try {
      await asteriskManager.connect(asterisk);
    } catch (error) {
      // Don't fail creation, just log
      console.error(`Failed to auto-connect Asterisk: ${error}`);
    }
  }

  return asterisk;
};

export default CreateAsteriskService;
