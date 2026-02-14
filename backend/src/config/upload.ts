import path from "path";
import multer from "multer";
import fs from "fs";

const publicFolder = path.resolve(__dirname, "..", "..", "public");

/**
 * Limite de tamanho de arquivo (16MB - limite do WhatsApp)
 */
const MAX_FILE_SIZE = 16 * 1024 * 1024; // 16MB

/**
 * Mimetypes permitidos para upload
 */
const ALLOWED_MIMETYPES = [
  // Imagens
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
  "image/bmp",
  // Áudio
  "audio/mpeg",
  "audio/mp3",
  "audio/ogg",
  "audio/opus",
  "audio/wav",
  "audio/aac",
  "audio/mp4",
  "audio/webm",
  // Vídeo
  "video/mp4",
  "video/3gpp",
  "video/quicktime",
  "video/webm",
  "video/mpeg",
  // Documentos
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "application/vnd.ms-excel",
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  "application/vnd.ms-powerpoint",
  "application/vnd.openxmlformats-officedocument.presentationml.presentation",
  "text/plain",
  "text/csv",
  "application/zip",
  "application/x-rar-compressed",
  "application/x-7z-compressed"
];

/**
 * Filtro de arquivos - valida mimetype
 */
const fileFilter = (
  req: Express.Request,
  file: Express.Multer.File,
  cb: multer.FileFilterCallback
): void => {
  if (ALLOWED_MIMETYPES.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error(`Tipo de arquivo não permitido: ${file.mimetype}. Tipos aceitos: imagens, áudios, vídeos e documentos.`));
  }
};

export default {
  directory: publicFolder,
  storage: multer.diskStorage({
    destination: async function (req, file, cb) {

      const { typeArch, fileId } = req.body;      

      let folder;

      if (typeArch && typeArch !== "announcements") {
        folder =  path.resolve(publicFolder , typeArch, fileId ? fileId : "") 
      } else if (typeArch && typeArch === "announcements") {
        folder =  path.resolve(publicFolder , typeArch) 
      }
      else
      {
        folder =  path.resolve(publicFolder) 
      }

      if (!fs.existsSync(folder)) {
        fs.mkdirSync(folder,  { recursive: true })
        fs.chmodSync(folder, 0o777)
      }
      return cb(null, folder);
    },
    filename(req, file, cb) {
      const { typeArch } = req.body;

      const fileName = typeArch && typeArch !== "announcements" ? file.originalname.replace('/','-').replace(/ /g, "_") : new Date().getTime() + '_' + file.originalname.replace('/','-').replace(/ /g, "_");
      return cb(null, fileName);
    }
  }),
  limits: {
    fileSize: MAX_FILE_SIZE,
    files: 10 // Máximo de 10 arquivos por requisição
  },
  fileFilter
};
