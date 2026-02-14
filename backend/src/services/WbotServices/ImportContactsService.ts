import * as Sentry from "@sentry/node";
import GetDefaultWhatsApp from "../../helpers/GetDefaultWhatsApp";
import { getWbot } from "../../libs/wbot-wwjs";
import Contact from "../../models/Contact";
import { logger } from "../../utils/logger";
import CreateContactService from "../ContactServices/CreateContactService";
import { isArray } from "lodash";
import path from "path";
import fs from 'fs';

const ImportContactsService = async (companyId: number): Promise<void> => {
  const defaultWhatsapp = await GetDefaultWhatsApp(companyId);
  const wbot = await getWbot(defaultWhatsapp.id);
  
  if (!wbot) {
    throw new Error("WhatsApp não conectado");
  }

  let phoneContacts: any[] = [];

  try {
    // Obter contatos do WhatsApp via whatsapp-web.js
    const contacts = await wbot.getContacts();
    
    phoneContacts = contacts
      .filter(contact => contact.isWAContact && !contact.isGroup)
      .map(contact => ({
        id: contact.id._serialized,
        name: contact.pushname || contact.name || "",
        notify: contact.pushname || "",
        number: contact.number
      }));

    const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");
    const beforeFilePath = path.join(publicFolder, 'contatos_antes.txt');
    fs.writeFile(beforeFilePath, JSON.stringify(phoneContacts, null, 2), (err) => {
      if (err) {
        logger.error(`Failed to write contacts to file: ${err}`);
      }
      console.log('O arquivo contatos_antes.txt foi criado!');
    });

  } catch (err) {
    Sentry.captureException(err);
    logger.error(`Could not get whatsapp contacts from phone. Err: ${err}`);
  }

  const publicFolder = path.resolve(__dirname, "..", "..", "..", "public");
  const afterFilePath = path.join(publicFolder, 'contatos_depois.txt');
  fs.writeFile(afterFilePath, JSON.stringify(phoneContacts, null, 2), (err) => {
    if (err) {
      logger.error(`Failed to write contacts to file: ${err}`);
    }
  });

  if (isArray(phoneContacts)) {
    phoneContacts.forEach(async ({ id, name, notify, number }) => {
      if (id === "status@broadcast" || id.includes("g.us")) return;
      const cleanNumber = number || id.replace(/\D/g, "");

      const existingContact = await Contact.findOne({
        where: { number: cleanNumber, companyId }
      });

      if (existingContact) {
        // Atualiza o nome do contato existente
        existingContact.name = name || notify;
        await existingContact.save();
      } else {
        // Criar um novo contato
        try {
          await CreateContactService({
            number: cleanNumber,
            name: name || notify,
            companyId
          });
        } catch (error) {
          Sentry.captureException(error);
          logger.warn(
            `Could not get whatsapp contacts from phone. Err: ${error}`
          );
        }
      }
    });
  }
};

export default ImportContactsService;
