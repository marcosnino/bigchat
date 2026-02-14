import axios, { AxiosInstance, AxiosResponse } from "axios";
import AppError from "../errors/AppError";

interface MetaApiConfig {
  accessToken: string;
  phoneNumberId: string;
  apiVersion?: string;
}

interface SendTextMessageParams {
  to: string;
  text: string;
  previewUrl?: boolean;
}

interface SendMediaMessageParams {
  to: string;
  type: "image" | "video" | "audio" | "document" | "sticker";
  mediaUrl?: string;
  mediaId?: string;
  caption?: string;
  filename?: string;
}

interface SendTemplateMessageParams {
  to: string;
  templateName: string;
  languageCode: string;
  components?: any[];
}

interface SendLocationMessageParams {
  to: string;
  latitude: number;
  longitude: number;
  name?: string;
  address?: string;
}

interface SendContactMessageParams {
  to: string;
  contacts: any[];
}

interface SendReactionParams {
  to: string;
  messageId: string;
  emoji: string;
}

interface MarkAsReadParams {
  messageId: string;
}

interface MetaMessageResponse {
  messaging_product: string;
  contacts?: Array<{ input: string; wa_id: string }>;
  messages: Array<{ id: string }>;
}

interface MetaMediaUploadResponse {
  id: string;
}

interface MetaMediaDownloadResponse {
  url: string;
  mime_type: string;
  sha256: string;
  file_size: number;
  id: string;
  messaging_product: string;
}

class MetaApiClient {
  private client: AxiosInstance;
  private phoneNumberId: string;
  private apiVersion: string;

  constructor(config: MetaApiConfig) {
    this.phoneNumberId = config.phoneNumberId;
    this.apiVersion = config.apiVersion || "v18.0";

    this.client = axios.create({
      baseURL: `https://graph.facebook.com/${this.apiVersion}`,
      headers: {
        Authorization: `Bearer ${config.accessToken}`,
        "Content-Type": "application/json",
      },
    });

    // Interceptor para log de erros
    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        const errorData = error.response?.data?.error || error.message;
        console.error("Meta API Error:", JSON.stringify(errorData, null, 2));
        throw new AppError(
          `Meta API Error: ${errorData?.message || errorData}`,
          error.response?.status || 500
        );
      }
    );
  }

  /**
   * Envia mensagem de texto
   */
  async sendTextMessage(params: SendTextMessageParams): Promise<MetaMessageResponse> {
    const response: AxiosResponse<MetaMessageResponse> = await this.client.post(
      `/${this.phoneNumberId}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: params.to,
        type: "text",
        text: {
          preview_url: params.previewUrl ?? false,
          body: params.text,
        },
      }
    );
    return response.data;
  }

  /**
   * Envia mensagem com mídia (imagem, vídeo, áudio, documento)
   */
  async sendMediaMessage(params: SendMediaMessageParams): Promise<MetaMessageResponse> {
    const mediaObject: any = {};

    if (params.mediaId) {
      mediaObject.id = params.mediaId;
    } else if (params.mediaUrl) {
      mediaObject.link = params.mediaUrl;
    }

    if (params.caption && ["image", "video", "document"].includes(params.type)) {
      mediaObject.caption = params.caption;
    }

    if (params.filename && params.type === "document") {
      mediaObject.filename = params.filename;
    }

    const response: AxiosResponse<MetaMessageResponse> = await this.client.post(
      `/${this.phoneNumberId}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: params.to,
        type: params.type,
        [params.type]: mediaObject,
      }
    );
    return response.data;
  }

  /**
   * Envia mensagem de template (HSM)
   */
  async sendTemplateMessage(params: SendTemplateMessageParams): Promise<MetaMessageResponse> {
    const response: AxiosResponse<MetaMessageResponse> = await this.client.post(
      `/${this.phoneNumberId}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: params.to,
        type: "template",
        template: {
          name: params.templateName,
          language: {
            code: params.languageCode,
          },
          components: params.components || [],
        },
      }
    );
    return response.data;
  }

  /**
   * Envia localização
   */
  async sendLocationMessage(params: SendLocationMessageParams): Promise<MetaMessageResponse> {
    const response: AxiosResponse<MetaMessageResponse> = await this.client.post(
      `/${this.phoneNumberId}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: params.to,
        type: "location",
        location: {
          latitude: params.latitude,
          longitude: params.longitude,
          name: params.name,
          address: params.address,
        },
      }
    );
    return response.data;
  }

  /**
   * Envia contatos
   */
  async sendContactMessage(params: SendContactMessageParams): Promise<MetaMessageResponse> {
    const response: AxiosResponse<MetaMessageResponse> = await this.client.post(
      `/${this.phoneNumberId}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: params.to,
        type: "contacts",
        contacts: params.contacts,
      }
    );
    return response.data;
  }

  /**
   * Envia reação a uma mensagem
   */
  async sendReaction(params: SendReactionParams): Promise<MetaMessageResponse> {
    const response: AxiosResponse<MetaMessageResponse> = await this.client.post(
      `/${this.phoneNumberId}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: params.to,
        type: "reaction",
        reaction: {
          message_id: params.messageId,
          emoji: params.emoji,
        },
      }
    );
    return response.data;
  }

  /**
   * Marca mensagem como lida
   */
  async markAsRead(params: MarkAsReadParams): Promise<void> {
    await this.client.post(`/${this.phoneNumberId}/messages`, {
      messaging_product: "whatsapp",
      status: "read",
      message_id: params.messageId,
    });
  }

  /**
   * Faz upload de mídia para a Meta
   */
  async uploadMedia(
    filePath: string,
    mimeType: string
  ): Promise<MetaMediaUploadResponse> {
    const FormData = require("form-data");
    const fs = require("fs");
    const form = new FormData();

    form.append("messaging_product", "whatsapp");
    form.append("file", fs.createReadStream(filePath), {
      contentType: mimeType,
    });
    form.append("type", mimeType);

    const response: AxiosResponse<MetaMediaUploadResponse> = await this.client.post(
      `/${this.phoneNumberId}/media`,
      form,
      {
        headers: {
          ...form.getHeaders(),
        },
      }
    );
    return response.data;
  }

  /**
   * Obtém URL de download de mídia
   */
  async getMediaUrl(mediaId: string): Promise<MetaMediaDownloadResponse> {
    const response: AxiosResponse<MetaMediaDownloadResponse> = await this.client.get(
      `/${mediaId}`
    );
    return response.data;
  }

  /**
   * Faz download de mídia da Meta
   */
  async downloadMedia(mediaUrl: string, accessToken: string): Promise<Buffer> {
    const response = await axios.get(mediaUrl, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
      responseType: "arraybuffer",
    });
    return Buffer.from(response.data);
  }

  /**
   * Verifica se um número é válido no WhatsApp
   */
  async checkContact(phoneNumber: string): Promise<boolean> {
    try {
      // A Meta não tem endpoint direto para isso
      // A verificação é feita ao enviar mensagem
      return true;
    } catch (error) {
      return false;
    }
  }

  /**
   * Obtém informações do número de telefone
   */
  async getPhoneNumberInfo(): Promise<any> {
    const response = await this.client.get(`/${this.phoneNumberId}`);
    return response.data;
  }

  /**
   * Lista templates de mensagem
   */
  async listTemplates(businessAccountId: string): Promise<any[]> {
    const response = await this.client.get(
      `/${businessAccountId}/message_templates`
    );
    return response.data.data || [];
  }
}

export default MetaApiClient;
