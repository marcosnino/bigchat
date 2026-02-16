--
-- PostgreSQL database dump
--

\restrict SIXORCNIPKgHUvn1dVBG7Tt3k1NeOg8v5OrcdYfa2b90CGa0UYGg3mZEzMa2VYJ

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: enum_Calls_direction; Type: TYPE; Schema: public; Owner: bigchat
--

CREATE TYPE public."enum_Calls_direction" AS ENUM (
    'inbound',
    'outbound'
);


ALTER TYPE public."enum_Calls_direction" OWNER TO bigchat;

--
-- Name: enum_Calls_status; Type: TYPE; Schema: public; Owner: bigchat
--

CREATE TYPE public."enum_Calls_status" AS ENUM (
    'ringing',
    'answered',
    'busy',
    'no-answer',
    'failed',
    'canceled',
    'completed'
);


ALTER TYPE public."enum_Calls_status" OWNER TO bigchat;

--
-- Name: enum_Extensions_status; Type: TYPE; Schema: public; Owner: bigchat
--

CREATE TYPE public."enum_Extensions_status" AS ENUM (
    'available',
    'busy',
    'ringing',
    'unavailable',
    'dnd'
);


ALTER TYPE public."enum_Extensions_status" OWNER TO bigchat;

--
-- Name: message_status; Type: TYPE; Schema: public; Owner: bigchat
--

CREATE TYPE public.message_status AS ENUM (
    'new',
    'replied',
    'waiting'
);


ALTER TYPE public.message_status OWNER TO bigchat;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Announcements; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Announcements" (
    id integer NOT NULL,
    priority integer,
    title character varying(255) NOT NULL,
    text text NOT NULL,
    "mediaPath" text,
    "mediaName" text,
    "companyId" integer NOT NULL,
    status boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Announcements" OWNER TO bigchat;

--
-- Name: Announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Announcements_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Announcements_id_seq" OWNER TO bigchat;

--
-- Name: Announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Announcements_id_seq" OWNED BY public."Announcements".id;


--
-- Name: Asterisks; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Asterisks" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    "ariPort" integer DEFAULT 8088,
    "sipPort" integer DEFAULT 5060,
    "wsPort" integer DEFAULT 8089,
    "ariUser" character varying(255) NOT NULL,
    "ariPassword" character varying(255) NOT NULL,
    "ariApplication" character varying(255),
    status character varying(255) DEFAULT 'DISCONNECTED'::character varying,
    "isActive" boolean DEFAULT false,
    "useSSL" boolean DEFAULT false,
    "sipDomain" character varying(255),
    "outboundContext" character varying(255),
    "inboundContext" character varying(255) DEFAULT 'from-internal'::character varying,
    notes text,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Asterisks" OWNER TO bigchat;

--
-- Name: Asterisks_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Asterisks_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Asterisks_id_seq" OWNER TO bigchat;

--
-- Name: Asterisks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Asterisks_id_seq" OWNED BY public."Asterisks".id;


--
-- Name: Baileys; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Baileys" (
    id integer NOT NULL,
    "whatsappId" integer NOT NULL,
    contacts text,
    chats text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Baileys" OWNER TO bigchat;

--
-- Name: BaileysChats; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."BaileysChats" (
    id integer NOT NULL,
    "whatsappId" integer,
    jid character varying(255) NOT NULL,
    "conversationTimestamp" character varying(255) NOT NULL,
    "unreadCount" integer DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."BaileysChats" OWNER TO bigchat;

--
-- Name: BaileysChats_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."BaileysChats_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BaileysChats_id_seq" OWNER TO bigchat;

--
-- Name: BaileysChats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."BaileysChats_id_seq" OWNED BY public."BaileysChats".id;


--
-- Name: BaileysMessages; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."BaileysMessages" (
    id integer NOT NULL,
    "whatsappId" integer,
    "baileysChatId" integer,
    "jsonMessage" json NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."BaileysMessages" OWNER TO bigchat;

--
-- Name: BaileysMessages_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."BaileysMessages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BaileysMessages_id_seq" OWNER TO bigchat;

--
-- Name: BaileysMessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."BaileysMessages_id_seq" OWNED BY public."BaileysMessages".id;


--
-- Name: Baileys_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Baileys_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Baileys_id_seq" OWNER TO bigchat;

--
-- Name: Baileys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Baileys_id_seq" OWNED BY public."Baileys".id;


--
-- Name: Calls; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Calls" (
    id integer NOT NULL,
    "uniqueId" character varying(255) NOT NULL,
    caller character varying(255) NOT NULL,
    called character varying(255) NOT NULL,
    "callerName" character varying(255),
    "calledName" character varying(255),
    direction public."enum_Calls_direction" DEFAULT 'inbound'::public."enum_Calls_direction",
    status public."enum_Calls_status" DEFAULT 'ringing'::public."enum_Calls_status",
    "startedAt" timestamp with time zone,
    "answeredAt" timestamp with time zone,
    "endedAt" timestamp with time zone,
    duration integer DEFAULT 0,
    "billableSeconds" integer DEFAULT 0,
    "hangupCause" character varying(255),
    "hangupCode" integer,
    "recordingPath" character varying(255),
    "recordingUrl" character varying(255),
    extension character varying(255),
    queue character varying(255),
    channel character varying(255),
    "linkedChannel" character varying(255),
    metadata jsonb,
    "companyId" integer,
    "userId" integer,
    "contactId" integer,
    "ticketId" integer,
    "asteriskId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Calls" OWNER TO bigchat;

--
-- Name: Calls_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Calls_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Calls_id_seq" OWNER TO bigchat;

--
-- Name: Calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Calls_id_seq" OWNED BY public."Calls".id;


--
-- Name: CampaignSettings; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."CampaignSettings" (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."CampaignSettings" OWNER TO bigchat;

--
-- Name: CampaignSettings_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."CampaignSettings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CampaignSettings_id_seq" OWNER TO bigchat;

--
-- Name: CampaignSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."CampaignSettings_id_seq" OWNED BY public."CampaignSettings".id;


--
-- Name: CampaignShipping; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."CampaignShipping" (
    id integer NOT NULL,
    "jobId" character varying(255),
    number character varying(255) NOT NULL,
    message text NOT NULL,
    "contactId" integer,
    "campaignId" integer NOT NULL,
    "deliveredAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."CampaignShipping" OWNER TO bigchat;

--
-- Name: CampaignShipping_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."CampaignShipping_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CampaignShipping_id_seq" OWNER TO bigchat;

--
-- Name: CampaignShipping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."CampaignShipping_id_seq" OWNED BY public."CampaignShipping".id;


--
-- Name: Campaigns; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Campaigns" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    message1 text DEFAULT ''::text,
    message2 text DEFAULT ''::text,
    message3 text DEFAULT ''::text,
    message4 text DEFAULT ''::text,
    message5 text DEFAULT ''::text,
    status character varying(255),
    "mediaPath" text,
    "mediaName" text,
    "companyId" integer NOT NULL,
    "contactListId" integer,
    "whatsappId" integer,
    "scheduledAt" timestamp with time zone,
    "completedAt" timestamp with time zone,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "fileListId" integer,
    "tagId" integer
);


ALTER TABLE public."Campaigns" OWNER TO bigchat;

--
-- Name: Campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Campaigns_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Campaigns_id_seq" OWNER TO bigchat;

--
-- Name: Campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Campaigns_id_seq" OWNED BY public."Campaigns".id;


--
-- Name: ChatMessages; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."ChatMessages" (
    id integer NOT NULL,
    "chatId" integer NOT NULL,
    "senderId" integer NOT NULL,
    message text DEFAULT ''::text,
    "mediaPath" text,
    "mediaName" text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ChatMessages" OWNER TO bigchat;

--
-- Name: ChatMessages_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."ChatMessages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ChatMessages_id_seq" OWNER TO bigchat;

--
-- Name: ChatMessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."ChatMessages_id_seq" OWNED BY public."ChatMessages".id;


--
-- Name: ChatUsers; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."ChatUsers" (
    id integer NOT NULL,
    "chatId" integer NOT NULL,
    "userId" integer NOT NULL,
    unreads integer DEFAULT 0,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ChatUsers" OWNER TO bigchat;

--
-- Name: ChatUsers_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."ChatUsers_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ChatUsers_id_seq" OWNER TO bigchat;

--
-- Name: ChatUsers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."ChatUsers_id_seq" OWNED BY public."ChatUsers".id;


--
-- Name: Chats; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Chats" (
    id integer NOT NULL,
    title text DEFAULT ''::text,
    uuid character varying(255) DEFAULT ''::character varying,
    "ownerId" integer NOT NULL,
    "lastMessage" text,
    "companyId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Chats" OWNER TO bigchat;

--
-- Name: Chats_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Chats_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Chats_id_seq" OWNER TO bigchat;

--
-- Name: Chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Chats_id_seq" OWNED BY public."Chats".id;


--
-- Name: Companies; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Companies" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    phone character varying(255),
    email character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "planId" integer,
    status boolean DEFAULT true,
    schedules jsonb DEFAULT '[]'::jsonb,
    "dueDate" timestamp with time zone,
    recurrence character varying(255) DEFAULT ''::character varying,
    language character varying(255) DEFAULT 'pt-BR'::character varying
);


ALTER TABLE public."Companies" OWNER TO bigchat;

--
-- Name: Companies_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Companies_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Companies_id_seq" OWNER TO bigchat;

--
-- Name: Companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Companies_id_seq" OWNED BY public."Companies".id;


--
-- Name: ContactCustomFields; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."ContactCustomFields" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    "contactId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ContactCustomFields" OWNER TO bigchat;

--
-- Name: ContactCustomFields_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."ContactCustomFields_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ContactCustomFields_id_seq" OWNER TO bigchat;

--
-- Name: ContactCustomFields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."ContactCustomFields_id_seq" OWNED BY public."ContactCustomFields".id;


--
-- Name: ContactListItems; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."ContactListItems" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    number character varying(255) NOT NULL,
    email character varying(255),
    "contactListId" integer NOT NULL,
    "isWhatsappValid" boolean DEFAULT false,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ContactListItems" OWNER TO bigchat;

--
-- Name: ContactListItems_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."ContactListItems_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ContactListItems_id_seq" OWNER TO bigchat;

--
-- Name: ContactListItems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."ContactListItems_id_seq" OWNED BY public."ContactListItems".id;


--
-- Name: ContactLists; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."ContactLists" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ContactLists" OWNER TO bigchat;

--
-- Name: ContactLists_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."ContactLists_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ContactLists_id_seq" OWNER TO bigchat;

--
-- Name: ContactLists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."ContactLists_id_seq" OWNED BY public."ContactLists".id;


--
-- Name: Contacts; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Contacts" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    number character varying(255) NOT NULL,
    "profilePicUrl" character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    "isGroup" boolean DEFAULT false NOT NULL,
    "companyId" integer,
    "whatsappId" integer
);


ALTER TABLE public."Contacts" OWNER TO bigchat;

--
-- Name: Contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Contacts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Contacts_id_seq" OWNER TO bigchat;

--
-- Name: Contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Contacts_id_seq" OWNED BY public."Contacts".id;


--
-- Name: Extensions; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Extensions" (
    id integer NOT NULL,
    exten character varying(255) NOT NULL,
    name character varying(255),
    password character varying(255),
    "callerIdName" character varying(255),
    "callerIdNumber" character varying(255),
    status public."enum_Extensions_status" DEFAULT 'available'::public."enum_Extensions_status",
    "isActive" boolean DEFAULT true,
    "canRecord" boolean DEFAULT false,
    "webrtcEnabled" boolean DEFAULT true,
    transport character varying(255),
    context character varying(255),
    codecs jsonb,
    notes text,
    "asteriskId" integer,
    "userId" integer,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Extensions" OWNER TO bigchat;

--
-- Name: Extensions_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Extensions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Extensions_id_seq" OWNER TO bigchat;

--
-- Name: Extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Extensions_id_seq" OWNED BY public."Extensions".id;


--
-- Name: Files; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Files" (
    id integer NOT NULL,
    "companyId" integer,
    name character varying(255),
    message text,
    "createdAt" timestamp(6) with time zone NOT NULL,
    "updatedAt" timestamp(6) with time zone NOT NULL
);


ALTER TABLE public."Files" OWNER TO bigchat;

--
-- Name: FilesOptions; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."FilesOptions" (
    id integer NOT NULL,
    name character varying(255),
    path character varying(255),
    "fileId" integer,
    "createdAt" timestamp(6) with time zone NOT NULL,
    "updatedAt" timestamp(6) with time zone NOT NULL,
    "mediaType" character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public."FilesOptions" OWNER TO bigchat;

--
-- Name: FilesOptions_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."FilesOptions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."FilesOptions_id_seq" OWNER TO bigchat;

--
-- Name: FilesOptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."FilesOptions_id_seq" OWNED BY public."FilesOptions".id;


--
-- Name: Files_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Files_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Files_id_seq" OWNER TO bigchat;

--
-- Name: Files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Files_id_seq" OWNED BY public."Files".id;


--
-- Name: Helps; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Helps" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    video character varying(255),
    link text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Helps" OWNER TO bigchat;

--
-- Name: Helps_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Helps_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Helps_id_seq" OWNER TO bigchat;

--
-- Name: Helps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Helps_id_seq" OWNED BY public."Helps".id;


--
-- Name: Invoices; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Invoices" (
    id integer NOT NULL,
    detail character varying(255),
    status character varying(255),
    value double precision,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "dueDate" character varying(255),
    "companyId" integer
);


ALTER TABLE public."Invoices" OWNER TO bigchat;

--
-- Name: Invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Invoices_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Invoices_id_seq" OWNER TO bigchat;

--
-- Name: Invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Invoices_id_seq" OWNED BY public."Invoices".id;


--
-- Name: Messages; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Messages" (
    id character varying(255) NOT NULL,
    body text NOT NULL,
    ack integer DEFAULT 0 NOT NULL,
    read boolean DEFAULT false NOT NULL,
    "mediaType" character varying(255),
    "mediaUrl" character varying(255),
    "ticketId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "fromMe" boolean DEFAULT false NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "contactId" integer,
    "quotedMsgId" character varying(255),
    "companyId" integer,
    "remoteJid" text,
    "dataJson" text,
    participant text,
    "queueId" integer,
    "isEdited" boolean DEFAULT false,
    "messageStatus" public.message_status DEFAULT 'new'::public.message_status NOT NULL,
    "responseTime" timestamp with time zone
);


ALTER TABLE public."Messages" OWNER TO bigchat;

--
-- Name: Plans; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Plans" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    users integer DEFAULT 0,
    connections integer DEFAULT 0,
    queues integer DEFAULT 0,
    value double precision DEFAULT '0'::double precision,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "useCampaigns" boolean DEFAULT true,
    "useExternalApi" boolean DEFAULT true,
    "useInternalChat" boolean DEFAULT true,
    "useSchedules" boolean DEFAULT true,
    "useKanban" boolean DEFAULT true,
    "useOpenAi" boolean DEFAULT true,
    "useIntegrations" boolean DEFAULT true
);


