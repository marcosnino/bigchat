/**
 * Mock do Baileys para desenvolvimento local
 * Este arquivo substitui o Baileys (ESM) com stubs para permitir que o servidor rode
 * Será substituído pela API oficial do WhatsApp Cloud API
 */

// Re-exportar tipos comuns para compatibilidade
export const DisconnectReason = {
  CONNECTION_CLOSED: 0,
  CONNECTION_LOST: 1,
  CONNECTION_REPLACED: 2,
  CONNECTION_ATTEMPT_FAILED: 3,
  CREDENTIALS_UPDATED: 4,
  CREDENTIALS_REFRESHED: 5,
  UNAUTHORIZED: 6,
  APIUSED: 7,
  MULTI_DEVICE_MISMATCH: 8,
  RESYNC_REQUIRED: 9,
  RATE_OVERLIMIT: 10,
  LOGOUT: 11
};

export const Browsers = {
  ubuntu: [() => "Linux", "5.10.0-1-generic"],
  macOS: [() => "MacOS", "10.15.7"],
  windows: [() => "Windows", "10.0"],
  ie: [() => "Internet Explorer", "11.0"],
  edge: [() => "Edge", "90.0"],
  chrome: [() => "Chrome", "100.0"],
  firefox: [() => "Firefox", "95.0"],
  opera: [() => "Opera", "90.0"],
  safari: [() => "Safari", "14.0"],
  mobile: [() => "Mobile", "1.0"],
  /**
   * Retorna browser apropriado para o tipo de cliente
   */
  appropriate: (platform: string): [string, string, string] => {
    return ["BigChat", "Chrome", "10.15.7"];
  }
};

// Type aliases
export type WASocket = any;
export type CacheStore = any;
export type Chat = any;
export type Contact = any;
export type WAMessage = any;
export type WAMessageStubType = any;
export type WAMessageUpdate = any;
export type MessageUpsertType = "notify" | "append";
export type AnyMessageContent = any;

// Utils mock
export const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

// Proto mock como namespace
export namespace proto {
  export interface IWebMessageInfo {
    key?: any;
    message?: any;
    messageTimestamp?: any;
    status?: any;
    participant?: any;
    pushName?: string;
    broadcast?: boolean;
    messageStubType?: any;
    messageStubParameters?: any[];
  }

  export class WebMessageInfo {
    static fromObject(obj: any): IWebMessageInfo {
      return obj;
    }
  }

  export class Message {
    static fromObject(obj: any): any {
      return obj;
    }

    static AppStateSyncKeyData = class {
      static fromObject(obj: any): any {
        return obj;
      }
    };
  }
}

// Auth mock
export const BufferJSON = {
  replacer: (key: string, value: any) => {
    if (Buffer.isBuffer(value)) {
      return {
        type: "Buffer",
        data: value.toString("base64")
      };
    }
    return value;
  },
  reviver: (key: string, value: any) => {
    if (value?.type === "Buffer" && value?.data) {
      return Buffer.from(value.data, "base64");
    }
    return value;
  }
};

export function initAuthCreds() {
  return {
    creds: {
      noiseKey: { private: Buffer.alloc(32), public: Buffer.alloc(32) },
      signedIdentityKey: { private: Buffer.alloc(32), public: Buffer.alloc(32) },
      signedPreKey: {
        keyId: 1,
        keyPair: { private: Buffer.alloc(32), public: Buffer.alloc(32) },
        signature: Buffer.alloc(64)
      },
      me: {
        id: "0@s.whatsapp.net",
        name: "Mock User"
      },
      platform: "mock",
      registered: false,
      regPhoneNumber: undefined,
      regPhoneNumberCountryCode: undefined,
      regPhoneNumberNsPrefix: undefined,
      regFirstName: undefined,
      regLastName: undefined,
      regEmail: undefined,
      certChain: undefined,
      acctBirthDay: undefined,
      acctSince: 0,
      deviceName: "Mock Device",
      deviceType: 1,
      phoneNumberCountryCode: undefined,
      phoneNumberNationalNumber: undefined,
      phoneNumberE164Format: undefined,
      status: 0,
      statusSetTime: 0,
      autoDownloadSettings: {},
      userStatusMuted: false,
      pushName: "Mock",
      sideList: [],
      statusPrivacy: undefined,
      dtStateChecksum: 0,
      addOnsUserList: [],
      fdBroadcastListInfo: [],
      fdStatusRanking: [],
      lastSeenTime: 0
    },
    keys: {
      get: async () => null,
      set: async () => {},
      del: async () => {}
    }
  };
}

// Mock de socket padrão
const mockSocket = {
  user: {
    id: "0@s.whatsapp.net",
    name: "Mock User",
    jid: "0@s.whatsapp.net"
  },
  ev: {
    on: () => {},
    off: () => {},
    emit: () => {}
  },
  ws: {
    isOpen: false
  },
  state: "connecting" as const,
  isOnline: () => false,
  sendMessage: async () => ({ key: { id: "mock" } }),
  sendPresenceUpdate: async () => {},
  presenceSubscribe: async () => {},
  groupMetadata: async () => ({
    id: "mock@g.us",
    subject: "Mock Group",
    participants: []
  }),
  groupCreate: async () => ({ gid: "mock@g.us" }),
  groupParticipantsUpdate: async () => {},
  groupUpdateSubject: async () => {},
  groupUpdateDescription: async () => {},
  groupUpdateSettingChange: async () => {},
  groupToggleEphemeral: async () => {},
  groupInviteCode: async () => "mock_invite_code",
  groupRevokeInvite: async () => {},
  groupAcceptInvite: async () => {},
  groupRequestParticipantsList: async () => [],
  groupRequestParticipantsUpdate: async () => {},
  groupFetchAllParticipating: async () => ({}),
  profilePictureUrl: async () => null,
  onWhatsApp: async () => [],
  fetchBlocklist: async () => [],
  updateBlockStatus: async () => {},
  getBusinessProfile: async () => null,
  resyncAppState: async () => {},
  logout: async () => {},
  end: async () => {},
  waitForConnectionUpdate: async () => ({})
};

export function makeWASocket(config: any): WASocket {
  console.log("[MOCK] Criando socket Baileys mock");
  return mockSocket as any;
}

export function makeInMemoryStore(config?: any) {
  return {
    bind: () => {},
    chats: new Map(),
    contacts: new Map(),
    messages: new Map(),
    groupMetadata: new Map(),
    state: new Map(),
    presences: new Map(),
    readReceipts: new Map()
  };
}

export function makeCacheableSignalKeyStore() {
  return {
    get: async () => null,
    set: async () => {},
    del: async () => {},
    getAll: async () => ({})
  };
}

export async function fetchLatestBaileysVersion() {
  return {
    version: [6, 0, 0],
    isLatest: true
  };
}

export function isJidBroadcast(jid: string) {
  return jid.includes("broadcast");
}

// Exports padrão
export default makeWASocket;
