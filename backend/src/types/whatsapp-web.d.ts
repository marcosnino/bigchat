/**
 * Type declarations for whatsapp-web.js
 * Permite compilação mesmo sem o pacote instalado localmente
 */

declare module "whatsapp-web.js" {
  export interface ClientInfo {
    wid: {
      user: string;
      server: string;
      _serialized: string;
    };
    pushname: string;
    platform?: string;
  }

  export interface MessageId {
    id: string;
    _serialized: string;
    fromMe: boolean;
    remote: string;
  }

  export class Client {
    constructor(options?: ClientOptions);
    
    id?: number;
    companyId?: number;
    isReady?: boolean;
    info: ClientInfo;
    
    initialize(): Promise<void>;
    logout(): Promise<void>;
    destroy(): Promise<void>;
    
    sendMessage(chatId: string, content: string | MessageMedia, options?: MessageSendOptions): Promise<Message>;
    getContacts(): Promise<Contact[]>;
    getChats(): Promise<Chat[]>;
    getChatById(chatId: string): Promise<Chat>;
    getContactById(contactId: string): Promise<Contact>;
    getNumberId(number: string): Promise<{ user: string; server: string; _serialized: string } | null>;
    getProfilePicUrl(contactId: string): Promise<string>;
    
    on(event: 'qr', listener: (qr: string) => void): this;
    on(event: 'authenticated', listener: () => void): this;
    on(event: 'auth_failure', listener: (message: string) => void): this;
    on(event: 'ready', listener: () => void): this;
    on(event: 'message', listener: (message: Message) => void): this;
    on(event: 'message_create', listener: (message: Message) => void): this;
    on(event: 'message_ack', listener: (message: Message, ack: number) => void): this;
    on(event: 'message_revoke_everyone', listener: (message: Message, revokedMsg: Message) => void): this;
    on(event: 'disconnected', listener: (reason: string) => void): this;
    on(event: 'change_state', listener: (state: WAState) => void): this;
    on(event: 'loading_screen', listener: (percent: number, message: string) => void): this;
    on(event: string, listener: (...args: any[]) => void): this;
  }

  export interface ClientOptions {
    authStrategy?: AuthStrategy;
    puppeteer?: {
      headless?: boolean;
      args?: string[];
      executablePath?: string;
    };
    qrMaxRetries?: number;
    restartOnAuthFail?: boolean;
  }

  export interface AuthStrategy {}

  export class LocalAuth implements AuthStrategy {
    constructor(options?: { clientId?: string; dataPath?: string });
  }

  export interface Message {
    id: MessageId;
    body: string;
    from: string;
    to: string;
    author?: string;
    timestamp: number;
    type: string;
    hasMedia: boolean;
    hasQuotedMsg: boolean;
    isStatus: boolean;
    isForwarded: boolean;
    forwardingScore?: number;
    isStarred: boolean;
    broadcast: boolean;
    fromMe: boolean;
    ack: number;
    location?: Location;
    vCards?: string[];
    mentionedIds?: string[];

    getContact(): Promise<Contact>;
    getChat(): Promise<Chat>;
    getQuotedMessage(): Promise<Message | undefined>;
    downloadMedia(): Promise<MessageMedia | undefined>;
    delete(everyone?: boolean): Promise<void>;
  }

  export class MessageMedia {
    mimetype: string;
    data: string;
    filename?: string;

    static fromFilePath(filePath: string): MessageMedia;
    static fromUrl(url: string, options?: { unsafeMime?: boolean; filename?: string }): Promise<MessageMedia>;
  }

  export interface MessageSendOptions {
    caption?: string;
    quotedMessageId?: string;
    sendAudioAsVoice?: boolean;
    sendMediaAsDocument?: boolean;
    sendMediaAsSticker?: boolean;
    mentions?: string[];
  }

  export interface Chat {
    id: {
      _serialized: string;
      server: string;
      user: string;
    };
    name: string;
    isGroup: boolean;
    isReadOnly: boolean;
    unreadCount: number;
    timestamp: number;
    
    sendMessage(content: string | MessageMedia, options?: MessageSendOptions): Promise<Message>;
    fetchMessages(options?: { limit?: number }): Promise<Message[]>;
  }

  export interface Contact {
    id: {
      _serialized: string;
      server: string;
      user: string;
    };
    number: string;
    name?: string;
    pushname?: string;
    isGroup: boolean;
    isWAContact: boolean;
    isMyContact: boolean;
    isBlocked: boolean;
    isEnterprise: boolean;
    isBusiness: boolean;
    
    getProfilePicUrl(): Promise<string | undefined>;
  }

  export interface Location {
    latitude: number;
    longitude: number;
    description?: string;
  }

  export enum WAState {
    CONFLICT = 'CONFLICT',
    CONNECTED = 'CONNECTED',
    DEPRECATED_VERSION = 'DEPRECATED_VERSION',
    OPENING = 'OPENING',
    PAIRING = 'PAIRING',
    PROXYBLOCK = 'PROXYBLOCK',
    SMB_TOS_BLOCK = 'SMB_TOS_BLOCK',
    TIMEOUT = 'TIMEOUT',
    TOS_BLOCK = 'TOS_BLOCK',
    UNLAUNCHED = 'UNLAUNCHED',
    UNPAIRED = 'UNPAIRED',
    UNPAIRED_IDLE = 'UNPAIRED_IDLE'
  }
}

declare module "qrcode" {
  export function toDataURL(text: string): Promise<string>;
  export function toBuffer(text: string): Promise<Buffer>;
  export function toString(text: string): Promise<string>;
}