ALTER TABLE public."Plans" OWNER TO bigchat;

--
-- Name: Plans_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Plans_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plans_id_seq" OWNER TO bigchat;

--
-- Name: Plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Plans_id_seq" OWNED BY public."Plans".id;


--
-- Name: Prompts; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Prompts" (
    id integer NOT NULL,
    name text,
    "apiKey" text,
    prompt text,
    "maxTokens" integer DEFAULT 100,
    "maxMessages" integer DEFAULT 10,
    temperature double precision DEFAULT 1,
    "promptTokens" integer DEFAULT 0,
    "completionTokens" integer DEFAULT 0,
    "totalTokens" integer DEFAULT 0,
    "companyId" integer,
    "createdAt" timestamp(6) with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp(6) with time zone DEFAULT now() NOT NULL,
    model character varying(255),
    "queueId" integer
);


ALTER TABLE public."Prompts" OWNER TO bigchat;

--
-- Name: Prompts_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Prompts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Prompts_id_seq" OWNER TO bigchat;

--
-- Name: Prompts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Prompts_id_seq" OWNED BY public."Prompts".id;


--
-- Name: QueueIntegrations; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."QueueIntegrations" (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "projectName" character varying(255) NOT NULL,
    "jsonContent" text NOT NULL,
    language character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "urlN8N" character varying(255) DEFAULT true NOT NULL,
    "companyId" integer,
    "typebotSlug" character varying(255) DEFAULT ''::character varying,
    "typebotExpires" integer DEFAULT 0,
    "typebotKeywordFinish" character varying(255) DEFAULT ''::character varying,
    "typebotUnknownMessage" character varying(255) DEFAULT ''::character varying,
    "typebotDelayMessage" integer DEFAULT 1000,
    "typebotKeywordRestart" character varying(255) DEFAULT ''::character varying,
    "typebotRestartMessage" character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public."QueueIntegrations" OWNER TO bigchat;

--
-- Name: QueueIntegrations_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."QueueIntegrations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."QueueIntegrations_id_seq" OWNER TO bigchat;

--
-- Name: QueueIntegrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."QueueIntegrations_id_seq" OWNED BY public."QueueIntegrations".id;


--
-- Name: QueueOptions; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."QueueOptions" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text,
    option text,
    "queueId" integer,
    "parentId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."QueueOptions" OWNER TO bigchat;

--
-- Name: QueueOptions_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."QueueOptions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."QueueOptions_id_seq" OWNER TO bigchat;

--
-- Name: QueueOptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."QueueOptions_id_seq" OWNED BY public."QueueOptions".id;


--
-- Name: Queues; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Queues" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    color character varying(255) NOT NULL,
    "greetingMessage" text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "companyId" integer,
    schedules jsonb DEFAULT '[]'::jsonb,
    "outOfHoursMessage" text,
    "orderQueue" integer,
    "integrationId" integer,
    "promptId" integer
);


ALTER TABLE public."Queues" OWNER TO bigchat;

--
-- Name: Queues_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Queues_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Queues_id_seq" OWNER TO bigchat;

--
-- Name: Queues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Queues_id_seq" OWNED BY public."Queues".id;


--
-- Name: QuickMessages; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."QuickMessages" (
    id integer NOT NULL,
    shortcode character varying(255) NOT NULL,
    message text,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" integer,
    "mediaPath" character varying(255) DEFAULT NULL::character varying,
    "mediaName" character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public."QuickMessages" OWNER TO bigchat;

--
-- Name: QuickMessages_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."QuickMessages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."QuickMessages_id_seq" OWNER TO bigchat;

--
-- Name: QuickMessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."QuickMessages_id_seq" OWNED BY public."QuickMessages".id;


--
-- Name: Schedules; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Schedules" (
    id integer NOT NULL,
    body text NOT NULL,
    "sendAt" timestamp with time zone,
    "sentAt" timestamp with time zone,
    "contactId" integer,
    "ticketId" integer,
    "userId" integer,
    "companyId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    status character varying(255),
    "mediaName" character varying(255) DEFAULT NULL::character varying,
    "mediaPath" character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public."Schedules" OWNER TO bigchat;

--
-- Name: Schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Schedules_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Schedules_id_seq" OWNER TO bigchat;

--
-- Name: Schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Schedules_id_seq" OWNED BY public."Schedules".id;


--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO bigchat;

--
-- Name: Settings; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Settings" (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "companyId" integer,
    id integer NOT NULL
);


ALTER TABLE public."Settings" OWNER TO bigchat;

--
-- Name: Settings_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Settings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Settings_id_seq" OWNER TO bigchat;

--
-- Name: Settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Settings_id_seq" OWNED BY public."Settings".id;


--
-- Name: Subscriptions; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Subscriptions" (
    id integer NOT NULL,
    "isActive" boolean DEFAULT false,
    "expiresAt" timestamp with time zone NOT NULL,
    "userPriceCents" integer,
    "whatsPriceCents" integer,
    "lastInvoiceUrl" character varying(255),
    "lastPlanChange" timestamp with time zone,
    "companyId" integer,
    "providerSubscriptionId" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Subscriptions" OWNER TO bigchat;

--
-- Name: Subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Subscriptions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Subscriptions_id_seq" OWNER TO bigchat;

--
-- Name: Subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Subscriptions_id_seq" OWNED BY public."Subscriptions".id;


--
-- Name: Tags; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Tags" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    color character varying(255),
    "companyId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    kanban integer
);


ALTER TABLE public."Tags" OWNER TO bigchat;

--
-- Name: Tags_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Tags_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tags_id_seq" OWNER TO bigchat;

--
-- Name: Tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Tags_id_seq" OWNED BY public."Tags".id;


