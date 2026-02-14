declare module "ari-client" {
  import { EventEmitter } from "events";

  interface Channel extends EventEmitter {
    id: string;
    name: string;
    state: string;
    caller: {
      name?: string;
      number?: string;
    };
    connected: {
      name?: string;
      number?: string;
    };
    dialplan?: {
      context?: string;
      exten?: string;
      priority?: number;
    };
    answer(): Promise<void>;
    hangup(): Promise<void>;
    continueInDialplan(options: {
      context?: string;
      extension?: string;
      priority?: number;
    }): Promise<void>;
    play(options: { media: string }): Promise<Playback>;
    record(options: RecordOptions): Promise<LiveRecording>;
    originate(options: OriginateOptions): Promise<Channel>;
  }

  interface Playback {
    id: string;
    stop(): Promise<void>;
  }

  interface LiveRecording {
    name: string;
    stop(): Promise<void>;
  }

  interface RecordOptions {
    name: string;
    format?: string;
    maxDurationSeconds?: number;
    maxSilenceSeconds?: number;
    ifExists?: "fail" | "overwrite" | "append";
    beep?: boolean;
    terminateOn?: string;
  }

  interface OriginateOptions {
    endpoint: string;
    extension?: string;
    context?: string;
    priority?: number;
    callerId?: string;
    timeout?: number;
    channelId?: string;
    otherChannelId?: string;
    originator?: string;
    formats?: string;
    variables?: Record<string, string>;
    app?: string;
    appArgs?: string;
  }

  interface Bridge extends EventEmitter {
    id: string;
    addChannel(options: { channel: string | string[] }): Promise<void>;
    removeChannel(options: { channel: string | string[] }): Promise<void>;
    destroy(): Promise<void>;
  }

  interface Endpoint {
    technology: string;
    resource: string;
    state: string;
  }

  interface ChannelMethods {
    originate(options: OriginateOptions): Promise<Channel>;
    list(): Promise<Channel[]>;
    get(options: { channelId: string }): Promise<Channel>;
  }

  interface BridgeMethods {
    create(options: { type?: string; bridgeId?: string }): Promise<Bridge>;
    list(): Promise<Bridge[]>;
    get(options: { bridgeId: string }): Promise<Bridge>;
  }

  interface EndpointMethods {
    list(): Promise<Endpoint[]>;
    get(options: { tech: string; resource: string }): Promise<Endpoint>;
  }

  interface RecordingMethods {
    getStored(options: { recordingName: string }): Promise<StoredRecording>;
    listStored(): Promise<StoredRecording[]>;
  }

  interface StoredRecording {
    name: string;
    format: string;
  }

  interface Client extends EventEmitter {
    channels: ChannelMethods;
    bridges: BridgeMethods;
    endpoints: EndpointMethods;
    recordings: RecordingMethods;
    Channel(channel?: Channel, id?: string): Channel;
    Bridge(bridge?: Bridge, id?: string): Bridge;
    start(application: string | string[]): void;
    stop(): void;
  }

  function connect(
    url: string,
    username: string,
    password: string
  ): Promise<Client>;

  function connect(
    url: string,
    username: string,
    password: string,
    callback: (err: Error | null, client: Client) => void
  ): void;

  export = {
    connect,
    Client,
    Channel,
    Bridge,
    Endpoint,
  };
}
