import { getIO } from "../../libs/socket";
import Contact from "../../models/Contact";
import ContactCustomField from "../../models/ContactCustomField";
import { isNil } from "lodash";
interface ExtraInfo extends ContactCustomField {
  name: string;
  value: string;
}

interface Request {
  name: string;
  number: string;
  isGroup: boolean;
  email?: string;
  profilePicUrl?: string;
  companyId: number;
  extraInfo?: ExtraInfo[];
  whatsappId?: number;
}

const CreateOrUpdateContactService = async ({
  name,
  number: rawNumber,
  profilePicUrl,
  isGroup,
  email = "",
  companyId,
  extraInfo = [],
  whatsappId
}: Request): Promise<Contact> => {
  // Normalizar número: remover caracteres não numéricos (exceto para grupos)
  const number = isGroup ? rawNumber : rawNumber.replace(/[^0-9]/g, "");
  
  // Validar número
  if (!number || number.length < 8) {
    throw new Error(`Número inválido: ${rawNumber}`);
  }

  const io = getIO();
  let contact: Contact | null;

  // Buscar contato existente por número E companyId
  contact = await Contact.findOne({
    where: {
      number,
      companyId
    }
  });

  if (contact) {
    // Atualizar campos se necessário
    const updateData: any = {};
    
    if (profilePicUrl && profilePicUrl !== contact.profilePicUrl) {
      updateData.profilePicUrl = profilePicUrl;
    }
    
    // Atualizar nome apenas se for mais completo
    if (name && name.length > (contact.name?.length || 0) && name !== number) {
      updateData.name = name;
    }
    
    // Atualizar whatsappId se não estiver definido
    if (whatsappId && !contact.whatsappId) {
      updateData.whatsappId = whatsappId;
    }
    
    if (Object.keys(updateData).length > 0) {
      await contact.update(updateData);
    }
    
    io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-contact`, {
      action: "update",
      contact
    });
  } else {
    // Criar novo contato
    contact = await Contact.create({
      name: name || number, // Usar número como nome se não houver nome
      number,
      profilePicUrl,
      email,
      isGroup,
      extraInfo,
      companyId,
      whatsappId
    });

    io.to(`company-${companyId}-mainchannel`).emit(`company-${companyId}-contact`, {
      action: "create",
      contact
    });
  }

  return contact;
};

export default CreateOrUpdateContactService;