--
-- Name: TicketNotes; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."TicketNotes" (
    id integer NOT NULL,
    note character varying(255) NOT NULL,
    "userId" integer,
    "contactId" integer NOT NULL,
    "ticketId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."TicketNotes" OWNER TO bigchat;

--
-- Name: TicketNotes_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."TicketNotes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TicketNotes_id_seq" OWNER TO bigchat;

--
-- Name: TicketNotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."TicketNotes_id_seq" OWNED BY public."TicketNotes".id;


--
-- Name: TicketTags; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."TicketTags" (
    "ticketId" integer NOT NULL,
    "tagId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."TicketTags" OWNER TO bigchat;

--
-- Name: TicketTraking; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."TicketTraking" (
    id integer NOT NULL,
    "ticketId" integer,
    "companyId" integer,
    "whatsappId" integer,
    "userId" integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "queuedAt" timestamp with time zone,
    "startedAt" timestamp with time zone,
    "finishedAt" timestamp with time zone,
    "ratingAt" timestamp with time zone,
    rated boolean DEFAULT false,
    "chatbotAt" timestamp with time zone
);


ALTER TABLE public."TicketTraking" OWNER TO bigchat;

--
-- Name: TicketTraking_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."TicketTraking_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TicketTraking_id_seq" OWNER TO bigchat;

--
-- Name: TicketTraking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."TicketTraking_id_seq" OWNED BY public."TicketTraking".id;


--
-- Name: Tickets; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Tickets" (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    "lastMessage" text,
    "contactId" integer,
    "userId" integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "whatsappId" integer,
    "isGroup" boolean DEFAULT false NOT NULL,
    "unreadMessages" integer,
    "queueId" integer,
    "companyId" integer,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    chatbot boolean DEFAULT false,
    "queueOptionId" integer,
    "amountUsedBotQueues" integer,
    "fromMe" boolean DEFAULT false,
    "useIntegration" boolean DEFAULT false,
    "integrationId" integer,
    "typebotSessionId" character varying(255) DEFAULT NULL::character varying,
    "typebotStatus" boolean DEFAULT false,
    "promptId" character varying(255) DEFAULT NULL::character varying,
    "lastClientMessageAt" timestamp with time zone,
    "lastAgentMessageAt" timestamp with time zone,
    "pendingClientMessages" integer DEFAULT 0
);


ALTER TABLE public."Tickets" OWNER TO bigchat;

--
-- Name: Tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Tickets_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tickets_id_seq" OWNER TO bigchat;

--
-- Name: Tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Tickets_id_seq" OWNED BY public."Tickets".id;


--
-- Name: UserQueues; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."UserQueues" (
    "userId" integer NOT NULL,
    "queueId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."UserQueues" OWNER TO bigchat;

--
-- Name: UserRatings; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."UserRatings" (
    id integer NOT NULL,
    "ticketId" integer,
    "companyId" integer,
    "userId" integer,
    rate integer DEFAULT 0,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public."UserRatings" OWNER TO bigchat;

--
-- Name: UserRatings_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."UserRatings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."UserRatings_id_seq" OWNER TO bigchat;

--
-- Name: UserRatings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."UserRatings_id_seq" OWNED BY public."UserRatings".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    "passwordHash" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    profile character varying(255) DEFAULT 'admin'::character varying NOT NULL,
    "tokenVersion" integer DEFAULT 0 NOT NULL,
    "companyId" integer,
    super boolean DEFAULT false,
    online boolean DEFAULT false,
    "allTicket" character varying(255) DEFAULT 'desabled'::character varying NOT NULL,
    "whatsappId" integer,
    "resetPassword" character varying(255)
);


ALTER TABLE public."Users" OWNER TO bigchat;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Users_id_seq" OWNER TO bigchat;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: WhatsappQueues; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."WhatsappQueues" (
    "whatsappId" integer NOT NULL,
    "queueId" integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."WhatsappQueues" OWNER TO bigchat;

--
-- Name: Whatsapps; Type: TABLE; Schema: public; Owner: bigchat
--

CREATE TABLE public."Whatsapps" (
    id integer NOT NULL,
    session text,
    qrcode text,
    status character varying(255),
    battery character varying(255),
    plugged boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    retries integer DEFAULT 0 NOT NULL,
    "greetingMessage" text,
    "companyId" integer,
    "complationMessage" text,
    "outOfHoursMessage" text,
    "ratingMessage" text,
    token text,
    "farewellMessage" text,
    provider text DEFAULT 'stable'::text,
    "sendIdQueue" integer,
    "promptId" integer,
    "integrationId" integer,
    "maxUseBotQueues" integer DEFAULT 3,
    "expiresTicket" integer DEFAULT 0,
    "expiresInactiveMessage" character varying(255) DEFAULT ''::character varying,
    "timeUseBotQueues" integer DEFAULT 0,
    "transferQueueId" integer,
    "timeToTransfer" integer,
    "phoneNumberId" character varying(255),
    "businessAccountId" character varying(255),
    "accessToken" text,
    "webhookVerifyToken" character varying(255),
    "metaApiVersion" character varying(255) DEFAULT 'v18.0'::character varying,
    number character varying(255)
);


ALTER TABLE public."Whatsapps" OWNER TO bigchat;

--
-- Name: Whatsapps_id_seq; Type: SEQUENCE; Schema: public; Owner: bigchat
--

CREATE SEQUENCE public."Whatsapps_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Whatsapps_id_seq" OWNER TO bigchat;

--
-- Name: Whatsapps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bigchat
--

ALTER SEQUENCE public."Whatsapps_id_seq" OWNED BY public."Whatsapps".id;


--
-- Name: Announcements id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Announcements" ALTER COLUMN id SET DEFAULT nextval('public."Announcements_id_seq"'::regclass);


--
-- Name: Asterisks id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Asterisks" ALTER COLUMN id SET DEFAULT nextval('public."Asterisks_id_seq"'::regclass);


--
-- Name: Baileys id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Baileys" ALTER COLUMN id SET DEFAULT nextval('public."Baileys_id_seq"'::regclass);


--
-- Name: BaileysChats id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysChats" ALTER COLUMN id SET DEFAULT nextval('public."BaileysChats_id_seq"'::regclass);


--
-- Name: BaileysMessages id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysMessages" ALTER COLUMN id SET DEFAULT nextval('public."BaileysMessages_id_seq"'::regclass);


--
-- Name: Calls id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls" ALTER COLUMN id SET DEFAULT nextval('public."Calls_id_seq"'::regclass);


--
-- Name: CampaignSettings id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignSettings" ALTER COLUMN id SET DEFAULT nextval('public."CampaignSettings_id_seq"'::regclass);


--
-- Name: CampaignShipping id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignShipping" ALTER COLUMN id SET DEFAULT nextval('public."CampaignShipping_id_seq"'::regclass);


--
-- Name: Campaigns id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns" ALTER COLUMN id SET DEFAULT nextval('public."Campaigns_id_seq"'::regclass);


--
-- Name: ChatMessages id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatMessages" ALTER COLUMN id SET DEFAULT nextval('public."ChatMessages_id_seq"'::regclass);


--
-- Name: ChatUsers id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatUsers" ALTER COLUMN id SET DEFAULT nextval('public."ChatUsers_id_seq"'::regclass);


--
-- Name: Chats id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Chats" ALTER COLUMN id SET DEFAULT nextval('public."Chats_id_seq"'::regclass);


--
-- Name: Companies id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Companies" ALTER COLUMN id SET DEFAULT nextval('public."Companies_id_seq"'::regclass);


--
-- Name: ContactCustomFields id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactCustomFields" ALTER COLUMN id SET DEFAULT nextval('public."ContactCustomFields_id_seq"'::regclass);


--
-- Name: ContactListItems id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactListItems" ALTER COLUMN id SET DEFAULT nextval('public."ContactListItems_id_seq"'::regclass);


--
-- Name: ContactLists id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactLists" ALTER COLUMN id SET DEFAULT nextval('public."ContactLists_id_seq"'::regclass);


--
-- Name: Contacts id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Contacts" ALTER COLUMN id SET DEFAULT nextval('public."Contacts_id_seq"'::regclass);


--
-- Name: Extensions id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Extensions" ALTER COLUMN id SET DEFAULT nextval('public."Extensions_id_seq"'::regclass);


--
-- Name: Files id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Files" ALTER COLUMN id SET DEFAULT nextval('public."Files_id_seq"'::regclass);


--
-- Name: FilesOptions id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."FilesOptions" ALTER COLUMN id SET DEFAULT nextval('public."FilesOptions_id_seq"'::regclass);


--
-- Name: Helps id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Helps" ALTER COLUMN id SET DEFAULT nextval('public."Helps_id_seq"'::regclass);


--
-- Name: Invoices id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Invoices" ALTER COLUMN id SET DEFAULT nextval('public."Invoices_id_seq"'::regclass);


--
-- Name: Plans id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Plans" ALTER COLUMN id SET DEFAULT nextval('public."Plans_id_seq"'::regclass);


--
-- Name: Prompts id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Prompts" ALTER COLUMN id SET DEFAULT nextval('public."Prompts_id_seq"'::regclass);


--
-- Name: QueueIntegrations id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueIntegrations" ALTER COLUMN id SET DEFAULT nextval('public."QueueIntegrations_id_seq"'::regclass);


--
-- Name: QueueOptions id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueOptions" ALTER COLUMN id SET DEFAULT nextval('public."QueueOptions_id_seq"'::regclass);


--
-- Name: Queues id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues" ALTER COLUMN id SET DEFAULT nextval('public."Queues_id_seq"'::regclass);


--
-- Name: QuickMessages id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QuickMessages" ALTER COLUMN id SET DEFAULT nextval('public."QuickMessages_id_seq"'::regclass);


--
-- Name: Schedules id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Schedules" ALTER COLUMN id SET DEFAULT nextval('public."Schedules_id_seq"'::regclass);


--
-- Name: Settings id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Settings" ALTER COLUMN id SET DEFAULT nextval('public."Settings_id_seq"'::regclass);


--
-- Name: Subscriptions id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Subscriptions" ALTER COLUMN id SET DEFAULT nextval('public."Subscriptions_id_seq"'::regclass);


--
-- Name: Tags id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tags" ALTER COLUMN id SET DEFAULT nextval('public."Tags_id_seq"'::regclass);


--
-- Name: TicketNotes id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketNotes" ALTER COLUMN id SET DEFAULT nextval('public."TicketNotes_id_seq"'::regclass);


--
-- Name: TicketTraking id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTraking" ALTER COLUMN id SET DEFAULT nextval('public."TicketTraking_id_seq"'::regclass);


--
-- Name: Tickets id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets" ALTER COLUMN id SET DEFAULT nextval('public."Tickets_id_seq"'::regclass);


--
-- Name: UserRatings id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."UserRatings" ALTER COLUMN id SET DEFAULT nextval('public."UserRatings_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Name: Whatsapps id; Type: DEFAULT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Whatsapps" ALTER COLUMN id SET DEFAULT nextval('public."Whatsapps_id_seq"'::regclass);


--
-- Data for Name: Announcements; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Announcements" (id, priority, title, text, "mediaPath", "mediaName", "companyId", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Asterisks; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Asterisks" (id, name, host, "ariPort", "sipPort", "wsPort", "ariUser", "ariPassword", "ariApplication", status, "isActive", "useSSL", "sipDomain", "outboundContext", "inboundContext", notes, "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Baileys; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Baileys" (id, "whatsappId", contacts, chats, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: BaileysChats; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."BaileysChats" (id, "whatsappId", jid, "conversationTimestamp", "unreadCount", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: BaileysMessages; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."BaileysMessages" (id, "whatsappId", "baileysChatId", "jsonMessage", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Calls; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Calls" (id, "uniqueId", caller, called, "callerName", "calledName", direction, status, "startedAt", "answeredAt", "endedAt", duration, "billableSeconds", "hangupCause", "hangupCode", "recordingPath", "recordingUrl", extension, queue, channel, "linkedChannel", metadata, "companyId", "userId", "contactId", "ticketId", "asteriskId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: CampaignSettings; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."CampaignSettings" (id, key, value, "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: CampaignShipping; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."CampaignShipping" (id, "jobId", number, message, "contactId", "campaignId", "deliveredAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Campaigns; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Campaigns" (id, name, message1, message2, message3, message4, message5, status, "mediaPath", "mediaName", "companyId", "contactListId", "whatsappId", "scheduledAt", "completedAt", "createdAt", "updatedAt", "fileListId", "tagId") FROM stdin;
\.


--
-- Data for Name: ChatMessages; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."ChatMessages" (id, "chatId", "senderId", message, "mediaPath", "mediaName", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ChatUsers; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."ChatUsers" (id, "chatId", "userId", unreads, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Chats; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Chats" (id, title, uuid, "ownerId", "lastMessage", "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Companies; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Companies" (id, name, phone, email, "createdAt", "updatedAt", "planId", status, schedules, "dueDate", recurrence, language) FROM stdin;
1	Empresa 1	\N	\N	2026-02-10 19:17:06.85+00	2026-02-10 19:41:27.274+00	1	t	[]	2093-03-14 03:00:00+00		pt
\.


--
-- Data for Name: ContactCustomFields; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."ContactCustomFields" (id, name, value, "contactId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ContactListItems; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."ContactListItems" (id, name, number, email, "contactListId", "isWhatsappValid", "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ContactLists; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."ContactLists" (id, name, "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Contacts; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Contacts" (id, name, number, "profilePicUrl", "createdAt", "updatedAt", email, "isGroup", "companyId", "whatsappId") FROM stdin;
1	Único Contato Suporte	553199932700		2026-02-12 00:33:14.86+00	2026-02-12 00:33:14.86+00		f	1	\N
2	Marcos Barbosa Nino	556592601001		2026-02-12 00:41:03.583+00	2026-02-12 00:41:03.583+00		f	1	\N
5	Pauline	556599100170		2026-02-12 00:57:32.77+00	2026-02-12 00:57:32.77+00		f	1	\N
7	✨NMC✨	556592300507		2026-02-12 00:57:52.604+00	2026-02-12 00:57:52.604+00		f	1	\N
8	Raquel Big master	556592270891		2026-02-12 00:58:04.534+00	2026-02-12 00:58:04.534+00		f	1	\N
9	Mah Lara	556581064225		2026-02-12 00:58:16.122+00	2026-02-12 00:58:16.122+00		f	1	\N
10	Vivi 💋	556592909122		2026-02-12 00:58:32.59+00	2026-02-12 00:58:32.59+00		f	1	\N
12	Joao Janssen	556593367901		2026-02-12 00:58:48.618+00	2026-02-12 00:58:48.618+00		f	1	\N
13	..	556581410359		2026-02-12 00:59:03.947+00	2026-02-12 00:59:03.947+00		f	1	\N
14	Jerson	556598177317		2026-02-12 00:59:18.712+00	2026-02-12 00:59:18.712+00		f	1	\N
15	CRM Big Master	120363405293949287		2026-02-12 00:59:33.395+00	2026-02-12 00:59:33.395+00		t	1	\N
16	Rodrigo M	558592567076		2026-02-12 00:59:33.407+00	2026-02-12 00:59:33.407+00		f	1	\N
17	𝕷𝖚𝖈𝖎𝖆𝖓𝖔 𝕭𝖆𝖎𝖈𝖊𝖗𝖊	556596449106		2026-02-12 00:59:42.205+00	2026-02-12 00:59:42.205+00		f	1	\N
18	Patríciah Kauffmann	556599229682		2026-02-12 00:59:54.736+00	2026-02-12 00:59:54.736+00		f	1	\N
19	Lucas Frangiott	556592296544		2026-02-12 01:00:10.297+00	2026-02-12 01:00:10.297+00		f	1	\N
20	Eduardo	556593239905		2026-02-12 01:01:08.035+00	2026-02-12 01:01:08.035+00		f	1	\N
21	𝙶𝚒𝚕 𝙵𝚒𝚐𝚞𝚎𝚒𝚛𝚎𝚍𝚘 [TECNOG3]	556596036632		2026-02-12 01:01:29.367+00	2026-02-12 01:01:29.367+00		f	1	\N
22	Nicole Assis	553172039362		2026-02-12 01:01:58.766+00	2026-02-12 01:01:58.766+00		f	1	\N
23	556581561628	556581561628		2026-02-12 01:02:15.008+00	2026-02-12 01:02:15.008+00		f	1	\N
24	Rise - Rede Big Master	556596725633-1629494914		2026-02-12 01:02:43.38+00	2026-02-12 01:02:43.38+00		t	1	\N
25	Gilberto Lana	556592492475		2026-02-12 01:02:44.538+00	2026-02-12 01:02:44.538+00		f	1	\N
26	Eliseu	556584690032		2026-02-12 01:02:45.263+00	2026-02-12 01:02:45.263+00		f	1	\N
27	Daiane Maiara	556592396683		2026-02-12 01:02:45.688+00	2026-02-12 01:02:45.688+00		f	1	\N
29	Sirley	556592352346		2026-02-12 01:03:19.885+00	2026-02-12 01:03:19.885+00		f	1	\N
30	Financeiro BIG MASTER	556581342379		2026-02-12 01:03:41.83+00	2026-02-12 01:03:41.83+00		f	1	\N
31	Vitória Soares	5512920018821		2026-02-12 01:04:20.041+00	2026-02-12 01:04:20.041+00		f	1	\N
32	Karlla Dhaísy	556596832240		2026-02-12 01:05:19.031+00	2026-02-12 01:05:19.031+00		f	1	\N
33	Zetti Geral Vetor Suporte	556231420062		2026-02-12 01:05:58.799+00	2026-02-12 01:05:58.799+00		f	1	\N
34	Minha Fórmula Farmácia de Manipulação	556530518544		2026-02-12 01:06:21.625+00	2026-02-12 01:06:21.625+00		f	1	\N
35	Drogaria Big Master Sangri-la	556592753880		2026-02-12 01:06:58.305+00	2026-02-12 01:06:58.305+00		f	1	\N
36	lau samico ꩜	5513997871101		2026-02-12 01:06:59.778+00	2026-02-12 01:06:59.778+00		f	1	\N
37	Jaqueline	556599058981		2026-02-12 01:07:40.288+00	2026-02-12 01:07:40.288+00		f	1	\N
38	Daise	556592563617		2026-02-12 01:07:53.313+00	2026-02-12 01:07:53.313+00		f	1	\N
39	Cristiano Nunes	556281469862		2026-02-12 01:08:41.107+00	2026-02-12 01:08:41.107+00		f	1	\N
40	Gabriel Samico	5512997400452		2026-02-12 01:09:32.809+00	2026-02-12 01:09:32.809+00		f	1	\N
41	Lucas De Nilo	556593236693		2026-02-12 01:10:08.386+00	2026-02-12 01:10:08.386+00		f	1	\N
42	Big Master Fer Correa	556593614715		2026-02-12 01:11:45.545+00	2026-02-12 01:11:45.545+00		f	1	\N
43	FUT CONTRA	120363425670397095		2026-02-12 01:11:46.805+00	2026-02-12 01:11:46.805+00		t	1	\N
44	.	556593235288		2026-02-12 01:11:46.868+00	2026-02-12 01:11:46.868+00		f	1	\N
45	Marcelo	556584771520		2026-02-12 01:11:47.318+00	2026-02-12 01:11:47.318+00		f	1	\N
46	Ronaldo	556596035633		2026-02-12 01:11:51.886+00	2026-02-12 01:11:51.886+00		f	1	\N
47	...	556581172160		2026-02-12 01:12:01.205+00	2026-02-12 01:12:01.205+00		f	1	\N
48	Amorim	556599663823		2026-02-12 01:12:17.793+00	2026-02-12 01:12:17.793+00		f	1	\N
49	…	556584636285		2026-02-12 01:15:27.267+00	2026-02-12 01:15:27.267+00		f	1	\N
50	551231853400	551231853400		2026-02-12 01:15:29.581+00	2026-02-12 01:15:29.581+00		f	1	\N
51	556584681443	556584681443		2026-02-12 01:16:25.947+00	2026-02-12 01:16:25.947+00		f	1	\N
52	555196266562	555196266562		2026-02-12 01:17:06.877+00	2026-02-12 01:17:06.877+00		f	1	\N
53	556533115998	556533115998		2026-02-12 01:17:54.63+00	2026-02-12 01:17:54.63+00		f	1	\N
54	Rh Drogarias Big Master	556592548949		2026-02-12 01:18:31.751+00	2026-02-12 01:18:31.751+00		f	1	\N
56	Leandro	556596217127		2026-02-12 12:02:28.568+00	2026-02-12 12:02:28.568+00		f	1	\N
28	Big Master Costa Verde	556592657409		2026-02-12 01:03:16.305+00	2026-02-12 12:40:01.557+00		f	1	\N
4	Luan Henrique	556596638389	https://pps.whatsapp.net/v/t61.24694-24/595890155_923263936883998_662612158470068355_n.jpg?ccb=11-4&oh=01_Q5Aa3wGTc3Q611Bt-ztbHaj3wMnd9nCHSi1zwRsStB9KhjS9eQ&oe=699B912A&_nc_sid=5e03e0&_nc_cat=109	2026-02-12 00:57:07.477+00	2026-02-12 23:28:52.322+00		f	1	\N
6	Rise Solutions Network	556533653149	https://pps.whatsapp.net/v/t61.24694-24/458345576_907057481556065_1384998491501755481_n.jpg?ccb=11-4&oh=01_Q5Aa3wHmRO9G23ycMf_RMll8Qy3d0nufzRXpmtu7dYU-sjhPGA&oe=699B75B4&_nc_sid=5e03e0&_nc_cat=109	2026-02-12 00:57:40.161+00	2026-02-12 23:30:21.593+00		f	1	\N
57	Lucas - Coordenador de TI	556593101852	https://pps.whatsapp.net/v/t61.24694-24/491876130_1620566838608153_1472461622084274932_n.jpg?ccb=11-4&oh=01_Q5Aa3wH1bIIdMkXsaLaJQ5mU0RNIVLU2uRuQtDksUIqdvIvOdw&oe=699B867C&_nc_sid=5e03e0&_nc_cat=102	2026-02-12 23:45:49.577+00	2026-02-12 23:45:49.577+00		f	1	\N
58	Valquíria Souza Psicologa	556596444310	https://pps.whatsapp.net/v/t61.24694-24/554821924_1408966134201274_2597572317092642276_n.jpg?ccb=11-4&oh=01_Q5Aa3wH6EuTKOS7RnXzFiPcQQObk372dG2v2m1UqYy-DJHW4-g&oe=699B63E1&_nc_sid=5e03e0&_nc_cat=103	2026-02-12 23:46:22.067+00	2026-02-12 23:46:22.067+00		f	1	\N
59	556581072809	556581072809	https://pps.whatsapp.net/v/t61.24694-24/519907675_750608331197546_3583728847367626362_n.jpg?ccb=11-4&oh=01_Q5Aa3wHceFW9_xuMLUcE8aG_amRSlDwDiolGGJuTn4e8eROVKQ&oe=699B7A7C&_nc_sid=5e03e0&_nc_cat=109	2026-02-12 23:46:34.196+00	2026-02-12 23:46:34.196+00		f	1	\N
60	Rodrigo Silva	556596846336	https://pps.whatsapp.net/v/t61.24694-24/605210910_1223119755904553_6021418998289430316_n.jpg?ccb=11-4&oh=01_Q5Aa3wGy3lQkitgxqEyVpkMkHZvokRM-ptFUY9FXE795Zz4qEA&oe=699B7492&_nc_sid=5e03e0&_nc_cat=101	2026-02-12 23:46:42.97+00	2026-02-12 23:46:42.97+00		f	1	\N
61	Tiago Dias	556799960777	https://pps.whatsapp.net/v/t61.24694-24/369524117_857018626056677_5223398256208136389_n.jpg?ccb=11-4&oh=01_Q5Aa3wE0dwFFqabJO33xtPsyjsGkBvVa5w7GsU9jFep2xHYgeA&oe=699B8360&_nc_sid=5e03e0&_nc_cat=101	2026-02-12 23:46:49.667+00	2026-02-12 23:46:49.667+00		f	1	\N
62	Renan Rise	556593507730	https://pps.whatsapp.net/v/t61.24694-24/386341639_3526366204248316_7567496076199969550_n.jpg?ccb=11-4&oh=01_Q5Aa3wERVRGYctysTlmwyUgfIXdqrwcKMvCE8MA8VokGnVrOPw&oe=699B64FF&_nc_sid=5e03e0&_nc_cat=105	2026-02-12 23:47:08.573+00	2026-02-12 23:47:08.573+00		f	1	\N
63	Monitoramento STELMAT	556592806037	https://pps.whatsapp.net/v/t61.24694-24/491868338_1064669982461487_3942489417910879590_n.jpg?ccb=11-4&oh=01_Q5Aa3wElQlSiL7Fm0eW_Hdn3fh7niFzbtjo4sMCFzIU6bjpUEQ&oe=699B7BA6&_nc_sid=5e03e0&_nc_cat=104	2026-02-12 23:47:15.621+00	2026-02-12 23:47:15.621+00		f	1	\N
64	Alberto Iris	556592673592	https://pps.whatsapp.net/v/t61.24694-24/538595875_1079101317767948_912210436732740715_n.jpg?ccb=11-4&oh=01_Q5Aa3wGabavVwCDbcl8rQvwm8z_QvH9kl_JRLSvRgquOkWv4dg&oe=699B7D6D&_nc_sid=5e03e0&_nc_cat=110	2026-02-12 23:47:23.798+00	2026-02-12 23:47:23.798+00		f	1	\N
65	Anderson Dias	556599569000	https://pps.whatsapp.net/v/t61.24694-24/611298294_1283623110241145_2410834818099979930_n.jpg?ccb=11-4&oh=01_Q5Aa3wH4Wdt0myUztFB_RY8aImIoAeUg3jVybLjR3g9peUboDA&oe=699B5F78&_nc_sid=5e03e0&_nc_cat=102	2026-02-12 23:47:30.733+00	2026-02-12 23:47:30.733+00		f	1	\N
66	Wagner Amaral	556596261321	https://pps.whatsapp.net/v/t61.24694-24/471748353_462242403411597_3071360228281292459_n.jpg?ccb=11-4&oh=01_Q5Aa3wFLN0MR0iapuWRuIpEc5BlhQBaV4_4HBpoeYmwHTIn1Lw&oe=699B6255&_nc_sid=5e03e0&_nc_cat=107	2026-02-12 23:47:46.756+00	2026-02-12 23:47:46.756+00		f	1	\N
67	556581065521	556581065521		2026-02-12 23:47:56.665+00	2026-02-12 23:47:56.665+00		f	1	\N
68	Kleiton Belvedere	556599159486	https://pps.whatsapp.net/v/t61.24694-24/505567121_2023630288169897_6621277400848207139_n.jpg?ccb=11-4&oh=01_Q5Aa3wH5zkl7ztTiU4Cfe9kLR1YqV85EIpExVtQanTEJ_TWosQ&oe=699B9521&_nc_sid=5e03e0&_nc_cat=103	2026-02-12 23:47:59.278+00	2026-02-12 23:47:59.278+00		f	1	\N
69	555133584770	555133584770	https://pps.whatsapp.net/v/t61.24694-24/57567722_2302638336671822_6298286170526711808_n.jpg?ccb=11-4&oh=01_Q5Aa3wHbVPBMN-I12AFrSa_b8VJd4e7qyjeVgbCzQu1g_g4GNA&oe=699B7290&_nc_sid=5e03e0&_nc_cat=101	2026-02-12 23:48:07.404+00	2026-02-12 23:48:07.404+00		f	1	\N
70	5511996529091	5511996529091	https://pps.whatsapp.net/v/t61.24694-24/486106928_1037010678287861_4353401180463104426_n.jpg?ccb=11-4&oh=01_Q5Aa3wHC0LsliKjV8dnmfI1Hnp855DtOh8zid4KcFAZ6uihU2w&oe=699B73D2&_nc_sid=5e03e0&_nc_cat=101	2026-02-12 23:48:39.256+00	2026-02-12 23:48:39.256+00		f	1	\N
71	Thiago vendas yakao	556536483035	https://pps.whatsapp.net/v/t61.24694-24/546156680_1479877780133434_2709113292997355383_n.jpg?ccb=11-4&oh=01_Q5Aa3wEAR5PNM9SZsqoY2KbzWZFKsmic7ih4Bbnr7X2FlOr1Dw&oe=699B802C&_nc_sid=5e03e0&_nc_cat=104	2026-02-12 23:48:46.343+00	2026-02-12 23:48:46.343+00		f	1	\N
72	Welington | Santa elisa	556592698746		2026-02-12 23:48:52.741+00	2026-02-12 23:48:52.741+00		f	1	\N
73	556596638389:18	55659663838918		2026-02-12 23:53:58.243+00	2026-02-12 23:53:58.243+00		f	1	\N
74	Lucas Lopes - Controladoria	164703422648560	https://pps.whatsapp.net/v/t61.24694-24/506910334_1670231486996021_2072558671200420489_n.jpg?ccb=11-4&oh=01_Q5Aa3wEARwlYHVMHgUsW1MhptOpAKrunFTOBTYis6P6-Y1q00w&oe=699DE531&_nc_sid=5e03e0&_nc_cat=103	2026-02-14 21:16:50.499+00	2026-02-14 21:16:50.499+00		f	1	\N
75	Bigchat	556593002657		2026-02-14 21:16:51.406+00	2026-02-14 21:16:51.406+00		f	1	\N
11	Lucas Lopes - Controladoria	556596132483	https://pps.whatsapp.net/v/t61.24694-24/506910334_1670231486996021_2072558671200420489_n.jpg?ccb=11-4&oh=01_Q5Aa3wEARwlYHVMHgUsW1MhptOpAKrunFTOBTYis6P6-Y1q00w&oe=699DE531&_nc_sid=5e03e0&_nc_cat=103	2026-02-12 00:58:34.977+00	2026-02-14 21:16:52.089+00		f	1	\N
76	Kamila Emy	556593293562		2026-02-14 21:17:05.894+00	2026-02-14 21:17:05.894+00		f	1	\N
3	Marcos - TI GRUPO COLLAB	556592694840	https://pps.whatsapp.net/v/t61.24694-24/543126397_1579112593271940_6454354658651498533_n.jpg?ccb=11-4&oh=01_Q5Aa3wH3p-pk9yW_hyVugyAyhq3janKiC-zM08w9eZ6Q9Nr9uQ&oe=699F8EF4&_nc_sid=5e03e0&_nc_cat=104	2026-02-12 00:41:37.793+00	2026-02-16 01:41:54.843+00		f	1	\N
\.


--
-- Data for Name: Extensions; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Extensions" (id, exten, name, password, "callerIdName", "callerIdNumber", status, "isActive", "canRecord", "webrtcEnabled", transport, context, codecs, notes, "asteriskId", "userId", "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Files; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Files" (id, "companyId", name, message, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: FilesOptions; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."FilesOptions" (id, name, path, "fileId", "createdAt", "updatedAt", "mediaType") FROM stdin;
\.


--
-- Data for Name: Helps; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Helps" (id, title, description, video, link, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Invoices; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Invoices" (id, detail, status, value, "createdAt", "updatedAt", "dueDate", "companyId") FROM stdin;
\.


--
-- Data for Name: Messages; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Messages" (id, body, ack, read, "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt", "fromMe", "isDeleted", "contactId", "quotedMsgId", "companyId", "remoteJid", "dataJson", participant, "queueId", "isEdited", "messageStatus", "responseTime") FROM stdin;
3EB06756A147BB6EDFE3BC	Olá seja bem vindo	2	t	chat	\N	397	2026-02-16 01:41:50.482+00	2026-02-16 01:41:50.482+00	t	f	\N	\N	1	\N	\N	\N	\N	f	new	\N
3EB0F75037822AFA76CEDA	Olá seja bem vindo	3	t	chat	\N	397	2026-02-16 01:41:51.455+00	2026-02-16 01:41:51.455+00	t	f	\N	\N	1	\N	\N	\N	\N	f	new	\N
3EB03E649D557C7A87A711	Olá, Drogarias ‎Big Master agradece seu contato. Como podemos ajudar?	3	t	chat	\N	397	2026-02-16 01:41:53.42+00	2026-02-16 01:41:53.42+00	t	f	\N	\N	1	\N	\N	\N	\N	f	new	\N
3EB012EB0B226A93004B93	Olá, Drogarias ‎Big Master agradece seu contato. Como podemos ajudar?	3	t	chat	\N	397	2026-02-16 01:41:55.709+00	2026-02-16 01:41:55.709+00	t	f	\N	\N	1	\N	\N	\N	\N	f	new	\N
3EB043B881505E3CF792E3	Olá	2	t	chat	\N	397	2026-02-16 01:41:55.482+00	2026-02-16 01:41:57.965+00	t	f	\N	\N	1	\N	\N	\N	\N	f	new	\N
3EB0DE378C8E16C616D394	Olá	3	t	chat	\N	397	2026-02-16 01:41:53.14+00	2026-02-16 01:42:36.779+00	t	f	\N	\N	1	\N	\N	\N	\N	f	new	\N
3A0FD86FA3037A55A455	Bom dia	0	f	chat	\N	398	2026-02-16 01:41:52.65+00	2026-02-16 01:46:52.733+00	f	f	2	\N	1	\N	\N	\N	\N	f	waiting	\N
3EB09D6C9B7E6F57CD570A	Bom dia	0	f	chat	\N	399	2026-02-16 01:41:54.972+00	2026-02-16 01:46:55.044+00	f	f	3	\N	1	\N	\N	\N	\N	f	waiting	\N
\.


--
-- Data for Name: Plans; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Plans" (id, name, users, connections, queues, value, "createdAt", "updatedAt", "useCampaigns", "useExternalApi", "useInternalChat", "useSchedules", "useKanban", "useOpenAi", "useIntegrations") FROM stdin;
1	Plano 1	10	10	10	30	2026-02-10 19:17:06.827+00	2026-02-10 19:17:06.827+00	t	t	t	t	t	t	t
\.


--
-- Data for Name: Prompts; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Prompts" (id, name, "apiKey", prompt, "maxTokens", "maxMessages", temperature, "promptTokens", "completionTokens", "totalTokens", "companyId", "createdAt", "updatedAt", model, "queueId") FROM stdin;
\.


--
-- Data for Name: QueueIntegrations; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."QueueIntegrations" (id, type, name, "projectName", "jsonContent", language, "createdAt", "updatedAt", "urlN8N", "companyId", "typebotSlug", "typebotExpires", "typebotKeywordFinish", "typebotUnknownMessage", "typebotDelayMessage", "typebotKeywordRestart", "typebotRestartMessage") FROM stdin;
\.


--
-- Data for Name: QueueOptions; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."QueueOptions" (id, title, message, option, "queueId", "parentId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Queues; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Queues" (id, name, color, "greetingMessage", "createdAt", "updatedAt", "companyId", schedules, "outOfHoursMessage", "orderQueue", "integrationId", "promptId") FROM stdin;
1	Palmiro	#008b02		2026-02-11 20:20:27.226+00	2026-02-11 20:20:27.226+00	1	[{"endTime": "18:00", "weekday": "Segunda-feira", "startTime": "08:00", "weekdayEn": "monday"}, {"endTime": "18:00", "weekday": "Terça-feira", "startTime": "08:00", "weekdayEn": "tuesday"}, {"endTime": "18:00", "weekday": "Quarta-feira", "startTime": "08:00", "weekdayEn": "wednesday"}, {"endTime": "18:00", "weekday": "Quinta-feira", "startTime": "08:00", "weekdayEn": "thursday"}, {"endTime": "18:00", "weekday": "Sexta-feira", "startTime": "08:00", "weekdayEn": "friday"}, {"endTime": "12:00", "weekday": "Sábado", "startTime": "08:00", "weekdayEn": "saturday"}, {"endTime": "00:00", "weekday": "Domingo", "startTime": "00:00", "weekdayEn": "sunday"}]		\N	\N	\N
2	FernandoCorreia	#f44e3b		2026-02-11 20:20:40.786+00	2026-02-11 20:20:40.786+00	1	[{"endTime": "18:00", "weekday": "Segunda-feira", "startTime": "08:00", "weekdayEn": "monday"}, {"endTime": "18:00", "weekday": "Terça-feira", "startTime": "08:00", "weekdayEn": "tuesday"}, {"endTime": "18:00", "weekday": "Quarta-feira", "startTime": "08:00", "weekdayEn": "wednesday"}, {"endTime": "18:00", "weekday": "Quinta-feira", "startTime": "08:00", "weekdayEn": "thursday"}, {"endTime": "18:00", "weekday": "Sexta-feira", "startTime": "08:00", "weekdayEn": "friday"}, {"endTime": "12:00", "weekday": "Sábado", "startTime": "08:00", "weekdayEn": "saturday"}, {"endTime": "00:00", "weekday": "Domingo", "startTime": "00:00", "weekdayEn": "sunday"}]		\N	\N	\N
3	JulioCampos	#a4dd00		2026-02-11 20:20:56.711+00	2026-02-11 20:20:56.711+00	1	[{"endTime": "18:00", "weekday": "Segunda-feira", "startTime": "08:00", "weekdayEn": "monday"}, {"endTime": "18:00", "weekday": "Terça-feira", "startTime": "08:00", "weekdayEn": "tuesday"}, {"endTime": "18:00", "weekday": "Quarta-feira", "startTime": "08:00", "weekdayEn": "wednesday"}, {"endTime": "18:00", "weekday": "Quinta-feira", "startTime": "08:00", "weekdayEn": "thursday"}, {"endTime": "18:00", "weekday": "Sexta-feira", "startTime": "08:00", "weekdayEn": "friday"}, {"endTime": "12:00", "weekday": "Sábado", "startTime": "08:00", "weekdayEn": "saturday"}, {"endTime": "00:00", "weekday": "Domingo", "startTime": "00:00", "weekdayEn": "sunday"}]		\N	\N	\N
\.


--
-- Data for Name: QuickMessages; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."QuickMessages" (id, shortcode, message, "companyId", "createdAt", "updatedAt", "userId", "mediaPath", "mediaName") FROM stdin;
\.


--
-- Data for Name: Schedules; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Schedules" (id, body, "sendAt", "sentAt", "contactId", "ticketId", "userId", "companyId", "createdAt", "updatedAt", status, "mediaName", "mediaPath") FROM stdin;
\.


--
-- Data for Name: SequelizeMeta; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."SequelizeMeta" (name) FROM stdin;
20200717133431-add-uuid-ossp.js
20200717133438-create-users.js
20200717144403-create-contacts.js
20200717145643-create-tickets.js
20200717151645-create-messages.js
20200717170223-create-whatsapps.js
20200723200315-create-contacts-custom-fields.js
20200723202116-add-email-field-to-contacts.js
20200730153237-remove-user-association-from-messages.js
20200730153545-add-fromMe-to-messages.js
20200813114236-change-ticket-lastMessage-column-type.js
20200901235509-add-profile-column-to-users.js
20200903215941-create-settings.js
20200904220257-add-name-to-whatsapp.js
20200906122228-add-name-default-field-to-whatsapp.js
20200906155658-add-whatsapp-field-to-tickets.js
20200919124112-update-default-column-name-on-whatsappp.js
20200927220708-add-isDeleted-column-to-messages.js
20200929145451-add-user-tokenVersion-column.js
20200930162323-add-isGroup-column-to-tickets.js
20200930194808-add-isGroup-column-to-contacts.js
20201004150008-add-contactId-column-to-messages.js
20201004155719-add-vcardContactId-column-to-messages.js
20201004955719-remove-vcardContactId-column-to-messages.js
20201026215410-add-retries-to-whatsapps.js
20201028124427-add-quoted-msg-to-messages.js
20210108001431-add-unreadMessages-to-tickets.js
20210108164404-create-queues.js
20210108164504-add-queueId-to-tickets.js
20210108174594-associate-whatsapp-queue.js
20210108204708-associate-users-queue.js
20210109192513-add-greetingMessage-to-whatsapp.js
20210109192514-create-companies-table.js
20210109192515-add-column-companyId-to-Settings-table.js
20210109192516-add-column-companyId-to-Users-table.js
20210109192517-add-column-companyId-to-Contacts-table.js
20210109192518-add-column-companyId-to-Messages-table.js
20210109192519-add-column-companyId-to-Queues-table.js
20210109192520-add-column-companyId-to-Whatsapps-table.js
20210109192521-add-column-companyId-to-Tickets-table.js
20210109192522-create-plans-table.js
20210109192523-add-column-planId-to-Companies.js
20210109192523-add-column-status-and-schedules-to-Companies.js
20210109192523-create-ticket-notes.js
20210109192524-create-quick-messages.js
20210109192525-add-column-complationMessage-to-whatsapp.js
20210109192526-add-column-outOfHoursMessage-to-whatsapp .js
20210109192527-add-column-super-to-Users-table.js
20210109192528-change-column-message-to-quick-messages-table.js
20210109192529-create-helps.js
20210109192530-add-unique-constraint-to-Contacts-table.js
20210109192531-create-TicketTracking-table.js
20210109192532-add-column-online-to-Users-table.js
20210109192533-create-UserRatings-table.js
20210109192534-add-rated-to-TicketTraking.js
20210109192535-add-column-ratingMessage-to-whatsapp.js
20210109192536-add-unique-constraint-to-Tickets-table.js
20210818102606-add-uuid-to-tickets.js
20210818102609-add-token-to-Whatsapps.js
20211205164404-create-queue-options.js
20211212125704-add-chatbot-to-tickets.js
20211227010200-create-schedules.js
20220115114088-add-column-userId-to-QuickMessages-table.js
20220117130000-create-tags.js
20220117134400-associate-tickets-tags.js
20220122160900-add-status-to-schedules.js
20220220014719-add-farewellMessage-to-whatsapp.js
20220221014717-add-provider-whatsapp.js
20220221014718-add-remoteJid-messages.js
20220221014719-add-jsonMessage-messages.js
20220221014720-add-participant-messages.js
20220221014721-create-baileys.js
20220315110000-create-ContactLists-table.js
20220315110001-create-ContactListItems-table.js
20220315110002-create-Campaigns-table.js
20220315110004-create-CampaignSettings-table.js
20220315110005-remove-constraint-to-Settings.js
20220321130000-create-CampaignShipping.js
20220404000000-add-column-queueId-to-Messages-table.js
20220406000000-add-column-dueDate-to-Companies.js
20220406000001-add-column-recurrence-to-Companies.js
20220411000000-add-column-startTime-and-endTime-to-Queues.js
20220411000001-remove-column-startTime-and-endTime-to-Queues.js
20220411000002-add-column-schedules-and-outOfHoursMessage-to-Queues.js
20220411000003-create-table-Announcements.js
20220425000000-create-table-Chats.js
20220425000001-create-table-ChatUsers.js
20220425000002-create-table-ChatMessages.js
20220512000001-create-Indexes.js
20220512000002-create-subscriptions.js
20220512000003-create-invoices.js
20220723000001-add-mediaPath-to-quickmessages.js
20220723000002-add-mediaName-to-quickemessages.js
20222016014720-create-baileys-chats.js
20222016014721-create-baileys-chats Messages.js
20230106164900-add-useCampaigns-Plans.js
20230106164900-add-useExternalApi-Plans.js
20230106164900-add-useInternalChat-Plans.js
20230106164900-add-useSchedules-Plans.js
20230303223001-add-amountUsedBotQueues-to-tickets.js
20230417203900-add-allTickets-user.js
20230603212335-create-QueueIntegrations.js
20230603212337-add-urlN8N-QueueIntegrations.js
20230623095932-add-whatsapp-to-user.js
20230623133903-add-chatbotAt-ticket-tracking.js
20230628134807-add-orderQueue-Queue.js
20230711094417-add-column-companyId-to-QueueIntegrations-table.js
20230711111701-add-sendIdQueue-to-whatsapp.js
20230714113901-create-Files.js
20230714113902-create-fileOptions.js
20230723301001-add-kanban-to-Tags.js
20230801081907-add-collumns-Ticket.js
20230813114236-change-ticket-lastMessage-column-type.js
20230824082607-add-mediaType-FilesOptions.js
20230828143411-add-Integrations-to-tickets.js
20230828144000-create-prompts.js
20230828144100-add-column-promptid-into-whatsapps.js
20230831093000-add-useKanban-Plans.js
20230922212337-add-integrationId-Queues.js
20230924212337-add-fileListId-Campaigns.js
20231111185822-add_reset_password_column.js
20231117000001-add-mediaName-to-schedules.js
20231117000001-add-mediaPath-to-schedules.js
20231127113000-add-columns-Plans.js
20231128123537-add-typebot-QueueIntegrations.js
20231202143411-add-typebotSessionId-to-tickets.js
20231207080337-add-typebotDelayMessage-QueueIntegrations.js
20231207085011-add-typebotStatus-to-tickets.js
20231214092337-add-promptId-Queues.js
20231214143411-add-columns-to-whatsapps.js
20231214143411-add-promptId-to-tickets.js
20231218160937-add-columns-QueueIntegrations.js
20231219153800-add-isEdited-column-to-messages.js
20231220192536-add-unique-constraint-to-Tickets-table.js
20231220223517-add-column-whatsappId-to-Contacts.js
20232016014719-add-transferTime-and-queueIdTransfer.js
20240918214408-change-prompt.js
20241019004400-remove-confirmation-from-campaing.js
20241023022021-remove-queueid-prompt.js
20241023022022-add-queueid-prompt.js
20241125223218-add-tagId-to-campaign-table.js
20241125223219-add-language-company.js
20260210200000-add-meta-fields-to-whatsapps.js
20260211100000-create-asterisks-table.js
20260211100001-create-calls-table.js
20260211100002-create-extensions-table.js
\.


--
-- Data for Name: Settings; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Settings" (key, value, "createdAt", "updatedAt", "companyId", id) FROM stdin;
chatBotType	text	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	1
sendGreetingAccepted	disabled	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	2
sendMsgTransfTicket	disabled	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	3
sendGreetingMessageOneQueues	disabled	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	4
userRating	disabled	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	5
scheduleType	queue	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	6
CheckMsgIsGroup	enabled	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	7
call	disabled	2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	8
ipixc		2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	9
tokenixc		2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	10
ipmkauth		2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	11
clientidmkauth		2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	12
clientsecretmkauth		2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	13
asaas		2026-02-10 19:17:07.042+00	2026-02-10 19:17:07.042+00	1	14
allTicket	disabled	2026-02-10 19:17:07.062+00	2026-02-10 19:17:07.062+00	\N	15
autoAcceptTickets	enabled	2026-02-12 01:55:42.053289+00	2026-02-12 01:55:42.053289+00	1	16
\.


--
-- Data for Name: Subscriptions; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Subscriptions" (id, "isActive", "expiresAt", "userPriceCents", "whatsPriceCents", "lastInvoiceUrl", "lastPlanChange", "companyId", "providerSubscriptionId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Tags; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Tags" (id, name, color, "companyId", "createdAt", "updatedAt", kanban) FROM stdin;
\.


--
-- Data for Name: TicketNotes; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."TicketNotes" (id, note, "userId", "contactId", "ticketId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: TicketTags; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."TicketTags" ("ticketId", "tagId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: TicketTraking; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."TicketTraking" (id, "ticketId", "companyId", "whatsappId", "userId", "createdAt", "updatedAt", "queuedAt", "startedAt", "finishedAt", "ratingAt", rated, "chatbotAt") FROM stdin;
70	397	1	7	\N	2026-02-16 01:41:50.38+00	2026-02-16 01:41:50.38+00	\N	\N	\N	\N	f	\N
71	398	1	7	\N	2026-02-16 01:41:52.445+00	2026-02-16 01:41:52.445+00	\N	\N	\N	\N	f	\N
72	399	1	7	\N	2026-02-16 01:41:54.894+00	2026-02-16 01:41:54.894+00	\N	\N	\N	\N	f	\N
\.


--
-- Data for Name: Tickets; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Tickets" (id, status, "lastMessage", "contactId", "userId", "createdAt", "updatedAt", "whatsappId", "isGroup", "unreadMessages", "queueId", "companyId", uuid, chatbot, "queueOptionId", "amountUsedBotQueues", "fromMe", "useIntegration", "integrationId", "typebotSessionId", "typebotStatus", "promptId", "lastClientMessageAt", "lastAgentMessageAt", "pendingClientMessages") FROM stdin;
398	open	Bom dia	2	\N	2026-02-16 01:41:52.417+00	2026-02-16 01:41:52.712+00	7	f	2	\N	1	c183c438-bf4f-4883-ad07-aedb35d0ef9a	f	\N	0	f	f	\N	\N	f	\N	2026-02-16 01:41:52.687+00	\N	1
399	open	Bom dia	3	\N	2026-02-16 01:41:54.868+00	2026-02-16 01:41:55.041+00	7	f	2	\N	1	2b132db9-060d-4aea-b9b3-c6e047efa495	f	\N	0	f	f	\N	\N	f	\N	2026-02-16 01:41:55.029+00	\N	1
397	open	Olá, Drogarias ‎Big Master agradece seu contato. Como podemos ajudar?	75	\N	2026-02-16 01:41:50.334+00	2026-02-16 01:41:55.75+00	7	f	0	\N	1	6339b95d-e6c4-411d-b483-9ed0704408ef	f	\N	0	f	f	\N	\N	f	\N	\N	2026-02-16 01:41:55.74+00	0
\.


--
-- Data for Name: UserQueues; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."UserQueues" ("userId", "queueId", "createdAt", "updatedAt") FROM stdin;
1	1	2026-02-12 23:30:47.927+00	2026-02-12 23:30:47.927+00
1	2	2026-02-12 23:30:47.927+00	2026-02-12 23:30:47.927+00
1	3	2026-02-12 23:30:47.927+00	2026-02-12 23:30:47.927+00
\.


--
-- Data for Name: UserRatings; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."UserRatings" (id, "ticketId", "companyId", "userId", rate, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Users" (id, name, email, "passwordHash", "createdAt", "updatedAt", profile, "tokenVersion", "companyId", super, online, "allTicket", "whatsappId", "resetPassword") FROM stdin;
2	Lucas.Controladoria	controladoria@drogariasbigmaster.com.br	$2a$08$dDD/ZMYKtUKISe4ksx2.VuK02qxiJKu0R9qZXEa7IK8K5XyD.cHvS	2026-02-11 17:11:51.485+00	2026-02-11 17:11:51.485+00	user	0	1	f	f	desabled	\N	\N
1	Admin	admin@admin.com	$2a$08$VdYVyYVUAA9rbn7G8wcpZuGen4Ac50iTEXAoP/uYbOQRtryqAXQZe	2026-02-10 19:17:07.021+00	2026-02-12 23:30:47.787+00	admin	0	1	t	t	desabled	\N	\N
\.


--
-- Data for Name: WhatsappQueues; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."WhatsappQueues" ("whatsappId", "queueId", "createdAt", "updatedAt") FROM stdin;
1	1	2026-02-11 23:05:02.257+00	2026-02-11 23:05:02.257+00
2	1	2026-02-11 23:34:51.582+00	2026-02-11 23:34:51.582+00
4	2	2026-02-12 19:44:18.924+00	2026-02-12 19:44:18.924+00
5	1	2026-02-14 21:15:03.109+00	2026-02-14 21:15:03.109+00
6	1	2026-02-14 21:28:28.376+00	2026-02-14 21:28:28.376+00
6	2	2026-02-14 21:28:28.376+00	2026-02-14 21:28:28.376+00
6	3	2026-02-14 21:28:28.376+00	2026-02-14 21:28:28.376+00
\.


--
-- Data for Name: Whatsapps; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Whatsapps" (id, session, qrcode, status, battery, plugged, "createdAt", "updatedAt", name, "isDefault", retries, "greetingMessage", "companyId", "complationMessage", "outOfHoursMessage", "ratingMessage", token, "farewellMessage", provider, "sendIdQueue", "promptId", "integrationId", "maxUseBotQueues", "expiresTicket", "expiresInactiveMessage", "timeUseBotQueues", "transferQueueId", "timeToTransfer", "phoneNumberId", "businessAccountId", "accessToken", "webhookVerifyToken", "metaApiVersion", number) FROM stdin;
7	{"pushname":"Bigchat","wid":{"server":"c.us","user":"556593002657","_serialized":"556593002657@c.us"},"platform":"android"}		CONNECTED	\N	\N	2026-02-16 01:14:08.484+00	2026-02-16 01:41:49.572+00	Atendimento	t	0	Olá	1						beta	\N	\N	\N	3	0		0	\N	\N	\N	\N	\N	\N	v18.0	556593002657
\.


--
-- Name: Announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Announcements_id_seq"', 1, false);


--
-- Name: Asterisks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Asterisks_id_seq"', 1, false);


--
-- Name: BaileysChats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."BaileysChats_id_seq"', 1, false);


--
-- Name: BaileysMessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."BaileysMessages_id_seq"', 1, false);


--
-- Name: Baileys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Baileys_id_seq"', 1, false);


--
-- Name: Calls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Calls_id_seq"', 1, false);


--
-- Name: CampaignSettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."CampaignSettings_id_seq"', 1, false);


--
-- Name: CampaignShipping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."CampaignShipping_id_seq"', 1, false);


--
-- Name: Campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Campaigns_id_seq"', 1, false);


--
-- Name: ChatMessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."ChatMessages_id_seq"', 1, false);


--
-- Name: ChatUsers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."ChatUsers_id_seq"', 1, false);


--
-- Name: Chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Chats_id_seq"', 1, false);


--
-- Name: Companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Companies_id_seq"', 1, true);


--
-- Name: ContactCustomFields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."ContactCustomFields_id_seq"', 1, false);


--
-- Name: ContactListItems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."ContactListItems_id_seq"', 1, false);


--
-- Name: ContactLists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."ContactLists_id_seq"', 1, false);


--
-- Name: Contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Contacts_id_seq"', 76, true);


--
-- Name: Extensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Extensions_id_seq"', 1, false);


--
-- Name: FilesOptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."FilesOptions_id_seq"', 1, false);


--
-- Name: Files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Files_id_seq"', 1, false);


--
-- Name: Helps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Helps_id_seq"', 1, false);


--
-- Name: Invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Invoices_id_seq"', 1, false);


--
-- Name: Plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Plans_id_seq"', 2, true);


--
-- Name: Prompts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Prompts_id_seq"', 1, false);


--
-- Name: QueueIntegrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."QueueIntegrations_id_seq"', 1, false);


--
-- Name: QueueOptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."QueueOptions_id_seq"', 1, false);


--
-- Name: Queues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Queues_id_seq"', 3, true);


--
-- Name: QuickMessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."QuickMessages_id_seq"', 1, false);


--
-- Name: Schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Schedules_id_seq"', 1, false);


--
-- Name: Settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Settings_id_seq"', 16, true);


--
-- Name: Subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Subscriptions_id_seq"', 1, false);


--
-- Name: Tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Tags_id_seq"', 1, false);


--
-- Name: TicketNotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."TicketNotes_id_seq"', 1, false);


--
-- Name: TicketTraking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."TicketTraking_id_seq"', 72, true);


--
-- Name: Tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Tickets_id_seq"', 399, true);


--
-- Name: UserRatings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."UserRatings_id_seq"', 1, false);


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Users_id_seq"', 2, true);


--
-- Name: Whatsapps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Whatsapps_id_seq"', 7, true);


--
-- Name: Announcements Announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Announcements"
    ADD CONSTRAINT "Announcements_pkey" PRIMARY KEY (id);


--
-- Name: Asterisks Asterisks_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Asterisks"
    ADD CONSTRAINT "Asterisks_pkey" PRIMARY KEY (id);


--
-- Name: BaileysChats BaileysChats_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysChats"
    ADD CONSTRAINT "BaileysChats_pkey" PRIMARY KEY (id);


--
-- Name: BaileysMessages BaileysMessages_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysMessages"
    ADD CONSTRAINT "BaileysMessages_pkey" PRIMARY KEY (id);


--
-- Name: Baileys Baileys_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Baileys"
    ADD CONSTRAINT "Baileys_pkey" PRIMARY KEY (id, "whatsappId");


--
-- Name: Calls Calls_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls"
    ADD CONSTRAINT "Calls_pkey" PRIMARY KEY (id);


--
-- Name: CampaignSettings CampaignSettings_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignSettings"
    ADD CONSTRAINT "CampaignSettings_pkey" PRIMARY KEY (id);


--
-- Name: CampaignShipping CampaignShipping_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignShipping"
    ADD CONSTRAINT "CampaignShipping_pkey" PRIMARY KEY (id);


--
-- Name: Campaigns Campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_pkey" PRIMARY KEY (id);


--
-- Name: ChatMessages ChatMessages_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatMessages"
    ADD CONSTRAINT "ChatMessages_pkey" PRIMARY KEY (id);


--
-- Name: ChatUsers ChatUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatUsers"
    ADD CONSTRAINT "ChatUsers_pkey" PRIMARY KEY (id);


--
-- Name: Chats Chats_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_pkey" PRIMARY KEY (id);


--
-- Name: Companies Companies_name_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_name_key" UNIQUE (name);


--
-- Name: Companies Companies_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_pkey" PRIMARY KEY (id);


--
-- Name: ContactCustomFields ContactCustomFields_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactCustomFields"
    ADD CONSTRAINT "ContactCustomFields_pkey" PRIMARY KEY (id);


--
-- Name: ContactListItems ContactListItems_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactListItems"
    ADD CONSTRAINT "ContactListItems_pkey" PRIMARY KEY (id);


--
-- Name: ContactLists ContactLists_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactLists"
    ADD CONSTRAINT "ContactLists_pkey" PRIMARY KEY (id);


--
-- Name: Contacts Contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT "Contacts_pkey" PRIMARY KEY (id);


--
-- Name: Extensions Extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Extensions"
    ADD CONSTRAINT "Extensions_pkey" PRIMARY KEY (id);


--
-- Name: FilesOptions FilesOptions_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."FilesOptions"
    ADD CONSTRAINT "FilesOptions_pkey" PRIMARY KEY (id);


--
-- Name: Files Files_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_pkey" PRIMARY KEY (id);


--
-- Name: Helps Helps_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Helps"
    ADD CONSTRAINT "Helps_pkey" PRIMARY KEY (id);


--
-- Name: Invoices Invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Invoices"
    ADD CONSTRAINT "Invoices_pkey" PRIMARY KEY (id);


--
-- Name: Messages Messages_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_pkey" PRIMARY KEY (id);


--
-- Name: Plans Plans_name_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Plans"
    ADD CONSTRAINT "Plans_name_key" UNIQUE (name);


--
-- Name: Plans Plans_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Plans"
    ADD CONSTRAINT "Plans_pkey" PRIMARY KEY (id);


--
-- Name: Prompts Prompts_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Prompts"
    ADD CONSTRAINT "Prompts_pkey" PRIMARY KEY (id);


--
-- Name: QueueIntegrations QueueIntegrations_name_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_name_key" UNIQUE (name);


--
-- Name: QueueIntegrations QueueIntegrations_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_pkey" PRIMARY KEY (id);


--
-- Name: QueueIntegrations QueueIntegrations_projectName_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_projectName_key" UNIQUE ("projectName");


--
-- Name: QueueOptions QueueOptions_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueOptions"
    ADD CONSTRAINT "QueueOptions_pkey" PRIMARY KEY (id);


--
-- Name: Queues Queues_color_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_color_key" UNIQUE (color);


--
-- Name: Queues Queues_name_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_name_key" UNIQUE (name);


--
-- Name: Queues Queues_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_pkey" PRIMARY KEY (id);


--
-- Name: QuickMessages QuickMessages_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QuickMessages"
    ADD CONSTRAINT "QuickMessages_pkey" PRIMARY KEY (id);


--
-- Name: Schedules Schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_pkey" PRIMARY KEY (id);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: Subscriptions Subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Subscriptions"
    ADD CONSTRAINT "Subscriptions_pkey" PRIMARY KEY (id);


--
-- Name: Tags Tags_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT "Tags_pkey" PRIMARY KEY (id);


--
-- Name: TicketNotes TicketNotes_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_pkey" PRIMARY KEY (id);


--
-- Name: TicketTraking TicketTraking_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_pkey" PRIMARY KEY (id);


--
-- Name: Tickets Tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_pkey" PRIMARY KEY (id);


--
-- Name: UserQueues UserQueues_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."UserQueues"
    ADD CONSTRAINT "UserQueues_pkey" PRIMARY KEY ("userId", "queueId");


--
-- Name: UserRatings UserRatings_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_email_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: WhatsappQueues WhatsappQueues_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."WhatsappQueues"
    ADD CONSTRAINT "WhatsappQueues_pkey" PRIMARY KEY ("whatsappId", "queueId");


--
-- Name: Whatsapps Whatsapps_name_key; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_name_key" UNIQUE (name);


--
-- Name: Whatsapps Whatsapps_pkey; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_pkey" PRIMARY KEY (id);


--
-- Name: Tickets contactid_companyid_unique; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT contactid_companyid_unique UNIQUE ("contactId", "companyId");


--
-- Name: Contacts number_companyid_unique; Type: CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT number_companyid_unique UNIQUE (number, "companyId");


--
-- Name: asterisks_company_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX asterisks_company_id ON public."Asterisks" USING btree ("companyId");


--
-- Name: calls_asterisk_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_asterisk_id ON public."Calls" USING btree ("asteriskId");


--
-- Name: calls_company_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_company_id ON public."Calls" USING btree ("companyId");


--
-- Name: calls_contact_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_contact_id ON public."Calls" USING btree ("contactId");


--
-- Name: calls_started_at; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_started_at ON public."Calls" USING btree ("startedAt");


--
-- Name: calls_status; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_status ON public."Calls" USING btree (status);


--
-- Name: calls_unique_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_unique_id ON public."Calls" USING btree ("uniqueId");


--
-- Name: calls_user_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX calls_user_id ON public."Calls" USING btree ("userId");


--
-- Name: extensions_asterisk_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX extensions_asterisk_id ON public."Extensions" USING btree ("asteriskId");


--
-- Name: extensions_company_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX extensions_company_id ON public."Extensions" USING btree ("companyId");


--
-- Name: extensions_exten; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX extensions_exten ON public."Extensions" USING btree (exten);


--
-- Name: extensions_user_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX extensions_user_id ON public."Extensions" USING btree ("userId");


--
-- Name: idx_cont_company_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX idx_cont_company_id ON public."Contacts" USING btree ("companyId");


--
-- Name: idx_cpsh_campaign_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX idx_cpsh_campaign_id ON public."CampaignShipping" USING btree ("campaignId");


--
-- Name: idx_ctli_contact_list_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX idx_ctli_contact_list_id ON public."ContactListItems" USING btree ("contactListId");


--
-- Name: idx_ms_company_id_ticket_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX idx_ms_company_id_ticket_id ON public."Messages" USING btree ("companyId", "ticketId");


--
-- Name: idx_sched_company_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX idx_sched_company_id ON public."Schedules" USING btree ("companyId");


--
-- Name: idx_tg_company_id; Type: INDEX; Schema: public; Owner: bigchat
--

CREATE INDEX idx_tg_company_id ON public."Tags" USING btree ("companyId");


--
-- Name: Announcements Announcements_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Announcements"
    ADD CONSTRAINT "Announcements_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Asterisks Asterisks_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Asterisks"
    ADD CONSTRAINT "Asterisks_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: BaileysChats BaileysChats_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysChats"
    ADD CONSTRAINT "BaileysChats_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: BaileysMessages BaileysMessages_baileysChatId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysMessages"
    ADD CONSTRAINT "BaileysMessages_baileysChatId_fkey" FOREIGN KEY ("baileysChatId") REFERENCES public."BaileysChats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: BaileysMessages BaileysMessages_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."BaileysMessages"
    ADD CONSTRAINT "BaileysMessages_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Calls Calls_asteriskId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls"
    ADD CONSTRAINT "Calls_asteriskId_fkey" FOREIGN KEY ("asteriskId") REFERENCES public."Asterisks"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Calls Calls_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls"
    ADD CONSTRAINT "Calls_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Calls Calls_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls"
    ADD CONSTRAINT "Calls_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Calls Calls_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls"
    ADD CONSTRAINT "Calls_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Calls Calls_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Calls"
    ADD CONSTRAINT "Calls_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: CampaignSettings CampaignSettings_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignSettings"
    ADD CONSTRAINT "CampaignSettings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CampaignShipping CampaignShipping_campaignId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignShipping"
    ADD CONSTRAINT "CampaignShipping_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES public."Campaigns"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CampaignShipping CampaignShipping_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."CampaignShipping"
    ADD CONSTRAINT "CampaignShipping_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."ContactListItems"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: Campaigns Campaigns_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Campaigns Campaigns_contactListId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_contactListId_fkey" FOREIGN KEY ("contactListId") REFERENCES public."ContactLists"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: Campaigns Campaigns_fileListId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_fileListId_fkey" FOREIGN KEY ("fileListId") REFERENCES public."Files"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Campaigns Campaigns_tagId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES public."Tags"(id);


--
-- Name: Campaigns Campaigns_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Campaigns"
    ADD CONSTRAINT "Campaigns_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: ChatMessages ChatMessages_chatId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatMessages"
    ADD CONSTRAINT "ChatMessages_chatId_fkey" FOREIGN KEY ("chatId") REFERENCES public."Chats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ChatMessages ChatMessages_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatMessages"
    ADD CONSTRAINT "ChatMessages_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ChatUsers ChatUsers_chatId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatUsers"
    ADD CONSTRAINT "ChatUsers_chatId_fkey" FOREIGN KEY ("chatId") REFERENCES public."Chats"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ChatUsers ChatUsers_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ChatUsers"
    ADD CONSTRAINT "ChatUsers_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Chats Chats_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Chats Chats_ownerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Chats"
    ADD CONSTRAINT "Chats_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Companies Companies_planId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Companies"
    ADD CONSTRAINT "Companies_planId_fkey" FOREIGN KEY ("planId") REFERENCES public."Plans"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ContactCustomFields ContactCustomFields_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactCustomFields"
    ADD CONSTRAINT "ContactCustomFields_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ContactListItems ContactListItems_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactListItems"
    ADD CONSTRAINT "ContactListItems_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ContactListItems ContactListItems_contactListId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactListItems"
    ADD CONSTRAINT "ContactListItems_contactListId_fkey" FOREIGN KEY ("contactListId") REFERENCES public."ContactLists"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ContactLists ContactLists_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."ContactLists"
    ADD CONSTRAINT "ContactLists_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Contacts Contacts_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT "Contacts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Contacts Contacts_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Contacts"
    ADD CONSTRAINT "Contacts_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Extensions Extensions_asteriskId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Extensions"
    ADD CONSTRAINT "Extensions_asteriskId_fkey" FOREIGN KEY ("asteriskId") REFERENCES public."Asterisks"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Extensions Extensions_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Extensions"
    ADD CONSTRAINT "Extensions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Extensions Extensions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Extensions"
    ADD CONSTRAINT "Extensions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: FilesOptions FilesOptions_fileId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."FilesOptions"
    ADD CONSTRAINT "FilesOptions_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Files"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Files Files_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Files"
    ADD CONSTRAINT "Files_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Invoices Invoices_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Invoices"
    ADD CONSTRAINT "Invoices_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Messages Messages_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Messages Messages_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Messages Messages_queueId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: Messages Messages_quotedMsgId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_quotedMsgId_fkey" FOREIGN KEY ("quotedMsgId") REFERENCES public."Messages"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Messages Messages_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Messages"
    ADD CONSTRAINT "Messages_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Prompts Prompts_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Prompts"
    ADD CONSTRAINT "Prompts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Prompts Prompts_queueId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Prompts"
    ADD CONSTRAINT "Prompts_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id);


--
-- Name: QueueIntegrations QueueIntegrations_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueIntegrations"
    ADD CONSTRAINT "QueueIntegrations_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: QueueOptions QueueOptions_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueOptions"
    ADD CONSTRAINT "QueueOptions_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."QueueOptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: QueueOptions QueueOptions_queueId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QueueOptions"
    ADD CONSTRAINT "QueueOptions_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Queues Queues_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Queues Queues_integrationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES public."QueueIntegrations"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Queues Queues_promptId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Queues"
    ADD CONSTRAINT "Queues_promptId_fkey" FOREIGN KEY ("promptId") REFERENCES public."Prompts"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: QuickMessages QuickMessages_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QuickMessages"
    ADD CONSTRAINT "QuickMessages_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: QuickMessages QuickMessages_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."QuickMessages"
    ADD CONSTRAINT "QuickMessages_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Schedules Schedules_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Schedules Schedules_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Schedules Schedules_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: Schedules Schedules_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Schedules"
    ADD CONSTRAINT "Schedules_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: Settings Settings_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Settings"
    ADD CONSTRAINT "Settings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Subscriptions Subscriptions_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Subscriptions"
    ADD CONSTRAINT "Subscriptions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Tags Tags_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tags"
    ADD CONSTRAINT "Tags_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TicketNotes TicketNotes_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TicketNotes TicketNotes_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TicketNotes TicketNotes_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketNotes"
    ADD CONSTRAINT "TicketNotes_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TicketTags TicketTags_tagId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTags"
    ADD CONSTRAINT "TicketTags_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES public."Tags"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TicketTags TicketTags_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTags"
    ADD CONSTRAINT "TicketTags_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TicketTraking TicketTraking_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON DELETE SET NULL;


--
-- Name: TicketTraking TicketTraking_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON DELETE SET NULL;


--
-- Name: TicketTraking TicketTraking_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON DELETE SET NULL;


--
-- Name: TicketTraking TicketTraking_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."TicketTraking"
    ADD CONSTRAINT "TicketTraking_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON DELETE SET NULL;


--
-- Name: Tickets Tickets_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Tickets Tickets_contactId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES public."Contacts"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Tickets Tickets_integrationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES public."QueueIntegrations"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Tickets Tickets_queueId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES public."Queues"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Tickets Tickets_queueOptionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_queueOptionId_fkey" FOREIGN KEY ("queueOptionId") REFERENCES public."QueueOptions"(id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: Tickets Tickets_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Tickets Tickets_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UserRatings UserRatings_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON DELETE SET NULL;


--
-- Name: UserRatings UserRatings_ticketId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES public."Tickets"(id) ON DELETE SET NULL;


--
-- Name: UserRatings UserRatings_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."UserRatings"
    ADD CONSTRAINT "UserRatings_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON DELETE SET NULL;


--
-- Name: Users Users_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Users Users_whatsappId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_whatsappId_fkey" FOREIGN KEY ("whatsappId") REFERENCES public."Whatsapps"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Whatsapps Whatsapps_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public."Companies"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Whatsapps Whatsapps_integrationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES public."QueueIntegrations"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Whatsapps Whatsapps_promptId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bigchat
--

ALTER TABLE ONLY public."Whatsapps"
    ADD CONSTRAINT "Whatsapps_promptId_fkey" FOREIGN KEY ("promptId") REFERENCES public."Prompts"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict SIXORCNIPKgHUvn1dVBG7Tt3k1NeOg8v5OrcdYfa2b90CGa0UYGg3mZEzMa2VYJ

