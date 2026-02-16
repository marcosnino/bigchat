--
-- PostgreSQL database dump
--

\restrict FM3ImpHtWc09tumHSuGGZ8lZkxkWFp1cO4FH34hd9VGknHCV1nCS7NBENSNWRoY

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
11	Lucas Lopes - Controladoria	556596132483		2026-02-12 00:58:34.977+00	2026-02-12 00:58:34.977+00		f	1	\N
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
3	Marcos - TI GRUPO COLLAB	556592694840	https://pps.whatsapp.net/v/t61.24694-24/543126397_1579112593271940_6454354658651498533_n.jpg?ccb=11-4&oh=01_Q5Aa3wG7qF6xwhyKNQZvEcTGMPJpILLVYwicKSt2kOLwk6jCWA&oe=699B6234&_nc_sid=5e03e0&_nc_cat=104	2026-02-12 00:41:37.793+00	2026-02-12 23:46:02.653+00		f	1	\N
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
3EB08A9B858846E5EDE6		0	t	chat	\N	1	2026-02-12 00:33:15.222+00	2026-02-12 00:38:32.08+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"3EB08A9B858846E5EDE6","_serialized":"false_242214781329600@lid_3EB08A9B858846E5EDE6"},"type":"notification_template","timestamp":1770856394,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02EBC85CC5F189DD65A	Olá	1	t	chat	\N	2	2026-02-12 00:41:04.638+00	2026-02-12 00:41:19.249+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3EB02EBC85CC5F189DD65A","_serialized":"false_47554028900535@lid_3EB02EBC85CC5F189DD65A"},"type":"chat","timestamp":1770856861,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB047855AB0B9E4397128	tentando inicializar	3	t	chat	\N	3	2026-02-12 00:57:02.734+00	2026-02-12 00:57:02.734+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB047855AB0B9E4397128","_serialized":"true_7202811162779@lid_3EB047855AB0B9E4397128"},"type":"chat","timestamp":1770847816,"from":"151909402964196@lid","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0D0FFB86A930F93BF9A	falta algo	3	t	chat	\N	3	2026-02-12 00:57:03.939+00	2026-02-12 00:57:03.939+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB0D0FFB86A930F93BF9A","_serialized":"true_7202811162779@lid_3EB0D0FFB86A930F93BF9A"},"type":"chat","timestamp":1770847818,"from":"151909402964196@lid","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09CA5FAFB00F451E4C0	*Admin:*\nBem vindo	3	t	chat	\N	3	2026-02-12 00:41:35.759+00	2026-02-12 00:42:34.435+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB09CA5FAFB00F451E4C0","_serialized":"true_47554028900535@lid_3EB09CA5FAFB00F451E4C0"},"type":"chat","timestamp":1770856895,"from":"151909402964196@lid","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06A1AEEAAB17FAE87A5	da o anydesk ai	0	t	chat	\N	4	2026-02-12 00:57:11.197+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3EB06A1AEEAAB17FAE87A5","_serialized":"false_7202811162779@lid_3EB06A1AEEAAB17FAE87A5"},"type":"chat","timestamp":1770847824,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08FAAD7584223D2DAD7	instalar extensão do docker?	3	t	chat	\N	3	2026-02-12 00:57:04.823+00	2026-02-12 00:57:04.823+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB08FAAD7584223D2DAD7","_serialized":"true_7202811162779@lid_3EB08FAAD7584223D2DAD7"},"type":"chat","timestamp":1770847823,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0486A252E80EEA45141	não precisa	3	t	chat	\N	3	2026-02-12 00:57:11.492+00	2026-02-12 00:57:11.492+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB0486A252E80EEA45141","_serialized":"true_7202811162779@lid_3EB0486A252E80EEA45141"},"type":"chat","timestamp":1770847826,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07489A397A40323E8C1	276361249	3	t	chat	\N	3	2026-02-12 00:57:12.158+00	2026-02-12 00:57:12.158+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB07489A397A40323E8C1","_serialized":"true_7202811162779@lid_3EB07489A397A40323E8C1"},"type":"chat","timestamp":1770847842,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04772BBDE974C0B1D8E	tela 3	3	t	chat	\N	3	2026-02-12 00:57:12.48+00	2026-02-12 00:57:12.48+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB04772BBDE974C0B1D8E","_serialized":"true_7202811162779@lid_3EB04772BBDE974C0B1D8E"},"type":"chat","timestamp":1770847887,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C0614AF2D6C9D8EA6C	tava demorando para conectar	3	t	chat	\N	3	2026-02-12 00:57:13.015+00	2026-02-12 00:57:13.015+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB0C0614AF2D6C9D8EA6C","_serialized":"true_7202811162779@lid_3EB0C0614AF2D6C9D8EA6C"},"type":"chat","timestamp":1770848051,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5125716ACC3AFC3079AFDF9D15BA2AA	So adequar uns erros que vi	3	t	chat	\N	3	2026-02-12 00:43:54.269+00	2026-02-12 01:17:26.811+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"A5125716ACC3AFC3079AFDF9D15BA2AA","_serialized":"true_7202811162779@lid_A5125716ACC3AFC3079AFDF9D15BA2AA"},"type":"chat","timestamp":1770857032,"from":"556592694840@c.us","to":"7202811162779@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CD4B8E0118DB2BD994	pronto	0	t	chat	\N	4	2026-02-12 00:57:12.683+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3EB0CD4B8E0118DB2BD994","_serialized":"false_7202811162779@lid_3EB0CD4B8E0118DB2BD994"},"type":"chat","timestamp":1770848040,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DB908B48BDFE213350	eu tinha feito certo né?	3	t	chat	\N	3	2026-02-12 00:57:13.529+00	2026-02-12 00:57:13.529+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"3EB0DB908B48BDFE213350","_serialized":"true_7202811162779@lid_3EB0DB908B48BDFE213350"},"type":"chat","timestamp":1770848057,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5CF294947DABD5AD934EE7BF74B37EE	Blz	1	f	chat	\N	11	2026-02-12 12:57:35.867+00	2026-02-12 12:57:35.944+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5CF294947DABD5AD934EE7BF74B37EE","_serialized":"false_164703422648560@lid_A5CF294947DABD5AD934EE7BF74B37EE"},"type":"chat","timestamp":1770901054,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0AF3189888C8DE5A30E	*Admin:*\nTeste	3	t	chat	\N	3	2026-02-12 01:42:54.762+00	2026-02-12 01:43:39.116+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB0AF3189888C8DE5A30E","_serialized":"true_164703422648560@lid_3EB0AF3189888C8DE5A30E"},"type":"chat","timestamp":1770860572,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A57CFE233883E271C55	Boa noite!	0	f	chat	\N	2	2026-02-12 00:57:17.173+00	2026-02-12 00:57:17.173+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3A57CFE233883E271C55","_serialized":"false_47554028900535@lid_3A57CFE233883E271C55"},"type":"chat","timestamp":1768428365,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00419BBE8BA41D8BECD	*LJFER01:*\nBoa noite!	3	t	chat	\N	3	2026-02-12 00:57:17.579+00	2026-02-12 00:57:17.579+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00419BBE8BA41D8BECD","_serialized":"true_47554028900535@lid_3EB00419BBE8BA41D8BECD"},"type":"chat","timestamp":1768428382,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00819BBE8BFD5CDE2DD	*LJFER01:*\nComo posso ajuda-lo?	3	t	chat	\N	3	2026-02-12 00:57:18.186+00	2026-02-12 00:57:18.186+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00819BBE8BFD5CDE2DD","_serialized":"true_47554028900535@lid_3EB00819BBE8BFD5CDE2DD"},"type":"chat","timestamp":1768428404,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919BBE8CBC5DBD22A	*LJFER01:*\nEstou enviando o orçamento	3	t	chat	\N	3	2026-02-12 00:57:18.578+00	2026-02-12 00:57:18.578+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00919BBE8CBC5DBD22A","_serialized":"true_47554028900535@lid_3EB00919BBE8CBC5DBD22A"},"type":"chat","timestamp":1768428453,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5581C051C43CAF11F9827433C95BD3E		3	t	image	1770857843091-3cw44.jpeg	3	2026-02-12 00:57:23.103+00	2026-02-12 00:57:23.103+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"A5581C051C43CAF11F9827433C95BD3E","_serialized":"true_47554028900535@lid_A5581C051C43CAF11F9827433C95BD3E"},"type":"image","timestamp":1768428470,"from":"556592694840@c.us","to":"47554028900535@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00819BBE8D42EF473F8	*LJFER01:*\nTenho esse medicamento ao valor 40,00	3	t	chat	\N	3	2026-02-12 00:57:24.504+00	2026-02-12 00:57:24.504+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00819BBE8D42EF473F8","_serialized":"true_47554028900535@lid_3EB00819BBE8D42EF473F8"},"type":"chat","timestamp":1768428488,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53F31F7311FCDE53841B00E91F5F9F8	Lkkk	3	t	chat	\N	3	2026-02-12 00:57:16.506+00	2026-02-12 01:17:26.756+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"A53F31F7311FCDE53841B00E91F5F9F8","_serialized":"true_7202811162779@lid_A53F31F7311FCDE53841B00E91F5F9F8"},"type":"chat","timestamp":1770856183,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A54EE0F148A250EC66C680F9113B6527		3	t	image	1770857835485-cmvxru.jpeg	3	2026-02-12 00:57:15.593+00	2026-02-12 01:17:26.869+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"A54EE0F148A250EC66C680F9113B6527","_serialized":"true_7202811162779@lid_A54EE0F148A250EC66C680F9113B6527"},"type":"image","timestamp":1770856177,"from":"556592694840@c.us","to":"7202811162779@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05470A2C6AB085AFC8E	cara nem sei o que eu fiz na verdade	0	t	chat	\N	4	2026-02-12 00:57:13.998+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3EB05470A2C6AB085AFC8E","_serialized":"false_7202811162779@lid_3EB05470A2C6AB085AFC8E"},"type":"chat","timestamp":1770848079,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52C21DC82E133B8E10D3767080D9295	Vou logo la entao	1	f	chat	\N	11	2026-02-12 12:57:38.468+00	2026-02-12 12:57:38.495+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A52C21DC82E133B8E10D3767080D9295","_serialized":"false_164703422648560@lid_A52C21DC82E133B8E10D3767080D9295"},"type":"chat","timestamp":1770901057,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB00419BBE8D60437D34A	*LJFER01:*\ncom entrega 2 reais	3	t	chat	\N	3	2026-02-12 00:57:25.025+00	2026-02-12 00:57:25.025+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00419BBE8D60437D34A","_serialized":"true_47554028900535@lid_3EB00419BBE8D60437D34A"},"type":"chat","timestamp":1768428495,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00019BBE8D8A8762096	*LJFER01:*\nbeleza pode entregar	3	t	chat	\N	3	2026-02-12 00:57:25.414+00	2026-02-12 00:57:25.414+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00019BBE8D8A8762096","_serialized":"true_47554028900535@lid_3EB00019BBE8D8A8762096"},"type":"chat","timestamp":1768428506,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919BBE8F28B2FDCDA	*LJFER01:*\nAgradecemos seu contato, e estaremos sempre à disposição.😉	3	t	chat	\N	3	2026-02-12 00:57:25.758+00	2026-02-12 00:57:25.758+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"47554028900535@lid","id":"3EB00919BBE8F28B2FDCDA","_serialized":"true_47554028900535@lid_3EB00919BBE8F28B2FDCDA"},"type":"chat","timestamp":1768428614,"from":"556592694840@c.us","to":"47554028900535@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CB39DCE1404326F964	UNIFI: marcos.barbosa@gcollab.com.br	0	f	chat	\N	2	2026-02-12 00:57:25.947+00	2026-02-12 00:57:25.947+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3EB0CB39DCE1404326F964","_serialized":"false_47554028900535@lid_3EB0CB39DCE1404326F964"},"type":"chat","timestamp":1768501816,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A1BEF9939A476C7D93	Senha: Bigmaster@123	0	f	chat	\N	2	2026-02-12 00:57:26.155+00	2026-02-12 00:57:26.155+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3EB0A1BEF9939A476C7D93","_serialized":"false_47554028900535@lid_3EB0A1BEF9939A476C7D93"},"type":"chat","timestamp":1768501819,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AF7121CCA131E0D5F9D		0	f	chat	\N	2	2026-02-12 00:57:26.355+00	2026-02-12 00:57:26.355+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3AF7121CCA131E0D5F9D","_serialized":"false_47554028900535@lid_3AF7121CCA131E0D5F9D"},"type":"revoked","timestamp":1768516665,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4A29699DF2331B7AD107	CNH-e.pdf.pdf	0	f	document	1770857849589-zvffd9.pdf	2	2026-02-12 00:57:29.592+00	2026-02-12 00:57:29.592+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"4A29699DF2331B7AD107","_serialized":"false_47554028900535@lid_4A29699DF2331B7AD107"},"type":"document","timestamp":1769016006,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4A8D20C4E509A2627B6C	Documento Único assinado.pdf	0	f	document	1770857850223-lhndlp.pdf	2	2026-02-12 00:57:30.23+00	2026-02-12 00:57:30.23+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"4A8D20C4E509A2627B6C","_serialized":"false_47554028900535@lid_4A8D20C4E509A2627B6C"},"type":"document","timestamp":1770667198,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4A645B2213CD78C891FA	https://bvsms.saude.gov.br/bvs/saudelegis/anvisa/2008/rdc0096_17_12_2008.html?utm_source=chatgpt.com	0	f	chat	\N	2	2026-02-12 00:57:30.461+00	2026-02-12 00:57:30.461+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"4A645B2213CD78C891FA","_serialized":"false_47554028900535@lid_4A645B2213CD78C891FA"},"type":"chat","timestamp":1770759658,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DC38F5435C6568A9C1		0	f	chat	\N	2	2026-02-12 00:57:30.642+00	2026-02-12 00:57:30.642+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3EB0DC38F5435C6568A9C1","_serialized":"false_47554028900535@lid_3EB0DC38F5435C6568A9C1"},"type":"revoked","timestamp":1770761667,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4A3D45EF140E502E7CAF	ComprovanteSantander-1770832314.359216.pdf	0	f	document	1770857851090-tiwew.pdf	2	2026-02-12 00:57:31.092+00	2026-02-12 00:57:31.092+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"4A3D45EF140E502E7CAF","_serialized":"false_47554028900535@lid_4A3D45EF140E502E7CAF"},"type":"document","timestamp":1770832328,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB075EEC04196279E16DA		0	f	chat	\N	2	2026-02-12 00:57:31.321+00	2026-02-12 00:57:31.321+00	f	f	2	\N	1	\N	{"id":{"fromMe":false,"remote":"47554028900535@lid","id":"3EB075EEC04196279E16DA","_serialized":"false_47554028900535@lid_3EB075EEC04196279E16DA"},"type":"revoked","timestamp":1770849847,"from":"47554028900535@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AD7D0075ED110C929C5	🌹🌹	0	f	chat	\N	5	2026-02-12 00:57:32.817+00	2026-02-12 00:57:32.817+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3AD7D0075ED110C929C5","_serialized":"false_74758267867267@lid_3AD7D0075ED110C929C5"},"type":"chat","timestamp":1770850100,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A44661DC4DDF9709B4	Os admiradores	2	t	chat	\N	3	2026-02-12 00:57:33.228+00	2026-02-12 00:57:33.228+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB0A44661DC4DDF9709B4","_serialized":"true_74758267867267@lid_3EB0A44661DC4DDF9709B4"},"type":"chat","timestamp":1770850101,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3ABA9806CF5F3E263D82	Kkkkk	0	f	chat	\N	5	2026-02-12 00:57:33.478+00	2026-02-12 00:57:33.478+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3ABA9806CF5F3E263D82","_serialized":"false_74758267867267@lid_3ABA9806CF5F3E263D82"},"type":"chat","timestamp":1770850102,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C12A6FD7E851AD3590	as flores	2	t	chat	\N	3	2026-02-12 00:57:34.139+00	2026-02-12 00:57:34.139+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB0C12A6FD7E851AD3590","_serialized":"true_74758267867267@lid_3EB0C12A6FD7E851AD3590"},"type":"chat","timestamp":1770850103,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FEE2DC433B712C6DBB	kkk	2	t	chat	\N	3	2026-02-12 00:57:34.826+00	2026-02-12 00:57:34.826+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB0FEE2DC433B712C6DBB","_serialized":"true_74758267867267@lid_3EB0FEE2DC433B712C6DBB"},"type":"chat","timestamp":1770850104,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A11C47B8D43DD836F4A	Deus é pai	0	f	chat	\N	5	2026-02-12 00:57:35.03+00	2026-02-12 00:57:35.03+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A11C47B8D43DD836F4A","_serialized":"false_74758267867267@lid_3A11C47B8D43DD836F4A"},"type":"chat","timestamp":1770850107,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AB0A20C7196F1B8AEE0	Só desses que arrumo	0	f	chat	\N	5	2026-02-12 00:57:35.24+00	2026-02-12 00:57:35.24+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3AB0A20C7196F1B8AEE0","_serialized":"false_74758267867267@lid_3AB0A20C7196F1B8AEE0"},"type":"chat","timestamp":1770850113,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A682AECD8DED8595622	Mkkk	0	f	chat	\N	5	2026-02-12 00:57:35.458+00	2026-02-12 00:57:35.458+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A682AECD8DED8595622","_serialized":"false_74758267867267@lid_3A682AECD8DED8595622"},"type":"chat","timestamp":1770850115,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08A359158BF5F6E2DDE	calma	2	t	chat	\N	3	2026-02-12 00:57:35.874+00	2026-02-12 00:57:35.874+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB08A359158BF5F6E2DDE","_serialized":"true_74758267867267@lid_3EB08A359158BF5F6E2DDE"},"type":"chat","timestamp":1770850122,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB033B734A863672639B8	vai evoluindo	2	t	chat	\N	3	2026-02-12 00:57:36.259+00	2026-02-12 00:57:36.259+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB033B734A863672639B8","_serialized":"true_74758267867267@lid_3EB033B734A863672639B8"},"type":"chat","timestamp":1770850126,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A98DD0BA41F21DDD467	Kkkkk	0	f	chat	\N	5	2026-02-12 00:57:36.438+00	2026-02-12 00:57:36.438+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A98DD0BA41F21DDD467","_serialized":"false_74758267867267@lid_3A98DD0BA41F21DDD467"},"type":"chat","timestamp":1770850126,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB024283DE8F832A625A9	motoqueiro hoje	2	t	chat	\N	3	2026-02-12 00:57:36.819+00	2026-02-12 00:57:36.819+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB024283DE8F832A625A9","_serialized":"true_74758267867267@lid_3EB024283DE8F832A625A9"},"type":"chat","timestamp":1770850129,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3ADDE1DBF3BC1B4B189B	Kkkkkk	0	f	chat	\N	5	2026-02-12 00:57:37.009+00	2026-02-12 00:57:37.009+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3ADDE1DBF3BC1B4B189B","_serialized":"false_74758267867267@lid_3ADDE1DBF3BC1B4B189B"},"type":"chat","timestamp":1770850130,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0698B468D67D446F6F9	pipoqueiro amanhã	2	t	chat	\N	3	2026-02-12 00:57:37.53+00	2026-02-12 00:57:37.53+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB0698B468D67D446F6F9","_serialized":"true_74758267867267@lid_3EB0698B468D67D446F6F9"},"type":"chat","timestamp":1770850134,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A4041F490AD7AFE4724	😂😂😂	0	f	chat	\N	5	2026-02-12 00:57:37.731+00	2026-02-12 00:57:37.731+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A4041F490AD7AFE4724","_serialized":"false_74758267867267@lid_3A4041F490AD7AFE4724"},"type":"chat","timestamp":1770850135,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A4DC458BA14A1AB55BB	Kkkkkk	0	f	chat	\N	5	2026-02-12 00:57:37.927+00	2026-02-12 00:57:37.927+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A4DC458BA14A1AB55BB","_serialized":"false_74758267867267@lid_3A4DC458BA14A1AB55BB"},"type":"chat","timestamp":1770850138,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A1A037B292B5866E15A	Não vou querer	0	f	chat	\N	5	2026-02-12 00:57:38.13+00	2026-02-12 00:57:38.13+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A1A037B292B5866E15A","_serialized":"false_74758267867267@lid_3A1A037B292B5866E15A"},"type":"chat","timestamp":1770850146,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CD9E3D100DF0139692	Me chama no meu outro	2	t	chat	\N	3	2026-02-12 00:57:38.554+00	2026-02-12 00:57:38.554+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB0CD9E3D100DF0139692","_serialized":"true_74758267867267@lid_3EB0CD9E3D100DF0139692"},"type":"chat","timestamp":1770850159,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA2EC6AC7C144317A41	Ok	0	f	chat	\N	5	2026-02-12 00:57:38.75+00	2026-02-12 00:57:38.75+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3AA2EC6AC7C144317A41","_serialized":"false_74758267867267@lid_3AA2EC6AC7C144317A41"},"type":"chat","timestamp":1770850164,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0327D127E62C8BC2212	pessoal me ver online já viu	2	t	chat	\N	3	2026-02-12 00:57:39.43+00	2026-02-12 00:57:39.43+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"3EB0327D127E62C8BC2212","_serialized":"true_74758267867267@lid_3EB0327D127E62C8BC2212"},"type":"chat","timestamp":1770850167,"from":"151909402964196@lid","to":"74758267867267@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB021DF16A0E2FAE97BB6	*Renan Araujo - Analista N2:*\nok	0	f	chat	\N	6	2026-02-12 00:57:40.216+00	2026-02-12 00:57:40.216+00	f	f	6	\N	1	\N	{"id":{"fromMe":false,"remote":"161696945598684@lid","id":"3EB021DF16A0E2FAE97BB6","_serialized":"false_161696945598684@lid_3EB021DF16A0E2FAE97BB6"},"type":"chat","timestamp":1770834621,"from":"161696945598684@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB063A443C43BB8163048	Renan	3	t	chat	\N	3	2026-02-12 00:57:40.771+00	2026-02-12 00:57:40.771+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB063A443C43BB8163048","_serialized":"true_161696945598684@lid_3EB063A443C43BB8163048"},"type":"chat","timestamp":1770837745,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EF30404C281288E5DD	estou com uma situação	3	t	chat	\N	3	2026-02-12 00:57:41.626+00	2026-02-12 00:57:41.626+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0EF30404C281288E5DD","_serialized":"true_161696945598684@lid_3EB0EF30404C281288E5DD"},"type":"chat","timestamp":1770837748,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00775B045FCBD0129B1	a RH nossa	3	t	chat	\N	3	2026-02-12 00:57:42.146+00	2026-02-12 00:57:42.146+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB00775B045FCBD0129B1","_serialized":"true_161696945598684@lid_3EB00775B045FCBD0129B1"},"type":"chat","timestamp":1770837751,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C1EDB39120C00493D4	usa o note e o computador	3	t	chat	\N	3	2026-02-12 00:57:42.874+00	2026-02-12 00:57:42.874+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0C1EDB39120C00493D4","_serialized":"true_161696945598684@lid_3EB0C1EDB39120C00493D4"},"type":"chat","timestamp":1770837755,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB043DABB027A2D3396F5	para poder operar	3	t	chat	\N	3	2026-02-12 00:57:43.485+00	2026-02-12 00:57:43.485+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB043DABB027A2D3396F5","_serialized":"true_161696945598684@lid_3EB043DABB027A2D3396F5"},"type":"chat","timestamp":1770837758,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0643E84D02FE9A6391C	ela salva na pasta no computador dela	3	t	chat	\N	3	2026-02-12 00:57:44.032+00	2026-02-12 00:57:44.032+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0643E84D02FE9A6391C","_serialized":"true_161696945598684@lid_3EB0643E84D02FE9A6391C"},"type":"chat","timestamp":1770837770,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F5D9CD17BBC5AA6678	vai para o nextcloud certinho	3	t	chat	\N	3	2026-02-12 00:57:44.719+00	2026-02-12 00:57:44.719+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0F5D9CD17BBC5AA6678","_serialized":"true_161696945598684@lid_3EB0F5D9CD17BBC5AA6678"},"type":"chat","timestamp":1770837775,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB077830F8BD8A5129730	agora quando está no note está uma expecífica	3	t	chat	\N	3	2026-02-12 00:57:45.719+00	2026-02-12 00:57:45.719+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB077830F8BD8A5129730","_serialized":"true_161696945598684@lid_3EB077830F8BD8A5129730"},"type":"chat","timestamp":1770837783,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04E653CFD968ECBC57C	como eu deixo o acesso igual do computador	3	t	chat	\N	3	2026-02-12 00:57:46.457+00	2026-02-12 00:57:46.457+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB04E653CFD968ECBC57C","_serialized":"true_161696945598684@lid_3EB04E653CFD968ECBC57C"},"type":"chat","timestamp":1770837792,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B5AA602C246785A52A	*Renan Araujo - Analista N2:*\ncomo esta no notebook ?	0	f	chat	\N	6	2026-02-12 00:57:46.78+00	2026-02-12 00:57:46.78+00	f	f	6	\N	1	\N	{"id":{"fromMe":false,"remote":"161696945598684@lid","id":"3EB0B5AA602C246785A52A","_serialized":"false_161696945598684@lid_3EB0B5AA602C246785A52A"},"type":"chat","timestamp":1770842659,"from":"161696945598684@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB043FDD47CA3DE3A0B58	Ok	0	f	chat	\N	7	2026-02-12 00:57:55.986+00	2026-02-12 00:57:55.986+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"3EB043FDD47CA3DE3A0B58","_serialized":"false_96422519132403@lid_3EB043FDD47CA3DE3A0B58"},"type":"chat","timestamp":1770838166,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A64A4621DF717576F6	*Renan Araujo - Analista N2:*\nconsegue me mandar uma foto dos dois	0	f	chat	\N	6	2026-02-12 00:57:47.071+00	2026-02-12 00:57:47.071+00	f	f	6	\N	1	\N	{"id":{"fromMe":false,"remote":"161696945598684@lid","id":"3EB0A64A4621DF717576F6","_serialized":"false_161696945598684@lid_3EB0A64A4621DF717576F6"},"type":"chat","timestamp":1770842667,"from":"161696945598684@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0D1CD94C911DC0C6D0B	eu deixei copiando lá	3	t	chat	\N	3	2026-02-12 00:57:47.912+00	2026-02-12 00:57:47.912+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0D1CD94C911DC0C6D0B","_serialized":"true_161696945598684@lid_3EB0D1CD94C911DC0C6D0B"},"type":"chat","timestamp":1770842728,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F704213DCBB3F45FDD	me localizei	3	t	chat	\N	3	2026-02-12 00:57:48.616+00	2026-02-12 00:57:48.616+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0F704213DCBB3F45FDD","_serialized":"true_161696945598684@lid_3EB0F704213DCBB3F45FDD"},"type":"chat","timestamp":1770842730,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0053B2B11D271967048	*Renan Araujo - Analista N2:*\nblz	0	f	chat	\N	6	2026-02-12 00:57:48.99+00	2026-02-12 00:57:48.99+00	f	f	6	\N	1	\N	{"id":{"fromMe":false,"remote":"161696945598684@lid","id":"3EB0053B2B11D271967048","_serialized":"false_161696945598684@lid_3EB0053B2B11D271967048"},"type":"chat","timestamp":1770842755,"from":"161696945598684@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05F9D168A106F2F664D	*Renan Araujo - Analista N2:*\najudo em algo mais ?	0	f	chat	\N	6	2026-02-12 00:57:49.298+00	2026-02-12 00:57:49.298+00	f	f	6	\N	1	\N	{"id":{"fromMe":false,"remote":"161696945598684@lid","id":"3EB05F9D168A106F2F664D","_serialized":"false_161696945598684@lid_3EB05F9D168A106F2F664D"},"type":"chat","timestamp":1770845573,"from":"161696945598684@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB037C207CDA0BB871E1A	Renan	2	t	chat	\N	3	2026-02-12 00:57:49.746+00	2026-02-12 00:57:49.746+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB037C207CDA0BB871E1A","_serialized":"true_161696945598684@lid_3EB037C207CDA0BB871E1A"},"type":"chat","timestamp":1770846437,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
6A95BE177BC08B7ECDB8	Olá! 👋\n\nNosso horário de atendimento é de segunda a domingo, das 07:30 às 17:30.\nFora desse período, as respostas podem levar um pouco mais de tempo, mas nossa equipe retornará assim que possível.\n\nAgradecemos a compreensão! 😊\nRise Solutions Network	0	f	chat	\N	6	2026-02-12 00:57:50.342+00	2026-02-12 00:57:50.342+00	f	f	6	\N	1	\N	{"id":{"fromMe":false,"remote":"161696945598684@lid","id":"6A95BE177BC08B7ECDB8","_serialized":"false_161696945598684@lid_6A95BE177BC08B7ECDB8"},"type":"chat","timestamp":1770846439,"from":"161696945598684@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CBDAB0E6B1050B1C35	quero conectar o VScode como docker	2	t	chat	\N	3	2026-02-12 00:57:50.979+00	2026-02-12 00:57:50.979+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB0CBDAB0E6B1050B1C35","_serialized":"true_161696945598684@lid_3EB0CBDAB0E6B1050B1C35"},"type":"chat","timestamp":1770846448,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07C8D905B1DAA7C6589	mudei de note aqui	2	t	chat	\N	3	2026-02-12 00:57:51.466+00	2026-02-12 00:57:51.466+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161696945598684@lid","id":"3EB07C8D905B1DAA7C6589","_serialized":"true_161696945598684@lid_3EB07C8D905B1DAA7C6589"},"type":"chat","timestamp":1770846451,"from":"151909402964196@lid","to":"161696945598684@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00C1B0F3553198104A5		0	f	image	1770857872943-9925v.jpeg	7	2026-02-12 00:57:52.945+00	2026-02-12 00:57:52.945+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"3EB00C1B0F3553198104A5","_serialized":"false_96422519132403@lid_3EB00C1B0F3553198104A5"},"type":"image","timestamp":1770837211,"from":"96422519132403@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB079A174C3957D6748B1	deixa sincronizando	2	t	chat	\N	3	2026-02-12 00:57:53.479+00	2026-02-12 00:57:53.479+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB079A174C3957D6748B1","_serialized":"true_96422519132403@lid_3EB079A174C3957D6748B1"},"type":"chat","timestamp":1770838036,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F1A0FD176503ABF0DD	Olk	0	f	chat	\N	7	2026-02-12 00:57:53.671+00	2026-02-12 00:57:53.671+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"3EB0F1A0FD176503ABF0DD","_serialized":"false_96422519132403@lid_3EB0F1A0FD176503ABF0DD"},"type":"chat","timestamp":1770838057,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0263CE1EEB03E58EA9A	Do nextcloud	2	t	chat	\N	3	2026-02-12 00:57:54.652+00	2026-02-12 00:57:54.652+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0263CE1EEB03E58EA9A","_serialized":"true_96422519132403@lid_3EB0263CE1EEB03E58EA9A"},"type":"chat","timestamp":1770838130,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C878D66EC31436B65D	usuário é o seu e-mail do rh@drogariasbigmaster.com.br\nSenha: rhbigmaster	2	t	chat	\N	3	2026-02-12 00:57:55.806+00	2026-02-12 00:57:55.806+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0C878D66EC31436B65D","_serialized":"true_96422519132403@lid_3EB0C878D66EC31436B65D"},"type":"chat","timestamp":1770838150,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB042192A068CD16939ED	libera ai	2	t	chat	\N	3	2026-02-12 00:57:56.506+00	2026-02-12 00:57:56.506+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB042192A068CD16939ED","_serialized":"true_96422519132403@lid_3EB042192A068CD16939ED"},"type":"chat","timestamp":1770842875,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A2268285E3726B57EE	Agora sim	2	t	chat	\N	3	2026-02-12 00:57:57.191+00	2026-02-12 00:57:57.191+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0A2268285E3726B57EE","_serialized":"true_96422519132403@lid_3EB0A2268285E3726B57EE"},"type":"chat","timestamp":1770842919,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B6DE99B6DFC0286EB5	o note e o computador	2	t	chat	\N	3	2026-02-12 00:57:58.022+00	2026-02-12 00:57:58.022+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0B6DE99B6DFC0286EB5","_serialized":"true_96422519132403@lid_3EB0B6DE99B6DFC0286EB5"},"type":"chat","timestamp":1770842923,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07089D034CB9C234072	tudo sincronizado	2	t	chat	\N	3	2026-02-12 00:57:58.659+00	2026-02-12 00:57:58.659+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB07089D034CB9C234072","_serialized":"true_96422519132403@lid_3EB07089D034CB9C234072"},"type":"chat","timestamp":1770842926,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB499D9C92F5EA64380DFDD09B0D7E3	🙏🙏🙏	0	f	chat	\N	7	2026-02-12 00:57:58.874+00	2026-02-12 00:57:58.874+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"ACB499D9C92F5EA64380DFDD09B0D7E3","_serialized":"false_96422519132403@lid_ACB499D9C92F5EA64380DFDD09B0D7E3"},"type":"chat","timestamp":1770842939,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC490252A9E4087FBC5C058DF0DF29ED	Demanda pendente comigo	0	f	chat	\N	7	2026-02-12 00:57:59.071+00	2026-02-12 00:57:59.071+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"AC490252A9E4087FBC5C058DF0DF29ED","_serialized":"false_96422519132403@lid_AC490252A9E4087FBC5C058DF0DF29ED"},"type":"chat","timestamp":1770842961,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC0C99C6C26AB29C388714F76D43DB15	e-mail da Big	0	f	chat	\N	7	2026-02-12 00:57:59.263+00	2026-02-12 00:57:59.263+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"AC0C99C6C26AB29C388714F76D43DB15","_serialized":"false_96422519132403@lid_AC0C99C6C26AB29C388714F76D43DB15"},"type":"chat","timestamp":1770842971,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00EDED063AB03DC5993	é o Lucas nesse caso	2	t	chat	\N	3	2026-02-12 00:58:00.589+00	2026-02-12 00:58:00.589+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB00EDED063AB03DC5993","_serialized":"true_96422519132403@lid_3EB00EDED063AB03DC5993"},"type":"chat","timestamp":1770842991,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACA7A75C86563B615E1DB141AEA4FDD7	Para Collab que não envia só recebe	0	f	chat	\N	7	2026-02-12 00:58:00.964+00	2026-02-12 00:58:00.964+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"ACA7A75C86563B615E1DB141AEA4FDD7","_serialized":"false_96422519132403@lid_ACA7A75C86563B615E1DB141AEA4FDD7"},"type":"chat","timestamp":1770842996,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06F8C504D2A6F54912A	eu não tenho o contato	2	t	chat	\N	3	2026-02-12 00:58:01.577+00	2026-02-12 00:58:01.577+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB06F8C504D2A6F54912A","_serialized":"true_96422519132403@lid_3EB06F8C504D2A6F54912A"},"type":"chat","timestamp":1770842996,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC49DE5B6491F970606BE9FF5F69CC45	Sério 😟😟	0	f	chat	\N	7	2026-02-12 00:58:01.791+00	2026-02-12 00:58:01.791+00	f	f	7	\N	1	\N	{"id":{"fromMe":false,"remote":"96422519132403@lid","id":"AC49DE5B6491F970606BE9FF5F69CC45","_serialized":"false_96422519132403@lid_AC49DE5B6491F970606BE9FF5F69CC45"},"type":"chat","timestamp":1770843014,"from":"96422519132403@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EAFEB29231C16FC4B7	Sim	2	t	chat	\N	3	2026-02-12 00:58:02.526+00	2026-02-12 00:58:02.526+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0EAFEB29231C16FC4B7","_serialized":"true_96422519132403@lid_3EB0EAFEB29231C16FC4B7"},"type":"chat","timestamp":1770843038,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C9F3CEFC013A26C4F0	só com o Lucas	2	t	chat	\N	3	2026-02-12 00:58:03.479+00	2026-02-12 00:58:03.479+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0C9F3CEFC013A26C4F0","_serialized":"true_96422519132403@lid_3EB0C9F3CEFC013A26C4F0"},"type":"chat","timestamp":1770843040,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A51635B21868B2B320	ele tem o contato do rapaz	2	t	chat	\N	3	2026-02-12 00:58:04.007+00	2026-02-12 00:58:04.007+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"96422519132403@lid","id":"3EB0A51635B21868B2B320","_serialized":"true_96422519132403@lid_3EB0A51635B21868B2B320"},"type":"chat","timestamp":1770843043,"from":"151909402964196@lid","to":"96422519132403@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB020AF867CC6B20D288D	se nao tiver almocando!	0	f	chat	\N	8	2026-02-12 00:58:04.612+00	2026-02-12 00:58:04.612+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB020AF867CC6B20D288D","_serialized":"false_82816280854646@lid_3EB020AF867CC6B20D288D"},"type":"chat","timestamp":1767974853,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5CB28FED7ED5748B5F4E02458C859A4	Almoçando	3	t	chat	\N	3	2026-02-12 00:58:05.323+00	2026-02-12 00:58:05.323+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"A5CB28FED7ED5748B5F4E02458C859A4","_serialized":"true_82816280854646@lid_A5CB28FED7ED5748B5F4E02458C859A4"},"type":"chat","timestamp":1767974918,"from":"556592694840@c.us","to":"82816280854646@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5B92FA5EB0FC8D6955F551EB5E5CABB	Te ligo daqui a pouco	3	t	chat	\N	3	2026-02-12 00:58:05.887+00	2026-02-12 00:58:05.887+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"A5B92FA5EB0FC8D6955F551EB5E5CABB","_serialized":"true_82816280854646@lid_A5B92FA5EB0FC8D6955F551EB5E5CABB"},"type":"chat","timestamp":1767974922,"from":"556592694840@c.us","to":"82816280854646@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A83AD575EF21DE84B6	vou almocar qdo chegar te chamo ta	0	f	chat	\N	8	2026-02-12 00:58:06.089+00	2026-02-12 00:58:06.089+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB0A83AD575EF21DE84B6","_serialized":"false_82816280854646@lid_3EB0A83AD575EF21DE84B6"},"type":"chat","timestamp":1767974945,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03501F09DF869320D3D	obg	0	f	chat	\N	8	2026-02-12 00:58:06.285+00	2026-02-12 00:58:06.285+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB03501F09DF869320D3D","_serialized":"false_82816280854646@lid_3EB03501F09DF869320D3D"},"type":"chat","timestamp":1767974948,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC04C8636D4925E826C6699F6704D7EE	BEGIN:VCARD\nVERSION:3.0\nN:;;;;\nFN:Pauline Gerente PALMIRO\nitem1.TEL;waid=556599100170:+55 65 9910-0170\nitem1.X-ABLabel:Celular\nPHOTO;BASE64:/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAH4AABAAEAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAAAABRnWFlaAAABKAAAABRiWFlaAAABPAAAABR3dHB0AAABUAAAABRyVFJDAAABZAAAAChnVFJDAAABZAAAAChiVFJDAAABZAAAAChjcHJ0AAABjAAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAHMAUgBHAEJYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9YWVogAAAAAAAA9tYAAQAAAADTLXBhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABtbHVjAAAAAAAAAAEAAAAMZW5VUwAAACAAAAAcAEcAbwBvAGcAbABlACAASQBuAGMALgAgADIAMAAxADb/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCABgAGADASIAAhEBAxEB/8QAHAAAAwEBAQEBAQAAAAAAAAAABAUGAwcCAQAI/8QAOhAAAgEDAgMFBQYFBAMAAAAAAQIDAAQRBSEGEjETQVFhkSJxgbHBBxQVIzKhQmJy4fAkQ1LRc8Lx/8QAGgEAAgMBAQAAAAAAAAAAAAAAAwQBAgUABv/EACERAAICAgICAwEAAAAAAAAAAAABAgMRIQQxEkEiIzJR/9oADAMBAAIRAxEAPwDS01CLU7TmBAfvFbQJmp+HRLq3uh2DlPI1SWMEyLibBbyoe/ZbXoISKiUhr1GlEKML0qUQ2KtT1C10W0e6upOVQNhnqfAVyPUtdvNcvC7yMIskrGDsBT3iN73X+LDp8aFkhOADuB4mqfTuArWO2/PLGUjqO6olYloZp48pbOWGaWJhgECj9N1e7sp1ktp5EOc7HY/Dvq7v/s3WV+a2nKjwIqT1fhi70ecJIAwO6MvfioU0y86ZR7Rb6TxXHq8C2tyqx3XUEfpceXn5U+0uEGV8eNce7V7dI542KuhDAjuP+fKutcG3o1PTVuv4jsw8CKNB50JXQ8doP4gHZ2EX/k+hqakGVql19i9jHv0l+hqcbpQbv2O8VfSUUkKx9+ffWSAFsUZOhKkigg2HpnkQUXoyOHY5x2MrKDtTgLk0Zd2b2lnLO6gKiFjv4VhpMuJwPOi+N79LPhmZww9scuR6n9gaGnhDSj5SIDhezSa+vr8rlpJeQN4gdT659KuIothUNwfqsFtoFvJdJKoYszSCMlQSxPWryxura8hEltMkqeKnNIzzk3afFQSR77Ek1McYWPPYLMFBaJwarzgLnNINcnhezlXtUJUZI5hmuXZeWHFpnGNTg7C67HcLJ05u4Hpn41efZWzLaXtu3VXDAe/P/VJOMdP5J7a7UYEm2PDGD/7U4+z4/dtdki6CSEnHjg/3pquW0Y90fiys1qJ1sV5x/u/Q1NybA1X8RjNnH/X9DUlKmxql+rA/Ff0IriqSRN7WCKSSyBHqJi+0BxpDBGD3kmTjGy0ttuOLhZUS9KuGP6gMYp26SkY3GrlDXo6jaXGJNjSnjS7lm0xLQMSHyfdgVhpuoCco4OzV94gUvD22cqkLfAkgfLNLy1AdqX2I8Wek3g0Ozt7S4eHs4MEIQOZsdTt0zT/QbabT+QT8pldfzGAAyR7q+cPMJtJtZGPWJdz7qLncif2ASFHdSTk+j0CrWmgHWImvuaQxtIVU8kZdgpx3beNT7xpdac6S6ULOQIWWRCRjcjfz7/jVpZ8ssGQPaGxpZrmDaOgA5m2qVLGiHUnlkzro+8cOaPI5zIx5T6DPyofSLtdO4gsZifYcFD8aI1YMLXTYiM8kh+WKntRn7KYLvmKXY/AUWMjLsWco6xq8qz2kfKcjmz+1T1xHhTX7Sbs3SdnnIRehO4re8XlU11zzPJ3HXjVg/npXKL7DHn8vCtFkJjJfu6UztNNi/B5JjLy3DthV8q+6XoVzf3axiPKA+0R30dtCyhJFvo90U06znYMgIAOT1p9rU4/A5Wzu/sihbvTRb6NDC0RjjjYe0TXqNPxEwxpESiAELnvP+Z+FCnYmsIPXXJSzJDjhS+RrFLBjiWGJWX+ZCOvwP0oz8dijuZYJ4JVZDy5UZBqbeIW+v6SYSQqTCAEHuCEb+lWslhbzNmeEFhtzdKWbSZs8WUcYmjOy1WC7dobVZMoMsSuAKwm/1d8Ihvy9cdxP9ga9zNHY2ziBFijAOT5/WvOgAdmZWJZnJcsfTFcu8leRYkmoiDitkgexiB9rd/ge/wCfpU5PYyX92236pcE+X+Gm3Fk5u9Sa4yNh2USr4A7n3bmi7GP8yCFhuW52PjvsKIjNYZodssV1PIFIyMZ7jjFFag2FNHkhATSbUZc5qZ9la/ycSie8jmJ7AuM9GXNdm+zfTlutMa9uIFRy3Ko5cYApfbw2+QRDHn3Vd6SUtNHWQAAdcCr3S+BHFinZkTcVwJLJDZI6gkdo6nuHQE/v6VhpX3S0tpktn7SVv1zEbe5aEe/E/El5c3IJgx2Kgd3L1J+OawacRTpBHgSSBQWBLBfifjvS66wHcnKTkeSjfjFigTHK/PjrsNh9avu3RBLlh129KktHVpr2e5C5CMEQnwA/vRgS9fUZpZsdkchR8jQ32OQWIgOv3gmm7BXJwNwvj4UTLcSabo0UEWDdTJhRnAHiT5b0vkteS8BRS08p5U26An50RxIbe2u7SaZ2CLHyqAMknNEX8F7Hlk/c25+9w2/advM28j+O3yp6iLBeQsD/AAc3vyP/ALU/fXiaeyXLp2StgRxsfbc+J91CprUkqxtHIeaIlF816jPqaIuxd70i+uJQLZWBzmp+8l5ia1h1QXVksRTlddzg7eFBTnJrpPLOhFpYYDBqUKKjZJB8BVlbaoo4Y+84ISJS2D34qPtLRWjTKjAplxHdCz4YhtY8Brhun8o3P74q93SA0z8FKX8RvpzxahoMKwr+ehIkbkyebqTnzom10OeR15du5ifDv38ahNP1K6sXDQSlSO4jI9DXTOHeKLLU4kglKW90BgxnZW/p/wCqXefQTi8mFmIy0xlZ6YLKARqMgbk+dY3TtEjHl6AmnLXdusfKZU5z0XO9K9TkjQxgDLuSF+tDNPy0I+YCRblmAIUhPEsdv23NDa1dtLPA8ZVOSMksQCVyT09K832lX82oLevJ2dqifrZhjHkPGlU84mu5gDkDBXvAHT60RMVmT19bXFxeidHluWByCy7D1ptpGhSXM4kEQjXmDMoGy1daba2F3psbuEyFw6gAYPfWlpZxWgMaPzR92eoqHY3ovGjG2IrrT1s4hIoA5zg4pXIap+IVCWUZH/P6GpKaTFXj0Cs0z//Z\nEND:VCARD	0	f	vcard	\N	8	2026-02-12 00:58:06.463+00	2026-02-12 00:58:06.463+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"AC04C8636D4925E826C6699F6704D7EE","_serialized":"false_82816280854646@lid_AC04C8636D4925E826C6699F6704D7EE"},"type":"vcard","timestamp":1768835190,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":["BEGIN:VCARD\\nVERSION:3.0\\nN:;;;;\\nFN:Pauline Gerente PALMIRO\\nitem1.TEL;waid=556599100170:+55 65 9910-0170\\nitem1.X-ABLabel:Celular\\nPHOTO;BASE64:/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAH4AABAAEAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAAAABRnWFlaAAABKAAAABRiWFlaAAABPAAAABR3dHB0AAABUAAAABRyVFJDAAABZAAAAChnVFJDAAABZAAAAChiVFJDAAABZAAAAChjcHJ0AAABjAAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAHMAUgBHAEJYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9YWVogAAAAAAAA9tYAAQAAAADTLXBhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABtbHVjAAAAAAAAAAEAAAAMZW5VUwAAACAAAAAcAEcAbwBvAGcAbABlACAASQBuAGMALgAgADIAMAAxADb/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCABgAGADASIAAhEBAxEB/8QAHAAAAwEBAQEBAQAAAAAAAAAABAUGAwcCAQAI/8QAOhAAAgEDAgMFBQYFBAMAAAAAAQIDAAQRBSEGEjETQVFhkSJxgbHBBxQVIzKhQmJy4fAkQ1LRc8Lx/8QAGgEAAgMBAQAAAAAAAAAAAAAAAwQBAgUABv/EACERAAICAgICAwEAAAAAAAAAAAABAgMRIQQxEkEiIzJR/9oADAMBAAIRAxEAPwDS01CLU7TmBAfvFbQJmp+HRLq3uh2DlPI1SWMEyLibBbyoe/ZbXoISKiUhr1GlEKML0qUQ2KtT1C10W0e6upOVQNhnqfAVyPUtdvNcvC7yMIskrGDsBT3iN73X+LDp8aFkhOADuB4mqfTuArWO2/PLGUjqO6olYloZp48pbOWGaWJhgECj9N1e7sp1ktp5EOc7HY/Dvq7v/s3WV+a2nKjwIqT1fhi70ecJIAwO6MvfioU0y86ZR7Rb6TxXHq8C2tyqx3XUEfpceXn5U+0uEGV8eNce7V7dI542KuhDAjuP+fKutcG3o1PTVuv4jsw8CKNB50JXQ8doP4gHZ2EX/k+hqakGVql19i9jHv0l+hqcbpQbv2O8VfSUUkKx9+ffWSAFsUZOhKkigg2HpnkQUXoyOHY5x2MrKDtTgLk0Zd2b2lnLO6gKiFjv4VhpMuJwPOi+N79LPhmZww9scuR6n9gaGnhDSj5SIDhezSa+vr8rlpJeQN4gdT659KuIothUNwfqsFtoFvJdJKoYszSCMlQSxPWryxura8hEltMkqeKnNIzzk3afFQSR77Ek1McYWPPYLMFBaJwarzgLnNINcnhezlXtUJUZI5hmuXZeWHFpnGNTg7C67HcLJ05u4Hpn41efZWzLaXtu3VXDAe/P/VJOMdP5J7a7UYEm2PDGD/7U4+z4/dtdki6CSEnHjg/3pquW0Y90fiys1qJ1sV5x/u/Q1NybA1X8RjNnH/X9DUlKmxql+rA/Ff0IriqSRN7WCKSSyBHqJi+0BxpDBGD3kmTjGy0ttuOLhZUS9KuGP6gMYp26SkY3GrlDXo6jaXGJNjSnjS7lm0xLQMSHyfdgVhpuoCco4OzV94gUvD22cqkLfAkgfLNLy1AdqX2I8Wek3g0Ozt7S4eHs4MEIQOZsdTt0zT/QbabT+QT8pldfzGAAyR7q+cPMJtJtZGPWJdz7qLncif2ASFHdSTk+j0CrWmgHWImvuaQxtIVU8kZdgpx3beNT7xpdac6S6ULOQIWWRCRjcjfz7/jVpZ8ssGQPaGxpZrmDaOgA5m2qVLGiHUnlkzro+8cOaPI5zIx5T6DPyofSLtdO4gsZifYcFD8aI1YMLXTYiM8kh+WKntRn7KYLvmKXY/AUWMjLsWco6xq8qz2kfKcjmz+1T1xHhTX7Sbs3SdnnIRehO4re8XlU11zzPJ3HXjVg/npXKL7DHn8vCtFkJjJfu6UztNNi/B5JjLy3DthV8q+6XoVzf3axiPKA+0R30dtCyhJFvo90U06znYMgIAOT1p9rU4/A5Wzu/sihbvTRb6NDC0RjjjYe0TXqNPxEwxpESiAELnvP+Z+FCnYmsIPXXJSzJDjhS+RrFLBjiWGJWX+ZCOvwP0oz8dijuZYJ4JVZDy5UZBqbeIW+v6SYSQqTCAEHuCEb+lWslhbzNmeEFhtzdKWbSZs8WUcYmjOy1WC7dobVZMoMsSuAKwm/1d8Ihvy9cdxP9ga9zNHY2ziBFijAOT5/WvOgAdmZWJZnJcsfTFcu8leRYkmoiDitkgexiB9rd/ge/wCfpU5PYyX92236pcE+X+Gm3Fk5u9Sa4yNh2USr4A7n3bmi7GP8yCFhuW52PjvsKIjNYZodssV1PIFIyMZ7jjFFag2FNHkhATSbUZc5qZ9la/ycSie8jmJ7AuM9GXNdm+zfTlutMa9uIFRy3Ko5cYApfbw2+QRDHn3Vd6SUtNHWQAAdcCr3S+BHFinZkTcVwJLJDZI6gkdo6nuHQE/v6VhpX3S0tpktn7SVv1zEbe5aEe/E/El5c3IJgx2Kgd3L1J+OawacRTpBHgSSBQWBLBfifjvS66wHcnKTkeSjfjFigTHK/PjrsNh9avu3RBLlh129KktHVpr2e5C5CMEQnwA/vRgS9fUZpZsdkchR8jQ32OQWIgOv3gmm7BXJwNwvj4UTLcSabo0UEWDdTJhRnAHiT5b0vkteS8BRS08p5U26An50RxIbe2u7SaZ2CLHyqAMknNEX8F7Hlk/c25+9w2/advM28j+O3yp6iLBeQsD/AAc3vyP/ALU/fXiaeyXLp2StgRxsfbc+J91CprUkqxtHIeaIlF816jPqaIuxd70i+uJQLZWBzmp+8l5ia1h1QXVksRTlddzg7eFBTnJrpPLOhFpYYDBqUKKjZJB8BVlbaoo4Y+84ISJS2D34qPtLRWjTKjAplxHdCz4YhtY8Brhun8o3P74q93SA0z8FKX8RvpzxahoMKwr+ehIkbkyebqTnzom10OeR15du5ifDv38ahNP1K6sXDQSlSO4jI9DXTOHeKLLU4kglKW90BgxnZW/p/wCqXefQTi8mFmIy0xlZ6YLKARqMgbk+dY3TtEjHl6AmnLXdusfKZU5z0XO9K9TkjQxgDLuSF+tDNPy0I+YCRblmAIUhPEsdv23NDa1dtLPA8ZVOSMksQCVyT09K832lX82oLevJ2dqifrZhjHkPGlU84mu5gDkDBXvAHT60RMVmT19bXFxeidHluWByCy7D1ptpGhSXM4kEQjXmDMoGy1daba2F3psbuEyFw6gAYPfWlpZxWgMaPzR92eoqHY3ovGjG2IrrT1s4hIoA5zg4pXIap+IVCWUZH/P6GpKaTFXj0Cs0z//Z\\nEND:VCARD"],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC692176869F28D0E5C264C1E38BBE42	C verde	0	f	chat	\N	8	2026-02-12 00:58:06.667+00	2026-02-12 00:58:06.667+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"AC692176869F28D0E5C264C1E38BBE42","_serialized":"false_82816280854646@lid_AC692176869F28D0E5C264C1E38BBE42"},"type":"chat","timestamp":1768835216,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AE9409AC6339A18DB5	image.png	3	t	image	1770857887679-qfe7.jpeg	3	2026-02-12 00:58:07.681+00	2026-02-12 00:58:07.681+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"3EB0AE9409AC6339A18DB5","_serialized":"true_82816280854646@lid_3EB0AE9409AC6339A18DB5"},"type":"image","timestamp":1768837369,"from":"151909402964196@lid","to":"82816280854646@lid","isForwarded":true,"forwardingScore":2,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0781240E7E4154E0CA1	bom diaa marcos tdo bem? esses dias vc pediu meu email.. aquele que te passei .. qdo peguei o cll da empresa foi desativado!! agora o ativo esta esse que vou te passar ta	0	f	chat	\N	8	2026-02-12 00:58:07.989+00	2026-02-12 00:58:07.989+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB0781240E7E4154E0CA1","_serialized":"false_82816280854646@lid_3EB0781240E7E4154E0CA1"},"type":"chat","timestamp":1768923399,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB033E1971ABC2C8DA928	na vdd nao me lembro qual te passei!! mais o ATIVO E esse ta	0	f	chat	\N	8	2026-02-12 00:58:08.192+00	2026-02-12 00:58:08.192+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB033E1971ABC2C8DA928","_serialized":"false_82816280854646@lid_3EB033E1971ABC2C8DA928"},"type":"chat","timestamp":1768923446,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0499A9AB5848CC4F6D9	perfumariadrogariasbigmaster@gmail.com	0	f	chat	\N	8	2026-02-12 00:58:08.381+00	2026-02-12 00:58:08.381+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB0499A9AB5848CC4F6D9","_serialized":"false_82816280854646@lid_3EB0499A9AB5848CC4F6D9"},"type":"chat","timestamp":1768923493,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C71571C94DDC3053F9	precisar enviar algo envia nesse ta .. ate mais	0	f	chat	\N	8	2026-02-12 00:58:08.569+00	2026-02-12 00:58:08.569+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB0C71571C94DDC3053F9","_serialized":"false_82816280854646@lid_3EB0C71571C94DDC3053F9"},"type":"chat","timestamp":1768923543,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5E82A275342D3CF43BC981108E84A67	Oiii	3	t	chat	\N	3	2026-02-12 00:58:09.026+00	2026-02-12 00:58:09.026+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"A5E82A275342D3CF43BC981108E84A67","_serialized":"true_82816280854646@lid_A5E82A275342D3CF43BC981108E84A67"},"type":"chat","timestamp":1768929798,"from":"556592694840@c.us","to":"82816280854646@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F8DD79CB53EF766C6B693728A35982	Estava acompanhando  meu pai em uns exames	3	t	chat	\N	3	2026-02-12 00:58:09.493+00	2026-02-12 00:58:09.493+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"A5F8DD79CB53EF766C6B693728A35982","_serialized":"true_82816280854646@lid_A5F8DD79CB53EF766C6B693728A35982"},"type":"chat","timestamp":1768929813,"from":"556592694840@c.us","to":"82816280854646@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB009A8F7DF74181ED672		3	t	image	1770857890814-vto77.jpeg	3	2026-02-12 00:58:10.818+00	2026-02-12 00:58:10.818+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"3EB009A8F7DF74181ED672","_serialized":"true_82816280854646@lid_3EB009A8F7DF74181ED672"},"type":"image","timestamp":1770830052,"from":"151909402964196@lid","to":"82816280854646@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E0F2E29C841C32C58B		3	t	image	1770857893123-q7ex08.jpeg	3	2026-02-12 00:58:13.127+00	2026-02-12 00:58:13.127+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"3EB0E0F2E29C841C32C58B","_serialized":"true_82816280854646@lid_3EB0E0F2E29C841C32C58B"},"type":"image","timestamp":1770830079,"from":"151909402964196@lid","to":"82816280854646@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B9A61C7DDCA276C99C	ja estou vendo o valor dele	0	f	chat	\N	8	2026-02-12 00:58:13.479+00	2026-02-12 00:58:13.479+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB0B9A61C7DDCA276C99C","_serialized":"false_82816280854646@lid_3EB0B9A61C7DDCA276C99C"},"type":"chat","timestamp":1770836306,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02E004EABE499F6FC5E	ok	3	t	chat	\N	3	2026-02-12 00:58:14.824+00	2026-02-12 00:58:14.824+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"82816280854646@lid","id":"3EB02E004EABE499F6FC5E","_serialized":"true_82816280854646@lid_3EB02E004EABE499F6FC5E"},"type":"chat","timestamp":1770836393,"from":"151909402964196@lid","to":"82816280854646@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04C567CEE741CD0E9F6	$ 1.026,00	0	f	chat	\N	8	2026-02-12 00:58:15.058+00	2026-02-12 00:58:15.058+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB04C567CEE741CD0E9F6","_serialized":"false_82816280854646@lid_3EB04C567CEE741CD0E9F6"},"type":"chat","timestamp":1770836714,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03B591A072288D13F90	- 17% $ 855,00	0	f	chat	\N	8	2026-02-12 00:58:15.373+00	2026-02-12 00:58:15.373+00	f	f	8	\N	1	\N	{"id":{"fromMe":false,"remote":"82816280854646@lid","id":"3EB03B591A072288D13F90","_serialized":"false_82816280854646@lid_3EB03B591A072288D13F90"},"type":"chat","timestamp":1770836730,"from":"82816280854646@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56F3AD6B4136E1F7D2CEB0FFE6D1717	Ja coloquei pra rodar	1	t	chat	\N	3	2026-02-12 01:50:10.705+00	2026-02-12 01:50:10.705+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A56F3AD6B4136E1F7D2CEB0FFE6D1717","_serialized":"true_164703422648560@lid_A56F3AD6B4136E1F7D2CEB0FFE6D1717"},"type":"chat","timestamp":1770861004,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0763D04CF9CDA9EABB6	Eita	3	t	chat	\N	3	2026-02-12 00:58:19.082+00	2026-02-12 00:58:19.082+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB0763D04CF9CDA9EABB6","_serialized":"true_225606126018578@lid_3EB0763D04CF9CDA9EABB6"},"type":"chat","timestamp":1770829146,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BCA7031638083A8697	bom demais	3	t	chat	\N	3	2026-02-12 00:58:20.651+00	2026-02-12 00:58:20.651+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB0BCA7031638083A8697","_serialized":"true_225606126018578@lid_3EB0BCA7031638083A8697"},"type":"chat","timestamp":1770829147,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB043E26D3CE5ABEB709B	pode fazer um pra min	3	t	chat	\N	3	2026-02-12 00:58:21.488+00	2026-02-12 00:58:21.488+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB043E26D3CE5ABEB709B","_serialized":"true_225606126018578@lid_3EB043E26D3CE5ABEB709B"},"type":"chat","timestamp":1770829151,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E32196A13476611C84	pesar e ver o preço	3	t	chat	\N	3	2026-02-12 00:58:22.455+00	2026-02-12 00:58:22.455+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB0E32196A13476611C84","_serialized":"true_225606126018578@lid_3EB0E32196A13476611C84"},"type":"chat","timestamp":1770829154,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52C08B5FD5B5F5709270211011D65CB		1	t	image	1770861028221-t9glah.jpeg	3	2026-02-12 01:50:28.243+00	2026-02-12 01:50:28.243+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A52C08B5FD5B5F5709270211011D65CB","_serialized":"true_164703422648560@lid_A52C08B5FD5B5F5709270211011D65CB"},"type":"image","timestamp":1770861024,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F22987D055B9A681B0	te envio o pix na hora	3	t	chat	\N	3	2026-02-12 00:58:23.651+00	2026-02-12 00:58:23.651+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB0F22987D055B9A681B0","_serialized":"true_225606126018578@lid_3EB0F22987D055B9A681B0"},"type":"chat","timestamp":1770829157,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EFB47BD6499E195534	por favor	3	t	chat	\N	3	2026-02-12 00:58:24.93+00	2026-02-12 00:58:24.93+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB0EFB47BD6499E195534","_serialized":"true_225606126018578@lid_3EB0EFB47BD6499E195534"},"type":"chat","timestamp":1770829162,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACA3EF0EAB5B0CFF5AF811E8EBC15CCD		1	f	image	1770903000625-r18mna.jpeg	48	2026-02-12 13:30:00.729+00	2026-02-12 13:30:00.961+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACA3EF0EAB5B0CFF5AF811E8EBC15CCD","_serialized":"false_2194761883822@lid_ACA3EF0EAB5B0CFF5AF811E8EBC15CCD"},"type":"image","timestamp":1770902999,"from":"2194761883822@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB06630EFB9064DCFAB8C	pode fazeer ai	3	t	chat	\N	3	2026-02-12 00:58:26.232+00	2026-02-12 00:58:26.232+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB06630EFB9064DCFAB8C","_serialized":"true_225606126018578@lid_3EB06630EFB9064DCFAB8C"},"type":"chat","timestamp":1770829220,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C79706EB7788B7ACBA	não sendo	3	t	chat	\N	3	2026-02-12 00:58:27.243+00	2026-02-12 00:58:27.243+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB0C79706EB7788B7ACBA","_serialized":"true_225606126018578@lid_3EB0C79706EB7788B7ACBA"},"type":"chat","timestamp":1770829225,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08BEE979E513085912C	jiló, biuchada ou dobradinha	3	t	chat	\N	3	2026-02-12 00:58:27.867+00	2026-02-12 00:58:27.867+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB08BEE979E513085912C","_serialized":"true_225606126018578@lid_3EB08BEE979E513085912C"},"type":"chat","timestamp":1770829234,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03816A0C60772F6CDCA	tá ótimo	3	t	chat	\N	3	2026-02-12 00:58:28.784+00	2026-02-12 00:58:28.784+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB03816A0C60772F6CDCA","_serialized":"true_225606126018578@lid_3EB03816A0C60772F6CDCA"},"type":"chat","timestamp":1770829237,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5AAAC307D13FED202B6AE1C7D86AB3F	Pix??	3	t	chat	\N	3	2026-02-12 00:58:29.822+00	2026-02-12 00:58:29.822+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"A5AAAC307D13FED202B6AE1C7D86AB3F","_serialized":"true_225606126018578@lid_A5AAAC307D13FED202B6AE1C7D86AB3F"},"type":"chat","timestamp":1770830567,"from":"556592694840@c.us","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A597024C97EF61E7FB421CC7600C0AFA	ComprovanteSantander-1770832314.359216.pdf	3	t	document	1770857910272-7henw.pdf	3	2026-02-12 00:58:30.285+00	2026-02-12 00:58:30.285+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"A597024C97EF61E7FB421CC7600C0AFA","_serialized":"true_225606126018578@lid_A597024C97EF61E7FB421CC7600C0AFA"},"type":"document","timestamp":1770832340,"from":"556592694840@c.us","to":"225606126018578@lid","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06E8BAB8465E7E69928	Estava ótimo	3	t	chat	\N	3	2026-02-12 00:58:31.241+00	2026-02-12 00:58:31.241+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB06E8BAB8465E7E69928","_serialized":"true_225606126018578@lid_3EB06E8BAB8465E7E69928"},"type":"chat","timestamp":1770833805,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01C130E0EA826A8008A	Obrigado	3	t	chat	\N	3	2026-02-12 00:58:32.137+00	2026-02-12 00:58:32.137+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"225606126018578@lid","id":"3EB01C130E0EA826A8008A","_serialized":"true_225606126018578@lid_3EB01C130E0EA826A8008A"},"type":"chat","timestamp":1770833807,"from":"151909402964196@lid","to":"225606126018578@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D24F2C0E5CE857588A6B0F5706C63F	Pode ser uma boa.	0	f	chat	\N	23	2026-02-12 01:54:05.123+00	2026-02-12 01:54:05.123+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"A5D24F2C0E5CE857588A6B0F5706C63F","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_556596725633-1629494914@g.us_A5D24F2C0E5CE857588A6B0F5706C63F_164703422648560@lid"},"type":"chat","timestamp":1770644819,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"164703422648560@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5E9E8D629E82DC7847CA15720BB28E7		0	t	chat	\N	3	2026-02-12 00:58:33.184+00	2026-02-12 00:58:33.184+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"81042157367534@lid","id":"A5E9E8D629E82DC7847CA15720BB28E7","_serialized":"true_81042157367534@lid_A5E9E8D629E82DC7847CA15720BB28E7"},"type":"e2e_notification","timestamp":1770829651,"from":"556592694840@c.us","to":"81042157367534@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05065294E7BC9211A45	https://www.youtube.com/watch?v=FGH8rnraxoE&list=RDFGH8rnraxoE&index=1	3	t	chat	\N	3	2026-02-12 00:58:33.974+00	2026-02-12 00:58:33.974+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"81042157367534@lid","id":"3EB05065294E7BC9211A45","_serialized":"true_81042157367534@lid_3EB05065294E7BC9211A45"},"type":"chat","timestamp":1770829660,"from":"151909402964196@lid","to":"81042157367534@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB036A0CD1BC3DC4C4D7E	e esse aqui ne	0	f	chat	\N	29	2026-02-12 01:54:08.294+00	2026-02-12 01:54:08.294+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB036A0CD1BC3DC4C4D7E","_serialized":"false_150950970921173@lid_3EB036A0CD1BC3DC4C4D7E"},"type":"chat","timestamp":1769699947,"from":"150950970921173@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A524A4A365A911E1AD5	Oi	0	t	chat	\N	10	2026-02-12 00:58:32.643+00	2026-02-12 01:40:50.11+00	f	f	10	\N	1	\N	{"id":{"fromMe":false,"remote":"81042157367534@lid","id":"3A524A4A365A911E1AD5","_serialized":"false_81042157367534@lid_3A524A4A365A911E1AD5"},"type":"chat","timestamp":1770829642,"from":"81042157367534@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC567D61D9A8EA3EBD152656B5DACB0A		0	t	sticker	1770857909345-nsgbub.webp	9	2026-02-12 00:58:29.35+00	2026-02-12 01:40:50.738+00	f	f	9	\N	1	\N	{"id":{"fromMe":false,"remote":"225606126018578@lid","id":"AC567D61D9A8EA3EBD152656B5DACB0A","_serialized":"false_225606126018578@lid_AC567D61D9A8EA3EBD152656B5DACB0A"},"type":"sticker","timestamp":1770829244,"from":"225606126018578@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07BCC467F1C6333FBD9	nessa chave	3	t	chat	\N	3	2026-02-12 01:54:10.12+00	2026-02-12 01:54:10.12+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB07BCC467F1C6333FBD9","_serialized":"true_150950970921173@lid_3EB07BCC467F1C6333FBD9"},"type":"chat","timestamp":1769699964,"from":"151909402964196@lid","to":"150950970921173@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A556D8C678B4062A7E5D30D697FAC915	Tem que ser que vai ser banido do celular	3	t	chat	\N	3	2026-02-12 00:58:35.874+00	2026-02-12 00:58:35.874+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A556D8C678B4062A7E5D30D697FAC915","_serialized":"true_164703422648560@lid_A556D8C678B4062A7E5D30D697FAC915"},"type":"chat","timestamp":1770815574,"from":"556592694840@c.us","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A51AD7380D4B76B0051EB816707702A8	Entendeu	3	t	chat	\N	3	2026-02-12 00:58:36.333+00	2026-02-12 00:58:36.333+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A51AD7380D4B76B0051EB816707702A8","_serialized":"true_164703422648560@lid_A51AD7380D4B76B0051EB816707702A8"},"type":"chat","timestamp":1770815576,"from":"556592694840@c.us","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56836C5EB43BDB8B0CFEE529F67EAAC	Ele sai do celular e vai para Nuvem da Meta	3	t	chat	\N	3	2026-02-12 00:58:37.016+00	2026-02-12 00:58:37.016+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A56836C5EB43BDB8B0CFEE529F67EAAC","_serialized":"true_164703422648560@lid_A56836C5EB43BDB8B0CFEE529F67EAAC"},"type":"chat","timestamp":1770815586,"from":"556592694840@c.us","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5EA82DEE94AF1AB44BD77547A953E79	Melhor	3	t	chat	\N	3	2026-02-12 00:58:37.68+00	2026-02-12 00:58:37.68+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A5EA82DEE94AF1AB44BD77547A953E79","_serialized":"true_164703422648560@lid_A5EA82DEE94AF1AB44BD77547A953E79"},"type":"chat","timestamp":1770816172,"from":"556592694840@c.us","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A559A1E4F8FFA4FCCCC4DC6205A4A3C7	Como faço para pegar 2 chips no balcão?	3	t	chat	\N	3	2026-02-12 00:58:38.168+00	2026-02-12 00:58:38.168+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A559A1E4F8FFA4FCCCC4DC6205A4A3C7","_serialized":"true_164703422648560@lid_A559A1E4F8FFA4FCCCC4DC6205A4A3C7"},"type":"chat","timestamp":1770816212,"from":"556592694840@c.us","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5984231C73DFA4D3DD040140F7C73C1	Ok	3	t	chat	\N	3	2026-02-12 00:58:39.14+00	2026-02-12 00:58:39.14+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A5984231C73DFA4D3DD040140F7C73C1","_serialized":"true_164703422648560@lid_A5984231C73DFA4D3DD040140F7C73C1"},"type":"chat","timestamp":1770816711,"from":"556592694840@c.us","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00B0411BAFC338F4CBE	beleza	3	t	chat	\N	3	2026-02-12 00:58:40.432+00	2026-02-12 00:58:40.432+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB00B0411BAFC338F4CBE","_serialized":"true_164703422648560@lid_3EB00B0411BAFC338F4CBE"},"type":"chat","timestamp":1770820078,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB098D2AE507343D44741	Vai vir pra cá hoje	3	t	chat	\N	3	2026-02-12 00:58:41.54+00	2026-02-12 00:58:41.54+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB098D2AE507343D44741","_serialized":"true_164703422648560@lid_3EB098D2AE507343D44741"},"type":"chat","timestamp":1770820081,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DBB5E02E11FE839B99	quero alinahr contigo	3	t	chat	\N	3	2026-02-12 00:58:42.251+00	2026-02-12 00:58:42.251+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB0DBB5E02E11FE839B99","_serialized":"true_164703422648560@lid_3EB0DBB5E02E11FE839B99"},"type":"chat","timestamp":1770820084,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F5F4EF9B6E68D3B584	estou vendo com o Luan para adiantar	3	t	chat	\N	3	2026-02-12 00:58:43.519+00	2026-02-12 00:58:43.519+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB0F5F4EF9B6E68D3B584","_serialized":"true_164703422648560@lid_3EB0F5F4EF9B6E68D3B584"},"type":"chat","timestamp":1770820089,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB099BAE89A95B70D9592	ia precisar de um aparelho	3	t	chat	\N	3	2026-02-12 00:58:44.233+00	2026-02-12 00:58:44.233+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB099BAE89A95B70D9592","_serialized":"true_164703422648560@lid_3EB099BAE89A95B70D9592"},"type":"chat","timestamp":1770820096,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACF83202D13F1187496C096007E614B1		4	f	audio	1770903032006-sz2io.oga	48	2026-02-12 13:30:32.015+00	2026-02-12 13:30:33.014+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACF83202D13F1187496C096007E614B1","_serialized":"false_2194761883822@lid_ACF83202D13F1187496C096007E614B1"},"type":"ptt","timestamp":1770903031,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"21","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0F762208B561ADC22F7	este meu cabe 2 chips	3	t	chat	\N	3	2026-02-12 00:58:45.319+00	2026-02-12 00:58:45.319+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB0F762208B561ADC22F7","_serialized":"true_164703422648560@lid_3EB0F762208B561ADC22F7"},"type":"chat","timestamp":1770820131,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01DB2C44EB3E0CAEFC9	kkkk	3	t	chat	\N	3	2026-02-12 00:58:46.134+00	2026-02-12 00:58:46.134+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB01DB2C44EB3E0CAEFC9","_serialized":"true_164703422648560@lid_3EB01DB2C44EB3E0CAEFC9"},"type":"chat","timestamp":1770820132,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB024E30FF971CA270B61	eu não sei	3	t	chat	\N	3	2026-02-12 00:58:47.364+00	2026-02-12 00:58:47.364+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"3EB024E30FF971CA270B61","_serialized":"true_164703422648560@lid_3EB024E30FF971CA270B61"},"type":"chat","timestamp":1770820134,"from":"151909402964196@lid","to":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB068F85BE98FF04D3D46	Sera feito nesse CNPJ ?	0	f	chat	\N	44	2026-02-12 01:54:16.397+00	2026-02-12 01:54:16.397+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB068F85BE98FF04D3D46","_serialized":"false_11407449915544@lid_3EB068F85BE98FF04D3D46"},"type":"chat","timestamp":1768847990,"from":"11407449915544@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01146A35D5EC9A8F787	Entendi, e claro precisa estabilizar...	0	f	chat	\N	45	2026-02-12 01:54:17.073+00	2026-02-12 01:54:17.073+00	f	f	52	\N	1	\N	{"id":{"fromMe":false,"remote":"73903821091006@lid","id":"3EB01146A35D5EC9A8F787","_serialized":"false_73903821091006@lid_3EB01146A35D5EC9A8F787"},"type":"chat","timestamp":1768849011,"from":"73903821091006@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A054168B0246E4C97B	tentar aqui	3	t	chat	\N	3	2026-02-12 00:58:49.862+00	2026-02-12 00:58:49.862+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"3EB0A054168B0246E4C97B","_serialized":"true_133865742024877@lid_3EB0A054168B0246E4C97B"},"type":"chat","timestamp":1770062090,"from":"151909402964196@lid","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C54A756B00C29614F77971F2F55CA4	Bom dia senhor	3	t	chat	\N	3	2026-02-12 00:58:50.799+00	2026-02-12 00:58:50.799+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"A5C54A756B00C29614F77971F2F55CA4","_serialized":"true_133865742024877@lid_A5C54A756B00C29614F77971F2F55CA4"},"type":"chat","timestamp":1770815640,"from":"556592694840@c.us","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5626A51AE5C0CFE7A534AAE82BFB706	Top dms	1	t	chat	\N	11	2026-02-12 01:54:20.311+00	2026-02-12 02:09:05.028+00	f	f	11	A52C08B5FD5B5F5709270211011D65CB	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5626A51AE5C0CFE7A534AAE82BFB706","_serialized":"false_164703422648560@lid_A5626A51AE5C0CFE7A534AAE82BFB706"},"type":"chat","timestamp":1770861259,"from":"164703422648560@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5914D568DD6F090059707D2B5F9FAB4	Ja vejo isso agora	3	t	chat	\N	3	2026-02-12 00:58:51.804+00	2026-02-12 00:58:51.804+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"A5914D568DD6F090059707D2B5F9FAB4","_serialized":"true_133865742024877@lid_A5914D568DD6F090059707D2B5F9FAB4"},"type":"chat","timestamp":1770816241,"from":"556592694840@c.us","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5ED6839E14949819FF8561E4CFFEFC7	Obrigado por informar	3	t	chat	\N	3	2026-02-12 00:58:52.736+00	2026-02-12 00:58:52.736+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"A5ED6839E14949819FF8561E4CFFEFC7","_serialized":"true_133865742024877@lid_A5ED6839E14949819FF8561E4CFFEFC7"},"type":"chat","timestamp":1770816338,"from":"556592694840@c.us","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53DE1969EA7EC53B5221D41463642A3	Cabe	0	t	chat	\N	11	2026-02-12 00:58:47.785+00	2026-02-12 01:40:49.459+00	f	f	11	3EB0F762208B561ADC22F7	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A53DE1969EA7EC53B5221D41463642A3","_serialized":"false_164703422648560@lid_A53DE1969EA7EC53B5221D41463642A3"},"type":"chat","timestamp":1770820175,"from":"164703422648560@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AB3C5ADB69494C42	BEGIN:VCARD\nVERSION:3.0\nN:;L5 Networks;;;\nFN:+55 11 2222-1010\nTEL;type=CELL;waid=551122221010:+55 11 2222-1010\nX-WA-BIZ-NAME:+55 11 2222-1010\nX-WA-BIZ-DESCRIPTION:WhatsApp Business For L5 NETWORKS\nX-WA-BIZ-AUTOMATED-TYPE:unknown\nEND:VCARD	0	t	vcard	\N	11	2026-02-12 00:58:48.069+00	2026-02-12 01:40:49.459+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"3EB0AB3C5ADB69494C42","_serialized":"false_164703422648560@lid_3EB0AB3C5ADB69494C42"},"type":"vcard","timestamp":1770823731,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":["BEGIN:VCARD\\nVERSION:3.0\\nN:;L5 Networks;;;\\nFN:+55 11 2222-1010\\nTEL;type=CELL;waid=551122221010:+55 11 2222-1010\\nX-WA-BIZ-NAME:+55 11 2222-1010\\nX-WA-BIZ-DESCRIPTION:WhatsApp Business For L5 NETWORKS\\nX-WA-BIZ-AUTOMATED-TYPE:unknown\\nEND:VCARD"],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC7D1F15C41DBA8A4BDDCCD905A531F1		4	f	audio	1770903036623-pllykr.oga	48	2026-02-12 13:30:36.626+00	2026-02-12 13:30:55.259+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC7D1F15C41DBA8A4BDDCCD905A531F1","_serialized":"false_2194761883822@lid_AC7D1F15C41DBA8A4BDDCCD905A531F1"},"type":"ptt","timestamp":1770903035,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"2","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5E087B0CE14C007910A4E01B733D3E4	João	3	t	chat	\N	3	2026-02-12 00:58:53.645+00	2026-02-12 00:58:53.645+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"A5E087B0CE14C007910A4E01B733D3E4","_serialized":"true_133865742024877@lid_A5E087B0CE14C007910A4E01B733D3E4"},"type":"chat","timestamp":1770816843,"from":"556592694840@c.us","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5A43BCCFFAB741340E759A692A17F8D	Mas vou acertar	3	t	chat	\N	3	2026-02-12 01:55:09.181+00	2026-02-12 01:56:51.32+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A5A43BCCFFAB741340E759A692A17F8D","_serialized":"true_164703422648560@lid_A5A43BCCFFAB741340E759A692A17F8D"},"type":"chat","timestamp":1770861307,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5B98F8DC67FE96A7229DDEC4B51AD94	Liguei e caiu 30252727	3	t	chat	\N	3	2026-02-12 00:58:54.407+00	2026-02-12 00:58:54.407+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"A5B98F8DC67FE96A7229DDEC4B51AD94","_serialized":"true_133865742024877@lid_A5B98F8DC67FE96A7229DDEC4B51AD94"},"type":"chat","timestamp":1770816868,"from":"556592694840@c.us","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5AE674F6B10B32E575D1B0E9C0F6D1C	Caiunna Fernando Correa	3	t	chat	\N	3	2026-02-12 00:58:55.242+00	2026-02-12 00:58:55.242+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"A5AE674F6B10B32E575D1B0E9C0F6D1C","_serialized":"true_133865742024877@lid_A5AE674F6B10B32E575D1B0E9C0F6D1C"},"type":"chat","timestamp":1770816874,"from":"556592694840@c.us","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5DEBCA899F47632C3E597D55B8EFE7B	Se tiver tudo certo acho que segunda já colocamos na Júlio Campos	3	t	chat	\N	3	2026-02-12 01:55:27.425+00	2026-02-12 01:56:51.329+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A5DEBCA899F47632C3E597D55B8EFE7B","_serialized":"true_164703422648560@lid_A5DEBCA899F47632C3E597D55B8EFE7B"},"type":"chat","timestamp":1770861325,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01BDB1222A1F22181CB	João	3	t	chat	\N	3	2026-02-12 00:58:56.567+00	2026-02-12 00:58:56.567+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"3EB01BDB1222A1F22181CB","_serialized":"true_133865742024877@lid_3EB01BDB1222A1F22181CB"},"type":"chat","timestamp":1770823680,"from":"151909402964196@lid","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB090BCC1EC41256E78B3	verifiquei aqui e adequamos	3	t	chat	\N	3	2026-02-12 00:58:57.846+00	2026-02-12 00:58:57.846+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"3EB090BCC1EC41256E78B3","_serialized":"true_133865742024877@lid_3EB090BCC1EC41256E78B3"},"type":"chat","timestamp":1770823684,"from":"151909402964196@lid","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03E866D01E2EB3B9A37	depois pede para o pessoal relatar se houve algum chamado da Fernando Correa	3	t	chat	\N	3	2026-02-12 00:58:58.555+00	2026-02-12 00:58:58.555+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"133865742024877@lid","id":"3EB03E866D01E2EB3B9A37","_serialized":"true_133865742024877@lid_3EB03E866D01E2EB3B9A37"},"type":"chat","timestamp":1770823702,"from":"151909402964196@lid","to":"133865742024877@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5DB246F87534A146AD911F43D206CEC		0	t	chat	\N	3	2026-02-12 00:58:59.762+00	2026-02-12 00:58:59.762+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"244181876367593@lid","id":"A5DB246F87534A146AD911F43D206CEC","_serialized":"true_244181876367593@lid_A5DB246F87534A146AD911F43D206CEC"},"type":"e2e_notification","timestamp":1769557875,"from":"556592694840@c.us","to":"244181876367593@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AB823B1B58C2720939	Bom dia!	3	t	chat	\N	3	2026-02-12 00:59:00.658+00	2026-02-12 00:59:00.658+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"244181876367593@lid","id":"3EB0AB823B1B58C2720939","_serialized":"true_244181876367593@lid_3EB0AB823B1B58C2720939"},"type":"chat","timestamp":1770818338,"from":"151909402964196@lid","to":"244181876367593@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BB53BFE5214C940E17	https://bvsms.saude.gov.br/bvs/saudelegis/anvisa/2008/rdc0096_17_12_2008.html?utm_source=chatgpt.com	3	t	chat	\N	3	2026-02-12 00:59:01.786+00	2026-02-12 00:59:01.786+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"244181876367593@lid","id":"3EB0BB53BFE5214C940E17","_serialized":"true_244181876367593@lid_3EB0BB53BFE5214C940E17"},"type":"chat","timestamp":1770818365,"from":"151909402964196@lid","to":"244181876367593@lid","isForwarded":true,"forwardingScore":3,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A50AFFD535E3AB26755E0330C370376A	Ela ta meio bufando aqui	1	t	chat	\N	3	2026-02-12 01:55:03.393+00	2026-02-12 01:56:21.647+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A50AFFD535E3AB26755E0330C370376A","_serialized":"true_164703422648560@lid_A50AFFD535E3AB26755E0330C370376A"},"type":"chat","timestamp":1770861301,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACBF02B42C99721382AE8012BE3227D9		1	f	video	1770903070073-0w323n.mp4	48	2026-02-12 13:31:10.115+00	2026-02-12 13:31:10.183+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACBF02B42C99721382AE8012BE3227D9","_serialized":"false_2194761883822@lid_ACBF02B42C99721382AE8012BE3227D9"},"type":"video","timestamp":1770903067,"from":"2194761883822@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"15","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB07675414C5A86D68FEB	Portaria da ANVISA que proibi a imagens e propaganda  de medicamentos	3	t	chat	\N	3	2026-02-12 00:59:03.255+00	2026-02-12 00:59:03.255+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"244181876367593@lid","id":"3EB07675414C5A86D68FEB","_serialized":"true_244181876367593@lid_3EB07675414C5A86D68FEB"},"type":"chat","timestamp":1770818365,"from":"151909402964196@lid","to":"244181876367593@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5FF39A29DE17B0B2C8749D50782ADB7	Bom dia	3	t	chat	\N	3	2026-02-12 00:59:05.587+00	2026-02-12 00:59:05.587+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"58939920105695@lid","id":"A5FF39A29DE17B0B2C8749D50782ADB7","_serialized":"true_58939920105695@lid_A5FF39A29DE17B0B2C8749D50782ADB7"},"type":"chat","timestamp":1770640749,"from":"556592694840@c.us","to":"58939920105695@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C8A4DDB2FBEE96D85552050FEE7C05	Vou ver se consigo te ajudar	3	t	chat	\N	3	2026-02-12 00:59:06.842+00	2026-02-12 00:59:06.842+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"58939920105695@lid","id":"A5C8A4DDB2FBEE96D85552050FEE7C05","_serialized":"true_58939920105695@lid_A5C8A4DDB2FBEE96D85552050FEE7C05"},"type":"chat","timestamp":1770640755,"from":"556592694840@c.us","to":"58939920105695@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC377836FA7283BD46D6B50A7FA3716D	Obrigado	1	f	chat	\N	48	2026-02-12 13:32:47.874+00	2026-02-12 13:32:47.903+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC377836FA7283BD46D6B50A7FA3716D","_serialized":"false_2194761883822@lid_AC377836FA7283BD46D6B50A7FA3716D"},"type":"chat","timestamp":1770903167,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A513EE8945E1D3B46AAE8FDC1DBA3136		4	t	audio	1770857948334-u6zvq2.oga	3	2026-02-12 00:59:08.339+00	2026-02-12 00:59:08.339+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"58939920105695@lid","id":"A513EE8945E1D3B46AAE8FDC1DBA3136","_serialized":"true_58939920105695@lid_A513EE8945E1D3B46AAE8FDC1DBA3136"},"type":"ptt","timestamp":1770643057,"from":"556592694840@c.us","to":"58939920105695@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"18","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52B2EE6F483C6641DC4FC3B275A17E3	Que é crucial	3	t	chat	\N	3	2026-02-12 01:57:27.947+00	2026-02-12 02:03:03.766+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A52B2EE6F483C6641DC4FC3B275A17E3","_serialized":"true_164703422648560@lid_A52B2EE6F483C6641DC4FC3B275A17E3"},"type":"chat","timestamp":1770861445,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53A9D73269B3207553BDA59828C297A	Não das mensagens mesmo da fila	3	t	chat	\N	3	2026-02-12 01:57:23.196+00	2026-02-12 02:03:03.751+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"164703422648560@lid","id":"A53A9D73269B3207553BDA59828C297A","_serialized":"true_164703422648560@lid_A53A9D73269B3207553BDA59828C297A"},"type":"chat","timestamp":1770861440,"from":"556592694840@c.us","to":"164703422648560@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A504A6B227DDD4557CCB27D884336571		4	t	audio	1770857952954-jsnf29.oga	3	2026-02-12 00:59:12.962+00	2026-02-12 00:59:12.962+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"58939920105695@lid","id":"A504A6B227DDD4557CCB27D884336571","_serialized":"true_58939920105695@lid_A504A6B227DDD4557CCB27D884336571"},"type":"ptt","timestamp":1770643220,"from":"556592694840@c.us","to":"58939920105695@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A501BA51971222FEDF527907AF307EAF	Tipo lento?	1	t	chat	\N	11	2026-02-12 01:57:02.49+00	2026-02-12 02:09:05.028+00	f	f	11	A50AFFD535E3AB26755E0330C370376A	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A501BA51971222FEDF527907AF307EAF","_serialized":"false_164703422648560@lid_A501BA51971222FEDF527907AF307EAF"},"type":"chat","timestamp":1770861421,"from":"164703422648560@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5E796509D0AA1AF8AF7C44E885F4A74		4	t	audio	1770857956847-kf3g39.oga	3	2026-02-12 00:59:16.849+00	2026-02-12 00:59:16.849+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"58939920105695@lid","id":"A5E796509D0AA1AF8AF7C44E885F4A74","_serialized":"true_58939920105695@lid_A5E796509D0AA1AF8AF7C44E885F4A74"},"type":"ptt","timestamp":1770643394,"from":"556592694840@c.us","to":"58939920105695@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"4","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5FF4C761600299D0DE8C62CC62AF3AC	Nao	3	t	chat	\N	3	2026-02-12 00:59:19.714+00	2026-02-12 00:59:19.714+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A5FF4C761600299D0DE8C62CC62AF3AC","_serialized":"true_125271831228508@lid_A5FF4C761600299D0DE8C62CC62AF3AC"},"type":"chat","timestamp":1770143594,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56D6C068E5F8ABAA92F02BC96D78622	Porque não conecta?	3	t	chat	\N	3	2026-02-12 00:59:20.342+00	2026-02-12 00:59:20.342+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A56D6C068E5F8ABAA92F02BC96D78622","_serialized":"true_125271831228508@lid_A56D6C068E5F8ABAA92F02BC96D78622"},"type":"chat","timestamp":1770143602,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D6A11CB0DB8196B933DA6AA7210B34	Ah sim	1	t	chat	\N	11	2026-02-12 02:03:11.877+00	2026-02-12 02:09:05.028+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5D6A11CB0DB8196B933DA6AA7210B34","_serialized":"false_164703422648560@lid_A5D6A11CB0DB8196B933DA6AA7210B34"},"type":"chat","timestamp":1770861788,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A570392A2CD0FB72D5BE59B090F38B29		4	t	audio	1770857962934-qo2q79.oga	3	2026-02-12 00:59:22.938+00	2026-02-12 00:59:22.938+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A570392A2CD0FB72D5BE59B090F38B29","_serialized":"true_125271831228508@lid_A570392A2CD0FB72D5BE59B090F38B29"},"type":"ptt","timestamp":1770143691,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D93D1F3534EC94C32049AA291B8723	Verifica que deve ter voltado	3	t	chat	\N	3	2026-02-12 00:59:23.514+00	2026-02-12 00:59:23.514+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A5D93D1F3534EC94C32049AA291B8723","_serialized":"true_125271831228508@lid_A5D93D1F3534EC94C32049AA291B8723"},"type":"chat","timestamp":1770143856,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56D455D177B966E1DD986B5C7DFC833	Aqui vou ter que pôr dnv	0	f	chat	\N	73	2026-02-12 23:45:49.783+00	2026-02-12 23:50:50.176+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
3A84AB7DB1C22C6D9940		0	t	chat	\N	13	2026-02-12 00:59:14.022+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A84AB7DB1C22C6D9940","_serialized":"false_58939920105695@lid_3A84AB7DB1C22C6D9940"},"type":"revoked","timestamp":1770643258,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A5CAC8673AE6183091D		0	t	image	1770857955059-0zizx.jpeg	13	2026-02-12 00:59:15.061+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A5CAC8673AE6183091D","_serialized":"false_58939920105695@lid_3A5CAC8673AE6183091D"},"type":"image","timestamp":1770643278,"from":"58939920105695@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A739AFAC751A99E6028		0	t	image	1770857955811-sgpcn.jpeg	13	2026-02-12 00:59:15.819+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A739AFAC751A99E6028","_serialized":"false_58939920105695@lid_3A739AFAC751A99E6028"},"type":"image","timestamp":1770643284,"from":"58939920105695@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AFDBA87BBFDC36F62A2		0	t	image	1770857957679-q4oyml.jpeg	13	2026-02-12 00:59:17.687+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3AFDBA87BBFDC36F62A2","_serialized":"false_58939920105695@lid_3AFDBA87BBFDC36F62A2"},"type":"image","timestamp":1770643433,"from":"58939920105695@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AFA47C3BF44605DA9F1	BEGIN:VCARD\nVERSION:3.0\nN:;;;;\nFN:Carlos Cavalcante\nitem1.TEL;waid=556799981961:+55 67 9998-1961\nitem1.X-ABLabel:Celular\nPHOTO;BASE64:/9j/4AAQSkZJRgABAQAAAQABAAD/4gIoSUNDX1BST0ZJTEUAAQEAAAIYAAAAAAIQAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AAAB3AAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z3BhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAIAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwADEANv/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIAGAAYAMBIgACEQEDEQH/xAAbAAACAwEBAQAAAAAAAAAAAAAFBgIEBwMBAP/EADsQAAIBAwIDBQcCBAQHAAAAAAECAwAEEQUhEjFBBhMiUWEUI3GBkaGxMkIHFVLRJXPB8DVTgpKy4fH/xAAZAQACAwEAAAAAAAAAAAAAAAADBAECBQD/xAAkEQACAgICAQMFAAAAAAAAAAABAgARAyESMQQUIlETMkFhcf/aAAwDAQACEQMRAD8AbXY8YI6Gr8PjgZPI7fA1QMsULd9M3DFH4nbGcKNydq76deW92gltpe8hfiVWAIzg+vwNZynUdIlokskbdcYNdnYvbg9Rj61XjPEkidQcih2o64LK6WyVMsycbSHkueQ9STn/AGaqRIuHCwEpbod/9a4QTwyTlY5UZlzkK2cUjX+t3cspjkYgJhsk8h8vXypR1bW5LW6d4Z2JKlQQfUY/1+tQO5NGbLcaU2q36xwzrHOISUVhs+Dvv05ipRdktaXZmtv+8/2rL+zfbi70eWG5bxEABBJkhgV3HPb/ANVv+iarFrejWupQqVSdOLhJzg5wRnruDRceJHJvuVbI+PqKcfZDVcyF/Zcs2Qe8byHpXWPsPO4zPeJGfKMFvucU719RfSY4M+TkmbdodEsdFsFmWSR5++WLjY4zxAkgDl0FBIjEwOZsVonam6stP0ySe5hifhBcBkDb4wOfXfHzrJdMUXMscfHKBI4UniO2TWS6lXKx3A5ZbMONcKsMju3CqqSWBxgY55wcfQ0N7J36S2dysbho4b2RUZTkMpPGDnA/qPQcq6rMixsZY1ljweKNxkOOoI6g1S0nWYrftZqtvcPGi3UEU/Co2R1ARhgcsjBpxW1KsvxHRGC3CnOzbUEa1n1Od7hVSIHwoxJzjp9sVffU7M2IYSoDyHn9OdfWgWCwRVOQACPWoJJGpXGltuBr/s3HbKGkkDOwySBilqbQrOVxxRhgCOfpTdqU8s0igk8GMUM7rGGI9edAbkI+mNa6lCXQLe509ogoVSuBgcqav4M6vcLBfaBdFm9n99CxbPhJww9N8H5mhDSsBtyHLFWOyVz/AC/tDdyW4EcxgOxUeIcQ3/FXwZODXAeXitdTZsivjsNqz6ftDrDSeG77sA/pWNCD9s1fg7W3aRgTQJI3VlJX7b056xDqZpwNF7+K38wvGs9PsHKlzxy52UqOhPxI+lLnZvQ9SW+tIGKPmRSwVzyByeYHQGnTWNRj1aWKTuO6KAjJYnOajpkVjHcpPdXDxCMhl4BzPx8qzqHLXzG1JVIlXsvdWc7mXugsbEyf0bc/lSxcWrWXsesxpwR20nvA362jbZmb15HHT8NOrRRLpF69wCYVgcyAD9vCc/avLS0hudP7mUB43ThIzkEYxR7AFwqmdY4w2+2OhohBrVjY6K1xds8caSOAccRIDEDlVKyt0tLKK2QsRCojBY5OBsKrjR7eKedbiMLJcHvY5W3fhIAKqTuMEZ25cQrsQGxOYkdSc3bDQLsrHDqEIf8Apbwn71Sn7RaZaWySS3UZ4mZVCniLAE7gClzUuz0dxqrSGYFcgsHJZVVRuTn0515F2MWxsIr1InRpo2aWLhPGsbk8O3moxkc+fWiMi1ZhEfJVS+O2i3TBbDT5Jl4sM7uqj5b86K9mBeal2ukvZIXtktoe7ZXwS4OTjI9eE0A0nTrez4lERkWVwxUJxZYbAkdOfpT52WtpBPeOQRJIONY+ZCjhHTmds/OgtxH2iQ3KrYw46rxcs1AgA7V40nirwuKDASWFPSpFRjFQVhmpZ2qDLCDNVsi2h3wEHfE28nuztx+E7fOgelxm2sLeFUkULGqhXOWGByJ860e90/h0q6IG4hc/Y0B0jR2knijwO+c7A/t9aZZCKWQmRaJM56bpjvIC0ZklbdYwM0S1jRpY7KOS+tozGWwA2G4T8KeNP06DT4BHEuWP6nPNjXmrWSahpk0DkLlchj+0jcGmk8XiLPcWPkW36mLXDWKavbwJEiJH7yUqozty+9Tvu0enTXPeq4Pg4e7Iww+VUpoHutTZLf3JwS0pGSTn+21CtQhnF4qyOokyVLoDhlOMjA68/hmquoZdx1crX7RC1teRJN3avlJN1B5r6H6079ioQ2pSTEECKM5PTcjH4NZk+lS2UAmhL3E7c1PN+uAB1rVtMgbTdCVZV7ueVQ9xg5wSP0g+g2+vnSZStidmyMV4tL1zBYakkl7MWTEhAeMgcS5wDuN6r/ySyu4XOm3xkkX9jgfmgs08t/cpEH7uJN+Feg9aK2l3HYL378Xd/pSNB4pKJ9PW4r/DKjaZqFuxElpLgdVXiH1FV3Z42CupU88EYps06+u9U99NF7Hb8o14syP6+QFT1rTvadLmWMAsql1JyTkb/flSz6MsuTdGEb6ELp1yccom/FA+y4U6lITzERx9RTHqP/DLr/Kb8GlnsyCNWYgbd0c+m4rWyADIsXTaNHCuF7IYrOZwvEQpwvnUreQyxcZGMk4HpUbuMz2kkanBZSAaOzewkQIG9zLJNCk0+9lglXhWOR3RgclgxJB9R+KBXbCPUeERjIYjiA6cs1qHaW1S20yfUXOPZbOT/qbhwPvSd2MsU1lf5pfsDawJhmfYO/ln7/Sk+zxIjyElC4Opb0jS2W3i1FggMbjBYZyev2rtqV2Xj2yIx+kE/eut1dm4YQxHgtYycYGKpcJu5cEYhQ7nz9K7Hh3uDbIezPdNsmldU5NKcsfJasSRrd3YbYRBgig8goq2ZBYafNdEe8ccKD47VSlcxac8nUoSvzFEIBNSAdQtBdMkgHQnYUwWxaSME8uXLnQ/RrFViW5fBldRz/aOf9qNcqRzYQWkPk1Uhqe2l3f+S/4NJehXrW2qoP8Amgx8vmPxTpqh/wAKvM8u4f8A8TWbJK8U8csTYdGDKRvuDWhnNMDK4hakTUIODuV7v9ONqC3FxrNxcziztligRSEZ2GXb+1eRX5te0Ytu8DW10hZcNkLIu5x8R0oxJPHHGSCMUQsK7gwDfURtXfV9d0O90W7It3lj8UnDuuGB9M74qjFappljaaTbZMNum3mzHmx9SaZ72VLh2htEd7h8cRx0z/8AKsWGgIkzyz7nYDfPQZ++aDtm1GOQVagK10uS4wG8EY/U3lVl7FfbDCpHdxHpsKM3+o2Vmvs3EpbqopbutTAjaO3ByxyW8q4tWpTjy3OWqTLcS9yhHdptVd/ewiEnw58NQijLHfrzqV0QrhF5KKEXrcKF/EadEkN3HESMoq4wfOmDg2pU7LTd0JBM3CoHECfI/wCzTNNeQw2/fs3g6evwo2Mow5GL5AeVT//Z\nEND:VCARD	0	t	vcard	\N	13	2026-02-12 00:59:18.053+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3AFA47C3BF44605DA9F1","_serialized":"false_58939920105695@lid_3AFA47C3BF44605DA9F1"},"type":"vcard","timestamp":1770818230,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":["BEGIN:VCARD\\nVERSION:3.0\\nN:;;;;\\nFN:Carlos Cavalcante\\nitem1.TEL;waid=556799981961:+55 67 9998-1961\\nitem1.X-ABLabel:Celular\\nPHOTO;BASE64:/9j/4AAQSkZJRgABAQAAAQABAAD/4gIoSUNDX1BST0ZJTEUAAQEAAAIYAAAAAAIQAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AAAB3AAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z3BhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAIAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwADEANv/bAEMACAYGBwYFCAcHBwkJCAoMFA0MCwsMGRITDxQdGh8eHRocHCAkLicgIiwjHBwoNyksMDE0NDQfJzk9ODI8LjM0Mv/bAEMBCQkJDAsMGA0NGDIhHCEyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMv/AABEIAGAAYAMBIgACEQEDEQH/xAAbAAACAwEBAQAAAAAAAAAAAAAFBgIEBwMBAP/EADsQAAIBAwIDBQcCBAQHAAAAAAECAwAEEQUhEjFBBhMiUWEUI3GBkaGxMkIHFVLRJXPB8DVTgpKy4fH/xAAZAQACAwEAAAAAAAAAAAAAAAADBAECBQD/xAAkEQACAgICAQMFAAAAAAAAAAABAgARAyESMQQUIlETMkFhcf/aAAwDAQACEQMRAD8AbXY8YI6Gr8PjgZPI7fA1QMsULd9M3DFH4nbGcKNydq76deW92gltpe8hfiVWAIzg+vwNZynUdIlokskbdcYNdnYvbg9Rj61XjPEkidQcih2o64LK6WyVMsycbSHkueQ9STn/AGaqRIuHCwEpbod/9a4QTwyTlY5UZlzkK2cUjX+t3cspjkYgJhsk8h8vXypR1bW5LW6d4Z2JKlQQfUY/1+tQO5NGbLcaU2q36xwzrHOISUVhs+Dvv05ipRdktaXZmtv+8/2rL+zfbi70eWG5bxEABBJkhgV3HPb/ANVv+iarFrejWupQqVSdOLhJzg5wRnruDRceJHJvuVbI+PqKcfZDVcyF/Zcs2Qe8byHpXWPsPO4zPeJGfKMFvucU719RfSY4M+TkmbdodEsdFsFmWSR5++WLjY4zxAkgDl0FBIjEwOZsVonam6stP0ySe5hifhBcBkDb4wOfXfHzrJdMUXMscfHKBI4UniO2TWS6lXKx3A5ZbMONcKsMju3CqqSWBxgY55wcfQ0N7J36S2dysbho4b2RUZTkMpPGDnA/qPQcq6rMixsZY1ljweKNxkOOoI6g1S0nWYrftZqtvcPGi3UEU/Co2R1ARhgcsjBpxW1KsvxHRGC3CnOzbUEa1n1Od7hVSIHwoxJzjp9sVffU7M2IYSoDyHn9OdfWgWCwRVOQACPWoJJGpXGltuBr/s3HbKGkkDOwySBilqbQrOVxxRhgCOfpTdqU8s0igk8GMUM7rGGI9edAbkI+mNa6lCXQLe509ogoVSuBgcqav4M6vcLBfaBdFm9n99CxbPhJww9N8H5mhDSsBtyHLFWOyVz/AC/tDdyW4EcxgOxUeIcQ3/FXwZODXAeXitdTZsivjsNqz6ftDrDSeG77sA/pWNCD9s1fg7W3aRgTQJI3VlJX7b056xDqZpwNF7+K38wvGs9PsHKlzxy52UqOhPxI+lLnZvQ9SW+tIGKPmRSwVzyByeYHQGnTWNRj1aWKTuO6KAjJYnOajpkVjHcpPdXDxCMhl4BzPx8qzqHLXzG1JVIlXsvdWc7mXugsbEyf0bc/lSxcWrWXsesxpwR20nvA362jbZmb15HHT8NOrRRLpF69wCYVgcyAD9vCc/avLS0hudP7mUB43ThIzkEYxR7AFwqmdY4w2+2OhohBrVjY6K1xds8caSOAccRIDEDlVKyt0tLKK2QsRCojBY5OBsKrjR7eKedbiMLJcHvY5W3fhIAKqTuMEZ25cQrsQGxOYkdSc3bDQLsrHDqEIf8Apbwn71Sn7RaZaWySS3UZ4mZVCniLAE7gClzUuz0dxqrSGYFcgsHJZVVRuTn0515F2MWxsIr1InRpo2aWLhPGsbk8O3moxkc+fWiMi1ZhEfJVS+O2i3TBbDT5Jl4sM7uqj5b86K9mBeal2ukvZIXtktoe7ZXwS4OTjI9eE0A0nTrez4lERkWVwxUJxZYbAkdOfpT52WtpBPeOQRJIONY+ZCjhHTmds/OgtxH2iQ3KrYw46rxcs1AgA7V40nirwuKDASWFPSpFRjFQVhmpZ2qDLCDNVsi2h3wEHfE28nuztx+E7fOgelxm2sLeFUkULGqhXOWGByJ860e90/h0q6IG4hc/Y0B0jR2knijwO+c7A/t9aZZCKWQmRaJM56bpjvIC0ZklbdYwM0S1jRpY7KOS+tozGWwA2G4T8KeNP06DT4BHEuWP6nPNjXmrWSahpk0DkLlchj+0jcGmk8XiLPcWPkW36mLXDWKavbwJEiJH7yUqozty+9Tvu0enTXPeq4Pg4e7Iww+VUpoHutTZLf3JwS0pGSTn+21CtQhnF4qyOokyVLoDhlOMjA68/hmquoZdx1crX7RC1teRJN3avlJN1B5r6H6079ioQ2pSTEECKM5PTcjH4NZk+lS2UAmhL3E7c1PN+uAB1rVtMgbTdCVZV7ueVQ9xg5wSP0g+g2+vnSZStidmyMV4tL1zBYakkl7MWTEhAeMgcS5wDuN6r/ySyu4XOm3xkkX9jgfmgs08t/cpEH7uJN+Feg9aK2l3HYL378Xd/pSNB4pKJ9PW4r/DKjaZqFuxElpLgdVXiH1FV3Z42CupU88EYps06+u9U99NF7Hb8o14syP6+QFT1rTvadLmWMAsql1JyTkb/flSz6MsuTdGEb6ELp1yccom/FA+y4U6lITzERx9RTHqP/DLr/Kb8GlnsyCNWYgbd0c+m4rWyADIsXTaNHCuF7IYrOZwvEQpwvnUreQyxcZGMk4HpUbuMz2kkanBZSAaOzewkQIG9zLJNCk0+9lglXhWOR3RgclgxJB9R+KBXbCPUeERjIYjiA6cs1qHaW1S20yfUXOPZbOT/qbhwPvSd2MsU1lf5pfsDawJhmfYO/ln7/Sk+zxIjyElC4Opb0jS2W3i1FggMbjBYZyev2rtqV2Xj2yIx+kE/eut1dm4YQxHgtYycYGKpcJu5cEYhQ7nz9K7Hh3uDbIezPdNsmldU5NKcsfJasSRrd3YbYRBgig8goq2ZBYafNdEe8ccKD47VSlcxac8nUoSvzFEIBNSAdQtBdMkgHQnYUwWxaSME8uXLnQ/RrFViW5fBldRz/aOf9qNcqRzYQWkPk1Uhqe2l3f+S/4NJehXrW2qoP8Amgx8vmPxTpqh/wAKvM8u4f8A8TWbJK8U8csTYdGDKRvuDWhnNMDK4hakTUIODuV7v9ONqC3FxrNxcziztligRSEZ2GXb+1eRX5te0Ytu8DW10hZcNkLIu5x8R0oxJPHHGSCMUQsK7gwDfURtXfV9d0O90W7It3lj8UnDuuGB9M74qjFappljaaTbZMNum3mzHmx9SaZ72VLh2htEd7h8cRx0z/8AKsWGgIkzyz7nYDfPQZ++aDtm1GOQVagK10uS4wG8EY/U3lVl7FfbDCpHdxHpsKM3+o2Vmvs3EpbqopbutTAjaO3ByxyW8q4tWpTjy3OWqTLcS9yhHdptVd/ewiEnw58NQijLHfrzqV0QrhF5KKEXrcKF/EadEkN3HESMoq4wfOmDg2pU7LTd0JBM3CoHECfI/wCzTNNeQw2/fs3g6evwo2Mow5GL5AeVT//Z\\nEND:VCARD"],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0ED31058A451C374192	Já vai voltar	3	t	chat	\N	3	2026-02-12 00:59:25.351+00	2026-02-12 00:59:25.351+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"3EB0ED31058A451C374192","_serialized":"true_125271831228508@lid_3EB0ED31058A451C374192"},"type":"chat","timestamp":1770145512,"from":"151909402964196@lid","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5DB7828B73945C598484424EF523884	Tem sim	3	t	chat	\N	3	2026-02-12 00:59:27.538+00	2026-02-12 00:59:27.538+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A5DB7828B73945C598484424EF523884","_serialized":"true_125271831228508@lid_A5DB7828B73945C598484424EF523884"},"type":"chat","timestamp":1770724641,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A58800665295443D67C0EEB674C8A0BC		4	t	audio	1770857968243-1rrfwk4g.oga	3	2026-02-12 00:59:28.249+00	2026-02-12 00:59:28.249+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A58800665295443D67C0EEB674C8A0BC","_serialized":"true_125271831228508@lid_A58800665295443D67C0EEB674C8A0BC"},"type":"ptt","timestamp":1770724675,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"28","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC528704E8107FFCF3750BEEFF207FBC		1	f	chat	\N	24	2026-02-12 11:19:05.548+00	2026-02-12 11:19:05.617+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC528704E8107FFCF3750BEEFF207FBC","_serialized":"false_175681342312561@lid_AC528704E8107FFCF3750BEEFF207FBC"},"type":"album","timestamp":1770895143,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5DA40082D3F92D98438A35ADB541EB7	Tá	3	t	chat	\N	3	2026-02-12 00:59:29.919+00	2026-02-12 00:59:29.919+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A5DA40082D3F92D98438A35ADB541EB7","_serialized":"true_125271831228508@lid_A5DA40082D3F92D98438A35ADB541EB7"},"type":"chat","timestamp":1770815911,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52E6A5AF20085BCD59EC153E5286CBA	222 é da Geovana	3	t	chat	\N	3	2026-02-12 00:59:30.64+00	2026-02-12 00:59:30.64+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A52E6A5AF20085BCD59EC153E5286CBA","_serialized":"true_125271831228508@lid_A52E6A5AF20085BCD59EC153E5286CBA"},"type":"chat","timestamp":1770815925,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53E9DEB29CB795AC9BD3DB5CAD35EC9	220	3	t	chat	\N	3	2026-02-12 00:59:31.903+00	2026-02-12 00:59:31.903+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"125271831228508@lid","id":"A53E9DEB29CB795AC9BD3DB5CAD35EC9","_serialized":"true_125271831228508@lid_A53E9DEB29CB795AC9BD3DB5CAD35EC9"},"type":"chat","timestamp":1770816719,"from":"556592694840@c.us","to":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC894D642CF984C4653EADB69202644F		1	f	image	1770895146567-rln2n5.jpeg	24	2026-02-12 11:19:06.594+00	2026-02-12 11:19:06.639+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC894D642CF984C4653EADB69202644F","_serialized":"false_175681342312561@lid_AC894D642CF984C4653EADB69202644F"},"type":"image","timestamp":1770895144,"from":"175681342312561@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A51430015C428F4BAAE	Ok	0	t	chat	\N	14	2026-02-12 00:59:25.722+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A51430015C428F4BAAE","_serialized":"false_125271831228508@lid_3A51430015C428F4BAAE"},"type":"chat","timestamp":1770145539,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA44769DA2D44FEC30E		4	t	audio	1770857966377-kbidfu.oga	14	2026-02-12 00:59:26.379+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3AA44769DA2D44FEC30E","_serialized":"false_125271831228508@lid_3AA44769DA2D44FEC30E"},"type":"ptt","timestamp":1770652218,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"9","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A57E3498D0E6C5DAE683B53D5B0BECBA	Cópia esse ai	0	f	chat	\N	73	2026-02-12 23:45:52.394+00	2026-02-12 23:50:52.484+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
3EB03C8B13293F2164F268	SELECT COUNT(T.ID_LOG)\n  FROM SS$REP.SS$LOG_REPLICA T\n WHERE T.TENTATIVAS = 0	0	f	chat	\N	73	2026-02-12 23:45:53.67+00	2026-02-12 23:50:53.752+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
3EB03AE9F4B5F4A773F01B	10k acumulo - 30k parado em algum lugar	0	f	chat	\N	73	2026-02-12 23:45:54.861+00	2026-02-12 23:50:54.981+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
A5A13DDE647AC777581A8B0EB3D566E7	🎵 Áudio	4	f	audio	1770939956091-A5A13DDE647A.ogg	73	2026-02-12 23:45:56.109+00	2026-02-12 23:50:56.504+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
A5379559DDB8891300A1EA8D5C112973	🎵 Áudio	4	f	audio	1770939958177-A5379559DDB8.ogg	73	2026-02-12 23:45:58.185+00	2026-02-12 23:50:58.447+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
A5204DF94B1984A0D76650DEECEB7E2B	🎵 Áudio	4	f	audio	1770939959584-A5204DF94B19.ogg	73	2026-02-12 23:45:59.598+00	2026-02-12 23:50:59.693+00	f	f	57	\N	1	\N	\N	\N	2	f	waiting	\N
ACB4A6C02B374051BE1B4D7942058BB5		1	f	image	1770895146539-44v3t.jpeg	24	2026-02-12 11:19:06.594+00	2026-02-12 11:19:06.659+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACB4A6C02B374051BE1B4D7942058BB5","_serialized":"false_175681342312561@lid_ACB4A6C02B374051BE1B4D7942058BB5"},"type":"image","timestamp":1770895144,"from":"175681342312561@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC7A1A30C5936A5F50A4A8D4E270C794		1	f	image	1770895690243-xeywk7.jpeg	16	2026-02-12 11:28:10.251+00	2026-02-12 11:28:10.287+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC7A1A30C5936A5F50A4A8D4E270C794","_serialized":"false_131752601366700@lid_AC7A1A30C5936A5F50A4A8D4E270C794"},"type":"image","timestamp":1770895689,"from":"131752601366700@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC33C6AF2E2F8E58BBC1588A55A7DEFB	Cai só algumas	1	f	chat	\N	16	2026-02-12 11:28:14.642+00	2026-02-12 11:28:14.673+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC33C6AF2E2F8E58BBC1588A55A7DEFB","_serialized":"false_131752601366700@lid_AC33C6AF2E2F8E58BBC1588A55A7DEFB"},"type":"chat","timestamp":1770895694,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
ACA54DEEF8470471C7FF012C64B46D63		4	f	audio	1770895156762-20odpj.oga	24	2026-02-12 11:19:16.765+00	2026-02-12 11:21:11.227+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACA54DEEF8470471C7FF012C64B46D63","_serialized":"false_175681342312561@lid_ACA54DEEF8470471C7FF012C64B46D63"},"type":"ptt","timestamp":1770895156,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC870A725E1B1A5F25E02DF51A9867E5		4	f	audio	1770895168041-6iu3jh.oga	24	2026-02-12 11:19:28.048+00	2026-02-12 11:21:20.259+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC870A725E1B1A5F25E02DF51A9867E5","_serialized":"false_175681342312561@lid_AC870A725E1B1A5F25E02DF51A9867E5"},"type":"ptt","timestamp":1770895167,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"10","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB00037E455B254FF06C6	entradando	3	t	chat	\N	3	2026-02-12 00:59:37.249+00	2026-02-12 00:59:37.249+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"120363405293949287@g.us","id":"3EB00037E455B254FF06C6","participant":{"server":"lid","user":"151909402964196","_serialized":"151909402964196@lid"},"_serialized":"true_120363405293949287@g.us_3EB00037E455B254FF06C6_151909402964196@lid"},"type":"chat","timestamp":1770814573,"from":"151909402964196@lid","to":"120363405293949287@g.us","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC83F659E0E5F4954E6630570F358CFF		4	f	audio	1770895181590-d7ecz.oga	24	2026-02-12 11:19:41.598+00	2026-02-12 11:21:31.344+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC83F659E0E5F4954E6630570F358CFF","_serialized":"false_175681342312561@lid_AC83F659E0E5F4954E6630570F358CFF"},"type":"ptt","timestamp":1770895181,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"11","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A07575AD47C285F9FFE	Só se ele deixar né	0	f	chat	\N	97	2026-02-12 23:46:23.453+00	2026-02-12 23:51:23.632+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
3AFF46F496EA0EEB6EE9	Não	0	f	chat	\N	97	2026-02-12 23:46:27.169+00	2026-02-12 23:51:27.339+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
3AB92E5AB97236E08829	Já já	0	f	chat	\N	97	2026-02-12 23:46:29.503+00	2026-02-12 23:51:29.702+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
3A1599CB20638E7D0FC2	Estou esquentando	0	f	chat	\N	97	2026-02-12 23:46:30.653+00	2026-02-12 23:51:30.78+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
3A670C0F16C9696ACCA3	Comida	0	f	chat	\N	97	2026-02-12 23:46:31.34+00	2026-02-12 23:51:31.472+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
AC76CF5C206FBFA58064B0DE46B6DA3A	Boa noite	0	f	chat	\N	108	2026-02-12 23:46:35.215+00	2026-02-12 23:51:35.763+00	f	f	59	\N	1	\N	\N	\N	2	f	waiting	\N
AC3C6E4CAE3F2D7B430370E3F80AB50D	Amanha nao da	0	f	chat	\N	108	2026-02-12 23:46:37.486+00	2026-02-12 23:51:37.603+00	f	f	59	\N	1	\N	\N	\N	2	f	waiting	\N
AC6DEEBBD849E34437F14BFBAB60A255	Sabado depois a tarde	0	f	chat	\N	108	2026-02-12 23:46:39.027+00	2026-02-12 23:51:39.081+00	f	f	59	\N	1	\N	\N	\N	2	f	waiting	\N
AC7131B89DCAD073C4FA5D6A1E73E32D	Te confirmo amanha	0	f	chat	\N	108	2026-02-12 23:46:40.835+00	2026-02-12 23:51:40.896+00	f	f	59	\N	1	\N	\N	\N	2	f	waiting	\N
AC18172B85EDC3ABC44492B3DED7C35E	Ok	0	f	chat	\N	108	2026-02-12 23:46:41.328+00	2026-02-12 23:51:41.376+00	f	f	59	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0F69DD026D9630B22FA	User.: rodrigo.silva@uniaoavicola.ind.br\nPassWord.: Mhorph3us@2035proth3usç	0	f	chat	\N	118	2026-02-12 23:46:43.127+00	2026-02-12 23:51:43.325+00	f	f	60	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B8DB0BDC19803B66B5	uniaoavicola	0	f	chat	\N	118	2026-02-12 23:46:44.321+00	2026-02-12 23:51:44.409+00	f	f	60	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0C1578EFB639C6B03D4	feito	0	f	chat	\N	118	2026-02-12 23:46:45.276+00	2026-02-12 23:51:45.354+00	f	f	60	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0A6EF618FAA2FB30374	Blz	0	f	chat	\N	118	2026-02-12 23:46:47.134+00	2026-02-12 23:51:47.784+00	f	f	60	\N	1	\N	\N	\N	2	f	waiting	\N
ACF67E78AA5485191968404E938A8333	Faça isso	0	f	chat	\N	128	2026-02-12 23:46:50.037+00	2026-02-12 23:51:50.107+00	f	f	61	\N	1	\N	\N	\N	2	f	waiting	\N
3EB069A360B2F09DA30035	o quanto antes	0	f	chat	\N	128	2026-02-12 23:46:50.568+00	2026-02-12 23:51:50.62+00	f	f	61	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0093B63EAF845CC4FB7	quanto tempo para o sistema voltar a funcionar\n?	0	f	chat	\N	128	2026-02-12 23:46:52.434+00	2026-02-12 23:51:52.486+00	f	f	61	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0480163CAC157BF223C	não	0	f	chat	\N	128	2026-02-12 23:46:54.863+00	2026-02-12 23:51:54.937+00	f	f	61	\N	1	\N	\N	\N	2	f	waiting	\N
AC66E83A23FA6E30EFE680E847637493	Sim	0	f	chat	\N	144	2026-02-12 23:47:08.665+00	2026-02-12 23:52:08.716+00	f	f	62	\N	1	\N	\N	\N	2	f	waiting	\N
3EB03B0A9DDD0009A3CBE2	ligou duro 10min morreu	0	f	chat	\N	144	2026-02-12 23:47:09.186+00	2026-02-12 23:52:09.294+00	f	f	62	\N	1	\N	\N	\N	2	f	waiting	\N
3EB083D5EE972717F01451	marco-big.conf	0	f	document	1770940031462-marco-big.conf	144	2026-02-12 23:47:11.48+00	2026-02-12 23:52:11.586+00	f	f	62	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0EDB3B6D7D551DCA0BF	helio falou que ta fazendo outro bkp do performace	0	f	chat	\N	144	2026-02-12 23:47:12.975+00	2026-02-12 23:52:13.028+00	f	f	62	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0F657E2A4E2A8A65483	entendi	0	f	chat	\N	152	2026-02-12 23:47:15.927+00	2026-02-12 23:52:15.961+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0521462C58AA9242FB3	tudo bem	0	f	chat	\N	152	2026-02-12 23:47:16.545+00	2026-02-12 23:52:16.585+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0217C36B5C7274C0D0E	boa noite, o sistema de alarme ainda não foi ativado, tem previsão para ativação ?	0	f	chat	\N	152	2026-02-12 23:47:17.164+00	2026-02-12 23:52:17.219+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B9336E6B1B8D1BB60A	ta meio lento	3	t	chat	\N	3	2026-02-12 00:59:38.66+00	2026-02-12 00:59:38.66+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"120363405293949287@g.us","id":"3EB0B9336E6B1B8D1BB60A","participant":{"server":"lid","user":"151909402964196","_serialized":"151909402964196@lid"},"_serialized":"true_120363405293949287@g.us_3EB0B9336E6B1B8D1BB60A_151909402964196@lid"},"type":"chat","timestamp":1770814578,"from":"151909402964196@lid","to":"120363405293949287@g.us","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F010B62EFCC0A244C67498474A5A4A	Grupo não tem	2	t	chat	\N	3	2026-02-12 11:21:42.919+00	2026-02-12 11:21:43.049+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A5F010B62EFCC0A244C67498474A5A4A","_serialized":"true_175681342312561@lid_A5F010B62EFCC0A244C67498474A5A4A"},"type":"chat","timestamp":1770895301,"from":"556592694840@c.us","to":"175681342312561@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5F7EAF73B4F26B87D6A6672E79E7CB9	São essas entregas?	3	t	chat	\N	3	2026-02-12 00:59:41.983+00	2026-02-12 00:59:41.983+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A5F7EAF73B4F26B87D6A6672E79E7CB9","_serialized":"true_131752601366700@lid_A5F7EAF73B4F26B87D6A6672E79E7CB9"},"type":"chat","timestamp":1770143461,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F587BFB90E2A8B71C2D616AE971828	Beleza	3	t	chat	\N	3	2026-02-12 00:59:43.331+00	2026-02-12 00:59:43.331+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A5F587BFB90E2A8B71C2D616AE971828","_serialized":"true_131752601366700@lid_A5F587BFB90E2A8B71C2D616AE971828"},"type":"chat","timestamp":1770143496,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F75ACA4E3BEA7DE3DBE22A38437041	Bom dia	2	t	chat	\N	3	2026-02-12 11:21:55.286+00	2026-02-12 11:21:55.531+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A5F75ACA4E3BEA7DE3DBE22A38437041","_serialized":"true_175681342312561@lid_A5F75ACA4E3BEA7DE3DBE22A38437041"},"type":"chat","timestamp":1770895313,"from":"556592694840@c.us","to":"175681342312561@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A56A1B4A79FBF03DB24BBE4D78A1785B	N to conseguindo acessar	0	t	chat	\N	15	2026-02-12 00:59:38.981+00	2026-02-12 01:40:46.866+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"A56A1B4A79FBF03DB24BBE4D78A1785B","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_120363405293949287@g.us_A56A1B4A79FBF03DB24BBE4D78A1785B_164703422648560@lid"},"type":"chat","timestamp":1770814597,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A527572FA1DD97BC431D967DA791CA2F	Compartilha novamente, pf	0	t	chat	\N	15	2026-02-12 00:59:39.339+00	2026-02-12 01:40:46.866+00	f	f	11	3EB0E81C750218A9192F28	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"A527572FA1DD97BC431D967DA791CA2F","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_120363405293949287@g.us_A527572FA1DD97BC431D967DA791CA2F_164703422648560@lid"},"type":"chat","timestamp":1770814776,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"164703422648560@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB026F6D5451846412686	vou verificar	0	f	chat	\N	152	2026-02-12 23:47:18.942+00	2026-02-12 23:52:18.989+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B19F926CB2160EDC7C	sim	0	f	image	1770940039634-3EB0B19F926C.jpeg	152	2026-02-12 23:47:19.642+00	2026-02-12 23:52:19.697+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3EB06C4C3E632702EDE0C3	ve com eles ate que horas vão ficar	0	f	chat	\N	152	2026-02-12 23:47:20.229+00	2026-02-12 23:52:20.277+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B9F964E548AEDD1CE4	consigo	0	f	chat	\N	152	2026-02-12 23:47:22.112+00	2026-02-12 23:52:22.169+00	f	f	63	\N	1	\N	\N	\N	2	f	waiting	\N
3AAE50E0CE06363BF2BB	Depende do adv kkk	0	f	chat	\N	162	2026-02-12 23:47:24.011+00	2026-02-12 23:52:24.148+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3A36B009260CD0055D72	Em médica 4 meses após a data da audiência	0	f	chat	\N	162	2026-02-12 23:47:25.388+00	2026-02-12 23:52:25.483+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3ADF5DE5A0344C348B5D	Nda azul é rica 🤑	0	f	chat	\N	162	2026-02-12 23:47:26.136+00	2026-02-12 23:52:26.222+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3A3E6AD9B9E56476AF7D	Não está em recuperação judicial	0	f	chat	\N	162	2026-02-12 23:47:26.924+00	2026-02-12 23:52:27.005+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3AD701AAAC4B40F0F32C	Geralmente eles oferecem proposta de acordo	0	f	chat	\N	162	2026-02-12 23:47:27.433+00	2026-02-12 23:52:27.49+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3ADC96AC24FF85E55F2E	03 passagens ida e volta  para qualquer lugar do Brasil	0	f	chat	\N	162	2026-02-12 23:47:28.846+00	2026-02-12 23:52:28.898+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3AC8E8D8F60641AFBC0A	Kkk meu sonho	0	f	chat	\N	162	2026-02-12 23:47:29.382+00	2026-02-12 23:52:29.448+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3A59F6FFB5D2095AF637	Esse tipo de ação média 3 a 4k	0	f	chat	\N	162	2026-02-12 23:47:29.827+00	2026-02-12 23:52:29.877+00	f	f	64	\N	1	\N	\N	\N	2	f	waiting	\N
3AE5A87D6C8015BCCBC9	Não deixa eu trocar de: @redeloja\nPara:\n@rededistribuidora	0	f	chat	\N	169	2026-02-12 23:47:30.804+00	2026-02-12 23:52:30.87+00	f	f	65	\N	1	\N	\N	\N	2	f	waiting	\N
3A8F74E8C7DAFD7061B3	📷 Imagem	0	f	image	1770940053296-3A8F74E8C7DA.jpeg	169	2026-02-12 23:47:33.3+00	2026-02-12 23:52:33.39+00	f	f	65	\N	1	\N	\N	\N	2	f	waiting	\N
3AE86EFB36098B3B8669	Acho que foi	0	f	chat	\N	169	2026-02-12 23:47:34.074+00	2026-02-12 23:52:34.12+00	f	f	65	\N	1	\N	\N	\N	2	f	waiting	\N
3B8DEFAF328DEEDF4B63	🎵 Áudio	0	f	audio	1770940055644-3B8DEFAF328D.ogg	169	2026-02-12 23:47:35.662+00	2026-02-12 23:52:35.711+00	f	f	65	\N	1	\N	\N	\N	2	f	waiting	\N
3BBE9B936771C345281E	luan	0	f	chat	\N	169	2026-02-12 23:47:38.48+00	2026-02-12 23:52:38.532+00	f	f	65	\N	1	\N	\N	\N	2	f	waiting	\N
3BE31D6C62DB5A933D4E	pode resolver por ai mesmo	0	f	chat	\N	169	2026-02-12 23:47:38.947+00	2026-02-12 23:52:39+00	f	f	65	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0C533BAAE5DE99EF35F	momento	3	t	chat	\N	3	2026-02-12 00:59:44.576+00	2026-02-12 00:59:44.576+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"3EB0C533BAAE5DE99EF35F","_serialized":"true_131752601366700@lid_3EB0C533BAAE5DE99EF35F"},"type":"chat","timestamp":1770145557,"from":"151909402964196@lid","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB008787C3047A6B9238F	verifica se voltou	3	t	chat	\N	3	2026-02-12 00:59:45.73+00	2026-02-12 00:59:45.73+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"3EB008787C3047A6B9238F","_serialized":"true_131752601366700@lid_3EB008787C3047A6B9238F"},"type":"chat","timestamp":1770145563,"from":"151909402964196@lid","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F1082E7508CF19A1D04D8E2CCD9C7F	Estamos mexendo no servidor	3	t	chat	\N	3	2026-02-12 00:59:47.304+00	2026-02-12 00:59:47.304+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A5F1082E7508CF19A1D04D8E2CCD9C7F","_serialized":"true_131752601366700@lid_A5F1082E7508CF19A1D04D8E2CCD9C7F"},"type":"chat","timestamp":1770147480,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A596B3DB8FD912B896E17C35873C42F3	Para não cair	3	t	chat	\N	3	2026-02-12 00:59:47.95+00	2026-02-12 00:59:47.95+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A596B3DB8FD912B896E17C35873C42F3","_serialized":"true_131752601366700@lid_A596B3DB8FD912B896E17C35873C42F3"},"type":"chat","timestamp":1770147483,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A571C495ED466EC4844467A383C021D2	Não ta caindo no sistema porque não deixaram lógico da fila	2	t	chat	\N	3	2026-02-12 11:22:31.215+00	2026-02-12 11:22:31.316+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A571C495ED466EC4844467A383C021D2","_serialized":"true_175681342312561@lid_A571C495ED466EC4844467A383C021D2"},"type":"chat","timestamp":1770895349,"from":"556592694840@c.us","to":"175681342312561@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A56BE5C466425F7D984B62DE64046DA2	Portaria da ANVISA que proibi a imagens e propaganda  de medicamentos	3	t	chat	\N	3	2026-02-12 00:59:49.011+00	2026-02-12 00:59:49.011+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A56BE5C466425F7D984B62DE64046DA2","_serialized":"true_131752601366700@lid_A56BE5C466425F7D984B62DE64046DA2"},"type":"chat","timestamp":1770760032,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A59BC1DD09C023F032E6FA9F5A2CA78F	https://bvsms.saude.gov.br/bvs/saudelegis/anvisa/2008/rdc0096_17_12_2008.html?utm_source=chatgpt.com	3	t	chat	\N	3	2026-02-12 00:59:50.056+00	2026-02-12 00:59:50.056+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A59BC1DD09C023F032E6FA9F5A2CA78F","_serialized":"true_131752601366700@lid_A59BC1DD09C023F032E6FA9F5A2CA78F"},"type":"chat","timestamp":1770760032,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A57BF23CF3232F7BE427DBC385D37988		4	t	audio	1770857991303-puua9g.oga	3	2026-02-12 00:59:51.342+00	2026-02-12 00:59:51.342+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A57BF23CF3232F7BE427DBC385D37988","_serialized":"true_131752601366700@lid_A57BF23CF3232F7BE427DBC385D37988"},"type":"ptt","timestamp":1770761204,"from":"556592694840@c.us","to":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"35","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACEFCF2375E6B184585B94D004C1C774	Sim	0	t	chat	\N	16	2026-02-12 00:59:45.962+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACEFCF2375E6B184585B94D004C1C774","_serialized":"false_131752601366700@lid_ACEFCF2375E6B184585B94D004C1C774"},"type":"chat","timestamp":1770146472,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03C227F72424E41EBBE	📷 Imagem	0	f	image	1770940067223-3EB03C227F72.jpeg	179	2026-02-12 23:47:47.249+00	2026-02-12 23:52:47.389+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B4C9A27A5C33904EC0	📷 Imagem	0	f	image	1770940068194-3EB0B4C9A27A.jpeg	179	2026-02-12 23:47:48.198+00	2026-02-12 23:52:48.272+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB02D3E80BAFE4CBDBA12	📷 Imagem	0	f	image	1770940068831-3EB02D3E80BA.jpeg	179	2026-02-12 23:47:48.842+00	2026-02-12 23:52:48.891+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0F1D13F98EF04E497C3	isso aqui dentro da maquina virtual ...	0	f	image	1770940069699-3EB0F1D13F98.jpeg	179	2026-02-12 23:47:49.715+00	2026-02-12 23:52:49.835+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB06BA6AF84C5420E96BD	depois de fazer o resize ... tem que reiniciar a vm ?	0	f	chat	\N	179	2026-02-12 23:47:51.461+00	2026-02-12 23:52:51.535+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0C211455E84285ADFB2	📷 Imagem	0	f	image	1770940072735-3EB0C211455E.jpeg	179	2026-02-12 23:47:52.739+00	2026-02-12 23:52:52.811+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0122F8E3469A91688C6	vou ver aqui como faz pra aumentar ... pq nao ta aparecendo opção pra simplesmente aumentar o tabanho da de 50gb ... mas agora eh windows ... eu vejo aqui	0	f	chat	\N	179	2026-02-12 23:47:53.342+00	2026-02-12 23:52:53.389+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3EB07D295C8426AB892CF9	blz ... valeuw	0	f	chat	\N	179	2026-02-12 23:47:54.499+00	2026-02-12 23:52:54.602+00	f	f	66	\N	1	\N	\N	\N	2	f	waiting	\N
3AFB700829B44FC8D5CC	Bom dia, Luan.\nEu consigo após as 15h.\nPode ser?\nMe dá um alô perto desse horário, por favor.	0	f	chat	\N	189	2026-02-12 23:47:56.753+00	2026-02-12 23:52:56.823+00	f	f	67	\N	1	\N	\N	\N	2	f	waiting	\N
3A81F79405DD41F52DDF	Não consigo, Luan.\nPode ser amanhã entre 9h e 10h?	0	f	chat	\N	189	2026-02-12 23:47:57.861+00	2026-02-12 23:52:57.909+00	f	f	67	\N	1	\N	\N	\N	2	f	waiting	\N
AC794D2B87A3BD78B0A243A2203E81BE	🎵 Áudio	4	f	audio	1770940079842-AC794D2B87A3.ogg	193	2026-02-12 23:47:59.849+00	2026-02-12 23:52:59.892+00	f	f	68	\N	1	\N	\N	\N	2	f	waiting	\N
3EB05CF663CDC425F567B9	uma não volta	3	t	chat	\N	3	2026-02-12 00:59:55.52+00	2026-02-12 00:59:55.52+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB05CF663CDC425F567B9","_serialized":"true_128050339545203@lid_3EB05CF663CDC425F567B9"},"type":"chat","timestamp":1770740551,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E3A97EB0F4DFBF39B8	vou tentar esta outra	3	t	chat	\N	3	2026-02-12 00:59:56.711+00	2026-02-12 00:59:56.711+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0E3A97EB0F4DFBF39B8","_serialized":"true_128050339545203@lid_3EB0E3A97EB0F4DFBF39B8"},"type":"chat","timestamp":1770740553,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0577762B626D73CF50D	tem que ficar de olho nas filas	3	t	chat	\N	3	2026-02-12 00:59:58.298+00	2026-02-12 00:59:58.298+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0577762B626D73CF50D","_serialized":"true_128050339545203@lid_3EB0577762B626D73CF50D"},"type":"chat","timestamp":1770740559,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BDC993ECF4D583B766	estão desativando	3	t	chat	\N	3	2026-02-12 00:59:59.319+00	2026-02-12 00:59:59.319+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0BDC993ECF4D583B766","_serialized":"true_128050339545203@lid_3EB0BDC993ECF4D583B766"},"type":"chat","timestamp":1770740562,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A558D26A7B49AC18033BFA54295BE975	Perai que vou gravar	3	t	chat	\N	3	2026-02-12 01:00:00.469+00	2026-02-12 01:00:00.469+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"A558D26A7B49AC18033BFA54295BE975","_serialized":"true_128050339545203@lid_A558D26A7B49AC18033BFA54295BE975"},"type":"chat","timestamp":1770740728,"from":"556592694840@c.us","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A538EF9E63E72DFF05FBBF23F4274311	Logado *	2	t	chat	\N	3	2026-02-12 11:25:14.65+00	2026-02-12 11:25:14.978+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A538EF9E63E72DFF05FBBF23F4274311","_serialized":"true_175681342312561@lid_A538EF9E63E72DFF05FBBF23F4274311"},"type":"chat","timestamp":1770895512,"from":"556592694840@c.us","to":"175681342312561@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0A27DAE25351C62B4E8	me passa do outro	3	t	chat	\N	3	2026-02-12 01:00:02.05+00	2026-02-12 01:00:02.05+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0A27DAE25351C62B4E8","_serialized":"true_128050339545203@lid_3EB0A27DAE25351C62B4E8"},"type":"chat","timestamp":1770740893,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EC7B329C2C95B8587C	nesse não tem	3	t	chat	\N	3	2026-02-12 01:00:03.278+00	2026-02-12 01:00:03.278+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0EC7B329C2C95B8587C","_serialized":"true_128050339545203@lid_3EB0EC7B329C2C95B8587C"},"type":"chat","timestamp":1770741013,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03AC5A15559142F5858	sim	3	t	chat	\N	3	2026-02-12 01:00:04.69+00	2026-02-12 01:00:04.69+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB03AC5A15559142F5858","_serialized":"true_128050339545203@lid_3EB03AC5A15559142F5858"},"type":"chat","timestamp":1770741041,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC8D7BFA6AF7FDFD2E4D0FA5DAC90F84	Combinado	0	t	chat	\N	16	2026-02-12 00:59:53.839+00	2026-02-12 01:40:45.973+00	f	f	17	A5668D682ED85C8B4BCFB42FF3D46F28	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC8D7BFA6AF7FDFD2E4D0FA5DAC90F84","_serialized":"false_131752601366700@lid_AC8D7BFA6AF7FDFD2E4D0FA5DAC90F84"},"type":"chat","timestamp":1770762805,"from":"131752601366700@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACDA7EC1FA5BC8505BF20B023A87CAF1	🎵 Áudio	4	f	audio	1770940081005-ACDA7EC1FA5B.ogg	193	2026-02-12 23:48:01.007+00	2026-02-12 23:53:01.083+00	f	f	68	\N	1	\N	\N	\N	2	f	waiting	\N
ACE56AE5381230B753FAC123F97A5199	🎵 Áudio	4	f	audio	1770940083962-ACE56AE53812.ogg	193	2026-02-12 23:48:03.969+00	2026-02-12 23:53:04.035+00	f	f	68	\N	1	\N	\N	\N	2	f	waiting	\N
AC7EE15B8DE0980C475E60BCB145B015	🎵 Áudio	4	f	audio	1770940085363-AC7EE15B8DE0.ogg	193	2026-02-12 23:48:05.371+00	2026-02-12 23:53:05.438+00	f	f	68	\N	1	\N	\N	\N	2	f	waiting	\N
ACFC50D08F647E8B216C1D32812471DA	Tmj	0	f	chat	\N	193	2026-02-12 23:48:06.253+00	2026-02-12 23:53:06.3+00	f	f	68	\N	1	\N	\N	\N	2	f	waiting	\N
A4B4F724C5760530D3	Luan, amanhã você vai mudar para o aplicativo Sicredi X!\nA partir de amanhã, você irá movimentar sua conta, cuidar do seu dinheiro com mais autonomia e ter uma experiência digital mais completa. \nBaixe seu novo aplicativo Sicredi X  e mantenha seu aplicativo atual Sicredi instalado. Será necessário configurar uma nova senha para realizar o primeiro acesso. \nQuer mais informações sobre *seu novo aplicativo?* Fale com o seu gerente ou *acesse a sessão perguntas frequentes e entenda as informações essências sobre a mudança:*	0	f	interactive	\N	204	2026-02-12 23:48:12.67+00	2026-02-12 23:53:12.793+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
9A2774B6DAC0C4D530	Luan, não foi possível fazer sua mudança de aplicativo.\nNão se preocupe, isso pode acontecer por diversos motivos, como a contratação de um produto indisponível no Sicredi X ou um imprevisto técnico que impediu que você pudesse utilizar o novo aplicativo. \n*Enquanto isso, você pode continuar acessando e movimentando sua conta pelo aplicativo atual Sicredi.* Em caso de dúvidas, fale com seu gerente.	0	f	chat	\N	204	2026-02-12 23:48:19.001+00	2026-02-12 23:53:19.04+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0A2B26DA0CBF5E6E3C4	então se voltar acompanhamos	3	t	chat	\N	3	2026-02-12 01:00:06.059+00	2026-02-12 01:00:06.059+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0A2B26DA0CBF5E6E3C4","_serialized":"true_128050339545203@lid_3EB0A2B26DA0CBF5E6E3C4"},"type":"chat","timestamp":1770741049,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C524FB8F781339C993D4C7ED1729FF	Sim	3	t	chat	\N	3	2026-02-12 01:00:07.021+00	2026-02-12 01:00:07.021+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"A5C524FB8F781339C993D4C7ED1729FF","_serialized":"true_128050339545203@lid_A5C524FB8F781339C993D4C7ED1729FF"},"type":"chat","timestamp":1770741755,"from":"556592694840@c.us","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FEF2B042C258CC0301	Portaria da ANVISA que proibi a imagens e propaganda  de medicamentos	3	t	chat	\N	3	2026-02-12 01:00:08.374+00	2026-02-12 01:00:08.374+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0FEF2B042C258CC0301","_serialized":"true_128050339545203@lid_3EB0FEF2B042C258CC0301"},"type":"chat","timestamp":1770762161,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0670702472416FEE3A4	https://bvsms.saude.gov.br/bvs/saudelegis/anvisa/2008/rdc0096_17_12_2008.html?utm_source=chatgpt.com	3	t	chat	\N	3	2026-02-12 01:00:09.564+00	2026-02-12 01:00:09.564+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"128050339545203@lid","id":"3EB0670702472416FEE3A4","_serialized":"true_128050339545203@lid_3EB0670702472416FEE3A4"},"type":"chat","timestamp":1770762161,"from":"151909402964196@lid","to":"128050339545203@lid","isForwarded":true,"forwardingScore":2,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D00774EF35A5BF63BC0180DED91A2E	Me passa o anydesk de um dos computadores	2	t	chat	\N	3	2026-02-12 11:25:29.439+00	2026-02-12 11:25:29.509+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A5D00774EF35A5BF63BC0180DED91A2E","_serialized":"true_175681342312561@lid_A5D00774EF35A5BF63BC0180DED91A2E"},"type":"chat","timestamp":1770895527,"from":"556592694840@c.us","to":"175681342312561@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5A0C6CB4DB9C0134F939ED686AC3E25	Esse era a outra maquina	3	t	chat	\N	3	2026-02-12 01:00:12.451+00	2026-02-12 01:00:12.451+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"A5A0C6CB4DB9C0134F939ED686AC3E25","_serialized":"true_236837582979101@lid_A5A0C6CB4DB9C0134F939ED686AC3E25"},"type":"chat","timestamp":1769567340,"from":"556592694840@c.us","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A55F11CD95BB079BD09E00A81BDF1BFA	Tem um monte de aba aberta ai	3	t	chat	\N	3	2026-02-12 01:00:13.464+00	2026-02-12 01:00:13.464+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"A55F11CD95BB079BD09E00A81BDF1BFA","_serialized":"true_236837582979101@lid_A55F11CD95BB079BD09E00A81BDF1BFA"},"type":"chat","timestamp":1769567347,"from":"556592694840@c.us","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
B7F12C4B9A53A4C533	Olá! *Você sabe quem é o(a) gerente da sua conta?* Confira no vídeo o passo a passo para saber o nome de quem está sempre disponível para atender você, *aqui pelo WhastApp ou na agência*. Conte conosco!	0	f	interactive	\N	204	2026-02-12 23:48:24.793+00	2026-02-12 23:53:25.006+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
3A35834C577183134CB7	Ok	0	t	chat	\N	17	2026-02-12 01:00:06.253+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3A35834C577183134CB7","_serialized":"false_128050339545203@lid_3A35834C577183134CB7"},"type":"chat","timestamp":1770741054,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A21A596B0270288910C	Pode usar os computadores né	0	t	chat	\N	17	2026-02-12 01:00:06.445+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3A21A596B0270288910C","_serialized":"false_128050339545203@lid_3A21A596B0270288910C"},"type":"chat","timestamp":1770741060,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
21E2195826F14DD9E9	Prezado(a) associado(a), informamos que seu acesso à Assembleia da Sicredi Ouro Verde MT estará liberado em 18/02/2026, às 19:00h por meio do Aplicativo Sicredi, na seção Assembleias.	0	f	chat	\N	204	2026-02-12 23:48:34.031+00	2026-02-12 23:53:34.091+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
ACD2050E2491BFE5F50B7E1A03F9BA50		1	f	image	1770895596692-buz2mg.jpeg	24	2026-02-12 11:26:36.727+00	2026-02-12 11:26:36.824+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACD2050E2491BFE5F50B7E1A03F9BA50","_serialized":"false_175681342312561@lid_ACD2050E2491BFE5F50B7E1A03F9BA50"},"type":"image","timestamp":1770895595,"from":"175681342312561@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0287F20EC6CF5134FF5	Boa tarde!	3	t	chat	\N	3	2026-02-12 01:00:26.14+00	2026-02-12 01:00:26.14+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"3EB0287F20EC6CF5134FF5","_serialized":"true_236837582979101@lid_3EB0287F20EC6CF5134FF5"},"type":"chat","timestamp":1770232813,"from":"151909402964196@lid","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EFA8908E4C2923E71D	arrumei essa opção hoje	3	t	chat	\N	3	2026-02-12 01:00:27.524+00	2026-02-12 01:00:27.524+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"3EB0EFA8908E4C2923E71D","_serialized":"true_236837582979101@lid_3EB0EFA8908E4C2923E71D"},"type":"chat","timestamp":1770232819,"from":"151909402964196@lid","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08F0FFDFBEC467B41DD	se caso acontecer tem a opção	3	t	chat	\N	3	2026-02-12 01:00:29.061+00	2026-02-12 01:00:29.061+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"3EB08F0FFDFBEC467B41DD","_serialized":"true_236837582979101@lid_3EB08F0FFDFBEC467B41DD"},"type":"chat","timestamp":1770232829,"from":"151909402964196@lid","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00804E9D506927748CA		3	t	image	1770858030674-u8w5ep.jpeg	3	2026-02-12 01:00:30.675+00	2026-02-12 01:00:30.675+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"3EB00804E9D506927748CA","_serialized":"true_236837582979101@lid_3EB00804E9D506927748CA"},"type":"image","timestamp":1770232864,"from":"151909402964196@lid","to":"236837582979101@lid","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5559001FCA20A98DB5CDE1B716EE9FF		4	t	audio	1770858031795-jwnt84.oga	3	2026-02-12 01:00:31.825+00	2026-02-12 01:00:31.825+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"A5559001FCA20A98DB5CDE1B716EE9FF","_serialized":"true_236837582979101@lid_A5559001FCA20A98DB5CDE1B716EE9FF"},"type":"ptt","timestamp":1770235149,"from":"556592694840@c.us","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"37","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A524FC1A3FF54688D8E16B014F6A5680	Portaria da ANVISA que proibi a imagens e propaganda  de medicamentos	2	t	chat	\N	3	2026-02-12 01:00:33.805+00	2026-02-12 01:00:33.805+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"A524FC1A3FF54688D8E16B014F6A5680","_serialized":"true_236837582979101@lid_A524FC1A3FF54688D8E16B014F6A5680"},"type":"chat","timestamp":1770760032,"from":"556592694840@c.us","to":"236837582979101@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5E982057B1B1C386FD020B0E4AB0752	https://bvsms.saude.gov.br/bvs/saudelegis/anvisa/2008/rdc0096_17_12_2008.html?utm_source=chatgpt.com	2	t	chat	\N	3	2026-02-12 01:00:34.424+00	2026-02-12 01:00:34.424+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"236837582979101@lid","id":"A5E982057B1B1C386FD020B0E4AB0752","_serialized":"true_236837582979101@lid_A5E982057B1B1C386FD020B0E4AB0752"},"type":"chat","timestamp":1770760032,"from":"556592694840@c.us","to":"236837582979101@lid","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07A1DA199C609D99488	Lucia	3	t	chat	\N	3	2026-02-12 01:00:36.855+00	2026-02-12 01:00:36.855+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"3EB07A1DA199C609D99488","_serialized":"true_242214781329600@lid_3EB07A1DA199C609D99488"},"type":"chat","timestamp":1770740709,"from":"151909402964196@lid","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04A28E6C95F882EA8F7	estou fechando e está voltando	3	t	chat	\N	3	2026-02-12 01:00:38.566+00	2026-02-12 01:00:38.566+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"3EB04A28E6C95F882EA8F7","_serialized":"true_242214781329600@lid_3EB04A28E6C95F882EA8F7"},"type":"chat","timestamp":1770740713,"from":"151909402964196@lid","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
B1DE7F78C36D89D918	Olá Francileide?, tudo bem?\n\nAqui é do Setor de Cobranças do Sicredi. Identificamos operações em atraso em sua conta, a não regularização poderá acarretar o bloqueio dos produtos e da sua conta.\n\nRegularize o mais breve possível para evitar transtornos.\n\nCaso tenha regularizado desconsidere a mensagem.	0	f	chat	\N	204	2026-02-12 23:48:27.929+00	2026-02-12 23:53:28.036+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
6E6D8A12BABFF3914C	Prezado(a) associado(a), informamos que seu acesso à Assembleia da Sicredi Ouro Verde MT estará liberado em 18/02/2026, às 19:00h por meio do Aplicativo Sicredi, na seção Assembleias.	0	f	chat	\N	204	2026-02-12 23:48:29.438+00	2026-02-12 23:53:29.911+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
960693454A65C2D416	Olá, associado (a)\n\nQueremos saber como está sendo sua experiência com o Sicredi.\n\nLevará menos de 1 minuto e não precisamos de nenhum dado seu.\n\nEsta pesquisa fica ativa por 6 horas para que você possa participar e é direcionada à pessoa responsável pela conta empresarial.	0	f	chat	\N	204	2026-02-12 23:48:31.922+00	2026-02-12 23:53:31.987+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
E8B37A386978D52259	Olá, associado (a)\n\nQueremos saber como está sendo sua experiência com o Sicredi.\n\nLevará menos de 1 minuto e não precisamos de nenhum dado seu.\n\nEsta pesquisa fica ativa por 6 horas para que você possa participar e é direcionada à pessoa responsável pela conta empresarial.	0	f	chat	\N	204	2026-02-12 23:48:35.786+00	2026-02-12 23:53:35.897+00	f	f	69	\N	1	\N	\N	\N	2	f	waiting	\N
A52E65EDA7E9B0B362C51525FE6708F1		3	t	video	1770858045768-zeqsim.mp4	3	2026-02-12 01:00:45.896+00	2026-02-12 01:00:45.896+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"A52E65EDA7E9B0B362C51525FE6708F1","_serialized":"true_242214781329600@lid_A52E65EDA7E9B0B362C51525FE6708F1"},"type":"video","timestamp":1770740824,"from":"556592694840@c.us","to":"242214781329600@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"85","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4560192A828C956758	*Lucia Felix - Suporte:*\nNão precisa testar, eu faço isso aqui mesmo	0	f	chat	\N	1	2026-02-12 01:00:46.847+00	2026-02-12 01:00:46.847+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"4560192A828C956758","_serialized":"false_242214781329600@lid_4560192A828C956758"},"type":"chat","timestamp":1770741315,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
7D3267F84761CCE4D3	*Lucia Felix - Suporte:*\nAinda não finalizei a configuração por isso não está funcionando rs	0	f	chat	\N	1	2026-02-12 01:00:47.936+00	2026-02-12 01:00:47.936+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"7D3267F84761CCE4D3","_serialized":"false_242214781329600@lid_7D3267F84761CCE4D3"},"type":"chat","timestamp":1770741326,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01304DBB1F3F4F281F4	entendi	3	t	chat	\N	3	2026-02-12 01:00:49.863+00	2026-02-12 01:00:49.863+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"3EB01304DBB1F3F4F281F4","_serialized":"true_242214781329600@lid_3EB01304DBB1F3F4F281F4"},"type":"chat","timestamp":1770748613,"from":"151909402964196@lid","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AE4F15ADE09B049C77	Lucia	3	t	chat	\N	3	2026-02-12 01:00:51.506+00	2026-02-12 01:00:51.506+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"3EB0AE4F15ADE09B049C77","_serialized":"true_242214781329600@lid_3EB0AE4F15ADE09B049C77"},"type":"chat","timestamp":1770748616,"from":"151909402964196@lid","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A0E1262040CEDFEE6E	necessito que configure o acesso do gerente da costa verde	3	t	chat	\N	3	2026-02-12 01:00:52.848+00	2026-02-12 01:00:52.848+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"3EB0A0E1262040CEDFEE6E","_serialized":"true_242214781329600@lid_3EB0A0E1262040CEDFEE6E"},"type":"chat","timestamp":1770748630,"from":"151909402964196@lid","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
F240FC0F6AC99DBD08	*Lucia Felix - Suporte:*\nOk	0	f	chat	\N	1	2026-02-12 01:00:53.192+00	2026-02-12 01:00:53.192+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"F240FC0F6AC99DBD08","_serialized":"false_242214781329600@lid_F240FC0F6AC99DBD08"},"type":"chat","timestamp":1770749368,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A74D5288C9FA9F4149	*Lucia Felix - Suporte:*\nEle também faz atendimento?	0	f	chat	\N	1	2026-02-12 01:00:53.535+00	2026-02-12 01:00:53.535+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"A74D5288C9FA9F4149","_serialized":"false_242214781329600@lid_A74D5288C9FA9F4149"},"type":"chat","timestamp":1770749385,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A50A87F27D9EC3DB04E19A788BBD94FA	Não	3	t	chat	\N	3	2026-02-12 01:00:55.022+00	2026-02-12 01:00:55.022+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"A50A87F27D9EC3DB04E19A788BBD94FA","_serialized":"true_242214781329600@lid_A50A87F27D9EC3DB04E19A788BBD94FA"},"type":"chat","timestamp":1770749457,"from":"556592694840@c.us","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A515DFD194B2DC0B0950EF127DE42A8A	Até o momento não	3	t	chat	\N	3	2026-02-12 01:00:55.868+00	2026-02-12 01:00:55.868+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"242214781329600@lid","id":"A515DFD194B2DC0B0950EF127DE42A8A","_serialized":"true_242214781329600@lid_A515DFD194B2DC0B0950EF127DE42A8A"},"type":"chat","timestamp":1770749461,"from":"556592694840@c.us","to":"242214781329600@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
8A46433D21060920A3	*Lucia Felix - Suporte:*\nPerfeito	0	f	chat	\N	1	2026-02-12 01:00:56.418+00	2026-02-12 01:00:56.418+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"8A46433D21060920A3","_serialized":"false_242214781329600@lid_8A46433D21060920A3"},"type":"chat","timestamp":1770749469,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
93477CA961B60F8FD9	*Lucia Felix - Suporte:*\nSegue acesso\n\nhttps://drogariasbigmaster.atenderbem.com/\n\nLoguin: Gerencia da Costa Verde\nSenha: Unico@2026	0	f	chat	\N	1	2026-02-12 01:00:57.438+00	2026-02-12 01:00:57.438+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"93477CA961B60F8FD9","_serialized":"false_242214781329600@lid_93477CA961B60F8FD9"},"type":"chat","timestamp":1770749771,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
D4C2A510FE39D6CFF6		0	f	audio	1770858059828-tztwxr.oga	1	2026-02-12 01:00:59.842+00	2026-02-12 01:00:59.842+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"D4C2A510FE39D6CFF6","_serialized":"false_242214781329600@lid_D4C2A510FE39D6CFF6"},"type":"audio","timestamp":1770751524,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"86","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB016EC62E325CC49DD0E	Tudo bem?	0	f	chat	\N	205	2026-02-12 23:48:39.886+00	2026-02-12 23:53:39.942+00	f	f	70	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0D2E887B09430FC65D8	Em setembro de 2025 encaminhamos a cobrança referente a um serviço prestado presencialmente.\nNosso financeiro nos informou que, até o momento, o pagamento não foi identificado. Poderia verificar, por favor	0	f	chat	\N	205	2026-02-12 23:48:41.547+00	2026-02-12 23:53:41.615+00	f	f	70	\N	1	\N	\N	\N	2	f	waiting	\N
9999E3A9B3D3D76572		0	f	image	1770858060438-7jvg9m.jpeg	1	2026-02-12 01:01:00.441+00	2026-02-12 01:01:00.441+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"9999E3A9B3D3D76572","_serialized":"false_242214781329600@lid_9999E3A9B3D3D76572"},"type":"image","timestamp":1770751540,"from":"242214781329600@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
C994C9D18DDA538B89	*Lucia Felix - Suporte:*\nNão achei assim muito prático	0	f	chat	\N	1	2026-02-12 01:01:00.762+00	2026-02-12 01:01:00.762+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"C994C9D18DDA538B89","_serialized":"false_242214781329600@lid_C994C9D18DDA538B89"},"type":"chat","timestamp":1770751544,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
FC4FFE86C38517B025	*Lucia Felix - Suporte:*\nBoa tarde No momento estou encerrando meu horário por hoje. Mas, caso precise de qualquer coisa é só entrar em contato que outro atendente dará continuidade com você! Tenha um ótimo dia!✨	0	f	chat	\N	1	2026-02-12 01:01:01.707+00	2026-02-12 01:01:01.707+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"FC4FFE86C38517B025","_serialized":"false_242214781329600@lid_FC4FFE86C38517B025"},"type":"chat","timestamp":1770753792,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
E9602E1ACAA60711A4	*Lucia Felix - Suporte:*\nFicamos felizes em receber seu contato... Estamos sempre a disposição. \n\nSUCESSO PRA NÓS 🚀	0	f	chat	\N	1	2026-02-12 01:01:02.892+00	2026-02-12 01:01:02.892+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"E9602E1ACAA60711A4","_serialized":"false_242214781329600@lid_E9602E1ACAA60711A4"},"type":"chat","timestamp":1770753796,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AE6603A884CE1DE3CB	Gostaria de uma avaliação sincera da sua parte sobre meu atendimento. Consegue me ajudar a ser um(a) profissional melhor?\n\nDigite 5️⃣ Muito satisfeito 😍\nDigite 4️⃣ Satisfeito 😀\nDigite 3️⃣ Indiferente 😐\nDigite 2️⃣ Insatisfeito ☹️\nDigite 1️⃣ Extremamente Insatisfeito 😞	0	f	chat	\N	1	2026-02-12 01:01:03.19+00	2026-02-12 01:01:03.19+00	f	f	1	\N	1	\N	{"id":{"fromMe":false,"remote":"242214781329600@lid","id":"AE6603A884CE1DE3CB","_serialized":"false_242214781329600@lid_AE6603A884CE1DE3CB"},"type":"chat","timestamp":1770753798,"from":"242214781329600@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A8686137D87B5005A9	Boa tarde!	3	t	chat	\N	3	2026-02-12 01:01:05.907+00	2026-02-12 01:01:05.907+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB0A8686137D87B5005A9","_serialized":"true_156504699232288@lid_3EB0A8686137D87B5005A9"},"type":"chat","timestamp":1769624928,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CAE907A0CA42939486	Tudo bem contigo?	3	t	chat	\N	3	2026-02-12 01:01:07.519+00	2026-02-12 01:01:07.519+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB0CAE907A0CA42939486","_serialized":"true_156504699232288@lid_3EB0CAE907A0CA42939486"},"type":"chat","timestamp":1769624933,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC5A066F11942E6B03D6727CF5AB2EF6	Bom dia	1	f	chat	\N	16	2026-02-12 11:26:37.392+00	2026-02-12 11:26:37.446+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC5A066F11942E6B03D6727CF5AB2EF6","_serialized":"false_131752601366700@lid_AC5A066F11942E6B03D6727CF5AB2EF6"},"type":"chat","timestamp":1770895596,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB03A549DDA099295F4CF	Que bom	3	t	chat	\N	3	2026-02-12 01:01:10.033+00	2026-02-12 01:01:10.033+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB03A549DDA099295F4CF","_serialized":"true_156504699232288@lid_3EB03A549DDA099295F4CF"},"type":"chat","timestamp":1769626155,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB058895651D8BDCE4FBA	na ativa ou de licença ainda?	3	t	chat	\N	3	2026-02-12 01:01:12.075+00	2026-02-12 01:01:12.075+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB058895651D8BDCE4FBA","_serialized":"true_156504699232288@lid_3EB058895651D8BDCE4FBA"},"type":"chat","timestamp":1769626161,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB061F758DEB5B8287265	se tiver nos falamos amanhã	3	t	chat	\N	3	2026-02-12 01:01:13.879+00	2026-02-12 01:01:13.879+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB061F758DEB5B8287265","_serialized":"true_156504699232288@lid_3EB061F758DEB5B8287265"},"type":"chat","timestamp":1769626167,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FC39036B1C8E68C43D	belezaa	0	f	chat	\N	215	2026-02-12 23:48:47.468+00	2026-02-12 23:53:47.5+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
3EB07C9F442FE83AAA9F89	somente você??	0	f	chat	\N	215	2026-02-12 23:48:47.925+00	2026-02-12 23:53:47.983+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B7D40BD419AD3DC187	ou vai mais alguém da rise	0	f	chat	\N	215	2026-02-12 23:48:48.44+00	2026-02-12 23:53:48.489+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0417B5F0A9426A0D0CE	fechou	0	f	chat	\N	215	2026-02-12 23:48:49.308+00	2026-02-12 23:53:49.366+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0B22E941916375BBBC0	Opa Luan, irá comparecer?	0	f	chat	\N	215	2026-02-12 23:48:50.652+00	2026-02-12 23:53:50.709+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
3EB09C0674A1910A77426F	Tranquilo, tmj	0	f	chat	\N	215	2026-02-12 23:48:51.828+00	2026-02-12 23:53:51.875+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
ACA7A020F297F24E2D6C0B8D73A2459B	🎵 Áudio	4	f	audio	1770940133734-ACA7A020F297.ogg	220	2026-02-12 23:48:53.741+00	2026-02-12 23:53:53.82+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
3EB019EA2ED26AEFD0389A	Sobre o inventário	3	t	chat	\N	3	2026-02-12 01:01:15.899+00	2026-02-12 01:01:15.899+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB019EA2ED26AEFD0389A","_serialized":"true_156504699232288@lid_3EB019EA2ED26AEFD0389A"},"type":"chat","timestamp":1769626229,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB002C844096F4BAEE4C6	alinhando com o Cristinao	3	t	chat	\N	3	2026-02-12 01:01:17.529+00	2026-02-12 01:01:17.529+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB002C844096F4BAEE4C6","_serialized":"true_156504699232288@lid_3EB002C844096F4BAEE4C6"},"type":"chat","timestamp":1769626382,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB024F66C76002292B6C0	vimos que nas correções do inventário	3	t	chat	\N	3	2026-02-12 01:01:19.012+00	2026-02-12 01:01:19.012+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB024F66C76002292B6C0","_serialized":"true_156504699232288@lid_3EB024F66C76002292B6C0"},"type":"chat","timestamp":1769626390,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB000590C11E43E91D4F0	posso te ligar	3	t	chat	\N	3	2026-02-12 01:01:20.855+00	2026-02-12 01:01:20.855+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB000590C11E43E91D4F0","_serialized":"true_156504699232288@lid_3EB000590C11E43E91D4F0"},"type":"chat","timestamp":1769627276,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5BE6A36FFDF68A37C082611C12593E6	Bom dia!	3	t	chat	\N	3	2026-02-12 01:01:22.542+00	2026-02-12 01:01:22.542+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"A5BE6A36FFDF68A37C082611C12593E6","_serialized":"true_156504699232288@lid_A5BE6A36FFDF68A37C082611C12593E6"},"type":"chat","timestamp":1770041519,"from":"556592694840@c.us","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C541A8EF8A80A3211B9B1922B2163F	Tudo bem aí?	3	t	chat	\N	3	2026-02-12 01:01:23.263+00	2026-02-12 01:01:23.263+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"A5C541A8EF8A80A3211B9B1922B2163F","_serialized":"true_156504699232288@lid_A5C541A8EF8A80A3211B9B1922B2163F"},"type":"chat","timestamp":1770041532,"from":"556592694840@c.us","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5257F7D339D86B6E98BBAB64A26728E	Posso te ligar?	3	t	chat	\N	3	2026-02-12 01:01:24.44+00	2026-02-12 01:01:24.44+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"A5257F7D339D86B6E98BBAB64A26728E","_serialized":"true_156504699232288@lid_A5257F7D339D86B6E98BBAB64A26728E"},"type":"chat","timestamp":1770041537,"from":"556592694840@c.us","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06EB47E6037AC30C831	NF_12435.pdf	3	t	document	1770858086734-jkz8fj.pdf	3	2026-02-12 01:01:26.747+00	2026-02-12 01:01:26.747+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"156504699232288@lid","id":"3EB06EB47E6037AC30C831","_serialized":"true_156504699232288@lid_3EB06EB47E6037AC30C831"},"type":"document","timestamp":1770734771,"from":"151909402964196@lid","to":"156504699232288@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A544E7B196E2EECD8213B1FF7EF65BB9		4	t	audio	1770858088906-n5fern.oga	3	2026-02-12 01:01:28.921+00	2026-02-12 01:01:28.921+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"A544E7B196E2EECD8213B1FF7EF65BB9","_serialized":"true_139891446939660@lid_A544E7B196E2EECD8213B1FF7EF65BB9"},"type":"ptt","timestamp":1770726645,"from":"556592694840@c.us","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"24","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACC705838F8EF25FEE992F804CDE5DF2	As mensagens não estão caindo no único, está direto no celular	1	f	chat	\N	16	2026-02-12 11:27:05.998+00	2026-02-12 11:27:06.043+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACC705838F8EF25FEE992F804CDE5DF2","_serialized":"false_131752601366700@lid_ACC705838F8EF25FEE992F804CDE5DF2"},"type":"chat","timestamp":1770895625,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB014081CCD6633BCFFCE	entenid	3	t	chat	\N	3	2026-02-12 01:01:30.959+00	2026-02-12 01:01:30.959+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB014081CCD6633BCFFCE","_serialized":"true_139891446939660@lid_3EB014081CCD6633BCFFCE"},"type":"chat","timestamp":1770726722,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB087AFBCF28611115E3F	Não entendi	0	t	chat	\N	19	2026-02-12 01:01:19.42+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB087AFBCF28611115E3F","_serialized":"false_156504699232288@lid_3EB087AFBCF28611115E3F"},"type":"chat","timestamp":1769626793,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07B278A0C06E569E31E	Sim	0	t	chat	\N	19	2026-02-12 01:01:21.226+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB07B278A0C06E569E31E","_serialized":"false_156504699232288@lid_3EB07B278A0C06E569E31E"},"type":"chat","timestamp":1769627293,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC0267313855DB616021F4CD5AF12F6B	Blz	0	f	chat	\N	220	2026-02-12 23:48:57.194+00	2026-02-12 23:53:57.295+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
ACA1145E6161B18B3F23FF895F17B00B	Luan	0	f	chat	\N	220	2026-02-12 23:48:58.381+00	2026-02-12 23:53:58.459+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
ACED098DCECAD8553B06AF3D42A71381	O nome do posto	0	f	chat	\N	220	2026-02-12 23:48:58.792+00	2026-02-12 23:53:58.846+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
AC3044D843265ED9756A172FA7CA682E	No google	0	f	chat	\N	220	2026-02-12 23:48:59.218+00	2026-02-12 23:53:59.28+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
AC8463EDE01F260B4F773009E50B8CFF	Tem como mudar	0	f	chat	\N	220	2026-02-12 23:48:59.816+00	2026-02-12 23:53:59.901+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0BB9416AAD8798A9DE6	tudo bem	3	t	chat	\N	3	2026-02-12 01:01:32.636+00	2026-02-12 01:01:32.636+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB0BB9416AAD8798A9DE6","_serialized":"true_139891446939660@lid_3EB0BB9416AAD8798A9DE6"},"type":"chat","timestamp":1770726724,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C976E7F62D6B2FA39D	vou verificar com ele  e pedir para lhe procurar	3	t	chat	\N	3	2026-02-12 01:01:34.765+00	2026-02-12 01:01:34.765+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB0C976E7F62D6B2FA39D","_serialized":"true_139891446939660@lid_3EB0C976E7F62D6B2FA39D"},"type":"chat","timestamp":1770726733,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB003DE73E4A8A530EE9E	Gil	3	t	chat	\N	3	2026-02-12 01:01:36.91+00	2026-02-12 01:01:36.91+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB003DE73E4A8A530EE9E","_serialized":"true_139891446939660@lid_3EB003DE73E4A8A530EE9E"},"type":"chat","timestamp":1770727606,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00C11D823282EBA46FE	alinhei com o Lucas aqu i	3	t	chat	\N	3	2026-02-12 01:01:38.782+00	2026-02-12 01:01:38.782+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB00C11D823282EBA46FE","_serialized":"true_139891446939660@lid_3EB00C11D823282EBA46FE"},"type":"chat","timestamp":1770727610,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01EB4A959FD64718855	ele informou que vai ser no financeiro	3	t	chat	\N	3	2026-02-12 01:01:40.342+00	2026-02-12 01:01:40.342+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB01EB4A959FD64718855","_serialized":"true_139891446939660@lid_3EB01EB4A959FD64718855"},"type":"chat","timestamp":1770727619,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07330374401EA60435B	ele já esta comprando o Swicht e filtro de linha	3	t	chat	\N	3	2026-02-12 01:01:42.056+00	2026-02-12 01:01:42.056+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB07330374401EA60435B","_serialized":"true_139891446939660@lid_3EB07330374401EA60435B"},"type":"chat","timestamp":1770727632,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01801CCDAC30E6339A8	então pode levar para lá já	3	t	chat	\N	3	2026-02-12 01:01:43.762+00	2026-02-12 01:01:43.762+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB01801CCDAC30E6339A8","_serialized":"true_139891446939660@lid_3EB01801CCDAC30E6339A8"},"type":"chat","timestamp":1770727785,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC0BB9070C5193A9EB80BE2E605A1036	Como proceder??	1	f	chat	\N	16	2026-02-12 11:27:12.768+00	2026-02-12 11:27:12.799+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC0BB9070C5193A9EB80BE2E605A1036","_serialized":"false_131752601366700@lid_AC0BB9070C5193A9EB80BE2E605A1036"},"type":"chat","timestamp":1770895632,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0217E07FF09E6B052A2	Sim	3	t	chat	\N	3	2026-02-12 01:01:46.2+00	2026-02-12 01:01:46.2+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB0217E07FF09E6B052A2","_serialized":"true_139891446939660@lid_3EB0217E07FF09E6B052A2"},"type":"chat","timestamp":1770728739,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5BC13130345E4169E62916A28E3A0CD	Me passa o anydesk	3	t	chat	\N	3	2026-02-12 11:27:50.419+00	2026-02-12 11:27:50.518+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A5BC13130345E4169E62916A28E3A0CD","_serialized":"true_131752601366700@lid_A5BC13130345E4169E62916A28E3A0CD"},"type":"chat","timestamp":1770895667,"from":"556592694840@c.us","to":"131752601366700@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3AC27BEFF946F04A24DD	No nome dela	0	f	chat	\N	97	2026-02-12 23:46:22.141+00	2026-02-12 23:51:22.233+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
3EB03F1230A933EE46B7B1	Show	3	t	chat	\N	3	2026-02-12 01:01:51.939+00	2026-02-12 01:01:51.939+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"139891446939660@lid","id":"3EB03F1230A933EE46B7B1","_serialized":"true_139891446939660@lid_3EB03F1230A933EE46B7B1"},"type":"chat","timestamp":1770730596,"from":"151909402964196@lid","to":"139891446939660@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A516AD05D41E7F4EE848AA3429CFFE00	Ok	3	t	chat	\N	3	2026-02-12 01:01:53.817+00	2026-02-12 01:01:53.817+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"A516AD05D41E7F4EE848AA3429CFFE00","_serialized":"true_159541543100490@lid_A516AD05D41E7F4EE848AA3429CFFE00"},"type":"chat","timestamp":1770226099,"from":"556592694840@c.us","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5955EF6C55FB5C82F36F00D2FBA32EF	Boa tarde	3	t	chat	\N	3	2026-02-12 01:01:54.618+00	2026-02-12 01:01:54.618+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"A5955EF6C55FB5C82F36F00D2FBA32EF","_serialized":"true_159541543100490@lid_A5955EF6C55FB5C82F36F00D2FBA32EF"},"type":"chat","timestamp":1770660425,"from":"556592694840@c.us","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A549585C2E51E4D2F9DE68990191BC84	Nicole	3	t	chat	\N	3	2026-02-12 01:01:55.895+00	2026-02-12 01:01:55.895+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"A549585C2E51E4D2F9DE68990191BC84","_serialized":"true_159541543100490@lid_A549585C2E51E4D2F9DE68990191BC84"},"type":"chat","timestamp":1770660427,"from":"556592694840@c.us","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53BDAA3E6B475978EE24AA072BB20CE	Estou tento problemas com seu suporte	3	t	chat	\N	3	2026-02-12 01:01:56.784+00	2026-02-12 01:01:56.784+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"A53BDAA3E6B475978EE24AA072BB20CE","_serialized":"true_159541543100490@lid_A53BDAA3E6B475978EE24AA072BB20CE"},"type":"chat","timestamp":1770660436,"from":"556592694840@c.us","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56589F8A5D3FCD12EA720322B2E8341		3	t	audio	1770858118247-loarx7.oga	3	2026-02-12 01:01:58.249+00	2026-02-12 01:01:58.249+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"A56589F8A5D3FCD12EA720322B2E8341","_serialized":"true_159541543100490@lid_A56589F8A5D3FCD12EA720322B2E8341"},"type":"ptt","timestamp":1770660474,"from":"556592694840@c.us","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"29","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C4F1ADF66270912F		0	t	chat	\N	3	2026-02-12 11:30:46.855+00	2026-02-12 11:30:46.91+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"151909402964196@lid","id":"3EB0C4F1ADF66270912F","self":"out","_serialized":"true_151909402964196@lid_3EB0C4F1ADF66270912F_out"},"type":"e2e_notification","timestamp":1770895843,"from":"151909402964196@lid","to":"151909402964196:5@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A799D9E64CE73C52E46	Sim	0	f	chat	\N	97	2026-02-12 23:46:25.138+00	2026-02-12 23:51:25.257+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
3EB06FC403359F6969E37F	Bom dia!	3	t	chat	\N	3	2026-02-12 01:02:01.563+00	2026-02-12 01:02:01.563+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"3EB06FC403359F6969E37F","_serialized":"true_159541543100490@lid_3EB06FC403359F6969E37F"},"type":"chat","timestamp":1770728062,"from":"151909402964196@lid","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EF67B22BC1EC410E35	Nicole, ontem eu assinei o termo e enviei para podermos prosseguir	3	t	chat	\N	3	2026-02-12 01:02:03.509+00	2026-02-12 01:02:03.509+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"3EB0EF67B22BC1EC410E35","_serialized":"true_159541543100490@lid_3EB0EF67B22BC1EC410E35"},"type":"chat","timestamp":1770728078,"from":"151909402964196@lid","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
2A04BC9A493D8CD51131		0	t	video	1770858109111-dkgac.mp4	20	2026-02-12 01:01:49.124+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"2A04BC9A493D8CD51131","_serialized":"false_139891446939660@lid_2A04BC9A493D8CD51131"},"type":"video","timestamp":1770728860,"from":"139891446939660@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"6","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B14407DD97F31E777A6	servidor finalizado!	0	t	chat	\N	20	2026-02-12 01:01:49.598+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"3B14407DD97F31E777A6","_serialized":"false_139891446939660@lid_3B14407DD97F31E777A6"},"type":"chat","timestamp":1770730480,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E73D90F70D546F827E	já dei andamento nesse processo	3	t	chat	\N	3	2026-02-12 01:02:05.67+00	2026-02-12 01:02:05.67+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"3EB0E73D90F70D546F827E","_serialized":"true_159541543100490@lid_3EB0E73D90F70D546F827E"},"type":"chat","timestamp":1770728084,"from":"151909402964196@lid","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0ED53743D0DEC85CA2C	me falaram que você estava ausente por questões pessoais	3	t	chat	\N	3	2026-02-12 01:02:07.592+00	2026-02-12 01:02:07.592+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"3EB0ED53743D0DEC85CA2C","_serialized":"true_159541543100490@lid_3EB0ED53743D0DEC85CA2C"},"type":"chat","timestamp":1770728097,"from":"151909402964196@lid","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5B47885303683BAC91AFA4C883E0F68	Maicon	3	t	chat	\N	3	2026-02-12 01:02:09.483+00	2026-02-12 01:02:09.483+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"A5B47885303683BAC91AFA4C883E0F68","_serialized":"true_159541543100490@lid_A5B47885303683BAC91AFA4C883E0F68"},"type":"chat","timestamp":1770728578,"from":"556592694840@c.us","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05011D65A574F5E8986	sim	3	t	chat	\N	3	2026-02-12 01:02:11.711+00	2026-02-12 01:02:11.711+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"3EB05011D65A574F5E8986","_serialized":"true_159541543100490@lid_3EB05011D65A574F5E8986"},"type":"chat","timestamp":1770728949,"from":"151909402964196@lid","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0691EBAE61B190364D3	enviei o documento assinado	3	t	chat	\N	3	2026-02-12 01:02:13.286+00	2026-02-12 01:02:13.286+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"159541543100490@lid","id":"3EB0691EBAE61B190364D3","_serialized":"true_159541543100490@lid_3EB0691EBAE61B190364D3"},"type":"chat","timestamp":1770728954,"from":"151909402964196@lid","to":"159541543100490@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC6319A2348DA68BF7D0F63B754646CB		1	f	image	1770895880174-qt9yn.jpeg	24	2026-02-12 11:31:20.177+00	2026-02-12 11:31:20.219+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC6319A2348DA68BF7D0F63B754646CB","_serialized":"false_175681342312561@lid_AC6319A2348DA68BF7D0F63B754646CB"},"type":"image","timestamp":1770895879,"from":"175681342312561@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3AF6905DAC741C27B9E0	Bem mala kkk	0	f	chat	\N	97	2026-02-12 23:46:25.778+00	2026-02-12 23:51:25.869+00	f	f	58	\N	1	\N	\N	\N	2	f	waiting	\N
A53FD1D26C526D845F17D2EFC7F84ED8	Bom dia	3	t	chat	\N	3	2026-02-12 01:02:16.415+00	2026-02-12 01:02:16.415+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"A53FD1D26C526D845F17D2EFC7F84ED8","_serialized":"true_254618613325979@lid_A53FD1D26C526D845F17D2EFC7F84ED8"},"type":"chat","timestamp":1770389747,"from":"556592694840@c.us","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5CF6FB29EC43235B675AFFDB76D1F84	Gostaria de pedir	3	t	chat	\N	3	2026-02-12 01:02:18.608+00	2026-02-12 01:02:18.608+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"A5CF6FB29EC43235B675AFFDB76D1F84","_serialized":"true_254618613325979@lid_A5CF6FB29EC43235B675AFFDB76D1F84"},"type":"chat","timestamp":1770389750,"from":"556592694840@c.us","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00419C47A29F162D4C9	*Nicole Assis - Consultora Comercial:*\nSim 	0	t	chat	\N	21	2026-02-12 01:02:08.359+00	2026-02-12 01:40:41.408+00	f	f	22	3EB0ED53743D0DEC85CA2C	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00419C47A29F162D4C9","_serialized":"false_159541543100490@lid_3EB00419C47A29F162D4C9"},"type":"chat","timestamp":1770728366,"from":"159541543100490@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00619C47A2FB9C2CDE8	*Nicole Assis - Consultora Comercial:*\nBom, com qual pessoa você conversou sobre seguir fora da oficial ? 	0	t	chat	\N	21	2026-02-12 01:02:08.699+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00619C47A2FB9C2CDE8","_serialized":"false_159541543100490@lid_3EB00619C47A2FB9C2CDE8"},"type":"chat","timestamp":1770728390,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5543300B479ED1EED8413948FE60DC2	Arroz,  feijão,  fracasse de frango	3	t	chat	\N	3	2026-02-12 01:02:20.17+00	2026-02-12 01:02:20.17+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"A5543300B479ED1EED8413948FE60DC2","_serialized":"true_254618613325979@lid_A5543300B479ED1EED8413948FE60DC2"},"type":"chat","timestamp":1770389814,"from":"556592694840@c.us","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A521DBC0B88B948B32BE615D6351C873	Marmita pequena	3	t	chat	\N	3	2026-02-12 01:02:22.411+00	2026-02-12 01:02:22.411+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"A521DBC0B88B948B32BE615D6351C873","_serialized":"true_254618613325979@lid_A521DBC0B88B948B32BE615D6351C873"},"type":"chat","timestamp":1770389819,"from":"556592694840@c.us","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AF632AB086DA46EE95B	Bom dia	1	f	chat	\N	15	2026-02-12 11:43:00.671+00	2026-02-12 11:43:00.711+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AF632AB086DA46EE95B","participant":"189309424541837@lid","_serialized":"false_120363405293949287@g.us_3AF632AB086DA46EE95B_189309424541837@lid"},"type":"chat","timestamp":1770896579,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0453B3330F6D0A8AE4D	Não me manda chave pix	3	t	chat	\N	3	2026-02-12 01:02:25.859+00	2026-02-12 01:02:25.859+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"3EB0453B3330F6D0A8AE4D","_serialized":"true_254618613325979@lid_3EB0453B3330F6D0A8AE4D"},"type":"chat","timestamp":1770405543,"from":"151909402964196@lid","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A32606C66F68F1B46EC	Tem que parar essa porra	1	f	chat	\N	15	2026-02-12 11:43:22.452+00	2026-02-12 11:43:22.477+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A32606C66F68F1B46EC","participant":"189309424541837@lid","_serialized":"false_120363405293949287@g.us_3A32606C66F68F1B46EC_189309424541837@lid"},"type":"chat","timestamp":1770896601,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A553A6EBDC00E9C1ED26D30B1DE887AF	Não e 15?	3	t	chat	\N	3	2026-02-12 01:02:30.107+00	2026-02-12 01:02:30.107+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"A553A6EBDC00E9C1ED26D30B1DE887AF","_serialized":"true_254618613325979@lid_A553A6EBDC00E9C1ED26D30B1DE887AF"},"type":"chat","timestamp":1770407222,"from":"556592694840@c.us","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AF330534B4FD53DCD8C	PQP	1	f	chat	\N	15	2026-02-12 11:43:25.859+00	2026-02-12 11:43:25.892+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AF330534B4FD53DCD8C","participant":"189309424541837@lid","_serialized":"false_120363405293949287@g.us_3AF330534B4FD53DCD8C_189309424541837@lid"},"type":"chat","timestamp":1770896605,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0448197C2BBB2B5BC3B	Sim	3	t	chat	\N	3	2026-02-12 01:02:33.002+00	2026-02-12 01:02:33.002+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"3EB0448197C2BBB2B5BC3B","_serialized":"true_254618613325979@lid_3EB0448197C2BBB2B5BC3B"},"type":"chat","timestamp":1770410094,"from":"151909402964196@lid","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F5F660D0A86D6F64FF	mas me mandou a de 15 ou a de 18?	3	t	chat	\N	3	2026-02-12 01:02:35.284+00	2026-02-12 01:02:35.284+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"3EB0F5F660D0A86D6F64FF","_serialized":"true_254618613325979@lid_3EB0F5F660D0A86D6F64FF"},"type":"chat","timestamp":1770410102,"from":"151909402964196@lid","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FD6B640295E1847935	Olá, boa tarde	0	f	chat	\N	205	2026-02-12 23:48:39.413+00	2026-02-12 23:53:39.47+00	f	f	70	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0888CBE7517B8AD93E4	entendi	3	t	chat	\N	3	2026-02-12 01:02:37.317+00	2026-02-12 01:02:37.317+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"3EB0888CBE7517B8AD93E4","_serialized":"true_254618613325979@lid_3EB0888CBE7517B8AD93E4"},"type":"chat","timestamp":1770410247,"from":"151909402964196@lid","to":"254618613325979@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02198DF9B18FA004DA6	Nesse numero eu consigo falar com a responsável da farmacia MINHA FORMULA?	0	f	chat	\N	205	2026-02-12 23:48:40.336+00	2026-02-12 23:53:40.379+00	f	f	70	\N	1	\N	\N	\N	2	f	waiting	\N
3EB0343A07C6A565BC273D	isso, ai ali na lista tem o dono da empresa, e tambem a razão social	0	f	chat	\N	215	2026-02-12 23:48:46.462+00	2026-02-12 23:53:46.532+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
A57FD40682C8C60C63F12918A48373A8	Olá! Tudo bem? 😊\nPassando para lembrar que o *Conecta Yakao | Brother é HOJE* !\n\n🕑 *Às 14h,* no *Hotel Inter Cuiabá*\n\n📍 Localização:\nhttps://maps.app.goo.gl/4sMLb9a2Lr85eWxK6\n\n*Te espero lá!*	0	f	image	1770940130031-A57FD40682C8.jpeg	215	2026-02-12 23:48:50.055+00	2026-02-12 23:53:50.134+00	f	f	71	\N	1	\N	\N	\N	2	f	waiting	\N
AC3D7DE9F2471089DE12E2B257E83BF6	Pode ser	0	f	chat	\N	220	2026-02-12 23:48:56.026+00	2026-02-12 23:53:56.143+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
A5601E15B996CB42690F198FA79E9A87		3	t	image	1770858159620-ijn3tv.jpeg	3	2026-02-12 01:02:39.635+00	2026-02-12 01:02:39.635+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"254618613325979@lid","id":"A5601E15B996CB42690F198FA79E9A87","_serialized":"true_254618613325979@lid_A5601E15B996CB42690F198FA79E9A87"},"type":"image","timestamp":1770411823,"from":"556592694840@c.us","to":"254618613325979@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06C4F903299A227E210	quer tentar na fernando?	0	t	chat	\N	23	2026-02-12 01:02:43.459+00	2026-02-12 01:40:18.136+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB06C4F903299A227E210","participant":{"server":"lid","user":"7202811162779","_serialized":"7202811162779@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB06C4F903299A227E210_7202811162779@lid"},"type":"chat","timestamp":1770644700,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A517B84730CF5A041D27A69B7C185C68	TEF pode sofrer lentidão, tendo em vista que a Fiserv tbm está com problemas.	0	t	chat	\N	23	2026-02-12 01:02:44.16+00	2026-02-12 01:40:18.136+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"A517B84730CF5A041D27A69B7C185C68","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_556596725633-1629494914@g.us_A517B84730CF5A041D27A69B7C185C68_164703422648560@lid"},"type":"chat","timestamp":1770644842,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC2EA8C420A50D5BA770193E19B7B7CB	Na shangri-la estamos sem Internet	0	t	chat	\N	23	2026-02-12 01:02:44.666+00	2026-02-12 01:40:18.136+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"AC2EA8C420A50D5BA770193E19B7B7CB","participant":{"server":"lid","user":"175681342312561","_serialized":"175681342312561@lid"},"_serialized":"false_556596725633-1629494914@g.us_AC2EA8C420A50D5BA770193E19B7B7CB_175681342312561@lid"},"type":"chat","timestamp":1770645356,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5A9D21A913A3E2F17FD360C4C76B5E5	Bom dia \nCardápio do dia /09/02/2026\n\n*Arroz \n\n*Feijão \n\n*Macarrão \n\n*Mandioca cozida\n\n*Maionese \n\n*Purê \n\n*Maionese de beterraba \n\n*Farofa de ovo \n\n*Mix de legumes\n\n*Salada \n\nOpção de mistura \n\n*Tulipa assado \n\n*Picadinho de carne \n\n*Churrasco \n\n*Linguiça Toscana	0	t	chat	\N	22	2026-02-12 01:02:41.042+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A5A9D21A913A3E2F17FD360C4C76B5E5","_serialized":"false_254618613325979@lid_A5A9D21A913A3E2F17FD360C4C76B5E5"},"type":"chat","timestamp":1770644429,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A552D977AB8CA7453F9E34A25D330312	Bom dia \nCardápio do dia /10/02/2026\n\n*Arroz \n\n*Feijão \n\n*Macarrão \n\n*Mandioca cozida\n\n*Batata rústica \n\n*Maionese \n\n*Jiló \n\n*Purê \n\n*Feijão tropeiro \n\n*Mix de legumes\n\n*Salada \n\nOpção de mistura \n\n*Frango assado \n\n*Churrasco \n\n*Linguiça Toscana	0	t	chat	\N	22	2026-02-12 01:02:41.41+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A552D977AB8CA7453F9E34A25D330312","_serialized":"false_254618613325979@lid_A552D977AB8CA7453F9E34A25D330312"},"type":"chat","timestamp":1770728430,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A57C2FC51AE9A02AC58	Vixe	1	f	chat	\N	15	2026-02-12 11:51:21.002+00	2026-02-12 11:51:21.072+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A57C2FC51AE9A02AC58","participant":"189309424541837@lid","_serialized":"false_120363405293949287@g.us_3A57C2FC51AE9A02AC58_189309424541837@lid"},"type":"chat","timestamp":1770897080,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3AE9640CF38E3CE54266	Ai nisso não temos controle né	1	f	chat	\N	15	2026-02-12 11:51:25.477+00	2026-02-12 11:51:25.508+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AE9640CF38E3CE54266","participant":"189309424541837@lid","_serialized":"false_120363405293949287@g.us_3AE9640CF38E3CE54266_189309424541837@lid"},"type":"chat","timestamp":1770897084,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3AD6996943D678E85185	Temos	1	f	chat	\N	15	2026-02-12 11:51:30.171+00	2026-02-12 11:51:30.208+00	f	f	4	3AE9640CF38E3CE54266	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AD6996943D678E85185","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3AD6996943D678E85185_7202811162779@lid"},"type":"chat","timestamp":1770897089,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A4C11011818F0D66887	Só por I.A	1	f	chat	\N	15	2026-02-12 11:51:33.741+00	2026-02-12 11:51:33.77+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A4C11011818F0D66887","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A4C11011818F0D66887_7202811162779@lid"},"type":"chat","timestamp":1770897092,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC20DD1973549B4A09D04406A6FD6E6A	📷 Imagem	0	f	image	1770940137949-AC20DD197354.jpeg	220	2026-02-12 23:48:57.952+00	2026-02-12 23:53:58.016+00	f	f	72	\N	1	\N	\N	\N	2	f	waiting	\N
3AFE2ACC8CA4325FB747	Pra analisar a imagem	1	f	chat	\N	15	2026-02-12 11:51:36.884+00	2026-02-12 11:51:36.981+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AFE2ACC8CA4325FB747","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3AFE2ACC8CA4325FB747_7202811162779@lid"},"type":"chat","timestamp":1770897096,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A4AC6D2EA0ABD986A5E	No nosso CRM da.	1	f	chat	\N	15	2026-02-12 11:51:44.701+00	2026-02-12 11:51:44.728+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A4AC6D2EA0ABD986A5E","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A4AC6D2EA0ABD986A5E_7202811162779@lid"},"type":"chat","timestamp":1770897103,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A0035ED27250A7E616F	Nós concorrentes não	1	f	chat	\N	15	2026-02-12 11:51:49.955+00	2026-02-12 11:51:49.996+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A0035ED27250A7E616F","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A0035ED27250A7E616F_7202811162779@lid"},"type":"chat","timestamp":1770897109,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB009595693EB14A23AF2	mel?	3	t	chat	\N	228	2026-02-12 23:53:58.707+00	2026-02-12 23:56:15.416+00	t	f	\N	\N	1	\N	\N	\N	2	f	new	\N
3A151C796B1C659A760C	Bom dia	1	f	chat	\N	5	2026-02-12 11:54:01.47+00	2026-02-12 11:54:01.574+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A151C796B1C659A760C","_serialized":"false_74758267867267@lid_3A151C796B1C659A760C"},"type":"chat","timestamp":1770897240,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A6E9684ABFB33FE6053	Tudo bem e com você?	1	f	chat	\N	5	2026-02-12 11:54:05.739+00	2026-02-12 11:54:05.75+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A6E9684ABFB33FE6053","_serialized":"false_74758267867267@lid_3A6E9684ABFB33FE6053"},"type":"chat","timestamp":1770897245,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB07B47C813D674198CC4	mas retorno para loja	2	t	chat	\N	3	2026-02-12 01:02:52.734+00	2026-02-12 01:02:52.734+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB07B47C813D674198CC4","_serialized":"true_175681342312561@lid_3EB07B47C813D674198CC4"},"type":"chat","timestamp":1770052852,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F141559D91A6B70BC5	deixa a Patricia avisada	2	t	chat	\N	3	2026-02-12 01:02:54.412+00	2026-02-12 01:02:54.412+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB0F141559D91A6B70BC5","_serialized":"true_175681342312561@lid_3EB0F141559D91A6B70BC5"},"type":"chat","timestamp":1770052855,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0400BBFE50981FF02B2	peço a gentileza se eu não chegar antes de trocar o turno	2	t	chat	\N	3	2026-02-12 01:02:56.883+00	2026-02-12 01:02:56.883+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB0400BBFE50981FF02B2","_serialized":"true_175681342312561@lid_3EB0400BBFE50981FF02B2"},"type":"chat","timestamp":1770052871,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0ED1033696D26D5E63C	só peça as meninas para passarem as orientações	2	t	chat	\N	3	2026-02-12 01:02:58.831+00	2026-02-12 01:02:58.831+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB0ED1033696D26D5E63C","_serialized":"true_175681342312561@lid_3EB0ED1033696D26D5E63C"},"type":"chat","timestamp":1770052880,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACC2DC65DA4DC284C7EBACD338C098A1		4	t	audio	1770858179463-qvqheo.oga	24	2026-02-12 01:02:59.467+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACC2DC65DA4DC284C7EBACD338C098A1","_serialized":"false_175681342312561@lid_ACC2DC65DA4DC284C7EBACD338C098A1"},"type":"ptt","timestamp":1770054538,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"9","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC5B3ADD3DD2F75FBEA2C8C69C7FA686		4	t	audio	1770858179959-k6pg6.oga	24	2026-02-12 01:02:59.961+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC5B3ADD3DD2F75FBEA2C8C69C7FA686","_serialized":"false_175681342312561@lid_AC5B3ADD3DD2F75FBEA2C8C69C7FA686"},"type":"ptt","timestamp":1770054549,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"8","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC590ACCD308FB3CE630A0906477F2ED	Bom dia!	0	t	chat	\N	24	2026-02-12 01:03:00.162+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC590ACCD308FB3CE630A0906477F2ED","_serialized":"false_175681342312561@lid_AC590ACCD308FB3CE630A0906477F2ED"},"type":"chat","timestamp":1770645166,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A2558401669D59550BF	Sim	1	f	chat	\N	5	2026-02-12 11:54:08.322+00	2026-02-12 11:54:08.366+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A2558401669D59550BF","_serialized":"false_74758267867267@lid_3A2558401669D59550BF"},"type":"chat","timestamp":1770897247,"from":"74758267867267@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A9E3E7F24FB8431AD36	Ok	1	f	chat	\N	5	2026-02-12 11:54:35.025+00	2026-02-12 11:54:35.068+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A9E3E7F24FB8431AD36","_serialized":"false_74758267867267@lid_3A9E3E7F24FB8431AD36"},"type":"chat","timestamp":1770897274,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A24EFDEF8007CE43B9E	Já faço	1	f	chat	\N	5	2026-02-12 11:54:37.364+00	2026-02-12 11:54:37.384+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A24EFDEF8007CE43B9E","_serialized":"false_74758267867267@lid_3A24EFDEF8007CE43B9E"},"type":"chat","timestamp":1770897276,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A007AE50D51BED13C9C	Já vejo	1	f	chat	\N	5	2026-02-12 11:55:08.079+00	2026-02-12 11:55:08.129+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A007AE50D51BED13C9C","_serialized":"false_74758267867267@lid_3A007AE50D51BED13C9C"},"type":"chat","timestamp":1770897307,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3AFC7D5DFEB73CF29A2A	Sim	1	f	chat	\N	97	2026-02-12 23:56:21.745+00	2026-02-13 00:01:21.966+00	f	f	58	\N	1	\N	\N	\N	\N	f	waiting	\N
3EB0CC533C1FF8C47ED955	Sem internet ou sem sistema?	2	t	chat	\N	3	2026-02-12 01:03:02.49+00	2026-02-12 01:03:02.49+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB0CC533C1FF8C47ED955","_serialized":"true_175681342312561@lid_3EB0CC533C1FF8C47ED955"},"type":"chat","timestamp":1770645506,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03912EF579884325BBC	gilberto	2	t	chat	\N	3	2026-02-12 01:03:04.423+00	2026-02-12 01:03:04.423+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB03912EF579884325BBC","_serialized":"true_175681342312561@lid_3EB03912EF579884325BBC"},"type":"chat","timestamp":1770648771,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB001EBF34E58D1E9ADC8	conecta o usuário atendente 02	2	t	chat	\N	3	2026-02-12 01:03:06.571+00	2026-02-12 01:03:06.571+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB001EBF34E58D1E9ADC8","_serialized":"true_175681342312561@lid_3EB001EBF34E58D1E9ADC8"},"type":"chat","timestamp":1770648780,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E32049C4F9BB07C72E	e continuar os atendimentos pela Único	2	t	chat	\N	3	2026-02-12 01:03:08.347+00	2026-02-12 01:03:08.347+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"3EB0E32049C4F9BB07C72E","_serialized":"true_175681342312561@lid_3EB0E32049C4F9BB07C72E"},"type":"chat","timestamp":1770648791,"from":"151909402964196@lid","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACE0B0D1BD22295EA62B4CAC74BF072F	Rapaz	1	f	chat	\N	16	2026-02-12 11:59:20.053+00	2026-02-12 11:59:20.092+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACE0B0D1BD22295EA62B4CAC74BF072F","_serialized":"false_131752601366700@lid_ACE0B0D1BD22295EA62B4CAC74BF072F"},"type":"chat","timestamp":1770897559,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5B6DC32CD723EB83FF6342296F58D5F		2	t	audio	1770858190463-uo0hk.oga	3	2026-02-12 01:03:10.469+00	2026-02-12 01:03:10.469+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A5B6DC32CD723EB83FF6342296F58D5F","_serialized":"true_175681342312561@lid_A5B6DC32CD723EB83FF6342296F58D5F"},"type":"ptt","timestamp":1770649300,"from":"556592694840@c.us","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"19","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A553C259BA27F5FB0C4EA611030F3E5E	Conseguiu fazer esse processo	2	t	chat	\N	3	2026-02-12 01:03:12.146+00	2026-02-12 01:03:12.146+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A553C259BA27F5FB0C4EA611030F3E5E","_serialized":"true_175681342312561@lid_A553C259BA27F5FB0C4EA611030F3E5E"},"type":"chat","timestamp":1770649990,"from":"556592694840@c.us","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACCBC9560354ECDB482C3B003956204E	Tem que tirar mesmo esse celular	1	f	chat	\N	16	2026-02-12 11:59:32.769+00	2026-02-12 11:59:32.788+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACCBC9560354ECDB482C3B003956204E","_serialized":"false_131752601366700@lid_ACCBC9560354ECDB482C3B003956204E"},"type":"chat","timestamp":1770897572,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A546C3E83306059D3F222588936CD94C		2	t	audio	1770858194830-317ek.oga	3	2026-02-12 01:03:14.834+00	2026-02-12 01:03:14.834+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A546C3E83306059D3F222588936CD94C","_serialized":"true_175681342312561@lid_A546C3E83306059D3F222588936CD94C"},"type":"ptt","timestamp":1770651532,"from":"556592694840@c.us","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"18","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A55875E1CCD56BB8C024F36AEEF0FE60	Bom dia!	2	t	chat	\N	3	2026-02-12 01:03:15.988+00	2026-02-12 01:03:15.988+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"175681342312561@lid","id":"A55875E1CCD56BB8C024F36AEEF0FE60","_serialized":"true_175681342312561@lid_A55875E1CCD56BB8C024F36AEEF0FE60"},"type":"chat","timestamp":1770724599,"from":"556592694840@c.us","to":"175681342312561@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC72C5FB7873242B1E6779D4878014FF	Estamos sem Internet	0	t	chat	\N	24	2026-02-12 01:03:00.353+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC72C5FB7873242B1E6779D4878014FF","_serialized":"false_175681342312561@lid_AC72C5FB7873242B1E6779D4878014FF"},"type":"chat","timestamp":1770645175,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC1AB906D2839BBDD6F6B41E7B0FE3F3	Povo não aprende	1	f	chat	\N	16	2026-02-12 11:59:39.206+00	2026-02-12 11:59:39.23+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC1AB906D2839BBDD6F6B41E7B0FE3F3","_serialized":"false_131752601366700@lid_AC1AB906D2839BBDD6F6B41E7B0FE3F3"},"type":"chat","timestamp":1770897578,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A739E12C16FA6788376	Eu acho que tem um prazo. Deixa eu ver aqui.	1	f	chat	\N	15	2026-02-12 11:59:47.932+00	2026-02-12 11:59:47.951+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A739E12C16FA6788376","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A739E12C16FA6788376_7202811162779@lid"},"type":"chat","timestamp":1770897586,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5E67F4406074E8572B90C93C0116B70		0	t	chat	\N	3	2026-02-12 01:03:17.591+00	2026-02-12 01:03:17.591+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"46733589512194@lid","id":"A5E67F4406074E8572B90C93C0116B70","_serialized":"true_46733589512194@lid_A5E67F4406074E8572B90C93C0116B70"},"type":"e2e_notification","timestamp":1770666982,"from":"556592694840@c.us","to":"46733589512194@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5EA0A5E8DAD7C6ADF01FB3F34E7F384	TERMO DE RESPONSABILIDADE - API.pdf	3	t	document	1770858198823-8zesj.pdf	3	2026-02-12 01:03:18.829+00	2026-02-12 01:03:18.829+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"46733589512194@lid","id":"A5EA0A5E8DAD7C6ADF01FB3F34E7F384","_serialized":"true_46733589512194@lid_A5EA0A5E8DAD7C6ADF01FB3F34E7F384"},"type":"document","timestamp":1770667001,"from":"556592694840@c.us","to":"46733589512194@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC06F6D609311EBEC7526F2FD0E63CE2	Só essa loja	1	f	chat	\N	16	2026-02-12 11:59:48.337+00	2026-02-12 11:59:48.361+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC06F6D609311EBEC7526F2FD0E63CE2","_serialized":"false_131752601366700@lid_AC06F6D609311EBEC7526F2FD0E63CE2"},"type":"chat","timestamp":1770897587,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB03FE693567EE24E5978	necessitava encerrar isso hoje	3	t	chat	\N	3	2026-02-12 01:03:22.124+00	2026-02-12 01:03:22.124+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB03FE693567EE24E5978","_serialized":"true_107464628424786@lid_3EB03FE693567EE24E5978"},"type":"chat","timestamp":1770057166,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00C162895EC315C1DD2	tenho uma demanda	3	t	chat	\N	3	2026-02-12 01:03:24.051+00	2026-02-12 01:03:24.051+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB00C162895EC315C1DD2","_serialized":"true_107464628424786@lid_3EB00C162895EC315C1DD2"},"type":"chat","timestamp":1770057169,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AF9F68FCF02FFA6436	ele vai deixar copiando para você trabalhar	3	t	chat	\N	3	2026-02-12 01:03:26.251+00	2026-02-12 01:03:26.251+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB0AF9F68FCF02FFA6436","_serialized":"true_107464628424786@lid_3EB0AF9F68FCF02FFA6436"},"type":"chat","timestamp":1770057180,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5008E9EB6FE65A7332DE369FFE630FF	E uma coisa que foge um pouco do nosso controle	3	t	chat	\N	3	2026-02-12 11:59:56.072+00	2026-02-12 12:20:27.31+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A5008E9EB6FE65A7332DE369FFE630FF","_serialized":"true_131752601366700@lid_A5008E9EB6FE65A7332DE369FFE630FF"},"type":"chat","timestamp":1770897592,"from":"556592694840@c.us","to":"131752601366700@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB047A58350BC08257EB1	Sim	3	t	chat	\N	3	2026-02-12 01:03:29.137+00	2026-02-12 01:03:29.137+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB047A58350BC08257EB1","_serialized":"true_107464628424786@lid_3EB047A58350BC08257EB1"},"type":"chat","timestamp":1770058589,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F4945F0D1567187B1D	mas tem	3	t	chat	\N	3	2026-02-12 01:03:31.419+00	2026-02-12 01:03:31.419+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB0F4945F0D1567187B1D","_serialized":"true_107464628424786@lid_3EB0F4945F0D1567187B1D"},"type":"chat","timestamp":1770058591,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB056D4CCE15BA6C720DE	Sirley	3	t	chat	\N	3	2026-02-12 01:03:33.675+00	2026-02-12 01:03:33.675+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB056D4CCE15BA6C720DE","_serialized":"true_107464628424786@lid_3EB056D4CCE15BA6C720DE"},"type":"chat","timestamp":1770060036,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02D25AB813BB46F7124	me passa o anydesk seu por gentileza	3	t	chat	\N	3	2026-02-12 01:03:36.003+00	2026-02-12 01:03:36.003+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"3EB02D25AB813BB46F7124","_serialized":"true_107464628424786@lid_3EB02D25AB813BB46F7124"},"type":"chat","timestamp":1770060042,"from":"151909402964196@lid","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A59F73CA1366E809BE7FB022BA04F415		4	t	audio	1770858218480-4xe0re.oga	3	2026-02-12 01:03:38.486+00	2026-02-12 01:03:38.486+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"107464628424786@lid","id":"A59F73CA1366E809BE7FB022BA04F415","_serialized":"true_107464628424786@lid_A59F73CA1366E809BE7FB022BA04F415"},"type":"ptt","timestamp":1770654982,"from":"556592694840@c.us","to":"107464628424786@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A566172D77DF103421A3313CAE26FD76	Estamos estudando um método de prevenir isso	3	t	chat	\N	3	2026-02-12 12:00:07.789+00	2026-02-12 12:20:27.317+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A566172D77DF103421A3313CAE26FD76","_serialized":"true_131752601366700@lid_A566172D77DF103421A3313CAE26FD76"},"type":"chat","timestamp":1770897604,"from":"556592694840@c.us","to":"131752601366700@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0250C97334EBDEA27E4	aceita	2	t	chat	\N	3	2026-02-12 01:03:41.469+00	2026-02-12 01:03:41.469+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0250C97334EBDEA27E4","_serialized":"true_102036091740395@lid_3EB0250C97334EBDEA27E4"},"type":"chat","timestamp":1770644128,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05DC4F576A81F3151E7	digita	2	t	chat	\N	3	2026-02-12 01:03:44.483+00	2026-02-12 01:03:44.483+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB05DC4F576A81F3151E7","_serialized":"true_102036091740395@lid_3EB05DC4F576A81F3151E7"},"type":"chat","timestamp":1770644149,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB033BC4469F23AD6A5A6	não dá pra eu escutar	2	t	chat	\N	3	2026-02-12 01:03:46.443+00	2026-02-12 01:03:46.443+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB033BC4469F23AD6A5A6","_serialized":"true_102036091740395@lid_3EB033BC4469F23AD6A5A6"},"type":"chat","timestamp":1770644152,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F7A63A7F869FCD6EDE	fazendo um favor	2	t	chat	\N	3	2026-02-12 01:03:48.326+00	2026-02-12 01:03:48.326+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0F7A63A7F869FCD6EDE","_serialized":"true_102036091740395@lid_3EB0F7A63A7F869FCD6EDE"},"type":"chat","timestamp":1770644156,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A73E878F641E8533FC9	Ele é só para ouvir	1	f	chat	\N	5	2026-02-12 12:00:20.211+00	2026-02-12 12:00:20.23+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A73E878F641E8533FC9","_serialized":"false_74758267867267@lid_3A73E878F641E8533FC9"},"type":"chat","timestamp":1770897619,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC88B91D4B66FCE5EBE509432D55B48F	Oii	0	t	chat	\N	26	2026-02-12 01:03:36.411+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC88B91D4B66FCE5EBE509432D55B48F","_serialized":"false_107464628424786@lid_AC88B91D4B66FCE5EBE509432D55B48F"},"type":"chat","timestamp":1770654054,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB389E1263A22E73FCA98209F7C7262	Vc quer pao e rosca	0	t	chat	\N	26	2026-02-12 01:03:36.61+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"ACB389E1263A22E73FCA98209F7C7262","_serialized":"false_107464628424786@lid_ACB389E1263A22E73FCA98209F7C7262"},"type":"chat","timestamp":1770654058,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09076CD022FAAB9513A	ok	2	t	chat	\N	3	2026-02-12 01:03:50.551+00	2026-02-12 01:03:50.551+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB09076CD022FAAB9513A","_serialized":"true_102036091740395@lid_3EB09076CD022FAAB9513A"},"type":"chat","timestamp":1770644192,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CE18FB5E6C1D8E6B47	aceitou não	2	t	chat	\N	3	2026-02-12 01:03:53.379+00	2026-02-12 01:03:53.379+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0CE18FB5E6C1D8E6B47","_serialized":"true_102036091740395@lid_3EB0CE18FB5E6C1D8E6B47"},"type":"chat","timestamp":1770644240,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E9B09C003489C9A479	esta tentando conectar	2	t	chat	\N	3	2026-02-12 01:03:55.263+00	2026-02-12 01:03:55.263+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0E9B09C003489C9A479","_serialized":"true_102036091740395@lid_3EB0E9B09C003489C9A479"},"type":"chat","timestamp":1770644244,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08F8A2E7C31B2D9BD92	NOTA FISCAL Nº 10524.pdf	2	t	document	1770858237683-v6ogg.pdf	3	2026-02-12 01:03:57.694+00	2026-02-12 01:03:57.694+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB08F8A2E7C31B2D9BD92","_serialized":"true_102036091740395@lid_3EB08F8A2E7C31B2D9BD92"},"type":"document","timestamp":1770646398,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":true,"forwardingScore":2,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02A61970892685E4BB7	Oi	2	t	chat	\N	3	2026-02-12 01:04:00.256+00	2026-02-12 01:04:00.256+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB02A61970892685E4BB7","_serialized":"true_102036091740395@lid_3EB02A61970892685E4BB7"},"type":"chat","timestamp":1770648597,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01AF7A210A1A1A17A5B	quem é?	2	t	chat	\N	3	2026-02-12 01:04:02.983+00	2026-02-12 01:04:02.983+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB01AF7A210A1A1A17A5B","_serialized":"true_102036091740395@lid_3EB01AF7A210A1A1A17A5B"},"type":"chat","timestamp":1770648599,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A96B41C2BD53AA21DED	Ou para gravar também ?	1	f	chat	\N	5	2026-02-12 12:00:25.559+00	2026-02-12 12:00:25.596+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A96B41C2BD53AA21DED","_serialized":"false_74758267867267@lid_3A96B41C2BD53AA21DED"},"type":"chat","timestamp":1770897625,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB04C1232C9A087122C67	Simone	2	t	chat	\N	3	2026-02-12 01:04:05.232+00	2026-02-12 01:04:05.232+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB04C1232C9A087122C67","_serialized":"true_102036091740395@lid_3EB04C1232C9A087122C67"},"type":"chat","timestamp":1770648652,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FE492700797B703A8F	o problema estava geral	2	t	chat	\N	3	2026-02-12 01:04:07.155+00	2026-02-12 01:04:07.155+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0FE492700797B703A8F","_serialized":"true_102036091740395@lid_3EB0FE492700797B703A8F"},"type":"chat","timestamp":1770648661,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E2CD29DBE2C928DA6F	estamos tentando resolver	2	t	chat	\N	3	2026-02-12 01:04:09.708+00	2026-02-12 01:04:09.708+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0E2CD29DBE2C928DA6F","_serialized":"true_102036091740395@lid_3EB0E2CD29DBE2C928DA6F"},"type":"chat","timestamp":1770648693,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A15D0E593FD4F5966E	o Lucas esta ai	2	t	chat	\N	3	2026-02-12 01:04:12.21+00	2026-02-12 01:04:12.21+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"102036091740395@lid","id":"3EB0A15D0E593FD4F5966E","_serialized":"true_102036091740395@lid_3EB0A15D0E593FD4F5966E"},"type":"chat","timestamp":1770648695,"from":"151909402964196@lid","to":"102036091740395@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AAE20BCAAB7499618C1	Áudio	1	f	chat	\N	5	2026-02-12 12:00:31.062+00	2026-02-12 12:00:31.086+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3AAE20BCAAB7499618C1","_serialized":"false_74758267867267@lid_3AAE20BCAAB7499618C1"},"type":"chat","timestamp":1770897630,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5CB9F2794671662619F7941C625025E		4	t	audio	1770858255310-jy31z.oga	3	2026-02-12 01:04:15.316+00	2026-02-12 01:04:15.316+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A5CB9F2794671662619F7941C625025E","_serialized":"true_10098005029093@lid_A5CB9F2794671662619F7941C625025E"},"type":"ptt","timestamp":1769790746,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"6","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05C85EAB27AA02FEB62	Terminaram a auditoria?	3	t	chat	\N	3	2026-02-12 01:04:18.058+00	2026-02-12 01:04:18.058+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"3EB05C85EAB27AA02FEB62","_serialized":"true_10098005029093@lid_3EB05C85EAB27AA02FEB62"},"type":"chat","timestamp":1769796766,"from":"151909402964196@lid","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5E394DB0ECA6013F65F1887535B5AD1	24 horas, aconteceu ontem e ninguém comunicou	3	t	chat	\N	3	2026-02-12 12:00:33.585+00	2026-02-12 12:17:35.511+00	t	f	3	3A739E12C16FA6788376	1	\N	{"id":{"fromMe":true,"remote":"120363405293949287@g.us","id":"A5E394DB0ECA6013F65F1887535B5AD1","participant":"151909402964196@lid","_serialized":"true_120363405293949287@g.us_A5E394DB0ECA6013F65F1887535B5AD1_151909402964196@lid"},"type":"chat","timestamp":1770897630,"from":"151909402964196@lid","to":"120363405293949287@g.us","author":"151909402964196@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A55DD2873B9180BE2CB7BF80637610B6	Bom dia!	3	t	chat	\N	3	2026-02-12 01:04:22.468+00	2026-02-12 01:04:22.468+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A55DD2873B9180BE2CB7BF80637610B6","_serialized":"true_10098005029093@lid_A55DD2873B9180BE2CB7BF80637610B6"},"type":"chat","timestamp":1770642135,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D6F4A5C46AA08C2D6234203B275815	Hoje de manhã operante informou e me mandou a mensagem	1	t	chat	\N	3	2026-02-12 12:00:50.303+00	2026-02-12 12:01:51.663+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"120363405293949287@g.us","id":"A5D6F4A5C46AA08C2D6234203B275815","participant":"151909402964196@lid","_serialized":"true_120363405293949287@g.us_A5D6F4A5C46AA08C2D6234203B275815_151909402964196@lid"},"type":"chat","timestamp":1770897647,"from":"151909402964196@lid","to":"120363405293949287@g.us","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A58EE093374772004D66ADCBDC56ADFF	Bom dia!	3	t	chat	\N	3	2026-02-12 01:04:24.699+00	2026-02-12 01:04:24.699+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A58EE093374772004D66ADCBDC56ADFF","_serialized":"true_10098005029093@lid_A58EE093374772004D66ADCBDC56ADFF"},"type":"chat","timestamp":1770642189,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5617B24EADEAB363644F3012198F835	Tudo sim e contigo?	3	t	chat	\N	3	2026-02-12 01:04:26.016+00	2026-02-12 01:04:26.016+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A5617B24EADEAB363644F3012198F835","_serialized":"true_10098005029093@lid_A5617B24EADEAB363644F3012198F835"},"type":"chat","timestamp":1770642203,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A55B219504E3079E462E36C2421D71BC	Gostaria de ver contigo duas situações	3	t	chat	\N	3	2026-02-12 01:04:26.935+00	2026-02-12 01:04:26.935+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A55B219504E3079E462E36C2421D71BC","_serialized":"true_10098005029093@lid_A55B219504E3079E462E36C2421D71BC"},"type":"chat","timestamp":1770642212,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A57C2AAA1E4FB4684E736DAE1BFCBCC2	Primeiros,  você consegue me enviar as NF dos  boletos?	3	t	chat	\N	3	2026-02-12 01:04:28.287+00	2026-02-12 01:04:28.287+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A57C2AAA1E4FB4684E736DAE1BFCBCC2","_serialized":"true_10098005029093@lid_A57C2AAA1E4FB4684E736DAE1BFCBCC2"},"type":"chat","timestamp":1770642232,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A534978F4BDD17E795A9B34095CAC43B		4	t	audio	1770858270374-cmzmfc.oga	3	2026-02-12 01:04:30.378+00	2026-02-12 01:04:30.378+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A534978F4BDD17E795A9B34095CAC43B","_serialized":"true_10098005029093@lid_A534978F4BDD17E795A9B34095CAC43B"},"type":"ptt","timestamp":1770642346,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"1","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A582C6DEBA1277F0B19C81EE0F0E33CF		4	t	audio	1770858272202-uue8lg.oga	3	2026-02-12 01:04:32.218+00	2026-02-12 01:04:32.218+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"10098005029093@lid","id":"A582C6DEBA1277F0B19C81EE0F0E33CF","_serialized":"true_10098005029093@lid_A582C6DEBA1277F0B19C81EE0F0E33CF"},"type":"ptt","timestamp":1770642414,"from":"556592694840@c.us","to":"10098005029093@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"62","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D96BE677D643EDC876F89641756280		0	t	chat	\N	3	2026-02-12 01:04:34.99+00	2026-02-12 01:04:34.99+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"253665214505073@lid","id":"A5D96BE677D643EDC876F89641756280","_serialized":"true_253665214505073@lid_A5D96BE677D643EDC876F89641756280"},"type":"e2e_notification","timestamp":1770643536,"from":"556592694840@c.us","to":"253665214505073@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A585D4781F84526B0DA18D6EC5985230	Oiii	3	t	chat	\N	3	2026-02-12 01:04:36.535+00	2026-02-12 01:04:36.535+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"253665214505073@lid","id":"A585D4781F84526B0DA18D6EC5985230","_serialized":"true_253665214505073@lid_A585D4781F84526B0DA18D6EC5985230"},"type":"chat","timestamp":1770643536,"from":"556592694840@c.us","to":"253665214505073@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A560F1640943412FF3472D93079512BD	Bom dia!	3	t	chat	\N	3	2026-02-12 01:04:37.69+00	2026-02-12 01:04:37.69+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"253665214505073@lid","id":"A560F1640943412FF3472D93079512BD","_serialized":"true_253665214505073@lid_A560F1640943412FF3472D93079512BD"},"type":"chat","timestamp":1770643540,"from":"556592694840@c.us","to":"253665214505073@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A8989CE8BC46BEC25CF	Falo se não tomar ação com relação ao recebimento da imagem.	1	f	chat	\N	15	2026-02-12 12:01:02.621+00	2026-02-12 12:01:02.695+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A8989CE8BC46BEC25CF","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A8989CE8BC46BEC25CF_7202811162779@lid"},"type":"chat","timestamp":1770897661,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0B8717CB17E2832F6C9	Isso	3	t	chat	\N	3	2026-02-12 01:04:41.238+00	2026-02-12 01:04:41.238+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0B8717CB17E2832F6C9","_serialized":"true_150950970921173@lid_3EB0B8717CB17E2832F6C9"},"type":"chat","timestamp":1769699954,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A51A3C582DE6876BBCCD3DCCD9E546BE	Ja contestaram e vai poder operar novamente dentro de 13 horas	3	t	chat	\N	3	2026-02-12 12:01:07.271+00	2026-02-12 12:17:35.496+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"120363405293949287@g.us","id":"A51A3C582DE6876BBCCD3DCCD9E546BE","participant":"151909402964196@lid","_serialized":"true_120363405293949287@g.us_A51A3C582DE6876BBCCD3DCCD9E546BE_151909402964196@lid"},"type":"chat","timestamp":1770897664,"from":"151909402964196@lid","to":"120363405293949287@g.us","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0A1AFE8EBA686E2C00D	Obrigado	3	t	chat	\N	3	2026-02-12 01:04:46.519+00	2026-02-12 01:04:46.519+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0A1AFE8EBA686E2C00D","_serialized":"true_150950970921173@lid_3EB0A1AFE8EBA686E2C00D"},"type":"chat","timestamp":1769700402,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00B6DD887E1814BB33B	pode deixar que as NFs já foram solicitadas	0	t	chat	\N	28	2026-02-12 01:04:32.459+00	2026-02-12 01:40:36.558+00	f	f	31	A582C6DEBA1277F0B19C81EE0F0E33CF	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB00B6DD887E1814BB33B","_serialized":"false_10098005029093@lid_3EB00B6DD887E1814BB33B"},"type":"chat","timestamp":1770642502,"from":"10098005029093@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0555FF3E3EC7561BF02	sobre o segundo ponto que o senhor me passou, seria uma portabilidade mesmo, correto?\nSe sim, o procedimento é o mesmo. Solicitamos a portabilidade a TIP, e temos que aguardar o tempo dessa transição.	0	t	chat	\N	28	2026-02-12 01:04:33.027+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB0555FF3E3EC7561BF02","_serialized":"false_10098005029093@lid_3EB0555FF3E3EC7561BF02"},"type":"chat","timestamp":1770642577,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0076E8C84C55BAE6A43	NOTA FISCAL Nº 10524.pdf	0	t	document	1770858273270-7rrmrf.pdf	28	2026-02-12 01:04:33.278+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB0076E8C84C55BAE6A43","_serialized":"false_10098005029093@lid_3EB0076E8C84C55BAE6A43"},"type":"document","timestamp":1770645042,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0D61AFB53BE0A93FFCD	Oi Daiane	3	t	chat	\N	3	2026-02-12 01:04:48.654+00	2026-02-12 01:04:48.654+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0D61AFB53BE0A93FFCD","_serialized":"true_150950970921173@lid_3EB0D61AFB53BE0A93FFCD"},"type":"chat","timestamp":1770125744,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CEA7B76246DA005B41	Bom dia!	3	t	chat	\N	3	2026-02-12 01:04:51.234+00	2026-02-12 01:04:51.234+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0CEA7B76246DA005B41","_serialized":"true_150950970921173@lid_3EB0CEA7B76246DA005B41"},"type":"chat","timestamp":1770125745,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BD6E3823ECFE86C92D	Como estou visando a nova loja	3	t	chat	\N	3	2026-02-12 01:04:53.408+00	2026-02-12 01:04:53.408+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0BD6E3823ECFE86C92D","_serialized":"true_150950970921173@lid_3EB0BD6E3823ECFE86C92D"},"type":"chat","timestamp":1770125752,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB066BDB0157C34F9EB73	temos que adquirir novos usuários	3	t	chat	\N	3	2026-02-12 01:04:55.908+00	2026-02-12 01:04:55.908+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB066BDB0157C34F9EB73","_serialized":"true_150950970921173@lid_3EB066BDB0157C34F9EB73"},"type":"chat","timestamp":1770125761,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0798901433DF5F2B0DA	consegui negociar aqui	3	t	chat	\N	3	2026-02-12 01:04:58.22+00	2026-02-12 01:04:58.22+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0798901433DF5F2B0DA","_serialized":"true_150950970921173@lid_3EB0798901433DF5F2B0DA"},"type":"chat","timestamp":1770125766,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB006FF85DCDA4A0ED6DA	Sim	3	t	chat	\N	3	2026-02-12 01:05:12.391+00	2026-02-12 01:05:12.391+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB006FF85DCDA4A0ED6DA","_serialized":"true_181088857157665@lid_3EB006FF85DCDA4A0ED6DA"},"type":"chat","timestamp":1770409305,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB036F9052D987CE6D41A	com a fórmula	3	t	chat	\N	3	2026-02-12 01:05:15.719+00	2026-02-12 01:05:15.719+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB036F9052D987CE6D41A","_serialized":"true_181088857157665@lid_3EB036F9052D987CE6D41A"},"type":"chat","timestamp":1770409307,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E070A38C0D6290DCDE	um de exemplo	3	t	chat	\N	3	2026-02-12 01:05:18.763+00	2026-02-12 01:05:18.763+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB0E070A38C0D6290DCDE","_serialized":"true_181088857157665@lid_3EB0E070A38C0D6290DCDE"},"type":"chat","timestamp":1770409311,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09B3A3D1ED17D07D4FD	Com os custos de cada um ?	3	t	chat	\N	3	2026-02-12 01:05:22.268+00	2026-02-12 01:05:22.268+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB09B3A3D1ED17D07D4FD","_serialized":"true_181088857157665@lid_3EB09B3A3D1ED17D07D4FD"},"type":"chat","timestamp":1770409418,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AB7686ECC9A4EEBE8F6	Tipo recebi uma foto, um filho manda para a mãe uma foto de ferida com sangue e etc	1	f	chat	\N	15	2026-02-12 12:01:38.039+00	2026-02-12 12:01:38.072+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AB7686ECC9A4EEBE8F6","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3AB7686ECC9A4EEBE8F6_7202811162779@lid"},"type":"chat","timestamp":1770897697,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0BB0C64E11DF361C0CF	Eu no momento não tenho acesso ao sistema	3	t	chat	\N	3	2026-02-12 01:05:25.168+00	2026-02-12 01:05:25.168+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB0BB0C64E11DF361C0CF","_serialized":"true_181088857157665@lid_3EB0BB0C64E11DF361C0CF"},"type":"chat","timestamp":1770409427,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B3AFCE6AF1B2E5F0AE	vou tentar falar com Gil sobre acesso	3	t	chat	\N	3	2026-02-12 01:05:27.823+00	2026-02-12 01:05:27.823+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB0B3AFCE6AF1B2E5F0AE","_serialized":"true_181088857157665@lid_3EB0B3AFCE6AF1B2E5F0AE"},"type":"chat","timestamp":1770409434,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AE3CCDCB21A36E8B65F	Como o WhatsApp entende se é uma questão pessoal ou um tipo de deepspam	1	f	chat	\N	15	2026-02-12 12:01:56.442+00	2026-02-12 12:01:56.484+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AE3CCDCB21A36E8B65F","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3AE3CCDCB21A36E8B65F_7202811162779@lid"},"type":"chat","timestamp":1770897715,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0D4503A8A8059E1E30C	do valor que pagamos semana passada	3	t	chat	\N	3	2026-02-12 01:05:00.379+00	2026-02-12 01:05:00.379+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0D4503A8A8059E1E30C","_serialized":"true_150950970921173@lid_3EB0D4503A8A8059E1E30C"},"type":"chat","timestamp":1770125771,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C3BB93371983857259	de 220 consegui 165,00 para os usuários da Costa Verde onde iremos colocar o whatsapp para operar	3	t	chat	\N	3	2026-02-12 01:05:02.57+00	2026-02-12 01:05:02.57+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB0C3BB93371983857259","_serialized":"true_150950970921173@lid_3EB0C3BB93371983857259"},"type":"chat","timestamp":1770125794,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04DD8DBB4B45EC6BE8F	Nova loja, quero dizer para colocar na Único	3	t	chat	\N	3	2026-02-12 01:05:05.707+00	2026-02-12 01:05:05.707+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"3EB04DD8DBB4B45EC6BE8F","_serialized":"true_150950970921173@lid_3EB04DD8DBB4B45EC6BE8F"},"type":"chat","timestamp":1770125864,"from":"151909402964196@lid","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A2DB036D10E0DD0878B	Eu acho que deve haver alguma questão sobre um tempo entre deletar a imagem e etc	1	f	chat	\N	15	2026-02-12 12:02:13.552+00	2026-02-12 12:02:13.585+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A2DB036D10E0DD0878B","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A2DB036D10E0DD0878B_7202811162779@lid"},"type":"chat","timestamp":1770897733,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A55A9B60C8E1639AF666D7012F5DA0D1	Bom dia!	3	t	chat	\N	3	2026-02-12 01:05:07.779+00	2026-02-12 01:05:07.779+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"A55A9B60C8E1639AF666D7012F5DA0D1","_serialized":"true_150950970921173@lid_A55A9B60C8E1639AF666D7012F5DA0D1"},"type":"chat","timestamp":1770636783,"from":"556592694840@c.us","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5CCE6864570C34FC7DCB52C784C1120	Vejo hoje essa questão	3	t	chat	\N	3	2026-02-12 01:05:09.443+00	2026-02-12 01:05:09.443+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"150950970921173@lid","id":"A5CCE6864570C34FC7DCB52C784C1120","_serialized":"true_150950970921173@lid_A5CCE6864570C34FC7DCB52C784C1120"},"type":"chat","timestamp":1770636808,"from":"556592694840@c.us","to":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05A1837811761F4EEF7	eu estou vendo porque não estou na loja para fazer isso	2	t	chat	\N	3	2026-02-12 01:06:01.737+00	2026-02-12 01:06:01.737+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"3EB05A1837811761F4EEF7","_serialized":"true_73667581095989@lid_3EB05A1837811761F4EEF7"},"type":"chat","timestamp":1770232874,"from":"151909402964196@lid","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F7EE133251ED266109	estou em uma outra rede	2	t	chat	\N	3	2026-02-12 01:06:04.337+00	2026-02-12 01:06:04.337+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"3EB0F7EE133251ED266109","_serialized":"true_73667581095989@lid_3EB0F7EE133251ED266109"},"type":"chat","timestamp":1770232878,"from":"151909402964196@lid","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07EA0911F5AC7FD05A9	1 052 507 966	2	t	chat	\N	3	2026-02-12 01:06:07.003+00	2026-02-12 01:06:07.003+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"3EB07EA0911F5AC7FD05A9","_serialized":"true_73667581095989@lid_3EB07EA0911F5AC7FD05A9"},"type":"chat","timestamp":1770233165,"from":"151909402964196@lid","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AF777F5317183BCE34	o anydesk	2	t	chat	\N	3	2026-02-12 01:06:09.603+00	2026-02-12 01:06:09.603+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"3EB0AF777F5317183BCE34","_serialized":"true_73667581095989@lid_3EB0AF777F5317183BCE34"},"type":"chat","timestamp":1770233167,"from":"151909402964196@lid","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B66553DE809320CE1B	*Isaac Carvalho:* \nOk	0	t	chat	\N	31	2026-02-12 01:06:10.304+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0B66553DE809320CE1B","_serialized":"false_73667581095989@lid_3EB0B66553DE809320CE1B"},"type":"chat","timestamp":1770233536,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5B68BBD8DA5701663F3A3B7AFA890C1	Gravar também	2	t	chat	\N	3	2026-02-12 12:02:20.433+00	2026-02-12 12:02:20.501+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A5B68BBD8DA5701663F3A3B7AFA890C1","_serialized":"true_74758267867267@lid_A5B68BBD8DA5701663F3A3B7AFA890C1"},"type":"chat","timestamp":1770897737,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5832D5556799F6FF816D0E61BB76640	Aí o celular fica apenas para foto	2	t	chat	\N	3	2026-02-12 12:02:27.309+00	2026-02-12 12:02:27.438+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A5832D5556799F6FF816D0E61BB76640","_serialized":"true_74758267867267@lid_A5832D5556799F6FF816D0E61BB76640"},"type":"chat","timestamp":1770897744,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB04967FD35BCEC83EEE1	O Lucas , comentou que tinha	3	t	chat	\N	3	2026-02-12 01:05:30.964+00	2026-02-12 01:05:30.964+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB04967FD35BCEC83EEE1","_serialized":"true_181088857157665@lid_3EB04967FD35BCEC83EEE1"},"type":"chat","timestamp":1770409459,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB007D9D1714FE7A72579	Sim	3	t	chat	\N	3	2026-02-12 01:05:34.378+00	2026-02-12 01:05:34.378+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB007D9D1714FE7A72579","_serialized":"true_181088857157665@lid_3EB007D9D1714FE7A72579"},"type":"chat","timestamp":1770409487,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB087E2968916E7CB33A1	Ele tinha mas, hoje não tem mais o acesso estava no antigo notebook dele	3	t	chat	\N	3	2026-02-12 01:05:36.643+00	2026-02-12 01:05:36.643+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB087E2968916E7CB33A1","_serialized":"true_181088857157665@lid_3EB087E2968916E7CB33A1"},"type":"chat","timestamp":1770409501,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB003421A775A5E92BA75	Faz assim	3	t	chat	\N	3	2026-02-12 01:05:39.492+00	2026-02-12 01:05:39.492+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB003421A775A5E92BA75","_serialized":"true_181088857157665@lid_3EB003421A775A5E92BA75"},"type":"chat","timestamp":1770409503,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BFBC30D16B01F46942	podemos marcar semana que vem	3	t	chat	\N	3	2026-02-12 01:05:42.017+00	2026-02-12 01:05:42.017+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB0BFBC30D16B01F46942","_serialized":"true_181088857157665@lid_3EB0BFBC30D16B01F46942"},"type":"chat","timestamp":1770409507,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0248ECC9C5919B1FD30	para que possa ir e entender com alguém que pode designar	3	t	chat	\N	3	2026-02-12 01:05:44.192+00	2026-02-12 01:05:44.192+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB0248ECC9C5919B1FD30","_serialized":"true_181088857157665@lid_3EB0248ECC9C5919B1FD30"},"type":"chat","timestamp":1770409518,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CC40CD47CA674F7D		0	f	chat	\N	48	2026-02-12 12:02:28.753+00	2026-02-12 12:02:28.807+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"3EB0CC40CD47CA674F7D","_serialized":"false_2194761883822@lid_3EB0CC40CD47CA674F7D"},"type":"e2e_notification","timestamp":1770897747,"from":"2194761883822@lid","to":"151909402964196:5@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0ADC8F75A52FB0EE1F8	ai tiramos dúvidas sobre esse processo	3	t	chat	\N	3	2026-02-12 01:05:47.155+00	2026-02-12 01:05:47.155+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"181088857157665@lid","id":"3EB0ADC8F75A52FB0EE1F8","_serialized":"true_181088857157665@lid_3EB0ADC8F75A52FB0EE1F8"},"type":"chat","timestamp":1770409524,"from":"151909402964196@lid","to":"181088857157665@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5A35625249156FB0F7324082F97C127		0	t	chat	\N	3	2026-02-12 01:05:48.777+00	2026-02-12 01:05:48.777+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"190112885411880@lid","id":"A5A35625249156FB0F7324082F97C127","_serialized":"true_190112885411880@lid_A5A35625249156FB0F7324082F97C127"},"type":"e2e_notification","timestamp":1770392892,"from":"556592694840@c.us","to":"190112885411880@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02E941C609944E38713	Bom dia bebe	3	t	chat	\N	3	2026-02-12 01:05:50.54+00	2026-02-12 01:05:50.54+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"190112885411880@lid","id":"3EB02E941C609944E38713","_serialized":"true_190112885411880@lid_3EB02E941C609944E38713"},"type":"chat","timestamp":1770392892,"from":"151909402964196@lid","to":"190112885411880@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01DAC69C96702392362	tudo bem contigo	3	t	chat	\N	3	2026-02-12 01:05:52.586+00	2026-02-12 01:05:52.586+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"190112885411880@lid","id":"3EB01DAC69C96702392362","_serialized":"true_190112885411880@lid_3EB01DAC69C96702392362"},"type":"chat","timestamp":1770392895,"from":"151909402964196@lid","to":"190112885411880@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0214E5602EAC3FAF084	é o Marcos do TI	3	t	chat	\N	3	2026-02-12 01:05:54.919+00	2026-02-12 01:05:54.919+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"190112885411880@lid","id":"3EB0214E5602EAC3FAF084","_serialized":"true_190112885411880@lid_3EB0214E5602EAC3FAF084"},"type":"chat","timestamp":1770392899,"from":"151909402964196@lid","to":"190112885411880@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC9B4B577B444F8D421D08097FD9A734	Bom dia	1	f	chat	\N	48	2026-02-12 12:02:29.74+00	2026-02-12 12:02:29.77+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC9B4B577B444F8D421D08097FD9A734","_serialized":"false_2194761883822@lid_AC9B4B577B444F8D421D08097FD9A734"},"type":"chat","timestamp":1770897746,"from":"2194761883822@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB049037ECAC1E858CDB1	Vai passar aqui pela Fernando Correa hoje?	3	t	chat	\N	3	2026-02-12 01:05:57.005+00	2026-02-12 01:05:57.005+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"190112885411880@lid","id":"3EB049037ECAC1E858CDB1","_serialized":"true_190112885411880@lid_3EB049037ECAC1E858CDB1"},"type":"chat","timestamp":1770392943,"from":"151909402964196@lid","to":"190112885411880@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05C767AB0AEAD9DAD5E	*Isaac Carvalho:* \nPode me mandar	0	t	chat	\N	31	2026-02-12 01:05:59.463+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB05C767AB0AEAD9DAD5E","_serialized":"false_73667581095989@lid_3EB05C767AB0AEAD9DAD5E"},"type":"chat","timestamp":1770232827,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04597BDB575C13B6CDB	*Isaac Carvalho:* \nPor favor.	0	t	chat	\N	31	2026-02-12 01:05:59.771+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB04597BDB575C13B6CDB","_serialized":"false_73667581095989@lid_3EB04597BDB575C13B6CDB"},"type":"chat","timestamp":1770232830,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A517CD76AA9891E26B7A3C46263EE3B2	Mas vou deixar um exemplo	2	t	chat	\N	3	2026-02-12 12:02:33.246+00	2026-02-12 12:02:33.447+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A517CD76AA9891E26B7A3C46263EE3B2","_serialized":"true_74758267867267@lid_A517CD76AA9891E26B7A3C46263EE3B2"},"type":"chat","timestamp":1770897750,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A55631C8C4FABBCC12A3824F2FAEA297	Por envio de foto	2	t	chat	\N	3	2026-02-12 12:02:49.169+00	2026-02-12 12:02:49.352+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A55631C8C4FABBCC12A3824F2FAEA297","_serialized":"true_74758267867267@lid_A55631C8C4FABBCC12A3824F2FAEA297"},"type":"chat","timestamp":1770897766,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A502608B3A800F0F75F51D08C37FF1B7	Número da Fernando Correa bloqueou ontem	2	t	chat	\N	3	2026-02-12 12:02:45.288+00	2026-02-12 12:02:45.522+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A502608B3A800F0F75F51D08C37FF1B7","_serialized":"true_74758267867267@lid_A502608B3A800F0F75F51D08C37FF1B7"},"type":"chat","timestamp":1770897762,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A620BF931BF50FF809E	Ou recompartilhar. Deve haver algo dentro dessa lógica. Uma mãe não tem que perder o número porque o filho mandou que caiu e ralou a perna por ex	1	f	chat	\N	15	2026-02-12 12:02:48.03+00	2026-02-12 12:02:48.093+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A620BF931BF50FF809E","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3A620BF931BF50FF809E_7202811162779@lid"},"type":"chat","timestamp":1770897766,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC9A629EDF55016B1BE94572FEE0CB09		4	f	audio	1770897770289-c1na8.oga	48	2026-02-12 12:02:50.296+00	2026-02-12 12:02:54.268+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC9A629EDF55016B1BE94572FEE0CB09","_serialized":"false_2194761883822@lid_AC9A629EDF55016B1BE94572FEE0CB09"},"type":"ptt","timestamp":1770897766,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"17","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5FD67D333707660BE70CE486803CBDD	192.168.231.135	2	t	chat	\N	3	2026-02-12 01:06:13.303+00	2026-02-12 01:06:13.303+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"A5FD67D333707660BE70CE486803CBDD","_serialized":"true_73667581095989@lid_A5FD67D333707660BE70CE486803CBDD"},"type":"chat","timestamp":1770233562,"from":"556592694840@c.us","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A522C9BA28F92605C647BDBCC2C55024	servidor ou root	2	t	chat	\N	3	2026-02-12 01:06:15.119+00	2026-02-12 01:06:15.119+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"A522C9BA28F92605C647BDBCC2C55024","_serialized":"true_73667581095989@lid_A522C9BA28F92605C647BDBCC2C55024"},"type":"chat","timestamp":1770233830,"from":"556592694840@c.us","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A546BDD76E569DF6337D5CB93889DAFC	Sim	2	t	chat	\N	3	2026-02-12 01:06:17.326+00	2026-02-12 01:06:17.326+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"A546BDD76E569DF6337D5CB93889DAFC","_serialized":"true_73667581095989@lid_A546BDD76E569DF6337D5CB93889DAFC"},"type":"chat","timestamp":1770233944,"from":"556592694840@c.us","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AFA49DD9024891F5E0E	Mas a gente investiga melhor isso, pra impedir. Por agora eu acho que a campanha é o problema mais grave.	1	f	chat	\N	15	2026-02-12 12:03:11.89+00	2026-02-12 12:03:11.928+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AFA49DD9024891F5E0E","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3AFA49DD9024891F5E0E_7202811162779@lid"},"type":"chat","timestamp":1770897790,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5C9E8904EDB77768B484CCF2D092571	Momento	2	t	chat	\N	3	2026-02-12 01:06:19.13+00	2026-02-12 01:06:19.13+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73667581095989@lid","id":"A5C9E8904EDB77768B484CCF2D092571","_serialized":"true_73667581095989@lid_A5C9E8904EDB77768B484CCF2D092571"},"type":"chat","timestamp":1770234138,"from":"556592694840@c.us","to":"73667581095989@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A7674B832B7236CDC98		4	f	audio	1770897796776-s49s8.oga	5	2026-02-12 12:03:16.782+00	2026-02-12 12:04:03.335+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A7674B832B7236CDC98","_serialized":"false_74758267867267@lid_3A7674B832B7236CDC98"},"type":"ptt","timestamp":1770897795,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5862199ADD7471861ED33A1C139F362	Bom dia	3	t	chat	\N	3	2026-02-12 12:03:10.395+00	2026-02-12 12:04:09.782+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"2194761883822@lid","id":"A5862199ADD7471861ED33A1C139F362","_serialized":"true_2194761883822@lid_A5862199ADD7471861ED33A1C139F362"},"type":"chat","timestamp":1770897788,"from":"556592694840@c.us","to":"2194761883822@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0C08398671AEFA952B2	Boa Tarde!	3	t	chat	\N	3	2026-02-12 01:06:30.692+00	2026-02-12 01:06:30.692+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB0C08398671AEFA952B2","_serialized":"true_64283496952056@lid_3EB0C08398671AEFA952B2"},"type":"chat","timestamp":1770146616,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D4F55296FEE0A2302F07385D5E3E21	Ola boa tarde	0	t	chat	\N	32	2026-02-12 01:06:21.699+00	2026-02-12 01:06:36.854+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A5D4F55296FEE0A2302F07385D5E3E21","_serialized":"false_64283496952056@lid_A5D4F55296FEE0A2302F07385D5E3E21"},"type":"chat","timestamp":1770145144,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5BE082A7FD9537FF677ECFC8B41605A	Tudo bem ?	0	t	chat	\N	32	2026-02-12 01:06:22.311+00	2026-02-12 01:06:36.854+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A5BE082A7FD9537FF677ECFC8B41605A","_serialized":"false_64283496952056@lid_A5BE082A7FD9537FF677ECFC8B41605A"},"type":"chat","timestamp":1770145155,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A54A2E0C9527931BBED71BCE0A562376	Estamos com um problema no PC dos rótulos	0	t	chat	\N	32	2026-02-12 01:06:22.746+00	2026-02-12 01:06:36.854+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A54A2E0C9527931BBED71BCE0A562376","_serialized":"false_64283496952056@lid_A54A2E0C9527931BBED71BCE0A562376"},"type":"chat","timestamp":1770145163,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5587370F1D06FEF6D207CE9E8D457FA		0	t	video	1770858385667-g1uiv9.mp4	32	2026-02-12 01:06:25.698+00	2026-02-12 01:06:36.854+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A5587370F1D06FEF6D207CE9E8D457FA","_serialized":"false_64283496952056@lid_A5587370F1D06FEF6D207CE9E8D457FA"},"type":"video","timestamp":1770145204,"from":"64283496952056@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"18","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A515901753E462C90FB1DE3BDED04150	Iniciamos o servidor, porém fica tudo preto. Nao conseguimos acessar nada.	0	t	chat	\N	32	2026-02-12 01:06:27.483+00	2026-02-12 01:06:36.854+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A515901753E462C90FB1DE3BDED04150","_serialized":"false_64283496952056@lid_A515901753E462C90FB1DE3BDED04150"},"type":"chat","timestamp":1770145218,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56FA837ABA582FB157EB236F06F1994	Oi eu sou a Lilian	0	t	chat	\N	32	2026-02-12 01:06:27.915+00	2026-02-12 01:06:36.854+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A56FA837ABA582FB157EB236F06F1994","_serialized":"false_64283496952056@lid_A56FA837ABA582FB157EB236F06F1994"},"type":"chat","timestamp":1770146391,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB093DE874E9C4579AFCC	já lhe retonro	3	t	chat	\N	3	2026-02-12 01:06:39.804+00	2026-02-12 01:06:39.804+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB093DE874E9C4579AFCC","_serialized":"true_64283496952056@lid_3EB093DE874E9C4579AFCC"},"type":"chat","timestamp":1770146635,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A500CF20CA06A5E8D401986409DA0018	Tem e só habilitar no navagador	3	t	chat	\N	3	2026-02-12 12:03:25.126+00	2026-02-12 12:04:09.758+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"2194761883822@lid","id":"A500CF20CA06A5E8D401986409DA0018","_serialized":"true_2194761883822@lid_A500CF20CA06A5E8D401986409DA0018"},"type":"chat","timestamp":1770897802,"from":"556592694840@c.us","to":"2194761883822@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A583B4DC09486CFE37FD57B16B657F0A	Sim, para gravar sim	3	t	chat	\N	3	2026-02-12 12:03:19.303+00	2026-02-12 12:04:09.771+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"2194761883822@lid","id":"A583B4DC09486CFE37FD57B16B657F0A","_serialized":"true_2194761883822@lid_A583B4DC09486CFE37FD57B16B657F0A"},"type":"chat","timestamp":1770897796,"from":"556592694840@c.us","to":"2194761883822@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0BBDC7C76C07020D74C	Lilian	3	t	chat	\N	3	2026-02-12 01:06:33.71+00	2026-02-12 01:06:33.71+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB0BBDC7C76C07020D74C","_serialized":"true_64283496952056@lid_3EB0BBDC7C76C07020D74C"},"type":"chat","timestamp":1770146619,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08F80F63DAA8DDB6D45	nesse momento estou com uma situação com o servidor aqui da Big Master	3	t	chat	\N	3	2026-02-12 01:06:36.47+00	2026-02-12 01:06:36.47+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB08F80F63DAA8DDB6D45","_serialized":"true_64283496952056@lid_3EB08F80F63DAA8DDB6D45"},"type":"chat","timestamp":1770146632,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB064AF4D19041ED2A08C	retorno	3	t	chat	\N	3	2026-02-12 01:06:42.148+00	2026-02-12 01:06:42.148+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB064AF4D19041ED2A08C","_serialized":"true_64283496952056@lid_3EB064AF4D19041ED2A08C"},"type":"chat","timestamp":1770146637,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AC7033F4763DC2E06E0	Mas pra evitar o spam aqui, te ligo depois.	1	f	chat	\N	15	2026-02-12 12:03:25.964+00	2026-02-12 12:03:25.994+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AC7033F4763DC2E06E0","participant":"7202811162779@lid","_serialized":"false_120363405293949287@g.us_3AC7033F4763DC2E06E0_7202811162779@lid"},"type":"chat","timestamp":1770897805,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0FDA3C2E3288D33CE3D	e aqui a loja ficar parada	3	t	chat	\N	3	2026-02-12 01:06:45.864+00	2026-02-12 01:06:45.864+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB0FDA3C2E3288D33CE3D","_serialized":"true_64283496952056@lid_3EB0FDA3C2E3288D33CE3D"},"type":"chat","timestamp":1770146716,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06710C6E0F859284D7D	vou tentar chamar a rise para ajudar	3	t	chat	\N	3	2026-02-12 01:06:47.94+00	2026-02-12 01:06:47.94+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB06710C6E0F859284D7D","_serialized":"true_64283496952056@lid_3EB06710C6E0F859284D7D"},"type":"chat","timestamp":1770146723,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00D74109EBD6C9D3CFA	momento	3	t	chat	\N	3	2026-02-12 01:06:50.733+00	2026-02-12 01:06:50.733+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB00D74109EBD6C9D3CFA","_serialized":"true_64283496952056@lid_3EB00D74109EBD6C9D3CFA"},"type":"chat","timestamp":1770146725,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04E84F0F85B954441	BEGIN:VCARD\nVERSION:3.0\nN:;Rise Chamados;;;\nFN:Rise Chamados\nTEL;type=CELL;waid=556533653149:+55 65 3365-3149\nX-WA-BIZ-NAME:Rise Chamados\nX-WA-BIZ-AUTOMATED-TYPE:unknown\nEND:VCARD	3	t	vcard	\N	3	2026-02-12 01:06:52.538+00	2026-02-12 01:06:52.538+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB04E84F0F85B954441","_serialized":"true_64283496952056@lid_3EB04E84F0F85B954441"},"type":"vcard","timestamp":1770146738,"from":"556592694840@c.us","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":["BEGIN:VCARD\\nVERSION:3.0\\nN:;Rise Chamados;;;\\nFN:Rise Chamados\\nTEL;type=CELL;waid=556533653149:+55 65 3365-3149\\nX-WA-BIZ-NAME:Rise Chamados\\nX-WA-BIZ-AUTOMATED-TYPE:unknown\\nEND:VCARD"],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0D7A7082A79908D1C6F	Pode chama-los enquanto isso	3	t	chat	\N	3	2026-02-12 01:06:54.45+00	2026-02-12 01:06:54.45+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"64283496952056@lid","id":"3EB0D7A7082A79908D1C6F","_serialized":"true_64283496952056@lid_3EB0D7A7082A79908D1C6F"},"type":"chat","timestamp":1770146744,"from":"151909402964196@lid","to":"64283496952056@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56C14F3BD6819F872985FE9B6015E12	Ja me passa o anydesk	3	t	chat	\N	3	2026-02-12 12:03:30.252+00	2026-02-12 12:04:09.744+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"2194761883822@lid","id":"A56C14F3BD6819F872985FE9B6015E12","_serialized":"true_2194761883822@lid_A56C14F3BD6819F872985FE9B6015E12"},"type":"chat","timestamp":1770897807,"from":"556592694840@c.us","to":"2194761883822@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A53B4A0F07B2C2CA868A9862AD12A42C		0	t	chat	\N	3	2026-02-12 01:06:56.304+00	2026-02-12 01:06:56.304+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"12300903784497@lid","id":"A53B4A0F07B2C2CA868A9862AD12A42C","_serialized":"true_12300903784497@lid_A53B4A0F07B2C2CA868A9862AD12A42C"},"type":"e2e_notification","timestamp":1770066217,"from":"556592694840@c.us","to":"12300903784497@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5258C0FD0C80EA382AEBC415CDC9F4D	Boa tarde!	3	t	chat	\N	3	2026-02-12 01:06:57.9+00	2026-02-12 01:06:57.9+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"12300903784497@lid","id":"A5258C0FD0C80EA382AEBC415CDC9F4D","_serialized":"true_12300903784497@lid_A5258C0FD0C80EA382AEBC415CDC9F4D"},"type":"chat","timestamp":1770066217,"from":"556592694840@c.us","to":"12300903784497@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05C383DBDAC83229C61	deixei no versão 12	3	t	chat	\N	3	2026-02-12 01:08:59.306+00	2026-02-12 01:08:59.306+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB05C383DBDAC83229C61","_serialized":"true_149061235691692@lid_3EB05C383DBDAC83229C61"},"type":"chat","timestamp":1769794802,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0556FEB6BA298A06045	segundo ele só funciona no 12	3	t	chat	\N	3	2026-02-12 01:09:05.066+00	2026-02-12 01:09:05.066+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB0556FEB6BA298A06045","_serialized":"true_149061235691692@lid_3EB0556FEB6BA298A06045"},"type":"chat","timestamp":1769795068,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0472651B5F256F72727	ai tive que formatar hoje	3	t	chat	\N	3	2026-02-12 01:09:07.183+00	2026-02-12 01:09:07.183+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB0472651B5F256F72727","_serialized":"true_149061235691692@lid_3EB0472651B5F256F72727"},"type":"chat","timestamp":1769795071,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09EB1BD37CD96DE02D6	uai, porque nao funciona a 13?	0	t	chat	\N	37	2026-02-12 01:09:02.423+00	2026-02-12 01:40:28.795+00	f	f	39	\N	1	\N	{"id":{"fromMe":false,"remote":"149061235691692@lid","id":"3EB09EB1BD37CD96DE02D6","_serialized":"false_149061235691692@lid_3EB09EB1BD37CD96DE02D6"},"type":"chat","timestamp":1769795052,"from":"149061235691692@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BFEF587AD78353A8B97	Como posso ajudar?	0	t	chat	\N	34	2026-02-12 01:06:59.908+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3BFEF587AD78353A8B97","_serialized":"false_141961671520277@lid_3BFEF587AD78353A8B97"},"type":"chat","timestamp":1769617930,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5AAFB6739AB0A6A955FCA5D78C8E373	‎Drogarias Big Master agradece seu contato. Como podemos ajudar?	0	t	chat	\N	33	2026-02-12 01:06:58.358+00	2026-02-12 01:40:32.296+00	f	f	35	\N	1	\N	{"id":{"fromMe":false,"remote":"12300903784497@lid","id":"A5AAFB6739AB0A6A955FCA5D78C8E373","_serialized":"false_12300903784497@lid_A5AAFB6739AB0A6A955FCA5D78C8E373"},"type":"chat","timestamp":1770066218,"from":"12300903784497@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919C20355956D16B2	Olá, Drogarias ‎Big Master agradece seu contato. Como podemos ajudar?	0	t	chat	\N	33	2026-02-12 01:06:58.622+00	2026-02-12 01:40:32.296+00	f	f	35	\N	1	\N	{"id":{"fromMe":false,"remote":"12300903784497@lid","id":"3EB00919C20355956D16B2","_serialized":"false_12300903784497@lid_3EB00919C20355956D16B2"},"type":"chat","timestamp":1770066895,"from":"12300903784497@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00219C203B3826E3CD7	O protocolo do seu atendimento é: 26020218141004049	0	t	chat	\N	33	2026-02-12 01:06:58.954+00	2026-02-12 01:40:32.296+00	f	f	35	\N	1	\N	{"id":{"fromMe":false,"remote":"12300903784497@lid","id":"3EB00219C203B3826E3CD7","_serialized":"false_12300903784497@lid_3EB00219C203B3826E3CD7"},"type":"chat","timestamp":1770067278,"from":"12300903784497@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C9BE7C107BF4ADD11DE237F54F024E	Da máquina que já vejo	3	t	chat	\N	3	2026-02-12 12:03:36.098+00	2026-02-12 12:04:09.788+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"2194761883822@lid","id":"A5C9BE7C107BF4ADD11DE237F54F024E","_serialized":"true_2194761883822@lid_A5C9BE7C107BF4ADD11DE237F54F024E"},"type":"chat","timestamp":1770897813,"from":"556592694840@c.us","to":"2194761883822@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0BDB7949E43643747C9	Só gostaria de alinhar contigo sobre os chamados pelo instagram	2	t	chat	\N	3	2026-02-12 01:07:02.342+00	2026-02-12 01:07:02.342+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB0BDB7949E43643747C9","_serialized":"true_141961671520277@lid_3EB0BDB7949E43643747C9"},"type":"chat","timestamp":1769619655,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DE838E830D328A3376	Laura, atualmente pelo instagram	2	t	chat	\N	3	2026-02-12 01:07:05.672+00	2026-02-12 01:07:05.672+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB0DE838E830D328A3376","_serialized":"true_141961671520277@lid_3EB0DE838E830D328A3376"},"type":"chat","timestamp":1769624971,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0479BB6059D9C8B1427	existe procuras de atendimento por lá?	2	t	chat	\N	3	2026-02-12 01:07:08.336+00	2026-02-12 01:07:08.336+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB0479BB6059D9C8B1427","_serialized":"true_141961671520277@lid_3EB0479BB6059D9C8B1427"},"type":"chat","timestamp":1769624979,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A60637CE247F1FA4B78	Leandro vai falar contigo	1	f	chat	\N	5	2026-02-12 12:04:12.611+00	2026-02-12 12:04:12.721+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A60637CE247F1FA4B78","_serialized":"false_74758267867267@lid_3A60637CE247F1FA4B78"},"type":"chat","timestamp":1770897851,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB00CC5C5FF7A880AC25B	Atualmente colocamos um ferreamenta de gerenciamento de whatsapp	2	t	chat	\N	3	2026-02-12 01:07:14.426+00	2026-02-12 01:07:14.426+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB00CC5C5FF7A880AC25B","_serialized":"true_141961671520277@lid_3EB00CC5C5FF7A880AC25B"},"type":"chat","timestamp":1769625231,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB096C25A9C2905000289	que consegui linkar com o instagram	2	t	chat	\N	3	2026-02-12 01:07:17.586+00	2026-02-12 01:07:17.586+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB096C25A9C2905000289","_serialized":"true_141961671520277@lid_3EB096C25A9C2905000289"},"type":"chat","timestamp":1769625239,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B530043BFE6A2A0292	que está vinculado ao facebook	2	t	chat	\N	3	2026-02-12 01:07:21.018+00	2026-02-12 01:07:21.018+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB0B530043BFE6A2A0292","_serialized":"true_141961671520277@lid_3EB0B530043BFE6A2A0292"},"type":"chat","timestamp":1769625247,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00EE12EF005209718F0	Queria saber se podemos colocar o numero la	2	t	chat	\N	3	2026-02-12 01:07:23.679+00	2026-02-12 01:07:23.679+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB00EE12EF005209718F0","_serialized":"true_141961671520277@lid_3EB00EE12EF005209718F0"},"type":"chat","timestamp":1769625503,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB097D15BC7E4F41E2E0B	para poder whatsapp	2	t	chat	\N	3	2026-02-12 01:07:25.723+00	2026-02-12 01:07:25.723+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB097D15BC7E4F41E2E0B","_serialized":"true_141961671520277@lid_3EB097D15BC7E4F41E2E0B"},"type":"chat","timestamp":1769625515,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07B5ADBCCC328B62393	Bom dia!	2	t	chat	\N	3	2026-02-12 01:07:28.525+00	2026-02-12 01:07:28.525+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"3EB07B5ADBCCC328B62393","_serialized":"true_141961671520277@lid_3EB07B5ADBCCC328B62393"},"type":"chat","timestamp":1769701236,"from":"151909402964196@lid","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A69631E33872D825DEA	Sim …	0	t	chat	\N	34	2026-02-12 01:07:08.788+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3A69631E33872D825DEA","_serialized":"false_141961671520277@lid_3A69631E33872D825DEA"},"type":"chat","timestamp":1769625186,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A4B41DAF07FDE3C0606	Ele tá mexendo	1	f	chat	\N	5	2026-02-12 12:04:15.529+00	2026-02-12 12:04:15.562+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A4B41DAF07FDE3C0606","_serialized":"false_74758267867267@lid_3A4B41DAF07FDE3C0606"},"type":"chat","timestamp":1770897854,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5D5AFE2BD382F68A1B26D61E33700B1	Ok	3	t	chat	\N	3	2026-02-12 12:04:03.114+00	2026-02-12 12:17:35.679+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"120363405293949287@g.us","id":"A5D5AFE2BD382F68A1B26D61E33700B1","participant":"151909402964196@lid","_serialized":"true_120363405293949287@g.us_A5D5AFE2BD382F68A1B26D61E33700B1_151909402964196@lid"},"type":"chat","timestamp":1770897839,"from":"151909402964196@lid","to":"120363405293949287@g.us","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A51BAADCF4C38D6BAE45137728C71A4E		2	t	audio	1770858451843-tg5fju.oga	3	2026-02-12 01:07:31.847+00	2026-02-12 01:07:31.847+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"141961671520277@lid","id":"A51BAADCF4C38D6BAE45137728C71A4E","_serialized":"true_141961671520277@lid_A51BAADCF4C38D6BAE45137728C71A4E"},"type":"ptt","timestamp":1770042622,"from":"556592694840@c.us","to":"141961671520277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"30","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACE1B30F1839F11446CED61895CDA03E	1890314718	1	f	chat	\N	48	2026-02-12 12:04:43.33+00	2026-02-12 12:04:43.35+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACE1B30F1839F11446CED61895CDA03E","_serialized":"false_2194761883822@lid_ACE1B30F1839F11446CED61895CDA03E"},"type":"chat","timestamp":1770897882,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A506BC4E9F8141E40E88F7802785823D	Ok	3	t	chat	\N	3	2026-02-12 01:07:41.906+00	2026-02-12 01:07:41.906+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A506BC4E9F8141E40E88F7802785823D","_serialized":"true_180599583166652@lid_A506BC4E9F8141E40E88F7802785823D"},"type":"chat","timestamp":1770041331,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5608FD6DC49F8436A9B5BC7D97E61CE	Então deixa que filtro por aqui mesmo	3	t	chat	\N	3	2026-02-12 01:07:43.343+00	2026-02-12 01:07:43.343+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A5608FD6DC49F8436A9B5BC7D97E61CE","_serialized":"true_180599583166652@lid_A5608FD6DC49F8436A9B5BC7D97E61CE"},"type":"chat","timestamp":1770041339,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D95E0759B164310A7B4D8F69C42D38	Olha vitamina entra no comércio	2	t	chat	\N	3	2026-02-12 12:04:25.085+00	2026-02-12 12:04:25.31+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A5D95E0759B164310A7B4D8F69C42D38","_serialized":"true_74758267867267@lid_A5D95E0759B164310A7B4D8F69C42D38"},"type":"chat","timestamp":1770897862,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A54F3834CC151AFA4B4EDE8BCF6E68FD	Ja estou falando com a Vetor	3	t	chat	\N	3	2026-02-12 01:07:44.997+00	2026-02-12 01:07:44.997+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A54F3834CC151AFA4B4EDE8BCF6E68FD","_serialized":"true_180599583166652@lid_A54F3834CC151AFA4B4EDE8BCF6E68FD"},"type":"chat","timestamp":1770041347,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A582E08683A7B3813C80FEF3DFFF9C94	Seria bom evitar	2	t	chat	\N	3	2026-02-12 12:04:29.125+00	2026-02-12 12:04:29.177+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"74758267867267@lid","id":"A582E08683A7B3813C80FEF3DFFF9C94","_serialized":"true_74758267867267@lid_A582E08683A7B3813C80FEF3DFFF9C94"},"type":"chat","timestamp":1770897866,"from":"556592694840@c.us","to":"74758267867267@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5BB67134F110CB63E0461D2DAC29582	Beleza	3	t	chat	\N	3	2026-02-12 01:07:47.32+00	2026-02-12 01:07:47.32+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A5BB67134F110CB63E0461D2DAC29582","_serialized":"true_180599583166652@lid_A5BB67134F110CB63E0461D2DAC29582"},"type":"chat","timestamp":1770041364,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A8A91B205FCB68BEDDC		4	t	audio	1770858449226-qgkhrs.oga	34	2026-02-12 01:07:29.23+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3A8A91B205FCB68BEDDC","_serialized":"false_141961671520277@lid_3A8A91B205FCB68BEDDC"},"type":"ptt","timestamp":1769711642,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"11","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA92574B717D56DB274		4	t	audio	1770858449689-5dxxa.oga	34	2026-02-12 01:07:29.702+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3AA92574B717D56DB274","_serialized":"false_141961671520277@lid_3AA92574B717D56DB274"},"type":"ptt","timestamp":1769711667,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"24","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B8109895747467B8FF6	Bom dia 🙂	0	t	chat	\N	34	2026-02-12 01:07:29.885+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3B8109895747467B8FF6","_serialized":"false_141961671520277@lid_3B8109895747467B8FF6"},"type":"chat","timestamp":1770041934,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B8892A026645EDF86D0	Tudo bem? Precisa de alguma ajuda com o Instagram da Big Master?	0	t	chat	\N	34	2026-02-12 01:07:30.077+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3B8892A026645EDF86D0","_serialized":"false_141961671520277@lid_3B8892A026645EDF86D0"},"type":"chat","timestamp":1770041956,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C84A64CBDD0ED3BF9EFC0374D45054	Momento que já conecto	3	t	chat	\N	3	2026-02-12 12:04:54.627+00	2026-02-12 12:04:54.756+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"2194761883822@lid","id":"A5C84A64CBDD0ED3BF9EFC0374D45054","_serialized":"true_2194761883822@lid_A5C84A64CBDD0ED3BF9EFC0374D45054"},"type":"chat","timestamp":1770897892,"from":"556592694840@c.us","to":"2194761883822@lid","author":"151909402964196@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5584454B57643ECCAF042F88E437920	Momento	3	t	chat	\N	3	2026-02-12 01:07:33.797+00	2026-02-12 01:07:33.797+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A5584454B57643ECCAF042F88E437920","_serialized":"true_180599583166652@lid_A5584454B57643ECCAF042F88E437920"},"type":"chat","timestamp":1770038082,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A54CF91479AB276F98A660EE904242A1	So pra me orientar	3	t	chat	\N	3	2026-02-12 01:07:36.56+00	2026-02-12 01:07:36.56+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A54CF91479AB276F98A660EE904242A1","_serialized":"true_180599583166652@lid_A54CF91479AB276F98A660EE904242A1"},"type":"chat","timestamp":1770041290,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5EDB044578FA79127223B3B7BE40051	Para não ficar assunto em dois pontos	3	t	chat	\N	3	2026-02-12 01:07:39.998+00	2026-02-12 01:07:39.998+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A5EDB044578FA79127223B3B7BE40051","_serialized":"true_180599583166652@lid_A5EDB044578FA79127223B3B7BE40051"},"type":"chat","timestamp":1770041307,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F72E67FB4A3ABAF470	ou seja com loja operando	3	t	chat	\N	3	2026-02-12 01:08:40.662+00	2026-02-12 01:08:40.662+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB0F72E67FB4A3ABAF470","_serialized":"true_149061235691692@lid_3EB0F72E67FB4A3ABAF470"},"type":"chat","timestamp":1769794655,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC6A80817A18DC1492F3D6F28069F706	Ok	1	f	chat	\N	48	2026-02-12 12:04:56.245+00	2026-02-12 12:04:56.274+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC6A80817A18DC1492F3D6F28069F706","_serialized":"false_2194761883822@lid_AC6A80817A18DC1492F3D6F28069F706"},"type":"chat","timestamp":1770897895,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5CCF582D787D03F5DEA895A00C1309D	Estou falando com pessoal da Vetor	3	t	chat	\N	3	2026-02-12 01:07:35.169+00	2026-02-12 01:07:35.169+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A5CCF582D787D03F5DEA895A00C1309D","_serialized":"true_180599583166652@lid_A5CCF582D787D03F5DEA895A00C1309D"},"type":"chat","timestamp":1770041254,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A55A517CB24D1F1118058B57E90622A6	Ja falou com o Lucas ou não?	3	t	chat	\N	3	2026-02-12 01:07:38.474+00	2026-02-12 01:07:38.474+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A55A517CB24D1F1118058B57E90622A6","_serialized":"true_180599583166652@lid_A55A517CB24D1F1118058B57E90622A6"},"type":"chat","timestamp":1770041299,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C9BF6A80C88CADCB82	tive que fazer a formatação novamente	3	t	chat	\N	3	2026-02-12 01:08:56.915+00	2026-02-12 01:08:56.915+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB0C9BF6A80C88CADCB82","_serialized":"true_149061235691692@lid_3EB0C9BF6A80C88CADCB82"},"type":"chat","timestamp":1769794795,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB013F3DA0023FB71E3D9	pq estava no 13	3	t	chat	\N	3	2026-02-12 01:09:02.043+00	2026-02-12 01:09:02.043+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB013F3DA0023FB71E3D9","_serialized":"true_149061235691692@lid_3EB013F3DA0023FB71E3D9"},"type":"chat","timestamp":1769794805,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07CA991300BA2A826BA	e colocar no debian no 12	3	t	chat	\N	3	2026-02-12 01:09:10.383+00	2026-02-12 01:09:10.383+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB07CA991300BA2A826BA","_serialized":"true_149061235691692@lid_3EB07CA991300BA2A826BA"},"type":"chat","timestamp":1769795075,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A72D1533B6A944B4E99	Tá bem	1	f	chat	\N	5	2026-02-12 12:05:09.772+00	2026-02-12 12:05:09.814+00	f	f	5	\N	1	\N	{"id":{"fromMe":false,"remote":"74758267867267@lid","id":"3A72D1533B6A944B4E99","_serialized":"false_74758267867267@lid_3A72D1533B6A944B4E99"},"type":"chat","timestamp":1770897909,"from":"74758267867267@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A58F3878FAFD8009FF6F98217305617A	Que boa atitude	3	t	chat	\N	3	2026-02-12 01:07:49.134+00	2026-02-12 01:07:49.134+00	t	f	3	AC0BC855BA8DFDFC9B50518DDAA326A0	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A58F3878FAFD8009FF6F98217305617A","_serialized":"true_180599583166652@lid_A58F3878FAFD8009FF6F98217305617A"},"type":"chat","timestamp":1770041369,"from":"556592694840@c.us","to":"180599583166652@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A54F3E3AD46017F679ED1CCAE7B07AB7	Isso	3	t	chat	\N	3	2026-02-12 01:07:51.199+00	2026-02-12 01:07:51.199+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A54F3E3AD46017F679ED1CCAE7B07AB7","_serialized":"true_180599583166652@lid_A54F3E3AD46017F679ED1CCAE7B07AB7"},"type":"chat","timestamp":1770041391,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D91B389B908360F2EDA51CD1A63C3E	Tá bom	3	t	chat	\N	3	2026-02-12 01:07:52.799+00	2026-02-12 01:07:52.799+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"180599583166652@lid","id":"A5D91B389B908360F2EDA51CD1A63C3E","_serialized":"true_180599583166652@lid_A5D91B389B908360F2EDA51CD1A63C3E"},"type":"chat","timestamp":1770041490,"from":"556592694840@c.us","to":"180599583166652@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5352EBA38F7798BE4FD5B0C00E5FBB8	Bom dia	1	f	chat	\N	11	2026-02-12 12:17:31.448+00	2026-02-12 12:17:31.496+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5352EBA38F7798BE4FD5B0C00E5FBB8","_serialized":"false_164703422648560@lid_A5352EBA38F7798BE4FD5B0C00E5FBB8"},"type":"chat","timestamp":1770898650,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB00185558BB4B7089422	vou pedir para ligar na loja	3	t	chat	\N	3	2026-02-12 01:07:55.772+00	2026-02-12 01:07:55.772+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB00185558BB4B7089422","_serialized":"true_113172539244633@lid_3EB00185558BB4B7089422"},"type":"chat","timestamp":1769614089,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB097F8EEC40C432BAB2C	fica atenta	3	t	chat	\N	3	2026-02-12 01:07:58.587+00	2026-02-12 01:07:58.587+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB097F8EEC40C432BAB2C","_serialized":"true_113172539244633@lid_3EB097F8EEC40C432BAB2C"},"type":"chat","timestamp":1769614093,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DE7D61533BB00B1AD1	igual ontem	3	t	chat	\N	3	2026-02-12 01:08:01.728+00	2026-02-12 01:08:01.728+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB0DE7D61533BB00B1AD1","_serialized":"true_113172539244633@lid_3EB0DE7D61533BB00B1AD1"},"type":"chat","timestamp":1769614095,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07136BD369B4CAD9F7B	que é o código	3	t	chat	\N	3	2026-02-12 01:08:04.459+00	2026-02-12 01:08:04.459+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB07136BD369B4CAD9F7B","_serialized":"true_113172539244633@lid_3EB07136BD369B4CAD9F7B"},"type":"chat","timestamp":1769614099,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB007F0F86E89DF7E740F	do whatsapp	3	t	chat	\N	3	2026-02-12 01:08:06.815+00	2026-02-12 01:08:06.815+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB007F0F86E89DF7E740F","_serialized":"true_113172539244633@lid_3EB007F0F86E89DF7E740F"},"type":"chat","timestamp":1769614103,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B1EACB12670CFA1263	verifica	3	t	chat	\N	3	2026-02-12 01:08:10.099+00	2026-02-12 01:08:10.099+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB0B1EACB12670CFA1263","_serialized":"true_113172539244633@lid_3EB0B1EACB12670CFA1263"},"type":"chat","timestamp":1769614157,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB9136627FF64DD324ED97FDD248CBF	De manhã  cedo	0	t	chat	\N	35	2026-02-12 01:07:49.339+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"ACB9136627FF64DD324ED97FDD248CBF","_serialized":"false_180599583166652@lid_ACB9136627FF64DD324ED97FDD248CBF"},"type":"chat","timestamp":1770041369,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACA870BEBF0022007C585818026AAE44	Na quele número  que você  me passou aquele dia	0	t	chat	\N	35	2026-02-12 01:07:49.581+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"ACA870BEBF0022007C585818026AAE44","_serialized":"false_180599583166652@lid_ACA870BEBF0022007C585818026AAE44"},"type":"chat","timestamp":1770041382,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A578A4812A2F5BD2A3B6ACC2ABB79CA6	E ai	1	f	chat	\N	11	2026-02-12 12:17:32.314+00	2026-02-12 12:17:32.332+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A578A4812A2F5BD2A3B6ACC2ABB79CA6","_serialized":"false_164703422648560@lid_A578A4812A2F5BD2A3B6ACC2ABB79CA6"},"type":"chat","timestamp":1770898651,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0AC277ADBC9BB55569E	pedi ligação	3	t	chat	\N	3	2026-02-12 01:08:13.258+00	2026-02-12 01:08:13.258+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"3EB0AC277ADBC9BB55569E","_serialized":"true_113172539244633@lid_3EB0AC277ADBC9BB55569E"},"type":"chat","timestamp":1769614160,"from":"151909402964196@lid","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52D956B5919454D639332B3C0B96E9C	Bom dia!	3	t	chat	\N	3	2026-02-12 01:08:15.082+00	2026-02-12 01:08:15.082+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"A52D956B5919454D639332B3C0B96E9C","_serialized":"true_113172539244633@lid_A52D956B5919454D639332B3C0B96E9C"},"type":"chat","timestamp":1770030152,"from":"556592694840@c.us","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52DFD68690F45C5BC78FDC45A7B7EDB	Tudo bem contigo?	3	t	chat	\N	3	2026-02-12 01:08:16.717+00	2026-02-12 01:08:16.717+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"A52DFD68690F45C5BC78FDC45A7B7EDB","_serialized":"true_113172539244633@lid_A52DFD68690F45C5BC78FDC45A7B7EDB"},"type":"chat","timestamp":1770030158,"from":"556592694840@c.us","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5891692AEC4FAA7DCBB33A404D5406C	Está na Sangri-la	3	t	chat	\N	3	2026-02-12 01:08:18.491+00	2026-02-12 01:08:18.491+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"A5891692AEC4FAA7DCBB33A404D5406C","_serialized":"true_113172539244633@lid_A5891692AEC4FAA7DCBB33A404D5406C"},"type":"chat","timestamp":1770030171,"from":"556592694840@c.us","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53DC25ECFCFC1DAD8BE5189EDB119D7	Acabei de ler	1	f	chat	\N	11	2026-02-12 12:18:54.47+00	2026-02-12 12:18:54.527+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A53DC25ECFCFC1DAD8BE5189EDB119D7","_serialized":"false_164703422648560@lid_A53DC25ECFCFC1DAD8BE5189EDB119D7"},"type":"chat","timestamp":1770898733,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A599AAB39FF9A10206F7F951CEBD17C0	Só BO	1	f	chat	\N	11	2026-02-12 12:18:57.846+00	2026-02-12 12:18:57.872+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A599AAB39FF9A10206F7F951CEBD17C0","_serialized":"false_164703422648560@lid_A599AAB39FF9A10206F7F951CEBD17C0"},"type":"chat","timestamp":1770898737,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5F731F26297F177E7696BB7528B050D	Ok	3	t	chat	\N	3	2026-02-12 01:08:20.839+00	2026-02-12 01:08:20.839+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"A5F731F26297F177E7696BB7528B050D","_serialized":"true_113172539244633@lid_A5F731F26297F177E7696BB7528B050D"},"type":"chat","timestamp":1770030207,"from":"556592694840@c.us","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A516ECCBF28633BAB7B010C19BFE6AB4	Vou pessoalmente lá falar com ele entao	3	t	chat	\N	3	2026-02-12 01:08:22.388+00	2026-02-12 01:08:22.388+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"A516ECCBF28633BAB7B010C19BFE6AB4","_serialized":"true_113172539244633@lid_A516ECCBF28633BAB7B010C19BFE6AB4"},"type":"chat","timestamp":1770030218,"from":"556592694840@c.us","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D5284282C2725A2930F954A15E8D81	Obrigado Daise	3	t	chat	\N	3	2026-02-12 01:08:23.551+00	2026-02-12 01:08:23.551+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"113172539244633@lid","id":"A5D5284282C2725A2930F954A15E8D81","_serialized":"true_113172539244633@lid_A5D5284282C2725A2930F954A15E8D81"},"type":"chat","timestamp":1770030224,"from":"556592694840@c.us","to":"113172539244633@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01ACF59F1932918B84B	Boa Tarde!	3	t	chat	\N	3	2026-02-12 01:08:27.343+00	2026-02-12 01:08:27.343+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB01ACF59F1932918B84B","_serialized":"true_149061235691692@lid_3EB01ACF59F1932918B84B"},"type":"chat","timestamp":1769794619,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06CEE7960627778D232	Cristiano, você tinha comentado que era 10 min a troca do servidor	3	t	chat	\N	3	2026-02-12 01:08:30.268+00	2026-02-12 01:08:30.268+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB06CEE7960627778D232","_serialized":"true_149061235691692@lid_3EB06CEE7960627778D232"},"type":"chat","timestamp":1769794631,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0D36110BED96FE83E10	mas o suporte falou que é 45 min	3	t	chat	\N	3	2026-02-12 01:08:33.11+00	2026-02-12 01:08:33.11+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB0D36110BED96FE83E10","_serialized":"true_149061235691692@lid_3EB0D36110BED96FE83E10"},"type":"chat","timestamp":1769794639,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05C9EEDE4DB3E3E702C	e só pode fazer entre 07 e 20:00	3	t	chat	\N	3	2026-02-12 01:08:36.651+00	2026-02-12 01:08:36.651+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB05C9EEDE4DB3E3E702C","_serialized":"true_149061235691692@lid_3EB05C9EEDE4DB3E3E702C"},"type":"chat","timestamp":1769794649,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC53C65D91FCE984EE1330ECD90732EC	Entendi	1	f	chat	\N	16	2026-02-12 12:20:35.224+00	2026-02-12 12:20:35.287+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC53C65D91FCE984EE1330ECD90732EC","_serialized":"false_131752601366700@lid_AC53C65D91FCE984EE1330ECD90732EC"},"type":"chat","timestamp":1770898834,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB00A9D141C216452D4EE	o rapaz falou que seria tudo de uma vez	3	t	chat	\N	3	2026-02-12 01:08:44.131+00	2026-02-12 01:08:44.131+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB00A9D141C216452D4EE","_serialized":"true_149061235691692@lid_3EB00A9D141C216452D4EE"},"type":"chat","timestamp":1769794671,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CEEDE2FF28DF9C3D1D	o scritp faz td	3	t	chat	\N	3	2026-02-12 01:08:47.506+00	2026-02-12 01:08:47.506+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB0CEEDE2FF28DF9C3D1D","_serialized":"true_149061235691692@lid_3EB0CEEDE2FF28DF9C3D1D"},"type":"chat","timestamp":1769794674,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB006FA21AF7A3C7FF6A9	então tem que alinhar isso com o suporte de vocês	3	t	chat	\N	3	2026-02-12 01:08:50.445+00	2026-02-12 01:08:50.445+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB006FA21AF7A3C7FF6A9","_serialized":"true_149061235691692@lid_3EB006FA21AF7A3C7FF6A9"},"type":"chat","timestamp":1769794781,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06A6D223A4AE54C3989	porque eu deixei pronto o debian	3	t	chat	\N	3	2026-02-12 01:08:53.858+00	2026-02-12 01:08:53.858+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"149061235691692@lid","id":"3EB06A6D223A4AE54C3989","_serialized":"true_149061235691692@lid_3EB06A6D223A4AE54C3989"},"type":"chat","timestamp":1769794789,"from":"151909402964196@lid","to":"149061235691692@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0277ACFC6870C9D6FB1	e sim, primeiro da carga dos dados	0	t	chat	\N	37	2026-02-12 01:08:41.16+00	2026-02-12 01:40:28.795+00	f	f	39	\N	1	\N	{"id":{"fromMe":false,"remote":"149061235691692@lid","id":"3EB0277ACFC6870C9D6FB1","_serialized":"false_149061235691692@lid_3EB0277ACFC6870C9D6FB1"},"type":"chat","timestamp":1769794659,"from":"149061235691692@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A9CFDE4558B2C54260	e depois troca	0	t	chat	\N	37	2026-02-12 01:08:41.377+00	2026-02-12 01:40:28.795+00	f	f	39	\N	1	\N	{"id":{"fromMe":false,"remote":"149061235691692@lid","id":"3EB0A9CFDE4558B2C54260","_serialized":"false_149061235691692@lid_3EB0A9CFDE4558B2C54260"},"type":"chat","timestamp":1769794660,"from":"149061235691692@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F756E77B1FEE2B26E2	quem esta falando com voce?	0	t	chat	\N	37	2026-02-12 01:08:41.592+00	2026-02-12 01:40:28.795+00	f	f	39	\N	1	\N	{"id":{"fromMe":false,"remote":"149061235691692@lid","id":"3EB0F756E77B1FEE2B26E2","_serialized":"false_149061235691692@lid_3EB0F756E77B1FEE2B26E2"},"type":"chat","timestamp":1769794668,"from":"149061235691692@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A598E3B603CBD0DF25	e antes de subir voce tem que configurar os daods de memoria	0	t	chat	\N	37	2026-02-12 01:08:47.859+00	2026-02-12 01:40:28.795+00	f	f	39	\N	1	\N	{"id":{"fromMe":false,"remote":"149061235691692@lid","id":"3EB0A598E3B603CBD0DF25","_serialized":"false_149061235691692@lid_3EB0A598E3B603CBD0DF25"},"type":"chat","timestamp":1769794766,"from":"149061235691692@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACE394B6C1C6BACE3127A5CE4A64088A	Eu vi	1	f	chat	\N	16	2026-02-12 12:24:09.328+00	2026-02-12 12:24:09.406+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACE394B6C1C6BACE3127A5CE4A64088A","_serialized":"false_131752601366700@lid_ACE394B6C1C6BACE3127A5CE4A64088A"},"type":"chat","timestamp":1770899048,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
ACFBEA532E5C99712162F605F06E05A6	Nesses casos qdo o cliente manda não teria um meio de bloquear?	1	f	chat	\N	16	2026-02-12 12:24:36.212+00	2026-02-12 12:24:36.228+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACFBEA532E5C99712162F605F06E05A6","_serialized":"false_131752601366700@lid_ACFBEA532E5C99712162F605F06E05A6"},"type":"chat","timestamp":1770899075,"from":"131752601366700@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0C336EDB96D802BC037	podemos tentar	2	t	chat	\N	3	2026-02-12 01:09:13.62+00	2026-02-12 01:09:13.62+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0C336EDB96D802BC037","_serialized":"true_134467272310884@lid_3EB0C336EDB96D802BC037"},"type":"chat","timestamp":1769521678,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB051D471B0157E4CFF36	qual o horário	2	t	chat	\N	3	2026-02-12 01:09:16.356+00	2026-02-12 01:09:16.356+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB051D471B0157E4CFF36","_serialized":"true_134467272310884@lid_3EB051D471B0157E4CFF36"},"type":"chat","timestamp":1769521680,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07881A9E63FC39F4E45	Gabriel	2	t	chat	\N	3	2026-02-12 01:09:19.863+00	2026-02-12 01:09:19.863+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB07881A9E63FC39F4E45","_serialized":"true_134467272310884@lid_3EB07881A9E63FC39F4E45"},"type":"chat","timestamp":1769539690,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B2D9D8F9113107EDC8	quem é responsável mesmo pelo Instagram?	2	t	chat	\N	3	2026-02-12 01:09:23.75+00	2026-02-12 01:09:23.75+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0B2D9D8F9113107EDC8","_serialized":"true_134467272310884@lid_3EB0B2D9D8F9113107EDC8"},"type":"chat","timestamp":1769539697,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02DEFC4574E22320AFD	Laura né?	2	t	chat	\N	3	2026-02-12 01:09:26.563+00	2026-02-12 01:09:26.563+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB02DEFC4574E22320AFD","_serialized":"true_134467272310884@lid_3EB02DEFC4574E22320AFD"},"type":"chat","timestamp":1769539701,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B0F277389E83E0A0DB	Bom dia!	2	t	chat	\N	3	2026-02-12 01:09:29.46+00	2026-02-12 01:09:29.46+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0B0F277389E83E0A0DB","_serialized":"true_134467272310884@lid_3EB0B0F277389E83E0A0DB"},"type":"chat","timestamp":1769610966,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06D3ED4C31D32CABE82	Gabriel	2	t	chat	\N	3	2026-02-12 01:09:32.482+00	2026-02-12 01:09:32.482+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB06D3ED4C31D32CABE82","_serialized":"true_134467272310884@lid_3EB06D3ED4C31D32CABE82"},"type":"chat","timestamp":1769610967,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F4841DB0AC97799332	Gabriel	2	t	chat	\N	3	2026-02-12 01:09:35.539+00	2026-02-12 01:09:35.539+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0F4841DB0AC97799332","_serialized":"true_134467272310884@lid_3EB0F4841DB0AC97799332"},"type":"chat","timestamp":1769610975,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A93DE4FFDB13168AFD7	Oi marcos	1	f	chat	\N	13	2026-02-12 12:32:25.642+00	2026-02-12 12:32:25.708+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A93DE4FFDB13168AFD7","_serialized":"false_58939920105695@lid_3A93DE4FFDB13168AFD7"},"type":"chat","timestamp":1770899544,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB047FB9ED8AEC732533E	pode me passar o contato da sua colega que atua com o Instagram?	2	t	chat	\N	3	2026-02-12 01:09:38.475+00	2026-02-12 01:09:38.475+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB047FB9ED8AEC732533E","_serialized":"true_134467272310884@lid_3EB047FB9ED8AEC732533E"},"type":"chat","timestamp":1769610989,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A56D8EAFAE40AB3BB05	Minha senha novamente	1	f	chat	\N	13	2026-02-12 12:32:28.31+00	2026-02-12 12:32:28.338+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A56D8EAFAE40AB3BB05","_serialized":"false_58939920105695@lid_3A56D8EAFAE40AB3BB05"},"type":"chat","timestamp":1770899547,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB01B223DB028970398F6	Obirgado	2	t	chat	\N	3	2026-02-12 01:09:41.719+00	2026-02-12 01:09:41.719+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB01B223DB028970398F6","_serialized":"true_134467272310884@lid_3EB01B223DB028970398F6"},"type":"chat","timestamp":1769613631,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0166D0E8C7E1FFBEF56	O facebook	2	t	chat	\N	3	2026-02-12 01:09:44.424+00	2026-02-12 01:09:44.424+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0166D0E8C7E1FFBEF56","_serialized":"true_134467272310884@lid_3EB0166D0E8C7E1FFBEF56"},"type":"chat","timestamp":1769613634,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AE17C01B7E607ADB6F0	Deu erro	1	f	chat	\N	13	2026-02-12 12:32:30.313+00	2026-02-12 12:32:30.335+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3AE17C01B7E607ADB6F0","_serialized":"false_58939920105695@lid_3AE17C01B7E607ADB6F0"},"type":"chat","timestamp":1770899549,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB036D5E24B39B8EE0964	eu necessito do usuário e senha mesmo do perfil	2	t	chat	\N	3	2026-02-12 01:09:47.032+00	2026-02-12 01:09:47.032+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB036D5E24B39B8EE0964","_serialized":"true_134467272310884@lid_3EB036D5E24B39B8EE0964"},"type":"chat","timestamp":1769613644,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04119C3A8EF355387D7	pq vou direcionar os direct do facebook para lá	2	t	chat	\N	3	2026-02-12 01:09:50.014+00	2026-02-12 01:09:50.014+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB04119C3A8EF355387D7","_serialized":"true_134467272310884@lid_3EB04119C3A8EF355387D7"},"type":"chat","timestamp":1769613656,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0981FC975635D25F631	retiro o que disse	2	t	chat	\N	3	2026-02-12 01:09:52.738+00	2026-02-12 01:09:52.738+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0981FC975635D25F631","_serialized":"true_134467272310884@lid_3EB0981FC975635D25F631"},"type":"chat","timestamp":1769614310,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB064D471149B3D1559C9	deu certo aqu i	2	t	chat	\N	3	2026-02-12 01:09:55.343+00	2026-02-12 01:09:55.343+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB064D471149B3D1559C9","_serialized":"true_134467272310884@lid_3EB064D471149B3D1559C9"},"type":"chat","timestamp":1769614312,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0AB023529AEA637F3FF	aqui!	2	t	chat	\N	3	2026-02-12 01:09:58.118+00	2026-02-12 01:09:58.118+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"134467272310884@lid","id":"3EB0AB023529AEA637F3FF","_serialized":"true_134467272310884@lid_3EB0AB023529AEA637F3FF"},"type":"chat","timestamp":1769614317,"from":"151909402964196@lid","to":"134467272310884@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5A353F2A5E956783CE570A29429F33F		0	t	chat	\N	3	2026-02-12 01:09:59.967+00	2026-02-12 01:09:59.967+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"A5A353F2A5E956783CE570A29429F33F","_serialized":"true_40562090635390@lid_A5A353F2A5E956783CE570A29429F33F"},"type":"e2e_notification","timestamp":1768337852,"from":"556592694840@c.us","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACCAEAD4FECB6AD5B39018E152B41DAD	Ai,Não  sei qual foi o retorno	0	t	chat	\N	35	2026-02-12 01:07:51.461+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"ACCAEAD4FECB6AD5B39018E152B41DAD","_serialized":"false_180599583166652@lid_ACCAEAD4FECB6AD5B39018E152B41DAD"},"type":"chat","timestamp":1770041406,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A51D1604BF9BE02ADB6E3E2048991E05	*PDF PARA ATENDENTE* https://drive.google.com/file/d/1ePJ8YqPibBkXwH2cKyiptrf1ezzduJYf/view?usp=sharing\n\n\n*TREINAMENTO NO YOUTUBE:* https://youtu.be/HsiqxyLl0d4\n\n*TREINAMENTO AO VIVO:* Segundas e Sextas ás 10 horas https://meet.google.com/tni-zpzn-uwb\nTerças e Quintas ás 15 horas https://meet.google.com/szq-fdya-jdf\n\n*(SEMPRE SEGUIMOS O HORÁRIO DE BRASÍLIA)*\n\n*Lembrando que temos uma tolerância de até 5 min, após esse período daremos inicio ao treinamento, se não houver ninguém na reunião está será encerrada*	3	t	chat	\N	3	2026-02-12 01:10:02.003+00	2026-02-12 01:10:02.003+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"A51D1604BF9BE02ADB6E3E2048991E05","_serialized":"true_40562090635390@lid_A51D1604BF9BE02ADB6E3E2048991E05"},"type":"chat","timestamp":1768337852,"from":"556592694840@c.us","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A57A4F51D7C7F99D81A89779C1F63D7B		2	t	audio	1770858608073-umefto.oga	3	2026-02-12 01:10:08.082+00	2026-02-12 01:10:08.082+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"A57A4F51D7C7F99D81A89779C1F63D7B","_serialized":"true_40562090635390@lid_A57A4F51D7C7F99D81A89779C1F63D7B"},"type":"ptt","timestamp":1768513414,"from":"556592694840@c.us","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"21","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5A0557CBF1800A2E6D46FC57B204B6D	Beleza	3	t	chat	\N	3	2026-02-12 01:10:12.111+00	2026-02-12 01:10:12.111+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"A5A0557CBF1800A2E6D46FC57B204B6D","_serialized":"true_40562090635390@lid_A5A0557CBF1800A2E6D46FC57B204B6D"},"type":"chat","timestamp":1768513565,"from":"556592694840@c.us","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A51B5E45A7BF74725F321424F543058B	Ele ainda está aberto ou encerrado?	3	t	chat	\N	3	2026-02-12 01:10:13.922+00	2026-02-12 01:10:13.922+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"A51B5E45A7BF74725F321424F543058B","_serialized":"true_40562090635390@lid_A51B5E45A7BF74725F321424F543058B"},"type":"chat","timestamp":1768513721,"from":"556592694840@c.us","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A4B0AF39E14B9D589B0	Consegue me ajudar ?	1	f	chat	\N	13	2026-02-12 12:32:33.65+00	2026-02-12 12:32:33.682+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A4B0AF39E14B9D589B0","_serialized":"false_58939920105695@lid_3A4B0AF39E14B9D589B0"},"type":"chat","timestamp":1770899553,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0BE67985B0149AD65DD	ok	3	t	chat	\N	3	2026-02-12 01:10:16.718+00	2026-02-12 01:10:16.718+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"3EB0BE67985B0149AD65DD","_serialized":"true_40562090635390@lid_3EB0BE67985B0149AD65DD"},"type":"chat","timestamp":1768513821,"from":"151909402964196@lid","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F6A27085C8BE230C36	reponde pelo aplicativo	3	t	chat	\N	3	2026-02-12 01:10:19.611+00	2026-02-12 01:10:19.611+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"3EB0F6A27085C8BE230C36","_serialized":"true_40562090635390@lid_3EB0F6A27085C8BE230C36"},"type":"chat","timestamp":1768513828,"from":"151909402964196@lid","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC86838ADCDEEF3D7E77D8399498F803	Ok	1	f	chat	\N	48	2026-02-12 12:33:43.054+00	2026-02-12 12:33:43.097+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC86838ADCDEEF3D7E77D8399498F803","_serialized":"false_2194761883822@lid_AC86838ADCDEEF3D7E77D8399498F803"},"type":"chat","timestamp":1770899622,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A5D0535313B3F6640BD34C4DE6B4545D	Qual a forma de pagamento?	0	t	chat	\N	39	2026-02-12 01:10:19.986+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A5D0535313B3F6640BD34C4DE6B4545D","_serialized":"false_40562090635390@lid_A5D0535313B3F6640BD34C4DE6B4545D"},"type":"chat","timestamp":1768513966,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC9A4897C3215D76A47CD7416CDAFB8D	Estava atendendo Keila que aceitou	1	f	chat	\N	48	2026-02-12 12:34:07.748+00	2026-02-12 12:34:07.804+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC9A4897C3215D76A47CD7416CDAFB8D","_serialized":"false_2194761883822@lid_AC9A4897C3215D76A47CD7416CDAFB8D"},"type":"chat","timestamp":1770899647,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC77ADC95AEA8C248E43F3DC2B685DC8	Agora que vi na tela aqui	1	f	chat	\N	48	2026-02-12 12:34:12.979+00	2026-02-12 12:34:13.008+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC77ADC95AEA8C248E43F3DC2B685DC8","_serialized":"false_2194761883822@lid_AC77ADC95AEA8C248E43F3DC2B685DC8"},"type":"chat","timestamp":1770899652,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0D6E0B55C23774E88DC	Vou colocar ela amanhã	3	t	chat	\N	3	2026-02-12 01:10:24.156+00	2026-02-12 01:10:24.156+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"3EB0D6E0B55C23774E88DC","_serialized":"true_40562090635390@lid_3EB0D6E0B55C23774E88DC"},"type":"chat","timestamp":1768516531,"from":"151909402964196@lid","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E60CA82D4C13E1A841	tem um acesso que eu não tenho no momento	3	t	chat	\N	3	2026-02-12 01:10:27.087+00	2026-02-12 01:10:27.087+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"3EB0E60CA82D4C13E1A841","_serialized":"true_40562090635390@lid_3EB0E60CA82D4C13E1A841"},"type":"chat","timestamp":1768516542,"from":"151909402964196@lid","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00ACCE7CA2C4C483EE5	tentei aqu ie não foi	3	t	chat	\N	3	2026-02-12 01:10:30.294+00	2026-02-12 01:10:30.294+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"40562090635390@lid","id":"3EB00ACCE7CA2C4C483EE5","_serialized":"true_40562090635390@lid_3EB00ACCE7CA2C4C483EE5"},"type":"chat","timestamp":1768516546,"from":"151909402964196@lid","to":"40562090635390@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC58B67B55D524B396FD9EE4D93646F4	Ok	1	f	chat	\N	48	2026-02-12 12:34:23.326+00	2026-02-12 12:34:23.36+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC58B67B55D524B396FD9EE4D93646F4","_serialized":"false_2194761883822@lid_AC58B67B55D524B396FD9EE4D93646F4"},"type":"chat","timestamp":1770899662,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0A6BDDB8C3E886E03A4	ok	3	t	chat	\N	3	2026-02-12 01:10:47.571+00	2026-02-12 01:10:47.571+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0A6BDDB8C3E886E03A4","_serialized":"true_189309424541837@lid_3EB0A6BDDB8C3E886E03A4"},"type":"chat","timestamp":1767988777,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B7B8BE1DDA2EAE7B4F	vejo com ela	3	t	chat	\N	3	2026-02-12 01:10:51.065+00	2026-02-12 01:10:51.065+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0B7B8BE1DDA2EAE7B4F","_serialized":"true_189309424541837@lid_3EB0B7B8BE1DDA2EAE7B4F"},"type":"chat","timestamp":1767988779,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB067874AD560B2F35FC8	Obrigado	3	t	chat	\N	3	2026-02-12 01:10:55.607+00	2026-02-12 01:10:55.607+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB067874AD560B2F35FC8","_serialized":"true_189309424541837@lid_3EB067874AD560B2F35FC8"},"type":"chat","timestamp":1767988781,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5C9BD0037BAEAD825C4B72A40F3D716	Me informa o endereço digitado, rua, quadra, casa e uma referência que facilite para o entregador.	0	t	chat	\N	39	2026-02-12 01:10:20.281+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A5C9BD0037BAEAD825C4B72A40F3D716","_serialized":"false_40562090635390@lid_A5C9BD0037BAEAD825C4B72A40F3D716"},"type":"chat","timestamp":1768513966,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACADB04D573D7C4B5AB0FE07DE41F9E6	Beleza entendi	1	f	chat	\N	48	2026-02-12 12:34:33.682+00	2026-02-12 12:34:33.711+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACADB04D573D7C4B5AB0FE07DE41F9E6","_serialized":"false_2194761883822@lid_ACADB04D573D7C4B5AB0FE07DE41F9E6"},"type":"chat","timestamp":1770899673,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0825245A1A4A3D3A76D	Rodrigo, Bom dia ai.\nO assunto é sobre o VOIP da Fernando Correa...\n\nO Voip hoje está,  L5 e não com a Rise e como vimos o princípio das ligações e integração com o nosso próprio VOIP no Whatsapp oficial, o correto seria efetuar a mudança com a o VOIP da Rise que está alinhada com o Único para isso.\nOutro ponto é o custo de VOIP com a Rise que passaria a ser R$15,00 reais a mais( arredondando) ao contrário da L5 que o custo mais elevado.\n\nGostaria de saber se posso tomar as providências quanto a migração do VOIP da Fernando Correa pra deixar com a Rise?\nNão perderemos o número e só vou levantar o tempo de indisponibilidade e se houver com a migração	3	t	chat	\N	3	2026-02-12 01:11:02.771+00	2026-02-12 01:11:02.771+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0825245A1A4A3D3A76D","_serialized":"true_189309424541837@lid_3EB0825245A1A4A3D3A76D"},"type":"chat","timestamp":1768248380,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC460E25BEB68370D485F2D329E4D17B	O áudio saiu sem som	1	f	chat	\N	48	2026-02-12 12:38:34.314+00	2026-02-12 12:38:34.395+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC460E25BEB68370D485F2D329E4D17B","_serialized":"false_2194761883822@lid_AC460E25BEB68370D485F2D329E4D17B"},"type":"chat","timestamp":1770899913,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0CA330EA30A5F63D0A1	Sim, amanhã de manhão já vejo com a empresa responsável	3	t	chat	\N	3	2026-02-12 01:11:08.442+00	2026-02-12 01:11:08.442+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0CA330EA30A5F63D0A1","_serialized":"true_189309424541837@lid_3EB0CA330EA30A5F63D0A1"},"type":"chat","timestamp":1768253258,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A599063E7C0183A4BBF62862913B8DD2	Bom dia!	3	t	chat	\N	3	2026-02-12 01:11:10.118+00	2026-02-12 01:11:10.118+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"A599063E7C0183A4BBF62862913B8DD2","_serialized":"true_189309424541837@lid_A599063E7C0183A4BBF62862913B8DD2"},"type":"chat","timestamp":1768348162,"from":"556592694840@c.us","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5BB1E86DC8EF757DE049EFBA41F548B	Estamos no grupo	3	t	chat	\N	3	2026-02-12 01:11:12.183+00	2026-02-12 01:11:12.183+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"A5BB1E86DC8EF757DE049EFBA41F548B","_serialized":"true_189309424541837@lid_A5BB1E86DC8EF757DE049EFBA41F548B"},"type":"chat","timestamp":1768348171,"from":"556592694840@c.us","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0D4563DC61D6A8DD9D2	Desocupar me avisa	3	t	chat	\N	3	2026-02-12 01:11:16.064+00	2026-02-12 01:11:16.064+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0D4563DC61D6A8DD9D2","_serialized":"true_189309424541837@lid_3EB0D4563DC61D6A8DD9D2"},"type":"chat","timestamp":1769112070,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09283D5EC440A85FA8A	preciso passar uma situação para você	3	t	chat	\N	3	2026-02-12 01:11:19.087+00	2026-02-12 01:11:19.087+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB09283D5EC440A85FA8A","_serialized":"true_189309424541837@lid_3EB09283D5EC440A85FA8A"},"type":"chat","timestamp":1769112076,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0017DD6E9D43C555BAB	da Único	3	t	chat	\N	3	2026-02-12 01:11:22.071+00	2026-02-12 01:11:22.071+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0017DD6E9D43C555BAB","_serialized":"true_189309424541837@lid_3EB0017DD6E9D43C555BAB"},"type":"chat","timestamp":1769112081,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC39392C09BF16CEC1D81E9B92B89B27	Mandei uma mensagem para eu mesmo por áudio mas veio sem som	1	f	chat	\N	48	2026-02-12 12:38:44.246+00	2026-02-12 12:38:44.287+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC39392C09BF16CEC1D81E9B92B89B27","_serialized":"false_2194761883822@lid_AC39392C09BF16CEC1D81E9B92B89B27"},"type":"chat","timestamp":1770899923,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0943AD4D05402D5B99C	Bom dia!	3	t	chat	\N	3	2026-02-12 01:11:29.299+00	2026-02-12 01:11:29.299+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0943AD4D05402D5B99C","_serialized":"true_189309424541837@lid_3EB0943AD4D05402D5B99C"},"type":"chat","timestamp":1769178995,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F4860E53FBF4A28B10	Em Cuiabá ou Viajou?	3	t	chat	\N	3	2026-02-12 01:11:33.446+00	2026-02-12 01:11:33.446+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB0F4860E53FBF4A28B10","_serialized":"true_189309424541837@lid_3EB0F4860E53FBF4A28B10"},"type":"chat","timestamp":1769179002,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01A97992C98F8540065	Rodrigo, quando puder falar sobre os cadastros que comentei ontem, me chame	3	t	chat	\N	3	2026-02-12 01:11:36.777+00	2026-02-12 01:11:36.777+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB01A97992C98F8540065","_serialized":"true_189309424541837@lid_3EB01A97992C98F8540065"},"type":"chat","timestamp":1769524063,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB074F113637816323548	por gentileza	3	t	chat	\N	3	2026-02-12 01:11:40.163+00	2026-02-12 01:11:40.163+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"189309424541837@lid","id":"3EB074F113637816323548","_serialized":"true_189309424541837@lid_3EB074F113637816323548"},"type":"chat","timestamp":1769524065,"from":"151909402964196@lid","to":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A50C72E8E5781E1774A14309BF2061A8		0	t	chat	\N	3	2026-02-12 01:11:43.607+00	2026-02-12 01:11:43.607+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"112974886891537@lid","id":"A50C72E8E5781E1774A14309BF2061A8","_serialized":"true_112974886891537@lid_A50C72E8E5781E1774A14309BF2061A8"},"type":"e2e_notification","timestamp":1769094242,"from":"556592694840@c.us","to":"112974886891537@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F32A04BCB7EA53B5BDEDBBFBC96F8D	Teste	3	t	chat	\N	3	2026-02-12 01:11:45.233+00	2026-02-12 01:11:45.233+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"112974886891537@lid","id":"A5F32A04BCB7EA53B5BDEDBBFBC96F8D","_serialized":"true_112974886891537@lid_A5F32A04BCB7EA53B5BDEDBBFBC96F8D"},"type":"chat","timestamp":1769094242,"from":"556592694840@c.us","to":"112974886891537@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACDEA1F7DEB9903060B66A8ED33578A0	992657409	1	f	chat	\N	48	2026-02-12 12:39:41.525+00	2026-02-12 12:39:41.579+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACDEA1F7DEB9903060B66A8ED33578A0","_serialized":"false_2194761883822@lid_ACDEA1F7DEB9903060B66A8ED33578A0"},"type":"chat","timestamp":1770899981,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC03D4BBE6F8886DF105DCCC96B8D3AE	Não caiu para nenhum ainda	1	f	chat	\N	48	2026-02-12 12:41:56.13+00	2026-02-12 12:41:56.181+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC03D4BBE6F8886DF105DCCC96B8D3AE","_serialized":"false_2194761883822@lid_AC03D4BBE6F8886DF105DCCC96B8D3AE"},"type":"chat","timestamp":1770900115,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB00419BE63BEB24E8455	Olá, Drogarias ‎Big Master agradece seu contato. Como podemos ajudar?	0	t	chat	\N	41	2026-02-12 01:11:45.585+00	2026-02-12 01:40:25.038+00	f	f	42	\N	1	\N	{"id":{"fromMe":false,"remote":"112974886891537@lid","id":"3EB00419BE63BEB24E8455","_serialized":"false_112974886891537@lid_3EB00419BE63BEB24E8455"},"type":"chat","timestamp":1769094246,"from":"112974886891537@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919BE63C233C3D95C	O protocolo do seu atendimento é: 26012212041001533	0	t	chat	\N	41	2026-02-12 01:11:45.846+00	2026-02-12 01:40:25.038+00	f	f	42	\N	1	\N	{"id":{"fromMe":false,"remote":"112974886891537@lid","id":"3EB00919BE63C233C3D95C","_serialized":"false_112974886891537@lid_3EB00919BE63C233C3D95C"},"type":"chat","timestamp":1769094260,"from":"112974886891537@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00819BE63C2331F5A88	*LJFER01:*\nAgradecemos seu contato, e estaremos sempre à disposição.😉	0	t	chat	\N	41	2026-02-12 01:11:46.106+00	2026-02-12 01:40:25.038+00	f	f	42	\N	1	\N	{"id":{"fromMe":false,"remote":"112974886891537@lid","id":"3EB00819BE63C2331F5A88","_serialized":"false_112974886891537@lid_3EB00819BE63C2331F5A88"},"type":"chat","timestamp":1769094262,"from":"112974886891537@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BF9CA9845ACF6AA4EB3	Viajei!	0	t	chat	\N	40	2026-02-12 01:11:34.222+00	2026-02-12 01:40:26.356+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"189309424541837@lid","id":"3BF9CA9845ACF6AA4EB3","_serialized":"false_189309424541837@lid_3BF9CA9845ACF6AA4EB3"},"type":"chat","timestamp":1769179621,"from":"189309424541837@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A87C01CDBB1374CA198		0	t	audio	1770858718329-142a9s.oga	42	2026-02-12 01:11:58.333+00	2026-02-12 01:40:23.803+00	f	f	45	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A87C01CDBB1374CA198","participant":{"server":"lid","user":"185439524798613","_serialized":"185439524798613@lid"},"_serialized":"false_120363425670397095@g.us_3A87C01CDBB1374CA198_185439524798613@lid"},"type":"ptt","timestamp":1768524890,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"185439524798613@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"2","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00719C51DD89649FEE4	Olá, Drogarias ‎Big Master agradece seu contato. Como podemos ajudar?	1	f	chat	\N	25	2026-02-12 12:40:01.617+00	2026-02-12 12:40:01.675+00	f	f	28	\N	1	\N	{"id":{"fromMe":false,"remote":"46733589512194@lid","id":"3EB00719C51DD89649FEE4","_serialized":"false_46733589512194@lid_3EB00719C51DD89649FEE4"},"type":"chat","timestamp":1770900000,"from":"46733589512194@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC2380867C7020E7622AC327B99F33F7	Não chegou ainda	1	f	chat	\N	48	2026-02-12 12:40:49.6+00	2026-02-12 12:40:49.651+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC2380867C7020E7622AC327B99F33F7","_serialized":"false_2194761883822@lid_AC2380867C7020E7622AC327B99F33F7"},"type":"chat","timestamp":1770900048,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0C6BBD2F8406FBFE85E	ok	3	t	chat	\N	3	2026-02-12 01:15:45.018+00	2026-02-12 01:15:45.018+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"144517244166226@lid","id":"3EB0C6BBD2F8406FBFE85E","_serialized":"true_144517244166226@lid_3EB0C6BBD2F8406FBFE85E"},"type":"chat","timestamp":1769013273,"from":"151909402964196@lid","to":"144517244166226@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5DEDFE4D5B24C0AE96769C9A3023740		4	f	audio	1770900157735-suy3v.oga	11	2026-02-12 12:42:37.746+00	2026-02-12 12:42:43.058+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5DEDFE4D5B24C0AE96769C9A3023740","_serialized":"false_164703422648560@lid_A5DEDFE4D5B24C0AE96769C9A3023740"},"type":"ptt","timestamp":1770900156,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"8","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0E8CBDC5960D5C1B1B9	Aceito!	3	t	chat	\N	3	2026-02-12 01:15:54.005+00	2026-02-12 01:15:54.005+00	t	f	3	B6F8F7B3240B165901	1	\N	{"id":{"fromMe":true,"remote":"144517244166226@lid","id":"3EB0E8CBDC5960D5C1B1B9","_serialized":"true_144517244166226@lid_3EB0E8CBDC5960D5C1B1B9"},"type":"template_button_reply","timestamp":1769014211,"from":"151909402964196@lid","to":"144517244166226@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A37B31B5C9CBE428A09	Iae gurizada bora bora	0	t	chat	\N	42	2026-02-12 01:15:19.074+00	2026-02-12 01:40:23.803+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A37B31B5C9CBE428A09","participant":{"server":"lid","user":"125271831228508","_serialized":"125271831228508@lid"},"_serialized":"false_120363425670397095@g.us_3A37B31B5C9CBE428A09_125271831228508@lid"},"type":"chat","timestamp":1769017983,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A32244E30BFABED6C39	Quinta agora ?	0	t	chat	\N	42	2026-02-12 01:15:19.354+00	2026-02-12 01:40:23.803+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A32244E30BFABED6C39","participant":{"server":"lid","user":"125271831228508","_serialized":"125271831228508@lid"},"_serialized":"false_120363425670397095@g.us_3A32244E30BFABED6C39_125271831228508@lid"},"type":"chat","timestamp":1769017987,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACA538FCEB962C4F45B3D34DE3459607		0	t	sticker	1770858923371-nj8pts.webp	42	2026-02-12 01:15:23.379+00	2026-02-12 01:40:23.803+00	f	f	47	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"ACA538FCEB962C4F45B3D34DE3459607","participant":{"server":"lid","user":"167186349965479","_serialized":"167186349965479@lid"},"_serialized":"false_120363425670397095@g.us_ACA538FCEB962C4F45B3D34DE3459607_167186349965479@lid"},"type":"sticker","timestamp":1769018021,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"167186349965479@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A369BB8E440DD9E5198	Cadê os gurizada???	0	t	chat	\N	42	2026-02-12 01:15:27.322+00	2026-02-12 01:40:23.803+00	f	f	49	3A32244E30BFABED6C39	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A369BB8E440DD9E5198","participant":{"server":"lid","user":"249602208973051","_serialized":"249602208973051@lid"},"_serialized":"false_120363425670397095@g.us_3A369BB8E440DD9E5198_249602208973051@lid"},"type":"chat","timestamp":1769091849,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"249602208973051@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A4C10BA084E5299E621	Povo tá enrolado kkkk	0	t	chat	\N	42	2026-02-12 01:15:27.55+00	2026-02-12 01:40:23.803+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A4C10BA084E5299E621","participant":{"server":"lid","user":"125271831228508","_serialized":"125271831228508@lid"},"_serialized":"false_120363425670397095@g.us_3A4C10BA084E5299E621_125271831228508@lid"},"type":"chat","timestamp":1769092039,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08EC6680A8C0B119C94	CNH-e.pdf.pdf	3	t	document	1770858957507-8oe3n.pdf	3	2026-02-12 01:15:57.513+00	2026-02-12 01:15:57.513+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"144517244166226@lid","id":"3EB08EC6680A8C0B119C94","_serialized":"true_144517244166226@lid_3EB08EC6680A8C0B119C94"},"type":"document","timestamp":1769016034,"from":"151909402964196@lid","to":"144517244166226@lid","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04AB475A01A0A98E0F1		3	t	image	1770858961761-gotdu.jpeg	3	2026-02-12 01:16:01.771+00	2026-02-12 01:16:01.771+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"144517244166226@lid","id":"3EB04AB475A01A0A98E0F1","_serialized":"true_144517244166226@lid_3EB04AB475A01A0A98E0F1"},"type":"image","timestamp":1769016070,"from":"151909402964196@lid","to":"144517244166226@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00019C51E17D885A433		1	f	audio	1770900261095-l3doi.oga	25	2026-02-12 12:44:21.108+00	2026-02-12 12:44:21.165+00	f	f	28	\N	1	\N	{"id":{"fromMe":false,"remote":"46733589512194@lid","id":"3EB00019C51E17D885A433","_serialized":"false_46733589512194@lid_3EB00019C51E17D885A433"},"type":"audio","timestamp":1770900259,"from":"46733589512194@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"11","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0D9E11E83B9E93502F4	necessita do Lucas também?w	3	t	chat	\N	3	2026-02-12 01:16:05.063+00	2026-02-12 01:16:05.063+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"144517244166226@lid","id":"3EB0D9E11E83B9E93502F4","_serialized":"true_144517244166226@lid_3EB0D9E11E83B9E93502F4"},"type":"chat","timestamp":1769016414,"from":"151909402964196@lid","to":"144517244166226@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5BEF8A6A594F06A7754C59442B3ADBC		4	f	audio	1770900282471-tlbc3.oga	11	2026-02-12 12:44:42.483+00	2026-02-12 12:44:42.651+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5BEF8A6A594F06A7754C59442B3ADBC","_serialized":"false_164703422648560@lid_A5BEF8A6A594F06A7754C59442B3ADBC"},"type":"ptt","timestamp":1770900281,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"12","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0FE8F9805F7F4D6E823	ok	3	t	chat	\N	3	2026-02-12 01:16:09.861+00	2026-02-12 01:16:09.861+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"144517244166226@lid","id":"3EB0FE8F9805F7F4D6E823","_serialized":"true_144517244166226@lid_3EB0FE8F9805F7F4D6E823"},"type":"chat","timestamp":1769016510,"from":"151909402964196@lid","to":"144517244166226@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EACB4B54B0F52A59EF	os audios que conversei com ela	3	t	chat	\N	3	2026-02-12 01:16:14.865+00	2026-02-12 01:16:14.865+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"161787341209830@lid","id":"3EB0EACB4B54B0F52A59EF","_serialized":"true_161787341209830@lid_3EB0EACB4B54B0F52A59EF"},"type":"chat","timestamp":1768938469,"from":"151909402964196@lid","to":"161787341209830@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01745FDAC9F8B7686D6	não	2	t	chat	\N	3	2026-02-12 01:16:18.648+00	2026-02-12 01:16:18.648+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB01745FDAC9F8B7686D6","_serialized":"true_11407449915544@lid_3EB01745FDAC9F8B7686D6"},"type":"chat","timestamp":1768847673,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB005984DD9A1CB50334B	no momento não	2	t	chat	\N	3	2026-02-12 01:16:22.341+00	2026-02-12 01:16:22.341+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB005984DD9A1CB50334B","_serialized":"true_11407449915544@lid_3EB005984DD9A1CB50334B"},"type":"chat","timestamp":1768847676,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB027AA9ED2E151D1D2C2	mas eu quero para o CNPJ separado	2	t	chat	\N	3	2026-02-12 01:16:25.149+00	2026-02-12 01:16:25.149+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB027AA9ED2E151D1D2C2","_serialized":"true_11407449915544@lid_3EB027AA9ED2E151D1D2C2"},"type":"chat","timestamp":1768847684,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0553F319C791FDB5962	Estarei te enviando como funciona e os valores.	0	f	chat	\N	44	2026-02-12 01:16:25.997+00	2026-02-12 01:16:25.997+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB0553F319C791FDB5962","_serialized":"false_11407449915544@lid_3EB0553F319C791FDB5962"},"type":"chat","timestamp":1768847689,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB086FD1D1CA333221388	ok	2	t	chat	\N	3	2026-02-12 01:16:28.76+00	2026-02-12 01:16:28.76+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB086FD1D1CA333221388","_serialized":"true_11407449915544@lid_3EB086FD1D1CA333221388"},"type":"chat","timestamp":1768847694,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BDB513112028C812A2	🔰*Seja Bem - vindo (a) a NaveNet!*🔰\n\n👇🏻*COMO FUNCIONA:*👇🏻\n\n✅ *Atendimento Exclusivo Empresarial;*\n✅ *Instalação R$300,00 faz em ate 3x no boleto (1+2);*\n✅ *Equipamentos em comodato, emprestados pela empresa;*\n✅ *Fidelidade de 1 ano;*\n✅ *3 MESES GRATUITOS DA MENSALIDADE DA INTERNET;*\n✅ *Prazo para instalação: de até 3 dias, após assinatura do contrato.*\n✅ *APP para auto atendimento;*\n✅ *Mensalidade Fixa;*\n🚗 *Suporte Técnico: De segunda a domingo, feriados, com o prazo de ate 24 horas;*🤳🏻\n\n🛜 *PLANO:*\n\n*700 MB* ➡️ *139,90*\n*900 MB* ➡️ *179,90*\n*1 GB* ➡️ *229,90*\n\n😎 *Qualquer duvida estou a disposição.*😎	0	f	chat	\N	44	2026-02-12 01:16:29.343+00	2026-02-12 01:16:29.343+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB0BDB513112028C812A2","_serialized":"false_11407449915544@lid_3EB0BDB513112028C812A2"},"type":"chat","timestamp":1768847854,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08964A6AE16026C9EFA	Hoje estamos com uma promoção de ate 3 meses gratuitos.	0	f	chat	\N	44	2026-02-12 01:16:29.656+00	2026-02-12 01:16:29.656+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB08964A6AE16026C9EFA","_serialized":"false_11407449915544@lid_3EB08964A6AE16026C9EFA"},"type":"chat","timestamp":1768847884,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09C6F563736EE79A0E7	humm	2	t	chat	\N	3	2026-02-12 01:16:32.845+00	2026-02-12 01:16:32.845+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB09C6F563736EE79A0E7","_serialized":"true_11407449915544@lid_3EB09C6F563736EE79A0E7"},"type":"chat","timestamp":1768847925,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01993F6F8CC14A59E4C	muito bom	2	t	chat	\N	3	2026-02-12 01:16:35.928+00	2026-02-12 01:16:35.928+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB01993F6F8CC14A59E4C","_serialized":"true_11407449915544@lid_3EB01993F6F8CC14A59E4C"},"type":"chat","timestamp":1768847927,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01450AD553E6FB785A2		0	f	chat	\N	44	2026-02-12 01:16:36.618+00	2026-02-12 01:16:36.618+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB01450AD553E6FB785A2","_serialized":"false_11407449915544@lid_3EB01450AD553E6FB785A2"},"type":"revoked","timestamp":1768847953,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DF7B0FC44B705F76D1		0	f	chat	\N	44	2026-02-12 01:16:36.894+00	2026-02-12 01:16:36.894+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB0DF7B0FC44B705F76D1","_serialized":"false_11407449915544@lid_3EB0DF7B0FC44B705F76D1"},"type":"revoked","timestamp":1768847967,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACA85ED2C8381A2CC416CA8AF430C2BE		1	f	audio	1770900274325-vrp8om.oga	48	2026-02-12 12:44:34.33+00	2026-02-12 12:44:34.403+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACA85ED2C8381A2CC416CA8AF430C2BE","_serialized":"false_2194761883822@lid_ACA85ED2C8381A2CC416CA8AF430C2BE"},"type":"ptt","timestamp":1770900273,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"4","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0EAEFB8CDF25618E745	32.864.855/0005-80	2	t	chat	\N	3	2026-02-12 01:16:40.224+00	2026-02-12 01:16:40.224+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB0EAEFB8CDF25618E745","_serialized":"true_11407449915544@lid_3EB0EAEFB8CDF25618E745"},"type":"chat","timestamp":1768848038,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB006799CDF227EF6B931	Preciso dos seguintes dados para fazer seu pedido:\n- CNPJ\n- Contrato Social\n- Foto RG ( frente e verso) ou CNH ( aberta)\n- E - mail\n- Endereço completo ( CEP, rua, bairro, número)\n- 02 telefones para contato.\n- Plano\n- Vencimento: 05 / 10 / 15 / 25\n- Nome do estabelecimento	0	f	chat	\N	44	2026-02-12 01:16:40.73+00	2026-02-12 01:16:40.73+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB006799CDF227EF6B931","_serialized":"false_11407449915544@lid_3EB006799CDF227EF6B931"},"type":"chat","timestamp":1768848064,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05C84EE5C265AFA0DE0	Conseguiu os dados para fazer o pedido ?	0	f	chat	\N	44	2026-02-12 01:16:41.033+00	2026-02-12 01:16:41.033+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB05C84EE5C265AFA0DE0","_serialized":"false_11407449915544@lid_3EB05C84EE5C265AFA0DE0"},"type":"chat","timestamp":1768855502,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BBEEF7EEC47A2D4047	Essa promoção só é valido para hoje.	0	f	chat	\N	44	2026-02-12 01:16:41.382+00	2026-02-12 01:16:41.382+00	f	f	51	3EB08964A6AE16026C9EFA	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB0BBEEF7EEC47A2D4047","_serialized":"false_11407449915544@lid_3EB0BBEEF7EEC47A2D4047"},"type":"chat","timestamp":1768855523,"from":"11407449915544@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09D2519703552644ED5	eu só consigo a resposta amanhã para tomada de decisão	2	t	chat	\N	3	2026-02-12 01:16:44.919+00	2026-02-12 01:16:44.919+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB09D2519703552644ED5","_serialized":"true_11407449915544@lid_3EB09D2519703552644ED5"},"type":"chat","timestamp":1768855619,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09F9C78F2F4ADF7417A	os diretores não estão disponíveis hoje	2	t	chat	\N	3	2026-02-12 01:16:48.464+00	2026-02-12 01:16:48.464+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"11407449915544@lid","id":"3EB09F9C78F2F4ADF7417A","_serialized":"true_11407449915544@lid_3EB09F9C78F2F4ADF7417A"},"type":"chat","timestamp":1768855626,"from":"151909402964196@lid","to":"11407449915544@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B31DAB9A5BFE956AB2	Bom dia. Tudo bem ?	0	f	chat	\N	44	2026-02-12 01:16:49.739+00	2026-02-12 01:16:49.739+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB0B31DAB9A5BFE956AB2","_serialized":"false_11407449915544@lid_3EB0B31DAB9A5BFE956AB2"},"type":"chat","timestamp":1768922576,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB07A0A6EFE37F6D81B16	Em relação a contratação vamos dar andamento ?	0	f	chat	\N	44	2026-02-12 01:16:50.078+00	2026-02-12 01:16:50.078+00	f	f	51	\N	1	\N	{"id":{"fromMe":false,"remote":"11407449915544@lid","id":"3EB07A0A6EFE37F6D81B16","_serialized":"false_11407449915544@lid_3EB07A0A6EFE37F6D81B16"},"type":"chat","timestamp":1768922588,"from":"11407449915544@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FD19E3EA39E88CCAEE	e para lhe garantir	3	t	chat	\N	3	2026-02-12 01:16:53.809+00	2026-02-12 01:16:53.809+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB0FD19E3EA39E88CCAEE","_serialized":"true_73903821091006@lid_3EB0FD19E3EA39E88CCAEE"},"type":"chat","timestamp":1768848935,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02BB5D9A9A9B38128CB	já decidimos pela Onhere	3	t	chat	\N	3	2026-02-12 01:16:58.446+00	2026-02-12 01:16:58.446+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB02BB5D9A9A9B38128CB","_serialized":"true_73903821091006@lid_3EB02BB5D9A9A9B38128CB"},"type":"chat","timestamp":1768848942,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A50520580ADA065AA88F9AC96585038D		3	t	image	1770857012784-f0kc.jpeg	3	2026-02-12 00:43:32.795+00	2026-02-12 01:17:26.773+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"A50520580ADA065AA88F9AC96585038D","_serialized":"true_7202811162779@lid_A50520580ADA065AA88F9AC96585038D"},"type":"image","timestamp":1770857008,"from":"556592694840@c.us","to":"7202811162779@lid","author":"151909402964196@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05273029985B8F797F4	a situação é a nossa diretoria deixar o gerenciador de whatsapp trabalhar mais um pouco	3	t	chat	\N	3	2026-02-12 01:17:03.246+00	2026-02-12 01:17:03.246+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB05273029985B8F797F4","_serialized":"true_73903821091006@lid_3EB05273029985B8F797F4"},"type":"chat","timestamp":1768848969,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A75397D8DBFF411E69	para colocarmos o roterizador	3	t	chat	\N	3	2026-02-12 01:17:06.413+00	2026-02-12 01:17:06.413+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB0A75397D8DBFF411E69","_serialized":"true_73903821091006@lid_3EB0A75397D8DBFF411E69"},"type":"chat","timestamp":1768848981,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08DE0087041F7BD3E92	estabilizando ele	3	t	chat	\N	3	2026-02-12 01:17:10.837+00	2026-02-12 01:17:10.837+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB08DE0087041F7BD3E92","_serialized":"true_73903821091006@lid_3EB08DE0087041F7BD3E92"},"type":"chat","timestamp":1768849040,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BD41A3DE0D976B270A	necessitaremos mesmo	3	t	chat	\N	3	2026-02-12 01:17:14.603+00	2026-02-12 01:17:14.603+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB0BD41A3DE0D976B270A","_serialized":"true_73903821091006@lid_3EB0BD41A3DE0D976B270A"},"type":"chat","timestamp":1768849044,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B88418534648C721D3	Perfeito, o Rodrigo na última conversa ele disse que estava amadurecendo essa questão...	0	f	chat	\N	45	2026-02-12 01:17:15.389+00	2026-02-12 01:17:15.389+00	f	f	52	3EB02BB5D9A9A9B38128CB	1	\N	{"id":{"fromMe":false,"remote":"73903821091006@lid","id":"3EB0B88418534648C721D3","_serialized":"false_73903821091006@lid_3EB0B88418534648C721D3"},"type":"chat","timestamp":1768849082,"from":"73903821091006@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB073300135D7B01CD28A	Sim	3	t	chat	\N	3	2026-02-12 01:17:18.39+00	2026-02-12 01:17:18.39+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB073300135D7B01CD28A","_serialized":"true_73903821091006@lid_3EB073300135D7B01CD28A"},"type":"chat","timestamp":1768849093,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB036E2080BF08909EAAB	isso mesmo	3	t	chat	\N	3	2026-02-12 01:17:22.312+00	2026-02-12 01:17:22.312+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB036E2080BF08909EAAB","_serialized":"true_73903821091006@lid_3EB036E2080BF08909EAAB"},"type":"chat","timestamp":1768849095,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB070E8FC6F1F22274AB8	Muito bom você me atualizar quanto a solução, assim consigo junto a nossa diretoria viabilizar questões já validadas.	0	f	chat	\N	45	2026-02-12 01:17:22.595+00	2026-02-12 01:17:22.595+00	f	f	52	\N	1	\N	{"id":{"fromMe":false,"remote":"73903821091006@lid","id":"3EB070E8FC6F1F22274AB8","_serialized":"false_73903821091006@lid_3EB070E8FC6F1F22274AB8"},"type":"chat","timestamp":1768849130,"from":"73903821091006@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B7C58DCF8341A39F22	sim	3	t	chat	\N	3	2026-02-12 01:17:26.117+00	2026-02-12 01:17:26.117+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB0B7C58DCF8341A39F22","_serialized":"true_73903821091006@lid_3EB0B7C58DCF8341A39F22"},"type":"chat","timestamp":1768849142,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5D21656A5C51E328542C166E9894F63	Fala comigo	3	t	chat	\N	3	2026-02-12 00:57:16.178+00	2026-02-12 01:17:26.735+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"A5D21656A5C51E328542C166E9894F63","_serialized":"true_7202811162779@lid_A5D21656A5C51E328542C166E9894F63"},"type":"chat","timestamp":1770856182,"from":"556592694840@c.us","to":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C0E4165F721C02D473	Terei uma reunião sobre os projetos de dezembro 25. E deixei a Big como prioridade. Só preciso que me sinalize uma data prevista para eu poder manter vocês aqui na grade.	0	f	chat	\N	45	2026-02-12 01:17:26.759+00	2026-02-12 01:17:26.759+00	f	f	52	\N	1	\N	{"id":{"fromMe":false,"remote":"73903821091006@lid","id":"3EB0C0E4165F721C02D473","_serialized":"false_73903821091006@lid_3EB0C0E4165F721C02D473"},"type":"chat","timestamp":1768849231,"from":"73903821091006@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A559BB9C8ED52C554EFF96DA91580BA1		3	t	image	1770857020734-ogsjs.jpeg	3	2026-02-12 00:43:40.808+00	2026-02-12 01:17:26.796+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"7202811162779@lid","id":"A559BB9C8ED52C554EFF96DA91580BA1","_serialized":"true_7202811162779@lid_A559BB9C8ED52C554EFF96DA91580BA1"},"type":"image","timestamp":1770857019,"from":"556592694840@c.us","to":"7202811162779@lid","author":"151909402964196@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0476525FA7E7BE82E5E	coloque para Fevereiro um novo contato	3	t	chat	\N	3	2026-02-12 01:17:31.038+00	2026-02-12 01:17:31.038+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB0476525FA7E7BE82E5E","_serialized":"true_73903821091006@lid_3EB0476525FA7E7BE82E5E"},"type":"chat","timestamp":1768849263,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0487C500D62F5C7A994	porque essa é a semana efetiva com os números transitando entre a ferramente	3	t	chat	\N	3	2026-02-12 01:17:34.903+00	2026-02-12 01:17:34.903+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB0487C500D62F5C7A994","_serialized":"true_73903821091006@lid_3EB0487C500D62F5C7A994"},"type":"chat","timestamp":1768849279,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB045F41EBEC05EF19C33	ferramenta*	3	t	chat	\N	3	2026-02-12 01:17:39.24+00	2026-02-12 01:17:39.24+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB045F41EBEC05EF19C33","_serialized":"true_73903821091006@lid_3EB045F41EBEC05EF19C33"},"type":"chat","timestamp":1768849283,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F76A972DB280E56235	Combinado, vou colocar até 25/Fev. Se for antes, vc sinaliza aqui para eu organizar a agenda.	0	f	chat	\N	45	2026-02-12 01:17:40.259+00	2026-02-12 01:17:40.259+00	f	f	52	\N	1	\N	{"id":{"fromMe":false,"remote":"73903821091006@lid","id":"3EB0F76A972DB280E56235","_serialized":"false_73903821091006@lid_3EB0F76A972DB280E56235"},"type":"chat","timestamp":1768849329,"from":"73903821091006@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB091C52D2D645D7DF5D0	Sim, claro que sinalizo sim	3	t	chat	\N	3	2026-02-12 01:17:44.506+00	2026-02-12 01:17:44.506+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB091C52D2D645D7DF5D0","_serialized":"true_73903821091006@lid_3EB091C52D2D645D7DF5D0"},"type":"chat","timestamp":1768849344,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0115DB8FBB3F557FDD9	Perfeito! Bom trabalho !	0	f	chat	\N	45	2026-02-12 01:17:44.949+00	2026-02-12 01:17:44.949+00	f	f	52	3EB091C52D2D645D7DF5D0	1	\N	{"id":{"fromMe":false,"remote":"73903821091006@lid","id":"3EB0115DB8FBB3F557FDD9","_serialized":"false_73903821091006@lid_3EB0115DB8FBB3F557FDD9"},"type":"chat","timestamp":1768849651,"from":"73903821091006@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB056BC8BA36DEEFD6CAA	Igualmente e obrigado!	3	t	chat	\N	3	2026-02-12 01:17:48.475+00	2026-02-12 01:17:48.475+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"73903821091006@lid","id":"3EB056BC8BA36DEEFD6CAA","_serialized":"true_73903821091006@lid_3EB056BC8BA36DEEFD6CAA"},"type":"chat","timestamp":1768849668,"from":"151909402964196@lid","to":"73903821091006@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A57BA286376FEE0D7ACAFB83713EB7C8		0	t	chat	\N	3	2026-02-12 01:17:50.979+00	2026-02-12 01:17:50.979+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"A57BA286376FEE0D7ACAFB83713EB7C8","_serialized":"true_27217845342277@lid_A57BA286376FEE0D7ACAFB83713EB7C8"},"type":"e2e_notification","timestamp":1768839233,"from":"556592694840@c.us","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F79F062D1DE6FB7741	Bom dia!	2	t	chat	\N	3	2026-02-12 01:17:54.09+00	2026-02-12 01:17:54.09+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"3EB0F79F062D1DE6FB7741","_serialized":"true_27217845342277@lid_3EB0F79F062D1DE6FB7741"},"type":"chat","timestamp":1768839233,"from":"151909402964196@lid","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACC70C14D7AAB392A44BB8632385D36A	1890314718	1	f	chat	\N	48	2026-02-12 12:45:02.372+00	2026-02-12 12:45:02.427+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACC70C14D7AAB392A44BB8632385D36A","_serialized":"false_2194761883822@lid_ACC70C14D7AAB392A44BB8632385D36A"},"type":"chat","timestamp":1770900301,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
A54E1C7FA4C82FA2937C15936D4E966F		0	t	chat	\N	3	2026-02-12 01:17:56.144+00	2026-02-12 01:17:56.144+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"A54E1C7FA4C82FA2937C15936D4E966F","_serialized":"true_27217845342277@lid_A54E1C7FA4C82FA2937C15936D4E966F"},"type":"notification_template","timestamp":1768839240,"from":"556592694840@c.us","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09FD564103E0E1D1B34	2	2	t	chat	\N	3	2026-02-12 01:17:59.335+00	2026-02-12 01:17:59.335+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"3EB09FD564103E0E1D1B34","_serialized":"true_27217845342277@lid_3EB09FD564103E0E1D1B34"},"type":"chat","timestamp":1768839308,"from":"151909402964196@lid","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA28892643390F82EEB	Boa	1	t	chat	\N	4	2026-02-12 01:17:40.074+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3AA28892643390F82EEB","_serialized":"false_7202811162779@lid_3AA28892643390F82EEB"},"type":"chat","timestamp":1770859049,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56CD049F32C14E6C5A3FDC2D97F5395		4	f	audio	1770900304793-5k0okx.oga	11	2026-02-12 12:45:04.797+00	2026-02-12 12:45:16.34+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A56CD049F32C14E6C5A3FDC2D97F5395","_serialized":"false_164703422648560@lid_A56CD049F32C14E6C5A3FDC2D97F5395"},"type":"ptt","timestamp":1770900303,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB06646EB324083E76E81	32864855/0005-80	2	t	chat	\N	3	2026-02-12 01:18:03.181+00	2026-02-12 01:18:03.181+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"3EB06646EB324083E76E81","_serialized":"true_27217845342277@lid_3EB06646EB324083E76E81"},"type":"chat","timestamp":1768839898,"from":"151909402964196@lid","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACC91F4646275B1B56408A7AA3202BEC	Nada	1	f	chat	\N	48	2026-02-12 12:47:57.011+00	2026-02-12 12:47:57.114+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"ACC91F4646275B1B56408A7AA3202BEC","_serialized":"false_2194761883822@lid_ACC91F4646275B1B56408A7AA3202BEC"},"type":"chat","timestamp":1770900476,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB04D883D422596BFB96E	eu estou aguardando o vendedor me responder	2	t	chat	\N	3	2026-02-12 01:18:07.588+00	2026-02-12 01:18:07.588+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"3EB04D883D422596BFB96E","_serialized":"true_27217845342277@lid_3EB04D883D422596BFB96E"},"type":"chat","timestamp":1768847092,"from":"151909402964196@lid","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB06837F8A63D9F6FACFF	até agora	2	t	chat	\N	3	2026-02-12 01:18:11.176+00	2026-02-12 01:18:11.176+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"27217845342277@lid","id":"3EB06837F8A63D9F6FACFF","_serialized":"true_27217845342277@lid_3EB06837F8A63D9F6FACFF"},"type":"chat","timestamp":1768847094,"from":"151909402964196@lid","to":"27217845342277@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB005C9D1C22B3D8230B3	Oi Ana	2	t	chat	\N	3	2026-02-12 01:18:15.399+00	2026-02-12 01:18:15.399+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB005C9D1C22B3D8230B3","_serialized":"true_199170702983221@lid_3EB005C9D1C22B3D8230B3"},"type":"chat","timestamp":1767627987,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB071486FA7BB21D83376	Bom dia!	2	t	chat	\N	3	2026-02-12 01:18:18.328+00	2026-02-12 01:18:18.328+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB071486FA7BB21D83376","_serialized":"true_199170702983221@lid_3EB071486FA7BB21D83376"},"type":"chat","timestamp":1767627995,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0001D5DC2EE39A0ACF5	É o Marcos	2	t	chat	\N	3	2026-02-12 01:18:21.807+00	2026-02-12 01:18:21.807+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB0001D5DC2EE39A0ACF5","_serialized":"true_199170702983221@lid_3EB0001D5DC2EE39A0ACF5"},"type":"chat","timestamp":1767628000,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB032C3EBDC2FD0AA36B7	Você chegou a conversar com o pessoal que fornece película para celular?	2	t	chat	\N	3	2026-02-12 01:18:24.798+00	2026-02-12 01:18:24.798+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB032C3EBDC2FD0AA36B7","_serialized":"true_199170702983221@lid_3EB032C3EBDC2FD0AA36B7"},"type":"chat","timestamp":1767628023,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03159B12078496F8421	Se eles conseguiram ver o do coletor que tirou foto	2	t	chat	\N	3	2026-02-12 01:18:28.076+00	2026-02-12 01:18:28.076+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB03159B12078496F8421","_serialized":"true_199170702983221@lid_3EB03159B12078496F8421"},"type":"chat","timestamp":1767628039,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DE5E6E4D608424CF32	?w	2	t	chat	\N	3	2026-02-12 01:18:31.476+00	2026-02-12 01:18:31.476+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB0DE5E6E4D608424CF32","_serialized":"true_199170702983221@lid_3EB0DE5E6E4D608424CF32"},"type":"chat","timestamp":1767628040,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5668D682ED85C8B4BCFB42FF3D46F28		4	t	audio	1770857993634-yckhn9.oga	3	2026-02-12 00:59:53.64+00	2026-02-12 01:53:58.414+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"131752601366700@lid","id":"A5668D682ED85C8B4BCFB42FF3D46F28","_serialized":"true_131752601366700@lid_A5668D682ED85C8B4BCFB42FF3D46F28"},"type":"ptt","timestamp":1770761416,"from":"556592694840@c.us","to":"131752601366700@lid","author":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"58","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5B375E20C9850CC129C0F854ABA7BAA		0	t	chat	\N	3	2026-02-12 01:18:33.319+00	2026-02-12 01:18:33.319+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"A5B375E20C9850CC129C0F854ABA7BAA","_serialized":"true_199170702983221@lid_A5B375E20C9850CC129C0F854ABA7BAA"},"type":"e2e_notification","timestamp":1767628097,"from":"556592694840@c.us","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00C0F0436102CC5FEC7	td bem	2	t	chat	\N	3	2026-02-12 01:18:36.595+00	2026-02-12 01:18:36.595+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB00C0F0436102CC5FEC7","_serialized":"true_199170702983221@lid_3EB00C0F0436102CC5FEC7"},"type":"chat","timestamp":1767628221,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB065B44C0E3ADD853C90	vou ver pela internet então	2	t	chat	\N	3	2026-02-12 01:18:40.127+00	2026-02-12 01:18:40.127+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB065B44C0E3ADD853C90","_serialized":"true_199170702983221@lid_3EB065B44C0E3ADD853C90"},"type":"chat","timestamp":1767628229,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A86EB13B334B029631	e-mail?	2	t	chat	\N	3	2026-02-12 01:18:43.395+00	2026-02-12 01:18:43.395+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB0A86EB13B334B029631","_serialized":"true_199170702983221@lid_3EB0A86EB13B334B029631"},"type":"chat","timestamp":1767798842,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0296F587BCE705F85CF	Nome completo	2	t	chat	\N	3	2026-02-12 01:18:46.839+00	2026-02-12 01:18:46.839+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB0296F587BCE705F85CF","_serialized":"true_199170702983221@lid_3EB0296F587BCE705F85CF"},"type":"chat","timestamp":1767799068,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC964A8F9EFFCF19B8BFB4732E7BBE97	Sim	1	f	chat	\N	48	2026-02-12 12:49:20.635+00	2026-02-12 12:49:20.67+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC964A8F9EFFCF19B8BFB4732E7BBE97","_serialized":"false_2194761883822@lid_AC964A8F9EFFCF19B8BFB4732E7BBE97"},"type":"chat","timestamp":1770900560,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB0E74B0F8C90A0C7C5C3	Verifica se chegou e-mail para você depois	2	t	chat	\N	3	2026-02-12 01:18:50.233+00	2026-02-12 01:18:50.233+00	t	f	3	\N	1	\N	{"id":{"fromMe":true,"remote":"199170702983221@lid","id":"3EB0E74B0F8C90A0C7C5C3","_serialized":"true_199170702983221@lid_3EB0E74B0F8C90A0C7C5C3"},"type":"chat","timestamp":1767800740,"from":"151909402964196@lid","to":"199170702983221@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC343AA6C4B9C8986F17C32F65DDC81B		1	f	image	1770900575093-vyjlh.jpeg	48	2026-02-12 12:49:35.097+00	2026-02-12 12:49:35.124+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC343AA6C4B9C8986F17C32F65DDC81B","_serialized":"false_2194761883822@lid_AC343AA6C4B9C8986F17C32F65DDC81B"},"type":"image","timestamp":1770900574,"from":"2194761883822@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3EB018FFBEA62E2803DDB3	??	0	t	chat	\N	29	2026-02-12 01:04:39.171+00	2026-02-12 01:40:18.033+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB018FFBEA62E2803DDB3","_serialized":"false_150950970921173@lid_3EB018FFBEA62E2803DDB3"},"type":"chat","timestamp":1769699948,"from":"150950970921173@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01BDA00A824EB83A1D3		0	t	image	1770858284519-i3l7pe.jpeg	29	2026-02-12 01:04:44.528+00	2026-02-12 01:40:18.033+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB01BDA00A824EB83A1D3","_serialized":"false_150950970921173@lid_3EB01BDA00A824EB83A1D3"},"type":"image","timestamp":1769700270,"from":"150950970921173@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04314BFFE9A5BC4D7A0	Bom diaa	0	t	chat	\N	29	2026-02-12 01:05:06.053+00	2026-02-12 01:40:18.033+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB04314BFFE9A5BC4D7A0","_serialized":"false_150950970921173@lid_3EB04314BFFE9A5BC4D7A0"},"type":"chat","timestamp":1770635411,"from":"150950970921173@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09AF2F0D515631380FE	preciso que veja essa questão do nexcloud	0	t	chat	\N	29	2026-02-12 01:05:06.267+00	2026-02-12 01:40:18.033+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB09AF2F0D515631380FE","_serialized":"false_150950970921173@lid_3EB09AF2F0D515631380FE"},"type":"chat","timestamp":1770635428,"from":"150950970921173@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A2168CC8B31A59F58B	toda vez preciso pedir planilha pra Marcelle das coisas	0	t	chat	\N	29	2026-02-12 01:05:06.483+00	2026-02-12 01:40:18.033+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB0A2168CC8B31A59F58B","_serialized":"false_150950970921173@lid_3EB0A2168CC8B31A59F58B"},"type":"chat","timestamp":1770635442,"from":"150950970921173@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0169A50EE4C13C240B2	obg	0	t	chat	\N	29	2026-02-12 01:05:09.707+00	2026-02-12 01:40:18.033+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"150950970921173@lid","id":"3EB0169A50EE4C13C240B2","_serialized":"false_150950970921173@lid_3EB0169A50EE4C13C240B2"},"type":"chat","timestamp":1770637903,"from":"150950970921173@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA532F7FDE4F88599BB	Ewww segunda feira	0	t	chat	\N	23	2026-02-12 01:02:45.044+00	2026-02-12 01:40:18.136+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3AA532F7FDE4F88599BB","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_556596725633-1629494914@g.us_3AA532F7FDE4F88599BB_189309424541837@lid"},"type":"chat","timestamp":1770645936,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA9EF08B307B3D625C4	As entregas não estou conseguindo finalizar	0	t	chat	\N	23	2026-02-12 01:02:45.286+00	2026-02-12 01:40:18.136+00	f	f	26	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3AA9EF08B307B3D625C4","participant":{"server":"lid","user":"259884192895170","_serialized":"259884192895170@lid"},"_serialized":"false_556596725633-1629494914@g.us_3AA9EF08B307B3D625C4_259884192895170@lid"},"type":"chat","timestamp":1770646104,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"259884192895170@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A9A83E3910E1EF55625	As vendas direto do balcão vai pro caixa	0	t	chat	\N	23	2026-02-12 01:02:45.488+00	2026-02-12 01:40:18.136+00	f	f	26	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3A9A83E3910E1EF55625","participant":{"server":"lid","user":"259884192895170","_serialized":"259884192895170@lid"},"_serialized":"false_556596725633-1629494914@g.us_3A9A83E3910E1EF55625_259884192895170@lid"},"type":"chat","timestamp":1770646115,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"259884192895170@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04D2CF8A92F1DFE0B5C	Bom diaaaaa	0	t	chat	\N	23	2026-02-12 01:02:45.71+00	2026-02-12 01:40:18.136+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB04D2CF8A92F1DFE0B5C","participant":{"server":"lid","user":"150950970921173","_serialized":"150950970921173@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB04D2CF8A92F1DFE0B5C_150950970921173@lid"},"type":"chat","timestamp":1770646944,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E662A5CF8BA82D484B	Hoje ta dificil pra trabalhar no sistema	0	t	chat	\N	23	2026-02-12 01:02:45.898+00	2026-02-12 01:40:18.136+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB0E662A5CF8BA82D484B","participant":{"server":"lid","user":"150950970921173","_serialized":"150950970921173@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB0E662A5CF8BA82D484B_150950970921173@lid"},"type":"chat","timestamp":1770646957,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09AD10832006AD9A8E1	toda hora cai	0	t	chat	\N	23	2026-02-12 01:02:46.122+00	2026-02-12 01:40:18.136+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB09AD10832006AD9A8E1","participant":{"server":"lid","user":"150950970921173","_serialized":"150950970921173@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB09AD10832006AD9A8E1_150950970921173@lid"},"type":"chat","timestamp":1770646961,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0514466760487C6AFBB	internet pessima	0	t	chat	\N	23	2026-02-12 01:02:46.347+00	2026-02-12 01:40:18.136+00	f	f	27	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB0514466760487C6AFBB","participant":{"server":"lid","user":"150950970921173","_serialized":"150950970921173@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB0514466760487C6AFBB_150950970921173@lid"},"type":"chat","timestamp":1770646964,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"150950970921173@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A44308C2DEB589DC013		0	t	audio	1770858167013-sbg956.oga	23	2026-02-12 01:02:47.02+00	2026-02-12 01:40:18.136+00	f	f	26	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3A44308C2DEB589DC013","participant":{"server":"lid","user":"259884192895170","_serialized":"259884192895170@lid"},"_serialized":"false_556596725633-1629494914@g.us_3A44308C2DEB589DC013_259884192895170@lid"},"type":"ptt","timestamp":1770646977,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"259884192895170@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"14","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A70E5A5580A995F7DAF	Se alguém tiver o msm problema	0	t	chat	\N	23	2026-02-12 01:02:47.267+00	2026-02-12 01:40:18.136+00	f	f	26	3A44308C2DEB589DC013	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3A70E5A5580A995F7DAF","participant":{"server":"lid","user":"259884192895170","_serialized":"259884192895170@lid"},"_serialized":"false_556596725633-1629494914@g.us_3A70E5A5580A995F7DAF_259884192895170@lid"},"type":"chat","timestamp":1770646987,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"259884192895170@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5530828A7510116EE736573EC35E05F		0	t	sticker	1770858167818-wz1na.webp	23	2026-02-12 01:02:47.825+00	2026-02-12 01:40:18.136+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"A5530828A7510116EE736573EC35E05F","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_556596725633-1629494914@g.us_A5530828A7510116EE736573EC35E05F_164703422648560@lid"},"type":"sticker","timestamp":1770646991,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA09A88B93B1B88DC86	Consegui seguir assim	0	t	chat	\N	23	2026-02-12 01:02:48.059+00	2026-02-12 01:40:18.136+00	f	f	26	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3AA09A88B93B1B88DC86","participant":{"server":"lid","user":"259884192895170","_serialized":"259884192895170@lid"},"_serialized":"false_556596725633-1629494914@g.us_3AA09A88B93B1B88DC86_259884192895170@lid"},"type":"chat","timestamp":1770646991,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"259884192895170@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EFCCA567EC4391BE21	As conexões estão sendo normalizadas aos poucos.	0	t	chat	\N	23	2026-02-12 01:02:48.418+00	2026-02-12 01:40:18.136+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB0EFCCA567EC4391BE21","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB0EFCCA567EC4391BE21_164703422648560@lid"},"type":"chat","timestamp":1770649776,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02E3523761A9D741779	Irão notar no decorrer do dia.	0	t	chat	\N	23	2026-02-12 01:02:49.071+00	2026-02-12 01:40:18.136+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"3EB02E3523761A9D741779","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_556596725633-1629494914@g.us_3EB02E3523761A9D741779_164703422648560@lid"},"type":"chat","timestamp":1770649778,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC243D549B8758AF76F3FD59335FBA26	Bom dia!@	0	t	chat	\N	23	2026-02-12 01:02:49.398+00	2026-02-12 01:40:18.136+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"AC243D549B8758AF76F3FD59335FBA26","participant":{"server":"lid","user":"131752601366700","_serialized":"131752601366700@lid"},"_serialized":"false_556596725633-1629494914@g.us_AC243D549B8758AF76F3FD59335FBA26_131752601366700@lid"},"type":"chat","timestamp":1770725193,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC8B1C1138DCD49E532431D5B07CA452	Só pra registrar	0	t	chat	\N	23	2026-02-12 01:02:49.656+00	2026-02-12 01:40:18.136+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"AC8B1C1138DCD49E532431D5B07CA452","participant":{"server":"lid","user":"131752601366700","_serialized":"131752601366700@lid"},"_serialized":"false_556596725633-1629494914@g.us_AC8B1C1138DCD49E532431D5B07CA452_131752601366700@lid"},"type":"chat","timestamp":1770725203,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"131752601366700@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACABD9E20471C87DCDDCD2B48AFA674A		0	t	image	1770858170062-ngy7u.jpeg	23	2026-02-12 01:02:50.069+00	2026-02-12 01:40:18.136+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"556596725633-1629494914@g.us","id":"ACABD9E20471C87DCDDCD2B48AFA674A","participant":{"server":"lid","user":"131752601366700","_serialized":"131752601366700@lid"},"_serialized":"false_556596725633-1629494914@g.us_ACABD9E20471C87DCDDCD2B48AFA674A_131752601366700@lid"},"type":"image","timestamp":1770725206,"from":"556596725633-1629494914@g.us","to":"556592694840@c.us","author":"131752601366700@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
5C82AF44A72E79114F	Bem-vindo à canal de cobrança e qualidade da NaveNET!\n\nCaso o seu contato seja para SUPORTE, siga para o canal 0800 311 5900 ou 065 3311 5900 ou clique no link abaixo.\n\nbit.ly/canal-de-suporte-navenet\n\n...\n\n\n*1* -  Já sou Cliente\n*2* -  Quero Contratar	0	t	chat	\N	46	2026-02-12 01:17:54.682+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"5C82AF44A72E79114F","_serialized":"false_27217845342277@lid_5C82AF44A72E79114F"},"type":"chat","timestamp":1768839239,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
7FCA943AA687BC1522	Estou transferindo seu atendimento para um atendente. Aguarde um instante que em breve será atendido!	0	t	chat	\N	46	2026-02-12 01:17:59.725+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"7FCA943AA687BC1522","_serialized":"false_27217845342277@lid_7FCA943AA687BC1522"},"type":"chat","timestamp":1768839315,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
7B6824661B75B94D42	Olá, bom dia! Tudo bem? Me chamo Jessica e irei te atender hoje.💖\nPor gentileza, me confirma o CPF ou CNPJ do cadastro	0	t	chat	\N	46	2026-02-12 01:17:59.995+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"7B6824661B75B94D42","_serialized":"false_27217845342277@lid_7B6824661B75B94D42"},"type":"chat","timestamp":1768839452,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
E198F82411AE3E0035	gostaria de contratar, correto?	0	t	chat	\N	46	2026-02-12 01:18:03.581+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"E198F82411AE3E0035","_serialized":"false_27217845342277@lid_E198F82411AE3E0035"},"type":"chat","timestamp":1768840036,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
C8BA4E5845B54C2ED6	O consultor de vendas Laércio entrará em contato para te explicar sobre os planos e valores, ok?	0	t	chat	\N	46	2026-02-12 01:18:03.847+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"C8BA4E5845B54C2ED6","_serialized":"false_27217845342277@lid_C8BA4E5845B54C2ED6"},"type":"chat","timestamp":1768840127,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
D6C4228F436962C2DD	Desejo que tenha um bom dia, qualquer dúvida estamos a disposição.	0	t	chat	\N	46	2026-02-12 01:18:04.113+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"D6C4228F436962C2DD","_serialized":"false_27217845342277@lid_D6C4228F436962C2DD"},"type":"chat","timestamp":1768840250,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
81A7E48FA1B70E9572	Avalie este atendimento, pois é de grande importância esse feedback, de 0 (insatisfeito) a 10 (muito satisfeito)!	0	t	chat	\N	46	2026-02-12 01:18:04.41+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"81A7E48FA1B70E9572","_serialized":"false_27217845342277@lid_81A7E48FA1B70E9572"},"type":"chat","timestamp":1768840253,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
769298A9209EC4E9A9	Precisaremos finalizar este atendimento devido à falta de interação. Caso queira prosseguir com o atendimento, faça o contato novamente que estaremos dispostos a lhe atender.  Agradecemos o contato, tenha um excelente dia!	0	t	chat	\N	46	2026-02-12 01:18:04.714+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"769298A9209EC4E9A9","_serialized":"false_27217845342277@lid_769298A9209EC4E9A9"},"type":"chat","timestamp":1768842070,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC20C32BC7A429824A8F18596E5969CE	Vou verificar aqui	0	t	chat	\N	28	2026-02-12 01:04:20.089+00	2026-02-12 01:40:36.558+00	f	f	31	3EB05C85EAB27AA02FEB62	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"AC20C32BC7A429824A8F18596E5969CE","_serialized":"false_10098005029093@lid_AC20C32BC7A429824A8F18596E5969CE"},"type":"chat","timestamp":1769796803,"from":"10098005029093@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4CD2C0D946B968F1D5	Bem-vindo à canal de cobrança e qualidade da NaveNET!\n\nCaso o seu contato seja para SUPORTE, siga para o canal 0800 311 5900 ou 065 3311 5900 ou clique no link abaixo.\n\nbit.ly/canal-de-suporte-navenet\n\n...\n\n\n*1* -  Já sou Cliente\n*2* -  Quero Contratar	0	t	chat	\N	46	2026-02-12 01:18:11.482+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"4CD2C0D946B968F1D5","_serialized":"false_27217845342277@lid_4CD2C0D946B968F1D5"},"type":"chat","timestamp":1768847098,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
382E65DACFA09BEA58	*Opção Inválida, digita uma opção válida:*	0	t	chat	\N	46	2026-02-12 01:18:11.742+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"382E65DACFA09BEA58","_serialized":"false_27217845342277@lid_382E65DACFA09BEA58"},"type":"chat","timestamp":1768847100,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACEEF070C7BC426E19	Precisaremos finalizar este atendimento devido à falta de interação. Caso queira prosseguir com o atendimento, faça o contato novamente que estaremos dispostos a lhe atender.  Agradecemos o contato, tenha um excelente dia!	0	t	chat	\N	46	2026-02-12 01:18:12.062+00	2026-02-12 01:40:19.23+00	f	f	53	\N	1	\N	{"id":{"fromMe":false,"remote":"27217845342277@lid","id":"ACEEF070C7BC426E19","_serialized":"false_27217845342277@lid_ACEEF070C7BC426E19"},"type":"chat","timestamp":1768847472,"from":"27217845342277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BD93572720253CF369	Bom dia! Marcos,\nEles não fornece esse modelo de capinha	0	t	chat	\N	47	2026-02-12 01:18:31.802+00	2026-02-12 01:40:20.186+00	f	f	54	\N	1	\N	{"id":{"fromMe":false,"remote":"199170702983221@lid","id":"3EB0BD93572720253CF369","_serialized":"false_199170702983221@lid_3EB0BD93572720253CF369"},"type":"chat","timestamp":1767628096,"from":"199170702983221@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0A2247AEF1ED495896C	oportunidades@drogariasbigmaster.com.br	0	t	chat	\N	47	2026-02-12 01:18:43.757+00	2026-02-12 01:40:20.186+00	f	f	54	\N	1	\N	{"id":{"fromMe":false,"remote":"199170702983221@lid","id":"3EB0A2247AEF1ED495896C","_serialized":"false_199170702983221@lid_3EB0A2247AEF1ED495896C"},"type":"chat","timestamp":1767798970,"from":"199170702983221@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0DF5A2F102B12B3052B	Ana Beatriz Tavares Lima	0	t	chat	\N	47	2026-02-12 01:18:47.204+00	2026-02-12 01:40:20.186+00	f	f	54	\N	1	\N	{"id":{"fromMe":false,"remote":"199170702983221@lid","id":"3EB0DF5A2F102B12B3052B","_serialized":"false_199170702983221@lid_3EB0DF5A2F102B12B3052B"},"type":"chat","timestamp":1767799096,"from":"199170702983221@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04076D4DDB337663BE1	mas me confundi nas pastas na real	0	t	chat	\N	4	2026-02-12 00:57:14.231+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3EB04076D4DDB337663BE1","_serialized":"false_7202811162779@lid_3EB04076D4DDB337663BE1"},"type":"chat","timestamp":1770848084,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB04EA10359CB7253D601	entao sim, deve que tava certo mas tava faltando vincular a pasta kk	0	t	chat	\N	4	2026-02-12 00:57:14.486+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3EB04EA10359CB7253D601","_serialized":"false_7202811162779@lid_3EB04EA10359CB7253D601"},"type":"chat","timestamp":1770848094,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A01A17B5309A5B334D7	Vai dando notícias precisar de algo avisa	0	t	chat	\N	4	2026-02-12 00:57:14.683+00	2026-02-12 01:40:21.148+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"7202811162779@lid","id":"3A01A17B5309A5B334D7","_serialized":"false_7202811162779@lid_3A01A17B5309A5B334D7"},"type":"chat","timestamp":1770855042,"from":"7202811162779@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
4C3ECAB10E2C2FB604	*Maria Vitória Vicente*:\nah sim, perfeito\nMuito grata\nVou enviar a voce novamente	0	t	chat	\N	43	2026-02-12 01:15:37.134+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"4C3ECAB10E2C2FB604","_serialized":"false_144517244166226@lid_4C3ECAB10E2C2FB604"},"type":"chat","timestamp":1769013223,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
6C837CF037EFC6F96C	*Maria Vitória Vicente*:\nSeu protocolo de atendimento é: OPA20262097563\n\nPara darmos continuidade à ativação dos seus serviços, precisamos confirmar sua identidade e sua ciência sobre o contrato de prestação de serviços referente aos itens discriminados abaixo:\n\nDados para Validação\n\n* Telefonia fixa: 1 numero + Franquia\n* Valor: 290,00 + 15,00\n* Valor total: 305,00\n* Nome completo: Savio Alves Gomes Bomfim\n* CNPJ: 01838362355\n* Telefone principal: (65)992694840\n* E-mail: marcos.barbosa@gcollab.com.br;controladoria@drogariasbigmaster.com.br\n* Vencimento da fatura: 10\n* Endereço completo: Avenida Camboriú Prq Geórgia 03, Parque Georgia - Cuiabá - MT	0	t	chat	\N	43	2026-02-12 01:15:47.67+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"6C837CF037EFC6F96C","_serialized":"false_144517244166226@lid_6C837CF037EFC6F96C"},"type":"chat","timestamp":1769013479,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
0BC9DEDB6D86DBA472	Novo Termo telefonia.docx	0	t	document	1770858950056-8z1gap.docx	43	2026-02-12 01:15:50.065+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"0BC9DEDB6D86DBA472","_serialized":"false_144517244166226@lid_0BC9DEDB6D86DBA472"},"type":"document","timestamp":1769013487,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
B6F8F7B3240B165901	Clique em ""ACEITO"" declarando que LEU, COMPREENDEU E ACEITA OS TERMOS DO CONTRATO DE PRESTAÇÃO DE SERVIÇOS COM A DBNET, ESTANDO CIENTE DE TODAS AS CLÁUSULAS DESCRITAS	0	t	chat	\N	43	2026-02-12 01:15:50.547+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"B6F8F7B3240B165901","_serialized":"false_144517244166226@lid_B6F8F7B3240B165901"},"type":"chat","timestamp":1769013489,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
E587B52F32C7C20227	*Maria Vitória Vicente*:\nPerfeito! 🙌 Para validar sua identidade, por favor envie: 📷 1. Uma selfie segurando um documento oficial com foto (RG, CNH ou similar) 🗂 2. Uma foto legível ou arquivo em PDF do mesmo documento (frente e verso)	0	t	chat	\N	43	2026-02-12 01:15:54.345+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"E587B52F32C7C20227","_serialized":"false_144517244166226@lid_E587B52F32C7C20227"},"type":"chat","timestamp":1769014537,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
E0EE465085C9A10B98	*Maria Vitória Vicente*:\nMuito grata Marcos\nEsta certinho.	0	t	chat	\N	43	2026-02-12 01:16:02.094+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"E0EE465085C9A10B98","_serialized":"false_144517244166226@lid_E0EE465085C9A10B98"},"type":"chat","timestamp":1769016361,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
15C9BE5AB7548DB7AE	*Maria Vitória Vicente*:\nNão, somente o senhor mesmo	0	t	chat	\N	43	2026-02-12 01:16:05.491+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"15C9BE5AB7548DB7AE","_serialized":"false_144517244166226@lid_15C9BE5AB7548DB7AE"},"type":"chat","timestamp":1769016429,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
861A5466B3363F109C	*Maria Vitória Vicente*:\nRealizarei a solicitação agora	0	t	chat	\N	43	2026-02-12 01:16:05.777+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"861A5466B3363F109C","_serialized":"false_144517244166226@lid_861A5466B3363F109C"},"type":"chat","timestamp":1769016436,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
DC6FC64C340CBE11BC	*Maria Vitória Vicente*:\nE como estamos em contato pelo numero corporativo, te envio a data que sairá a portabilidade, tudo bem?	0	t	chat	\N	43	2026-02-12 01:16:06.115+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"DC6FC64C340CBE11BC","_serialized":"false_144517244166226@lid_DC6FC64C340CBE11BC"},"type":"chat","timestamp":1769016458,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
1F21CBC7AB452A85B8	*Maria Vitória Vicente*:\nVou encerrar nosso atendimento\nMas qualquer duvida estou a disposição para ajuda-lo 😉	0	t	chat	\N	43	2026-02-12 01:16:10.262+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"1F21CBC7AB452A85B8","_serialized":"false_144517244166226@lid_1F21CBC7AB452A85B8"},"type":"chat","timestamp":1769017200,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
16CBFC06AF83494008	*Maria Vitória Vicente*:\nTe desejo uma otima tarde e uma excelente semana 🙏	0	t	chat	\N	43	2026-02-12 01:16:10.629+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"16CBFC06AF83494008","_serialized":"false_144517244166226@lid_16CBFC06AF83494008"},"type":"chat","timestamp":1769017212,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
F769F59132A143B4C4	*Maria Vitória Vicente*:\nMaria Vitória Vicente encerrou o atendimento.	0	t	chat	\N	43	2026-02-12 01:16:10.955+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"F769F59132A143B4C4","_serialized":"false_144517244166226@lid_F769F59132A143B4C4"},"type":"chat","timestamp":1769017232,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
900A45D5799AFAF9B8	*Apolo (Agente virtual)*:\n💬 *Nos informe como foi o seu atendimento!*\nSua opinião sobre como foi o contato com nossa equipe é muito importante.\n\n5️⃣ - ⭐⭐⭐⭐⭐\n4️⃣ - ⭐⭐⭐⭐\n3️⃣ - ⭐⭐⭐\n2️⃣ - ⭐⭐\n1️⃣ - ⭐\n 5 - 5️⃣ - ⭐⭐⭐⭐⭐\n 4 - 4️⃣ - ⭐⭐⭐⭐\n 3 - 3️⃣ - ⭐⭐⭐\n 2 - 2️⃣ - ⭐⭐\n 1 - 1️⃣ - ⭐	0	t	chat	\N	43	2026-02-12 01:16:11.366+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"900A45D5799AFAF9B8","_serialized":"false_144517244166226@lid_900A45D5799AFAF9B8"},"type":"chat","timestamp":1769017234,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
BEB4DEEA9E97521605	*Apolo*:\nPesquisa de satisfação encerrada por inatividade	0	t	chat	\N	43	2026-02-12 01:16:11.756+00	2026-02-12 01:40:22.395+00	f	f	50	\N	1	\N	{"id":{"fromMe":false,"remote":"144517244166226@lid","id":"BEB4DEEA9E97521605","_serialized":"false_144517244166226@lid_BEB4DEEA9E97521605"},"type":"chat","timestamp":1769018434,"from":"144517244166226@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A45F0D45B2C2FCFA984	Podemos alinhar sim	0	t	chat	\N	34	2026-02-12 01:07:02.688+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3A45F0D45B2C2FCFA984","_serialized":"false_141961671520277@lid_3A45F0D45B2C2FCFA984"},"type":"chat","timestamp":1769619770,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AB98F6B86802273C50A		0	t	video	1770858431287-wauw8p.mp4	34	2026-02-12 01:07:11.316+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3AB98F6B86802273C50A","_serialized":"false_141961671520277@lid_3AB98F6B86802273C50A"},"type":"video","timestamp":1769625190,"from":"141961671520277@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"28","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A7A5DBF68EBD22BB6C5	Ótimo! Vai ser excelente	0	t	chat	\N	34	2026-02-12 01:07:21.321+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3A7A5DBF68EBD22BB6C5","_serialized":"false_141961671520277@lid_3A7A5DBF68EBD22BB6C5"},"type":"chat","timestamp":1769625285,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB0981F6131897758EAF1838297B42D		0	t	audio	1770858720950-hf6i7b.oga	42	2026-02-12 01:12:00.954+00	2026-02-12 01:40:23.803+00	f	f	46	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"ACB0981F6131897758EAF1838297B42D","participant":{"server":"lid","user":"83426166190201","_serialized":"83426166190201@lid"},"_serialized":"false_120363425670397095@g.us_ACB0981F6131897758EAF1838297B42D_83426166190201@lid"},"type":"ptt","timestamp":1768526519,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"83426166190201@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"13","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC8BB924A0339FF0D65E2C6C23B46C65		0	t	sticker	1770858723192-2ntdb.webp	42	2026-02-12 01:12:03.2+00	2026-02-12 01:40:23.803+00	f	f	47	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC8BB924A0339FF0D65E2C6C23B46C65","participant":{"server":"lid","user":"167186349965479","_serialized":"167186349965479@lid"},"_serialized":"false_120363425670397095@g.us_AC8BB924A0339FF0D65E2C6C23B46C65_167186349965479@lid"},"type":"sticker","timestamp":1768526641,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"167186349965479@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC87FB913AC96FCD3D452A9CBD317C69		0	t	sticker	1770858726272-7cs44.webp	42	2026-02-12 01:12:06.285+00	2026-02-12 01:40:23.803+00	f	f	47	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC87FB913AC96FCD3D452A9CBD317C69","participant":{"server":"lid","user":"167186349965479","_serialized":"167186349965479@lid"},"_serialized":"false_120363425670397095@g.us_AC87FB913AC96FCD3D452A9CBD317C69_167186349965479@lid"},"type":"sticker","timestamp":1768526645,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"167186349965479@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC9BDB2AABFF7C51C68DDF5E16C590CD		0	t	audio	1770858728992-xy462.oga	42	2026-02-12 01:12:09.001+00	2026-02-12 01:40:23.803+00	f	f	47	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC9BDB2AABFF7C51C68DDF5E16C590CD","participant":{"server":"lid","user":"167186349965479","_serialized":"167186349965479@lid"},"_serialized":"false_120363425670397095@g.us_AC9BDB2AABFF7C51C68DDF5E16C590CD_167186349965479@lid"},"type":"ptt","timestamp":1768526655,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"167186349965479@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACFCB4886BD500B35755AB072BBE8A3B		0	t	audio	1770858731269-nraanj.oga	42	2026-02-12 01:12:11.271+00	2026-02-12 01:40:23.803+00	f	f	46	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"ACFCB4886BD500B35755AB072BBE8A3B","participant":{"server":"lid","user":"83426166190201","_serialized":"83426166190201@lid"},"_serialized":"false_120363425670397095@g.us_ACFCB4886BD500B35755AB072BBE8A3B_83426166190201@lid"},"type":"ptt","timestamp":1768526670,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"83426166190201@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"2","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC8CDAD2C37B5DA2AF2E988A0B673792		0	t	audio	1770858734006-9q2ont.oga	42	2026-02-12 01:12:14.011+00	2026-02-12 01:40:23.803+00	f	f	47	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC8CDAD2C37B5DA2AF2E988A0B673792","participant":{"server":"lid","user":"167186349965479","_serialized":"167186349965479@lid"},"_serialized":"false_120363425670397095@g.us_AC8CDAD2C37B5DA2AF2E988A0B673792_167186349965479@lid"},"type":"ptt","timestamp":1768526684,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"167186349965479@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"2","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC69B46FF0951BDE9F607DAD48763FEA		0	t	image	1770858736627-oefnyn.jpeg	42	2026-02-12 01:12:16.629+00	2026-02-12 01:40:23.803+00	f	f	46	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC69B46FF0951BDE9F607DAD48763FEA","participant":{"server":"lid","user":"83426166190201","_serialized":"83426166190201@lid"},"_serialized":"false_120363425670397095@g.us_AC69B46FF0951BDE9F607DAD48763FEA_83426166190201@lid"},"type":"image","timestamp":1768537429,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"83426166190201@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC8887FF1232590318024FCF3DB2A320	Heheehhehehehe	0	t	chat	\N	42	2026-02-12 01:12:17.813+00	2026-02-12 01:40:23.803+00	f	f	48	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC8887FF1232590318024FCF3DB2A320","participant":{"server":"lid","user":"188145572307107","_serialized":"188145572307107@lid"},"_serialized":"false_120363425670397095@g.us_AC8887FF1232590318024FCF3DB2A320_188145572307107@lid"},"type":"chat","timestamp":1768539753,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"188145572307107@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A90485DD661870158BD		0	t	sticker	\N	42	2026-02-12 01:15:18.03+00	2026-02-12 01:40:23.803+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A90485DD661870158BD","participant":{"server":"lid","user":"125271831228508","_serialized":"125271831228508@lid"},"_serialized":"false_120363425670397095@g.us_3A90485DD661870158BD_125271831228508@lid"},"type":"sticker","timestamp":1768566118,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"125271831228508@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACDF54D04F4B2E365128AC4FFAC9E97E	Bora bora	0	t	chat	\N	42	2026-02-12 01:11:46.905+00	2026-02-12 01:40:23.803+00	f	f	44	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"ACDF54D04F4B2E365128AC4FFAC9E97E","participant":{"server":"lid","user":"154176491384837","_serialized":"154176491384837@lid"},"_serialized":"false_120363425670397095@g.us_ACDF54D04F4B2E365128AC4FFAC9E97E_154176491384837@lid"},"type":"chat","timestamp":1768524658,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"154176491384837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACAABAF4E9AD616136F6605E2D4EFBD4	Saindo jaja	0	t	chat	\N	42	2026-02-12 01:11:47.126+00	2026-02-12 01:40:23.803+00	f	f	44	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"ACAABAF4E9AD616136F6605E2D4EFBD4","participant":{"server":"lid","user":"154176491384837","_serialized":"154176491384837@lid"},"_serialized":"false_120363425670397095@g.us_ACAABAF4E9AD616136F6605E2D4EFBD4_154176491384837@lid"},"type":"chat","timestamp":1768524662,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"154176491384837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A585EE1B52EEC7532D6		0	t	audio	1770858710484-5qygf8.oga	42	2026-02-12 01:11:50.497+00	2026-02-12 01:40:23.803+00	f	f	45	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"3A585EE1B52EEC7532D6","participant":{"server":"lid","user":"185439524798613","_serialized":"185439524798613@lid"},"_serialized":"false_120363425670397095@g.us_3A585EE1B52EEC7532D6_185439524798613@lid"},"type":"ptt","timestamp":1768524807,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"185439524798613@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"3","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC1FD16EF21FBCDCC07B6F773E2EEC96		0	t	image	1770858715388-822wbf.jpeg	42	2026-02-12 01:11:55.395+00	2026-02-12 01:40:23.803+00	f	f	46	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC1FD16EF21FBCDCC07B6F773E2EEC96","participant":{"server":"lid","user":"83426166190201","_serialized":"83426166190201@lid"},"_serialized":"false_120363425670397095@g.us_AC1FD16EF21FBCDCC07B6F773E2EEC96_83426166190201@lid"},"type":"image","timestamp":1768524871,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"83426166190201@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC3E91642B3618945639A3805C2B7ADB	Cadê vcs pessoal	0	t	chat	\N	42	2026-02-12 01:11:55.909+00	2026-02-12 01:40:23.803+00	f	f	46	\N	1	\N	{"id":{"fromMe":false,"remote":"120363425670397095@g.us","id":"AC3E91642B3618945639A3805C2B7ADB","participant":{"server":"lid","user":"83426166190201","_serialized":"83426166190201@lid"},"_serialized":"false_120363425670397095@g.us_AC3E91642B3618945639A3805C2B7ADB_83426166190201@lid"},"type":"chat","timestamp":1768524882,"from":"120363425670397095@g.us","to":"556592694840@c.us","author":"83426166190201@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B6703B3DA87BC436976	Bom dia	0	t	chat	\N	40	2026-02-12 01:11:33.898+00	2026-02-12 01:40:26.356+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"189309424541837@lid","id":"3B6703B3DA87BC436976","_serialized":"false_189309424541837@lid_3B6703B3DA87BC436976"},"type":"chat","timestamp":1769179620,"from":"189309424541837@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AB48E75C9C0D7A2C09C	Bom dia!	0	t	chat	\N	40	2026-02-12 01:11:03.255+00	2026-02-12 01:40:26.356+00	f	f	16	3EB0825245A1A4A3D3A76D	1	\N	{"id":{"fromMe":false,"remote":"189309424541837@lid","id":"3AB48E75C9C0D7A2C09C","_serialized":"false_189309424541837@lid_3AB48E75C9C0D7A2C09C"},"type":"chat","timestamp":1768252913,"from":"189309424541837@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AC8DCA7B1A4C85BA44E	Veja o tempo de indisponibilidade	0	t	chat	\N	40	2026-02-12 01:11:04.026+00	2026-02-12 01:40:26.356+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"189309424541837@lid","id":"3AC8DCA7B1A4C85BA44E","_serialized":"false_189309424541837@lid_3AC8DCA7B1A4C85BA44E"},"type":"chat","timestamp":1768252924,"from":"189309424541837@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A4EEDD5D395D7CB539B	Por favor	0	t	chat	\N	40	2026-02-12 01:11:05.686+00	2026-02-12 01:40:26.356+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"189309424541837@lid","id":"3A4EEDD5D395D7CB539B","_serialized":"false_189309424541837@lid_3A4EEDD5D395D7CB539B"},"type":"chat","timestamp":1768252927,"from":"189309424541837@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B6E584E35A0BE4B3A9E	ok	0	t	chat	\N	40	2026-02-12 01:11:23.217+00	2026-02-12 01:40:26.356+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"189309424541837@lid","id":"3B6E584E35A0BE4B3A9E","_serialized":"false_189309424541837@lid_3B6E584E35A0BE4B3A9E"},"type":"chat","timestamp":1769112191,"from":"189309424541837@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A586D28F14BD081BEB915EE62CE307F4		4	t	audio	1770858610474-rwwkq9.oga	39	2026-02-12 01:10:10.482+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A586D28F14BD081BEB915EE62CE307F4","_serialized":"false_40562090635390@lid_A586D28F14BD081BEB915EE62CE307F4"},"type":"ptt","timestamp":1768513533,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"5","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5055886F52A87E78D912836237339F2	Aberto, ele ainda está verificando	0	t	chat	\N	39	2026-02-12 01:10:14.547+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A5055886F52A87E78D912836237339F2","_serialized":"false_40562090635390@lid_A5055886F52A87E78D912836237339F2"},"type":"chat","timestamp":1768513801,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5FC2190464B5A9EF4673119B261DFD7	Me envie a localização para agilizar a entrega.	0	t	chat	\N	39	2026-02-12 01:10:20.587+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A5FC2190464B5A9EF4673119B261DFD7","_serialized":"false_40562090635390@lid_A5FC2190464B5A9EF4673119B261DFD7"},"type":"chat","timestamp":1768513966,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A580D2E0BB9CC50FBDE90AC71EA0E58C	Ok, pedido finalizado, foi um prazer atender você, prazo de 40 a 90 minutos.	0	t	chat	\N	39	2026-02-12 01:10:20.841+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A580D2E0BB9CC50FBDE90AC71EA0E58C","_serialized":"false_40562090635390@lid_A580D2E0BB9CC50FBDE90AC71EA0E58C"},"type":"chat","timestamp":1768513966,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53403EAB8558EC40F709BB78CA5A160	Chegando confere o pedido.	0	t	chat	\N	39	2026-02-12 01:10:21.102+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A53403EAB8558EC40F709BB78CA5A160","_serialized":"false_40562090635390@lid_A53403EAB8558EC40F709BB78CA5A160"},"type":"chat","timestamp":1768513966,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A50E4BFDE88AB04F6118A737BC0A7DC3	As respostas rápidas.	0	t	chat	\N	39	2026-02-12 01:10:21.711+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A50E4BFDE88AB04F6118A737BC0A7DC3","_serialized":"false_40562090635390@lid_A50E4BFDE88AB04F6118A737BC0A7DC3"},"type":"chat","timestamp":1768514007,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A58231BACEB6A0B625185165CDD458C9	Opa Marcos boa tarde	0	t	chat	\N	39	2026-02-12 01:10:31.894+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A58231BACEB6A0B625185165CDD458C9","_serialized":"false_40562090635390@lid_A58231BACEB6A0B625185165CDD458C9"},"type":"chat","timestamp":1769545310,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5ED2686457679A0A17D5953A13CA081	Qual foi o cliente que ficou sem resposta do atendimento de ontem?	0	t	chat	\N	39	2026-02-12 01:10:34.425+00	2026-02-12 01:40:27.277+00	f	f	41	\N	1	\N	{"id":{"fromMe":false,"remote":"40562090635390@lid","id":"A5ED2686457679A0A17D5953A13CA081","_serialized":"false_40562090635390@lid_A5ED2686457679A0A17D5953A13CA081"},"type":"chat","timestamp":1769545326,"from":"40562090635390@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0343F7DCC221A5EA105	Opa	0	t	chat	\N	38	2026-02-12 01:09:32.866+00	2026-02-12 01:40:28.108+00	f	f	40	\N	1	\N	{"id":{"fromMe":false,"remote":"134467272310884@lid","id":"3EB0343F7DCC221A5EA105","_serialized":"false_134467272310884@lid_3EB0343F7DCC221A5EA105"},"type":"chat","timestamp":1769610970,"from":"134467272310884@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CD49211B844DBE4173	Bom dia!	0	t	chat	\N	38	2026-02-12 01:09:35.855+00	2026-02-12 01:40:28.108+00	f	f	40	\N	1	\N	{"id":{"fromMe":false,"remote":"134467272310884@lid","id":"3EB0CD49211B844DBE4173","_serialized":"false_134467272310884@lid_3EB0CD49211B844DBE4173"},"type":"chat","timestamp":1769610975,"from":"134467272310884@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB098CF67079C3419A438	13 997871101!	0	t	chat	\N	38	2026-02-12 01:09:38.816+00	2026-02-12 01:40:28.108+00	f	f	40	\N	1	\N	{"id":{"fromMe":false,"remote":"134467272310884@lid","id":"3EB098CF67079C3419A438","_serialized":"false_134467272310884@lid_3EB098CF67079C3419A438"},"type":"chat","timestamp":1769610998,"from":"134467272310884@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB08083C275A18E1745C4	Laura	0	t	chat	\N	38	2026-02-12 01:09:39.046+00	2026-02-12 01:40:28.108+00	f	f	40	\N	1	\N	{"id":{"fromMe":false,"remote":"134467272310884@lid","id":"3EB08083C275A18E1745C4","_serialized":"false_134467272310884@lid_3EB08083C275A18E1745C4"},"type":"chat","timestamp":1769611000,"from":"134467272310884@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919C203B381C69F6A	*LOJA SHANGRI-LA 02:*\nAgradecemos seu contato, e estaremos sempre à disposição.😉	0	t	chat	\N	33	2026-02-12 01:06:59.28+00	2026-02-12 01:40:32.296+00	f	f	35	\N	1	\N	{"id":{"fromMe":false,"remote":"12300903784497@lid","id":"3EB00919C203B381C69F6A","_serialized":"false_12300903784497@lid_3EB00919C203B381C69F6A"},"type":"chat","timestamp":1770067280,"from":"12300903784497@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A51DE1331563EA14850FA558D0CF7FD4	Entao, precisamos dos rótulos com uma certa urgência	0	t	chat	\N	32	2026-02-12 01:06:42.598+00	2026-02-12 01:40:33.373+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A51DE1331563EA14850FA558D0CF7FD4","_serialized":"false_64283496952056@lid_A51DE1331563EA14850FA558D0CF7FD4"},"type":"chat","timestamp":1770146666,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A53C89B99FDF8E380113400E369B32E4		0	t	sticker	1770858403316-s2dawc.webp	32	2026-02-12 01:06:43.329+00	2026-02-12 01:40:33.373+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A53C89B99FDF8E380113400E369B32E4","_serialized":"false_64283496952056@lid_A53C89B99FDF8E380113400E369B32E4"},"type":"sticker","timestamp":1770146668,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5103AE37A3B4114DC334AF2FD2470C0	Ta bom	0	t	chat	\N	32	2026-02-12 01:06:51.126+00	2026-02-12 01:40:33.373+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A5103AE37A3B4114DC334AF2FD2470C0","_serialized":"false_64283496952056@lid_A5103AE37A3B4114DC334AF2FD2470C0"},"type":"chat","timestamp":1770146737,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5280E64A5885566AA687111B359EB63	Ok	0	t	chat	\N	32	2026-02-12 01:06:54.809+00	2026-02-12 01:40:33.373+00	f	f	34	\N	1	\N	{"id":{"fromMe":false,"remote":"64283496952056@lid","id":"A5280E64A5885566AA687111B359EB63","_serialized":"false_64283496952056@lid_A5280E64A5885566AA687111B359EB63"},"type":"chat","timestamp":1770146747,"from":"64283496952056@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC121BF8BA3C6A279B5173CD59784148	Estamos atendendo no celular	0	t	chat	\N	24	2026-02-12 01:03:00.547+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"AC121BF8BA3C6A279B5173CD59784148","_serialized":"false_175681342312561@lid_AC121BF8BA3C6A279B5173CD59784148"},"type":"chat","timestamp":1770645189,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACA1FB7A6514D2A641CF8C9D5F2DD020		4	t	audio	1770858188828-xv8ny.oga	24	2026-02-12 01:03:08.834+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACA1FB7A6514D2A641CF8C9D5F2DD020","_serialized":"false_175681342312561@lid_ACA1FB7A6514D2A641CF8C9D5F2DD020"},"type":"ptt","timestamp":1770649265,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"4","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACAF9CCF3B89B1DB7FC8C22C79D28D24	Sim	0	t	chat	\N	36	2026-02-12 01:07:53.362+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"ACAF9CCF3B89B1DB7FC8C22C79D28D24","_serialized":"false_113172539244633@lid_ACAF9CCF3B89B1DB7FC8C22C79D28D24"},"type":"chat","timestamp":1769614078,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC32928E4C1F1A6DA9ABF2218A07EF0A	Ok	0	t	chat	\N	36	2026-02-12 01:08:07.106+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"AC32928E4C1F1A6DA9ABF2218A07EF0A","_serialized":"false_113172539244633@lid_AC32928E4C1F1A6DA9ABF2218A07EF0A"},"type":"chat","timestamp":1769614137,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACC2B2662704F865400D4910A851D27A	415931	0	t	chat	\N	36	2026-02-12 01:08:13.618+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"ACC2B2662704F865400D4910A851D27A","_serialized":"false_113172539244633@lid_ACC2B2662704F865400D4910A851D27A"},"type":"chat","timestamp":1769614196,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACF8258717382337DE1650C3BFF1CF8A	Bom dia	0	t	chat	\N	36	2026-02-12 01:08:18.822+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"ACF8258717382337DE1650C3BFF1CF8A","_serialized":"false_113172539244633@lid_ACF8258717382337DE1650C3BFF1CF8A"},"type":"chat","timestamp":1770030188,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC942C0C712FC2AA01EC7D7FD7622812	Não	0	t	chat	\N	36	2026-02-12 01:08:19.006+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"AC942C0C712FC2AA01EC7D7FD7622812","_serialized":"false_113172539244633@lid_AC942C0C712FC2AA01EC7D7FD7622812"},"type":"chat","timestamp":1770030191,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC3AC06AB5A01ABA203325B6F6597024	Gilberto retornou hoje	0	t	chat	\N	36	2026-02-12 01:08:19.235+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"AC3AC06AB5A01ABA203325B6F6597024","_serialized":"false_113172539244633@lid_AC3AC06AB5A01ABA203325B6F6597024"},"type":"chat","timestamp":1770030201,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC508FDD4FF040396AFF5E618388AF5F	🤝	0	t	chat	\N	36	2026-02-12 01:08:23.946+00	2026-02-12 01:40:29.707+00	f	f	38	\N	1	\N	{"id":{"fromMe":false,"remote":"113172539244633@lid","id":"AC508FDD4FF040396AFF5E618388AF5F","_serialized":"false_113172539244633@lid_AC508FDD4FF040396AFF5E618388AF5F"},"type":"chat","timestamp":1770030229,"from":"113172539244633@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACF94FB31E48BD18852F6BB8F13665FF	Não  falei, ele não  responde	0	t	chat	\N	35	2026-02-12 01:07:40.331+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"ACF94FB31E48BD18852F6BB8F13665FF","_serialized":"false_180599583166652@lid_ACF94FB31E48BD18852F6BB8F13665FF"},"type":"chat","timestamp":1770041316,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC2096B70326A71F9799D3B9B78A006A	Então  ja nem mando pra ele	0	t	chat	\N	35	2026-02-12 01:07:40.516+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"AC2096B70326A71F9799D3B9B78A006A","_serialized":"false_180599583166652@lid_AC2096B70326A71F9799D3B9B78A006A"},"type":"chat","timestamp":1770041322,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACE42894461842117B59C01C093E0434	Ta ok	0	t	chat	\N	35	2026-02-12 01:07:43.586+00	2026-02-12 01:40:30.453+00	f	f	37	A5608FD6DC49F8436A9B5BC7D97E61CE	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"ACE42894461842117B59C01C093E0434","_serialized":"false_180599583166652@lid_ACE42894461842117B59C01C093E0434"},"type":"chat","timestamp":1770041344,"from":"180599583166652@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC0BC855BA8DFDFC9B50518DDAA326A0	Pauline ligou no safra	0	t	chat	\N	35	2026-02-12 01:07:45.227+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"AC0BC855BA8DFDFC9B50518DDAA326A0","_serialized":"false_180599583166652@lid_AC0BC855BA8DFDFC9B50518DDAA326A0"},"type":"chat","timestamp":1770041355,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC6B0F218106692D8F7EF893F6C35913	Para ver	0	t	chat	\N	35	2026-02-12 01:07:45.417+00	2026-02-12 01:40:30.453+00	f	f	37	\N	1	\N	{"id":{"fromMe":false,"remote":"180599583166652@lid","id":"AC6B0F218106692D8F7EF893F6C35913","_serialized":"false_180599583166652@lid_AC6B0F218106692D8F7EF893F6C35913"},"type":"chat","timestamp":1770041362,"from":"180599583166652@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B0A7E957CAD1642FD5C	Pode sim!	0	t	chat	\N	34	2026-02-12 01:07:25.988+00	2026-02-12 01:40:31.518+00	f	f	36	\N	1	\N	{"id":{"fromMe":false,"remote":"141961671520277@lid","id":"3B0A7E957CAD1642FD5C","_serialized":"false_141961671520277@lid_3B0A7E957CAD1642FD5C"},"type":"chat","timestamp":1769685448,"from":"141961671520277@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0BD57AB54B4BCFB5CA6	*Isaac Carvalho:* \nAcessei	0	t	chat	\N	31	2026-02-12 01:06:10.807+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0BD57AB54B4BCFB5CA6","_serialized":"false_73667581095989@lid_3EB0BD57AB54B4BCFB5CA6"},"type":"chat","timestamp":1770233539,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E7B97851546EAEBD85	*Isaac Carvalho:* \nSabe me informar o IP da máquina?	0	t	chat	\N	31	2026-02-12 01:06:11.091+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0E7B97851546EAEBD85","_serialized":"false_73667581095989@lid_3EB0E7B97851546EAEBD85"},"type":"chat","timestamp":1770233546,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09FFC7A72C0B4D54B02	*Isaac Carvalho:* \nQual o login do Putty?	0	t	chat	\N	31	2026-02-12 01:06:13.716+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB09FFC7A72C0B4D54B02","_serialized":"false_73667581095989@lid_3EB09FFC7A72C0B4D54B02"},"type":"chat","timestamp":1770233618,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F6404FE0648D7690E5	*Isaac Carvalho:* \nA senha realmente é bigmaster?	0	t	chat	\N	31	2026-02-12 01:06:15.513+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0F6404FE0648D7690E5","_serialized":"false_73667581095989@lid_3EB0F6404FE0648D7690E5"},"type":"chat","timestamp":1770233912,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB012C823BABF9C4A0939	*Isaac Carvalho:* \nNão está funcionando.	0	t	chat	\N	31	2026-02-12 01:06:17.717+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB012C823BABF9C4A0939","_serialized":"false_73667581095989@lid_3EB012C823BABF9C4A0939"},"type":"chat","timestamp":1770234115,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0170BC318E1E707E585	*Isaac Carvalho:* \nPor ser o final do meu expediente, estarei encaminhando seu atendimento para a fila, ok?	0	t	chat	\N	31	2026-02-12 01:06:19.529+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0170BC318E1E707E585","_serialized":"false_73667581095989@lid_3EB0170BC318E1E707E585"},"type":"chat","timestamp":1770235546,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E1D0DE6F553BBAFAE5	*Isaac Carvalho:* \nTenha uma ótima noite!	0	t	chat	\N	31	2026-02-12 01:06:19.906+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0E1D0DE6F553BBAFAE5","_serialized":"false_73667581095989@lid_3EB0E1D0DE6F553BBAFAE5"},"type":"chat","timestamp":1770235552,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C4FB5849E728001C82	*Jherik Jesus:* \nBoa noite, Marcos! Tudo bem?\n\nPodemos dar seguimento na tratativa deste caso agora?	0	t	chat	\N	31	2026-02-12 01:06:20.268+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0C4FB5849E728001C82","_serialized":"false_73667581095989@lid_3EB0C4FB5849E728001C82"},"type":"chat","timestamp":1770242516,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0FE1C52D6C1893C6D68	*Jherik Jesus:* \nOlá, Marcos! Passados 15 minutos desde o nosso último contato, e como não recebemos os dados essenciais para iniciar o atendimento, estamos procedendo ao encerramento do chat por inatividade. Esta ação é necessária para liberar a fila de atendimento. Por favor, fique à vontade para abrir um novo chat quando estiver disponível para dar seguimento. Estaremos prontos para ajudá-lo(a).	0	t	chat	\N	31	2026-02-12 01:06:20.587+00	2026-02-12 01:40:33.991+00	f	f	33	\N	1	\N	{"id":{"fromMe":false,"remote":"73667581095989@lid","id":"3EB0FE1C52D6C1893C6D68","_serialized":"false_73667581095989@lid_3EB0FE1C52D6C1893C6D68"},"type":"chat","timestamp":1770243961,"from":"73667581095989@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB03B22A541E7651B56A6		4	t	audio	1770858319744-5hx8bt.oga	30	2026-02-12 01:05:19.762+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB03B22A541E7651B56A6","_serialized":"false_181088857157665@lid_3EB03B22A541E7651B56A6"},"type":"ptt","timestamp":1770409370,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"47","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0433A03CFB0B13E3C24	sim	0	t	chat	\N	30	2026-02-12 01:05:22.629+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB0433A03CFB0B13E3C24","_serialized":"false_181088857157665@lid_3EB0433A03CFB0B13E3C24"},"type":"chat","timestamp":1770409427,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0EADF1596F47041B8BC	O Lucas tem acesso	0	t	chat	\N	30	2026-02-12 01:05:28.303+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB0EADF1596F47041B8BC","_serialized":"false_181088857157665@lid_3EB0EADF1596F47041B8BC"},"type":"chat","timestamp":1770409439,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB029297FC6C4C35BD8BF	por pra vc fazer esse levantamento	0	t	chat	\N	30	2026-02-12 01:05:28.86+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB029297FC6C4C35BD8BF","_serialized":"false_181088857157665@lid_3EB029297FC6C4C35BD8BF"},"type":"chat","timestamp":1770409450,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B08BBAE281AA4BB72D	primeiro vc precisará do sistema	0	t	chat	\N	30	2026-02-12 01:05:31.299+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB0B08BBAE281AA4BB72D","_serialized":"false_181088857157665@lid_3EB0B08BBAE281AA4BB72D"},"type":"chat","timestamp":1770409462,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05B98E61C5F24F6E288	Hoje ainda pagamos o logiprix onde ele dá o sugestão de preço e todo o levantamento do preço de custo	0	t	chat	\N	30	2026-02-12 01:05:44.53+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB05B98E61C5F24F6E288","_serialized":"false_181088857157665@lid_3EB05B98E61C5F24F6E288"},"type":"chat","timestamp":1770409520,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB09F3C4B978F7FAC752B	ok	0	t	chat	\N	30	2026-02-12 01:05:47.418+00	2026-02-12 01:40:35.644+00	f	f	32	\N	1	\N	{"id":{"fromMe":false,"remote":"181088857157665@lid","id":"3EB09F3C4B978F7FAC752B","_serialized":"false_181088857157665@lid_3EB09F3C4B978F7FAC752B"},"type":"chat","timestamp":1770409894,"from":"181088857157665@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC3D0E9E36444EACC5889C26B139CD2E	Essas saíram agora	0	t	chat	\N	16	2026-02-12 00:59:42.257+00	2026-02-12 01:40:45.973+00	f	f	17	A5F7EAF73B4F26B87D6A6672E79E7CB9	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC3D0E9E36444EACC5889C26B139CD2E","_serialized":"false_131752601366700@lid_AC3D0E9E36444EACC5889C26B139CD2E"},"type":"chat","timestamp":1770143487,"from":"131752601366700@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC0BCBBA97F11F645C009D27D6AB1A98	Aqui bugou	0	t	chat	\N	16	2026-02-12 00:59:43.539+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC0BCBBA97F11F645C009D27D6AB1A98","_serialized":"false_131752601366700@lid_AC0BCBBA97F11F645C009D27D6AB1A98"},"type":"chat","timestamp":1770145409,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACFB6BB8F042F8A78D29D0D1922248CE	Não está lançando as vendas	0	t	chat	\N	16	2026-02-12 00:59:43.738+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACFB6BB8F042F8A78D29D0D1922248CE","_serialized":"false_131752601366700@lid_ACFB6BB8F042F8A78D29D0D1922248CE"},"type":"chat","timestamp":1770145418,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC9C96EE39B362417782F929E31E2118	Sistema lento	0	t	chat	\N	16	2026-02-12 00:59:46.132+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC9C96EE39B362417782F929E31E2118","_serialized":"false_131752601366700@lid_AC9C96EE39B362417782F929E31E2118"},"type":"chat","timestamp":1770147459,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB46A49A25D49C4526CB192D2189E5F	Bom dia	0	t	chat	\N	16	2026-02-12 00:59:48.134+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACB46A49A25D49C4526CB192D2189E5F","_serialized":"false_131752601366700@lid_ACB46A49A25D49C4526CB192D2189E5F"},"type":"chat","timestamp":1770391940,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACBC93C09D26824B4022FA0434F73D06	Sistema caiu	0	t	chat	\N	16	2026-02-12 00:59:48.326+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACBC93C09D26824B4022FA0434F73D06","_serialized":"false_131752601366700@lid_ACBC93C09D26824B4022FA0434F73D06"},"type":"chat","timestamp":1770391944,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC4CBA28542A305099462BCE14C0579A	Então essas faixas que estão na frente da farmácia tb entram nesse quesito né?	0	t	chat	\N	16	2026-02-12 00:59:50.27+00	2026-02-12 01:40:45.973+00	f	f	17	A56BE5C466425F7D984B62DE64046DA2	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"AC4CBA28542A305099462BCE14C0579A","_serialized":"false_131752601366700@lid_AC4CBA28542A305099462BCE14C0579A"},"type":"chat","timestamp":1770761066,"from":"131752601366700@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB0BA879B5622C9A4458FFC21FDC929		4	t	audio	1770857991984-0u5llo.oga	16	2026-02-12 00:59:51.985+00	2026-02-12 01:40:45.973+00	f	f	17	\N	1	\N	{"id":{"fromMe":false,"remote":"131752601366700@lid","id":"ACB0BA879B5622C9A4458FFC21FDC929","_serialized":"false_131752601366700@lid_ACB0BA879B5622C9A4458FFC21FDC929"},"type":"ptt","timestamp":1770761294,"from":"131752601366700@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"40","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC0D85308AC075316AD18684DE440F84	Um momento	0	t	chat	\N	28	2026-02-12 01:04:20.282+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"AC0D85308AC075316AD18684DE440F84","_serialized":"false_10098005029093@lid_AC0D85308AC075316AD18684DE440F84"},"type":"chat","timestamp":1769796804,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC7DADCB1A74509CB0B887F1B814BC7E		4	t	audio	1770858260794-tpjx5c.oga	28	2026-02-12 01:04:20.801+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"AC7DADCB1A74509CB0B887F1B814BC7E","_serialized":"false_10098005029093@lid_AC7DADCB1A74509CB0B887F1B814BC7E"},"type":"ptt","timestamp":1769796825,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"14","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC4A34BF479B4F2DB9838DC3B0D4C368	Marcos já verifiquei aqui que deu certo. O pessoal me passou certinho e encaminhei para o Luan subir pra você 😉	0	t	chat	\N	28	2026-02-12 01:04:20.998+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"AC4A34BF479B4F2DB9838DC3B0D4C368","_serialized":"false_10098005029093@lid_AC4A34BF479B4F2DB9838DC3B0D4C368"},"type":"chat","timestamp":1769800762,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0603D406235D9824446	Olá, bom dia Marcos	0	t	chat	\N	28	2026-02-12 01:04:23.018+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB0603D406235D9824446","_serialized":"false_10098005029093@lid_3EB0603D406235D9824446"},"type":"chat","timestamp":1770642180,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB02DB04F8817223C8A67	tudo bem?	0	t	chat	\N	28	2026-02-12 01:04:23.347+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB02DB04F8817223C8A67","_serialized":"false_10098005029093@lid_3EB02DB04F8817223C8A67"},"type":"chat","timestamp":1770642183,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B9F8B6972C46EE0CF3	bem graças a Deus	0	t	chat	\N	28	2026-02-12 01:04:28.502+00	2026-02-12 01:40:36.558+00	f	f	31	\N	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB0B9F8B6972C46EE0CF3","_serialized":"false_10098005029093@lid_3EB0B9F8B6972C46EE0CF3"},"type":"chat","timestamp":1770642245,"from":"10098005029093@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C6EB708D8E7BAA57B4	vamos lá	0	t	chat	\N	28	2026-02-12 01:04:28.699+00	2026-02-12 01:40:36.558+00	f	f	31	A55B219504E3079E462E36C2421D71BC	1	\N	{"id":{"fromMe":false,"remote":"10098005029093@lid","id":"3EB0C6EB708D8E7BAA57B4","_serialized":"false_10098005029093@lid_3EB0C6EB708D8E7BAA57B4"},"type":"chat","timestamp":1770642250,"from":"10098005029093@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0C98223B9BBE7525C45	OIE	0	t	chat	\N	25	2026-02-12 01:03:16.358+00	2026-02-12 01:40:38.591+00	f	f	28	\N	1	\N	{"id":{"fromMe":false,"remote":"46733589512194@lid","id":"3EB0C98223B9BBE7525C45","_serialized":"false_46733589512194@lid_3EB0C98223B9BBE7525C45"},"type":"chat","timestamp":1770666981,"from":"46733589512194@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A548E95A011816C130284E8E5AEE8C87		4	f	audio	1770900653364-71zv1l.oga	11	2026-02-12 12:50:53.382+00	2026-02-12 12:51:14.779+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A548E95A011816C130284E8E5AEE8C87","_serialized":"false_164703422648560@lid_A548E95A011816C130284E8E5AEE8C87"},"type":"ptt","timestamp":1770900652,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"15","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
ACDC8482D2162716A006C88E4B9FA858		0	t	audio	1770858222562-82cyi.oga	27	2026-02-12 01:03:42.563+00	2026-02-12 01:40:37.262+00	f	f	30	\N	1	\N	{"id":{"fromMe":false,"remote":"102036091740395@lid","id":"ACDC8482D2162716A006C88E4B9FA858","_serialized":"false_102036091740395@lid_ACDC8482D2162716A006C88E4B9FA858"},"type":"ptt","timestamp":1770644137,"from":"102036091740395@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"1","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC05B4D6D6662A555C4BF2A2FB4BF0BA	Ela já aceitou	0	t	chat	\N	27	2026-02-12 01:03:48.619+00	2026-02-12 01:40:37.262+00	f	f	30	\N	1	\N	{"id":{"fromMe":false,"remote":"102036091740395@lid","id":"AC05B4D6D6662A555C4BF2A2FB4BF0BA","_serialized":"false_102036091740395@lid_AC05B4D6D6662A555C4BF2A2FB4BF0BA"},"type":"chat","timestamp":1770644186,"from":"102036091740395@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB001A3C04B05E733E647	luan estava mexendo aqui mas continua a mesma coisa	0	t	chat	\N	27	2026-02-12 01:03:57.93+00	2026-02-12 01:40:37.262+00	f	f	30	3EB0CE18FB5E6C1D8E6B47	1	\N	{"id":{"fromMe":false,"remote":"102036091740395@lid","id":"3EB001A3C04B05E733E647","_serialized":"false_102036091740395@lid_3EB001A3C04B05E733E647"},"type":"chat","timestamp":1770647403,"from":"102036091740395@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0566F65B8B94818E425	simone	0	t	chat	\N	27	2026-02-12 01:04:03.317+00	2026-02-12 01:40:37.262+00	f	f	30	\N	1	\N	{"id":{"fromMe":false,"remote":"102036091740395@lid","id":"3EB0566F65B8B94818E425","_serialized":"false_102036091740395@lid_3EB0566F65B8B94818E425"},"type":"chat","timestamp":1770648610,"from":"102036091740395@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0B9ECE99D849783BE93	tem previsao de volta?	0	t	chat	\N	27	2026-02-12 01:04:07.46+00	2026-02-12 01:40:37.262+00	f	f	30	\N	1	\N	{"id":{"fromMe":false,"remote":"102036091740395@lid","id":"3EB0B9ECE99D849783BE93","_serialized":"false_102036091740395@lid_3EB0B9ECE99D849783BE93"},"type":"chat","timestamp":1770648680,"from":"102036091740395@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CF9B3A3057E416242E	ok	0	t	chat	\N	27	2026-02-12 01:04:12.59+00	2026-02-12 01:40:37.262+00	f	f	30	\N	1	\N	{"id":{"fromMe":false,"remote":"102036091740395@lid","id":"3EB0CF9B3A3057E416242E","_serialized":"false_102036091740395@lid_3EB0CF9B3A3057E416242E"},"type":"chat","timestamp":1770648717,"from":"102036091740395@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC344ECC74286E639AEDDD33EB084528	Pode see qdo eu for embora ele acessar	0	t	chat	\N	26	2026-02-12 01:03:19.922+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC344ECC74286E639AEDDD33EB084528","_serialized":"false_107464628424786@lid_AC344ECC74286E639AEDDD33EB084528"},"type":"chat","timestamp":1770057153,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACD3FB1A04FE4156ED7833200D34938F	Agora nao da	0	t	chat	\N	26	2026-02-12 01:03:20.106+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"ACD3FB1A04FE4156ED7833200D34938F","_serialized":"false_107464628424786@lid_ACD3FB1A04FE4156ED7833200D34938F"},"type":"chat","timestamp":1770057156,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC4C525F6B49EA01FCC1E4EF744E1045	Tenho tantas coisas pra mim entregar amanhã	0	t	chat	\N	26	2026-02-12 01:03:20.298+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC4C525F6B49EA01FCC1E4EF744E1045","_serialized":"false_107464628424786@lid_AC4C525F6B49EA01FCC1E4EF744E1045"},"type":"chat","timestamp":1770057165,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC61643EE5DBA01BE74EC85F01C05206	Se eu nao terminar hj	0	t	chat	\N	26	2026-02-12 01:03:24.327+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC61643EE5DBA01BE74EC85F01C05206","_serialized":"false_107464628424786@lid_AC61643EE5DBA01BE74EC85F01C05206"},"type":"chat","timestamp":1770057176,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC625AE9307177C9FFC90B29F3DB9A97	Amanha to ferrada e mal paga	0	t	chat	\N	26	2026-02-12 01:03:26.523+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC625AE9307177C9FFC90B29F3DB9A97","_serialized":"false_107464628424786@lid_AC625AE9307177C9FFC90B29F3DB9A97"},"type":"chat","timestamp":1770057183,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACFDADC4B2B00863D01205691F2B50F5	Mas posso mexer cm ele acessando	0	t	chat	\N	26	2026-02-12 01:03:26.727+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"ACFDADC4B2B00863D01205691F2B50F5","_serialized":"false_107464628424786@lid_ACFDADC4B2B00863D01205691F2B50F5"},"type":"chat","timestamp":1770057193,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACD356A776DF850FA313F341000F0E09	????	0	t	chat	\N	26	2026-02-12 01:03:26.914+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"ACD356A776DF850FA313F341000F0E09","_serialized":"false_107464628424786@lid_ACD356A776DF850FA313F341000F0E09"},"type":"chat","timestamp":1770057463,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC4B325E67C810E8063A3326CF3F77B8	Homem me mandou msg	0	t	chat	\N	26	2026-02-12 01:03:36.81+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC4B325E67C810E8063A3326CF3F77B8","_serialized":"false_107464628424786@lid_AC4B325E67C810E8063A3326CF3F77B8"},"type":"chat","timestamp":1770654062,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACD8E17B1B164D7E4528123432A2B30A	Ta bem	0	t	chat	\N	26	2026-02-12 01:03:38.718+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"ACD8E17B1B164D7E4528123432A2B30A","_serialized":"false_107464628424786@lid_ACD8E17B1B164D7E4528123432A2B30A"},"type":"chat","timestamp":1770655363,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC1AE7619AD8991D7A5DA270B0F4CDE1	Por nada	0	t	chat	\N	26	2026-02-12 01:03:38.925+00	2026-02-12 01:40:37.958+00	f	f	29	\N	1	\N	{"id":{"fromMe":false,"remote":"107464628424786@lid","id":"AC1AE7619AD8991D7A5DA270B0F4CDE1","_serialized":"false_107464628424786@lid_AC1AE7619AD8991D7A5DA270B0F4CDE1"},"type":"chat","timestamp":1770655366,"from":"107464628424786@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
2A3331CD3D01289C4C50	O servidor estava com Windows 11 pro. Ontem noite consegui instalar Windows server 2016 … ou seja até ontem ainda tava essa questão da instalação do Windows … porém ontem mesmo conversando com Lucas … ainda não tem aonde instalar o servidor … eu preciso que tenha local pra eu não ir lá só pra deixar o servidor.	0	t	chat	\N	20	2026-02-12 01:01:29.439+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"2A3331CD3D01289C4C50","_serialized":"false_139891446939660@lid_2A3331CD3D01289C4C50"},"type":"chat","timestamp":1770726692,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
2A7436E0572A5174928B	Sim vê com ele se já tem local pra deixar o servidor funcionado com monitor	0	t	chat	\N	20	2026-02-12 01:01:35.137+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"2A7436E0572A5174928B","_serialized":"false_139891446939660@lid_2A7436E0572A5174928B"},"type":"chat","timestamp":1770726761,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BF304595598C12B504F	certo o local esta decidido então!	0	t	chat	\N	20	2026-02-12 01:01:44.322+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"3BF304595598C12B504F","_serialized":"false_139891446939660@lid_3BF304595598C12B504F"},"type":"chat","timestamp":1770728732,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BD93E0EF198FC9F6BF1	blz	0	t	chat	\N	20	2026-02-12 01:01:46.597+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"3BD93E0EF198FC9F6BF1","_serialized":"false_139891446939660@lid_3BD93E0EF198FC9F6BF1"},"type":"chat","timestamp":1770728749,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BB76DFB44BDF6BDBEE2	vou depois do almoço	0	t	chat	\N	20	2026-02-12 01:01:46.936+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"3BB76DFB44BDF6BDBEE2","_serialized":"false_139891446939660@lid_3BB76DFB44BDF6BDBEE2"},"type":"chat","timestamp":1770728782,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B169A175C205FCBD21F	to baixando atualizacoes do servidor	0	t	chat	\N	20	2026-02-12 01:01:47.283+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"3B169A175C205FCBD21F","_serialized":"false_139891446939660@lid_3B169A175C205FCBD21F"},"type":"chat","timestamp":1770728797,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B7C24F6B5BBA9584F7F	e vendo questao dos drive de video	0	t	chat	\N	20	2026-02-12 01:01:47.667+00	2026-02-12 01:40:42.317+00	f	f	21	\N	1	\N	{"id":{"fromMe":false,"remote":"139891446939660@lid","id":"3B7C24F6B5BBA9584F7F","_serialized":"false_139891446939660@lid_3B7C24F6B5BBA9584F7F"},"type":"chat","timestamp":1770728814,"from":"139891446939660@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC97604C26B919F326EDAB8DCF606CC2		4	t	audio	1770858010801-h03j9.oga	18	2026-02-12 01:00:10.803+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC97604C26B919F326EDAB8DCF606CC2","_serialized":"false_236837582979101@lid_AC97604C26B919F326EDAB8DCF606CC2"},"type":"ptt","timestamp":1769567316,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"7","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC30C5E5B47B8E1A302DEA5AEB1283C6		0	t	image	1770858011390-9li986.jpeg	18	2026-02-12 01:00:11.405+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC30C5E5B47B8E1A302DEA5AEB1283C6","_serialized":"false_236837582979101@lid_AC30C5E5B47B8E1A302DEA5AEB1283C6"},"type":"image","timestamp":1769567324,"from":"236837582979101@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC067D39AB47752223E92B69D9139B7B	Foi	0	t	chat	\N	18	2026-02-12 01:00:11.73+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC067D39AB47752223E92B69D9139B7B","_serialized":"false_236837582979101@lid_AC067D39AB47752223E92B69D9139B7B"},"type":"chat","timestamp":1769567340,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC1627A99E505B06DAC26BCDFDB6968B	1831910042	0	t	chat	\N	18	2026-02-12 01:00:13.711+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC1627A99E505B06DAC26BCDFDB6968B","_serialized":"false_236837582979101@lid_AC1627A99E505B06DAC26BCDFDB6968B"},"type":"chat","timestamp":1769567348,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACFAC62C487208F6031E3AAEE127FA57		4	t	audio	1770858192917-ko0dg.oga	24	2026-02-12 01:03:12.925+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACFAC62C487208F6031E3AAEE127FA57","_serialized":"false_175681342312561@lid_ACFAC62C487208F6031E3AAEE127FA57"},"type":"ptt","timestamp":1770651494,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"9","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACBEFB291DE68B0869681C802527894A		4	t	audio	1770858193694-h2da6.oga	24	2026-02-12 01:03:13.701+00	2026-02-12 01:40:39.913+00	f	f	25	\N	1	\N	{"id":{"fromMe":false,"remote":"175681342312561@lid","id":"ACBEFB291DE68B0869681C802527894A","_serialized":"false_175681342312561@lid_ACBEFB291DE68B0869681C802527894A"},"type":"ptt","timestamp":1770651502,"from":"175681342312561@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"6","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A56863CD84DFBB60407BADBEE952E3C2	Bom dia \nCardápio do dia /06/02/2026\n\n*Arroz \n\n*Feijão \n\n*Macarrão \n\n*Mandioca cozida\n\n*Maionese \n\n*Purê \n\n*Maionese de beterraba \n\n*Mix de legumes\n\n*Cabotia \n\n*Salada de beterraba \n\n*Salada \n\nOpção de carne\n\n*Fricassê de frango \n\n*Frango assado \n\n*Churrasco \n\n*Linguiça Toscana	0	t	chat	\N	22	2026-02-12 01:02:15.058+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A56863CD84DFBB60407BADBEE952E3C2","_serialized":"false_254618613325979@lid_A56863CD84DFBB60407BADBEE952E3C2"},"type":"chat","timestamp":1770385296,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":true,"forwardingScore":1,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A52FFBD854D46F00272E34C295989F4E	Ok	0	t	chat	\N	22	2026-02-12 01:02:19.301+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A52FFBD854D46F00272E34C295989F4E","_serialized":"false_254618613325979@lid_A52FFBD854D46F00272E34C295989F4E"},"type":"chat","timestamp":1770389798,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A531D9FC43B67C453ECE94F8C553275D	Ok	0	t	chat	\N	22	2026-02-12 01:02:22.778+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A531D9FC43B67C453ECE94F8C553275D","_serialized":"false_254618613325979@lid_A531D9FC43B67C453ECE94F8C553275D"},"type":"chat","timestamp":1770389893,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A559B6674B50D19A8DF56ED2DF05C4FC	É pra anotar a sua marmita	0	t	chat	\N	22	2026-02-12 01:02:24.282+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A559B6674B50D19A8DF56ED2DF05C4FC","_serialized":"false_254618613325979@lid_A559B6674B50D19A8DF56ED2DF05C4FC"},"type":"chat","timestamp":1770405339,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A587AB6EB7DEED87974F6672644D3E0B		0	t	chat	\N	22	2026-02-12 01:02:27.303+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A587AB6EB7DEED87974F6672644D3E0B","_serialized":"false_254618613325979@lid_A587AB6EB7DEED87974F6672644D3E0B"},"type":"interactive","timestamp":1770406663,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A58DC4BC0F249ED36D0F564CB29CCF32	18.00	0	t	chat	\N	22	2026-02-12 01:02:27.65+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A58DC4BC0F249ED36D0F564CB29CCF32","_serialized":"false_254618613325979@lid_A58DC4BC0F249ED36D0F564CB29CCF32"},"type":"chat","timestamp":1770406671,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5E58050C67434694A8D9513DE004FAF	A de 15 é menor	0	t	chat	\N	22	2026-02-12 01:02:30.486+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A5E58050C67434694A8D9513DE004FAF","_serialized":"false_254618613325979@lid_A5E58050C67434694A8D9513DE004FAF"},"type":"chat","timestamp":1770409725,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A580E53808CE771BEE8F4AB69AA399B9	Entrega de 1 só sai de 18.00 a cima pra não cobrar taxa de entrega	0	t	chat	\N	22	2026-02-12 01:02:35.739+00	2026-02-12 01:40:40.738+00	f	f	23	\N	1	\N	{"id":{"fromMe":false,"remote":"254618613325979@lid","id":"A580E53808CE771BEE8F4AB69AA399B9","_serialized":"false_254618613325979@lid_A580E53808CE771BEE8F4AB69AA399B9"},"type":"chat","timestamp":1770410223,"from":"254618613325979@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919C47995FD26283C	*Nicole Assis - Consultora Comercial:*\nBom dia Marcos 	0	t	chat	\N	21	2026-02-12 01:01:58.956+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00919C47995FD26283C","_serialized":"false_159541543100490@lid_3EB00919C47995FD26283C"},"type":"chat","timestamp":1770727760,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00719C479A140D75939	*Nicole Assis - Consultora Comercial:*\nOntem tive problemas de saúde e não estava disponível 	0	t	chat	\N	21	2026-02-12 01:01:59.265+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00719C479A140D75939","_serialized":"false_159541543100490@lid_3EB00719C479A140D75939"},"type":"chat","timestamp":1770727806,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00119C479D8E5D0FEBA	*Nicole Assis - Consultora Comercial:*\nBom, desde quando fechamos o sistema, e algo que conversamos, o sistema da único e usado dentro da api oficial, como sua equipe precisava conhecer o sistema até o número ser verificado liberamos, mas assim que fosse aprovado pela meta o número seria migrado para a oficial, isso não e uma exceção todos os clientes da único estão dentro da oficial.\nIsso e algo que conversamos bem antes de você implantar o sistema, minha diretoria está me cobrando a respeito disso, e não da pra ficar fora da oficial pelos riscos que corre, e uma regra da empresa, sei que vai entender porque na rede que trabalha tem as regras a serem cumpridas, quero resolver da melhor forma, mas fora da oficial não tem como prosseguir com o sistema 	0	t	chat	\N	21	2026-02-12 01:01:59.603+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00119C479D8E5D0FEBA","_serialized":"false_159541543100490@lid_3EB00119C479D8E5D0FEBA"},"type":"chat","timestamp":1770728035,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00519C47AA309272D4F	*Nicole Assis - Consultora Comercial:*\nSupervisor do suporte, ok deram continuidade ? 	0	t	chat	\N	21	2026-02-12 01:02:10.032+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00519C47AA309272D4F","_serialized":"false_159541543100490@lid_3EB00519C47AA309272D4F"},"type":"chat","timestamp":1770728862,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00519C47B54C9DC4395	*Nicole Assis - Consultora Comercial:*\nCerto	0	t	chat	\N	21	2026-02-12 01:02:13.822+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00519C47B54C9DC4395","_serialized":"false_159541543100490@lid_3EB00519C47B54C9DC4395"},"type":"chat","timestamp":1770729590,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00119C47B57FA195DAB	*Nicole Assis - Consultora Comercial:*\nE os meninos do suporte conseguiram te ajudar no problema que estava tendo ?	0	t	chat	\N	21	2026-02-12 01:02:14.328+00	2026-02-12 01:40:41.408+00	f	f	22	\N	1	\N	{"id":{"fromMe":false,"remote":"159541543100490@lid","id":"3EB00119C47B57FA195DAB","_serialized":"false_159541543100490@lid_3EB00119C47B57FA195DAB"},"type":"chat","timestamp":1770729603,"from":"159541543100490@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AE3D816CCCE4356CD80	😂	0	t	chat	\N	12	2026-02-12 00:58:48.669+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3AE3D816CCCE4356CD80","_serialized":"false_133865742024877@lid_3AE3D816CCCE4356CD80"},"type":"chat","timestamp":1770062075,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A81BDE6AA1D6C348F4C	Vai acha eles aí	0	t	chat	\N	12	2026-02-12 00:58:48.865+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A81BDE6AA1D6C348F4C","_serialized":"false_133865742024877@lid_3A81BDE6AA1D6C348F4C"},"type":"chat","timestamp":1770062083,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A731DA1B27DEDB04FA5	Bom dia	0	t	chat	\N	12	2026-02-12 00:58:50.202+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A731DA1B27DEDB04FA5","_serialized":"false_133865742024877@lid_3A731DA1B27DEDB04FA5"},"type":"chat","timestamp":1770815609,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A90E2FB2E60601CCC37	O fio estou aqui na Júlio Campos	0	t	chat	\N	12	2026-02-12 00:58:50.998+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A90E2FB2E60601CCC37","_serialized":"false_133865742024877@lid_3A90E2FB2E60601CCC37"},"type":"chat","timestamp":1770816211,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A540A13AA43381419DD	Pessoal me disse que está caindo ligação da Fernando Correia aqui	0	t	chat	\N	12	2026-02-12 00:58:51.174+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A540A13AA43381419DD","_serialized":"false_133865742024877@lid_3A540A13AA43381419DD"},"type":"chat","timestamp":1770816229,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A0ECF535637C83C4E32	Opa de nada	0	t	chat	\N	12	2026-02-12 00:58:53.154+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A0ECF535637C83C4E32","_serialized":"false_133865742024877@lid_3A0ECF535637C83C4E32"},"type":"chat","timestamp":1770816368,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A6224FF60F4F4DC3531	Oi	0	t	chat	\N	12	2026-02-12 00:58:53.852+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A6224FF60F4F4DC3531","_serialized":"false_133865742024877@lid_3A6224FF60F4F4DC3531"},"type":"chat","timestamp":1770816859,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A352BDDC9AE8369B022	Já não sei dizer \nEstava aqui balconista atendeu e cliente perguntou se era da loja Fernando \nAí ele pediu pra liga de novo	0	t	chat	\N	12	2026-02-12 00:58:55.466+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A352BDDC9AE8369B022","_serialized":"false_133865742024877@lid_3A352BDDC9AE8369B022"},"type":"chat","timestamp":1770816920,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB009C7A9CBCCC9A582A1	Boa tarde Marcos,	0	t	chat	\N	19	2026-02-12 01:01:08.083+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB009C7A9CBCCC9A582A1","_serialized":"false_156504699232288@lid_3EB009C7A9CBCCC9A582A1"},"type":"chat","timestamp":1769626137,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB01CEDA99A2B8FEEF31E	Tudo indo bem, melhorando	0	t	chat	\N	19	2026-02-12 01:01:08.342+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB01CEDA99A2B8FEEF31E","_serialized":"false_156504699232288@lid_3EB01CEDA99A2B8FEEF31E"},"type":"chat","timestamp":1769626149,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0CE0F1A6C59B3B67A55	Agora estou na ativa em casa	0	t	chat	\N	19	2026-02-12 01:01:14.168+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB0CE0F1A6C59B3B67A55","_serialized":"false_156504699232288@lid_3EB0CE0F1A6C59B3B67A55"},"type":"chat","timestamp":1769626215,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB05F8EDC2B69D575687D	Manda ai	0	t	chat	\N	19	2026-02-12 01:01:14.462+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB05F8EDC2B69D575687D","_serialized":"false_156504699232288@lid_3EB05F8EDC2B69D575687D"},"type":"chat","timestamp":1769626219,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0F2AA62DCD61691B7E6	Bom dia Marcos	0	t	chat	\N	19	2026-02-12 01:01:24.761+00	2026-02-12 01:40:43.426+00	f	f	20	\N	1	\N	{"id":{"fromMe":false,"remote":"156504699232288@lid","id":"3EB0F2AA62DCD61691B7E6","_serialized":"false_156504699232288@lid_3EB0F2AA62DCD61691B7E6"},"type":"chat","timestamp":1770041650,"from":"156504699232288@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A58DBF14BA2721BC25B	Está mexendo no sistema ?	0	t	chat	\N	14	2026-02-12 00:59:18.742+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A58DBF14BA2721BC25B","_serialized":"false_125271831228508@lid_3A58DBF14BA2721BC25B"},"type":"chat","timestamp":1770143589,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A736CC4D63BE5EEE25A		0	t	image	1770857961845-qylegk.jpeg	14	2026-02-12 00:59:21.85+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A736CC4D63BE5EEE25A","_serialized":"false_125271831228508@lid_3A736CC4D63BE5EEE25A"},"type":"image","timestamp":1770143619,"from":"125271831228508@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A478F8808A23AEF8874		4	t	audio	1770857963970-7e8m58.oga	14	2026-02-12 00:59:23.973+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A478F8808A23AEF8874","_serialized":"false_125271831228508@lid_3A478F8808A23AEF8874"},"type":"ptt","timestamp":1770144338,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"2","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A786ADEB1015C829398	Não está indo de novo	0	t	chat	\N	14	2026-02-12 00:59:24.396+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A786ADEB1015C829398","_serialized":"false_125271831228508@lid_3A786ADEB1015C829398"},"type":"chat","timestamp":1770145503,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A2B9E14A5C401DA46C4	Blz fechou	0	t	chat	\N	14	2026-02-12 00:59:28.479+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A2B9E14A5C401DA46C4","_serialized":"false_125271831228508@lid_3A2B9E14A5C401DA46C4"},"type":"chat","timestamp":1770725532,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A0D75977F41BE35C5B3		4	t	audio	1770857968887-hzb6j2.oga	14	2026-02-12 00:59:28.89+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A0D75977F41BE35C5B3","_serialized":"false_125271831228508@lid_3A0D75977F41BE35C5B3"},"type":"ptt","timestamp":1770815480,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"9","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A28C873C6BE0CE2E432	E da Simone ?	0	t	chat	\N	14	2026-02-12 00:59:30.923+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A28C873C6BE0CE2E432","_serialized":"false_125271831228508@lid_3A28C873C6BE0CE2E432"},"type":"chat","timestamp":1770816710,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A84D5B1CEE0B0F0E226	Ok, obrigado	0	t	chat	\N	14	2026-02-12 00:59:32.249+00	2026-02-12 01:40:47.732+00	f	f	14	\N	1	\N	{"id":{"fromMe":false,"remote":"125271831228508@lid","id":"3A84D5B1CEE0B0F0E226","_serialized":"false_125271831228508@lid_3A84D5B1CEE0B0F0E226"},"type":"chat","timestamp":1770816764,"from":"125271831228508@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACC614542B83125C4BF120323BAEE9B2	Blz	0	t	chat	\N	18	2026-02-12 01:00:13.884+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"ACC614542B83125C4BF120323BAEE9B2","_serialized":"false_236837582979101@lid_ACC614542B83125C4BF120323BAEE9B2"},"type":"chat","timestamp":1769567446,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC953322A4F28C5BB1FFE6CA964CBFD4	Obrigado Marcos	0	t	chat	\N	18	2026-02-12 01:00:14.092+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC953322A4F28C5BB1FFE6CA964CBFD4","_serialized":"false_236837582979101@lid_AC953322A4F28C5BB1FFE6CA964CBFD4"},"type":"chat","timestamp":1769567450,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACD0CB8FF804E98CDE07A4716EE35A69		4	t	audio	1770858014698-gsvjqk.oga	18	2026-02-12 01:00:14.703+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"ACD0CB8FF804E98CDE07A4716EE35A69","_serialized":"false_236837582979101@lid_ACD0CB8FF804E98CDE07A4716EE35A69"},"type":"ptt","timestamp":1769901778,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"8","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC398AAFE74A4FCDBF4D4D53674EE257		0	t	video	1770858022141-mt7cst.mp4	18	2026-02-12 01:00:22.446+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC398AAFE74A4FCDBF4D4D53674EE257","_serialized":"false_236837582979101@lid_AC398AAFE74A4FCDBF4D4D53674EE257"},"type":"video","timestamp":1770163148,"from":"236837582979101@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"75","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC6ACCED8DE9DA18FBA9C92800CCBD9C	Marcos \nSobre mandar a localização para motoboy, vamos ter que começar a avisar o cliente que nao conseguimos mandar a localização para motoboy e que ele ira ligar para o cliente pedindo?	0	t	chat	\N	18	2026-02-12 01:00:24.837+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC6ACCED8DE9DA18FBA9C92800CCBD9C","_serialized":"false_236837582979101@lid_AC6ACCED8DE9DA18FBA9C92800CCBD9C"},"type":"chat","timestamp":1770170953,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC14CA80731AE5B2886F33E36EA9A5C8	Ok	0	t	chat	\N	18	2026-02-12 01:00:32.015+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC14CA80731AE5B2886F33E36EA9A5C8","_serialized":"false_236837582979101@lid_AC14CA80731AE5B2886F33E36EA9A5C8"},"type":"chat","timestamp":1770243588,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC7B5F7FB6FD5B6590BF2D2ADB9C9E5A		0	t	audio	1770858032474-t9l8iu.oga	18	2026-02-12 01:00:32.482+00	2026-02-12 01:40:44.36+00	f	f	19	\N	1	\N	{"id":{"fromMe":false,"remote":"236837582979101@lid","id":"AC7B5F7FB6FD5B6590BF2D2ADB9C9E5A","_serialized":"false_236837582979101@lid_AC7B5F7FB6FD5B6590BF2D2ADB9C9E5A"},"type":"ptt","timestamp":1770423151,"from":"236837582979101@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"28","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B8D399DD060C82788E8	Alinhamento é agora	0	t	chat	\N	15	2026-02-12 00:59:33.442+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3B8D399DD060C82788E8","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3B8D399DD060C82788E8_189309424541837@lid"},"type":"chat","timestamp":1770814150,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BFE2BFF16F69DEBFF90	bora	0	t	chat	\N	15	2026-02-12 00:59:33.67+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3BFE2BFF16F69DEBFF90","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3BFE2BFF16F69DEBFF90_189309424541837@lid"},"type":"chat","timestamp":1770814151,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B32F6D295004DDF99EA	lá	0	t	chat	\N	15	2026-02-12 00:59:33.902+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3B32F6D295004DDF99EA","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3B32F6D295004DDF99EA_189309424541837@lid"},"type":"chat","timestamp":1770814152,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B7CBB1112480DB22E4E	cria ai a sala	0	t	chat	\N	15	2026-02-12 00:59:34.098+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3B7CBB1112480DB22E4E","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3B7CBB1112480DB22E4E_189309424541837@lid"},"type":"chat","timestamp":1770814155,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BD5CF78B043B9E838ED	por favor	0	t	chat	\N	15	2026-02-12 00:59:34.297+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3BD5CF78B043B9E838ED","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3BD5CF78B043B9E838ED_189309424541837@lid"},"type":"chat","timestamp":1770814156,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3ABEEF00952C8E8D602C	Continua voltando né	0	t	chat	\N	17	2026-02-12 00:59:54.781+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3ABEEF00952C8E8D602C","_serialized":"false_128050339545203@lid_3ABEEF00952C8E8D602C"},"type":"chat","timestamp":1770740476,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A0B0C65AC62706BC3BB	Voltou	0	t	chat	\N	17	2026-02-12 00:59:59.823+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3A0B0C65AC62706BC3BB","_serialized":"false_128050339545203@lid_3A0B0C65AC62706BC3BB"},"type":"chat","timestamp":1770740579,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA061316013473ED10F	No outro tbm	0	t	chat	\N	17	2026-02-12 01:00:00.721+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3AA061316013473ED10F","_serialized":"false_128050339545203@lid_3AA061316013473ED10F"},"type":"chat","timestamp":1770740740,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AD2DEFBD7E41514C013	1081380145	0	t	chat	\N	17	2026-02-12 01:00:02.264+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3AD2DEFBD7E41514C013","_serialized":"false_128050339545203@lid_3AD2DEFBD7E41514C013"},"type":"chat","timestamp":1770740936,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3ABE9978976583A9C85B	Fechou agora pouco da forma que vc pediu	0	t	chat	\N	17	2026-02-12 01:00:03.713+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3ABE9978976583A9C85B","_serialized":"false_128050339545203@lid_3ABE9978976583A9C85B"},"type":"chat","timestamp":1770741035,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A40C0DCED0CC57DF5D0	Não voltou	0	t	chat	\N	17	2026-02-12 01:00:03.934+00	2026-02-12 01:40:44.834+00	f	f	18	\N	1	\N	{"id":{"fromMe":false,"remote":"128050339545203@lid","id":"3A40C0DCED0CC57DF5D0","_serialized":"false_128050339545203@lid_3A40C0DCED0CC57DF5D0"},"type":"chat","timestamp":1770741039,"from":"128050339545203@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A595F060896C94B9894869BB8679960C		4	f	audio	1770900731637-d750u1.oga	11	2026-02-12 12:52:11.64+00	2026-02-12 12:52:11.966+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A595F060896C94B9894869BB8679960C","_serialized":"false_164703422648560@lid_A595F060896C94B9894869BB8679960C"},"type":"ptt","timestamp":1770900730,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"3","vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3A5BD0BB15A316404E61	Eu queria ver com você	0	t	chat	\N	13	2026-02-12 00:59:04.499+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A5BD0BB15A316404E61","_serialized":"false_58939920105695@lid_3A5BD0BB15A316404E61"},"type":"chat","timestamp":1770640636,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A97B9AACD0074FFC66E	Se você tem acesso para alterar minha senha do\nVetor ?	0	t	chat	\N	13	2026-02-12 00:59:04.691+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A97B9AACD0074FFC66E","_serialized":"false_58939920105695@lid_3A97B9AACD0074FFC66E"},"type":"chat","timestamp":1770640647,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A72468667DB7F4290BC	Na verdade	0	t	chat	\N	13	2026-02-12 00:59:04.879+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A72468667DB7F4290BC","_serialized":"false_58939920105695@lid_3A72468667DB7F4290BC"},"type":"chat","timestamp":1770640652,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AEF180ECD5978557F07	Eu errei minha senha e não consigo acessar o vetor	0	t	chat	\N	13	2026-02-12 00:59:05.073+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3AEF180ECD5978557F07","_serialized":"false_58939920105695@lid_3AEF180ECD5978557F07"},"type":"chat","timestamp":1770640672,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AAD257BBAB549A0AA88	Blz	0	t	chat	\N	13	2026-02-12 00:59:07.226+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3AAD257BBAB549A0AA88","_serialized":"false_58939920105695@lid_3AAD257BBAB549A0AA88"},"type":"chat","timestamp":1770640796,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A88DA4E794837685FB9		0	t	video	1770857950716-5t5uup.mp4	13	2026-02-12 00:59:10.729+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A88DA4E794837685FB9","_serialized":"false_58939920105695@lid_3A88DA4E794837685FB9"},"type":"video","timestamp":1770643106,"from":"58939920105695@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"14","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A79B93C0748067C9847		0	t	image	1770857952104-refyzi.jpeg	13	2026-02-12 00:59:12.112+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A79B93C0748067C9847","_serialized":"false_58939920105695@lid_3A79B93C0748067C9847"},"type":"image","timestamp":1770643179,"from":"58939920105695@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3B4E93886652A4F14EF9	vamos logo rosolver o que será feito	0	t	chat	\N	15	2026-02-12 00:59:34.857+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3B4E93886652A4F14EF9","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3B4E93886652A4F14EF9_189309424541837@lid"},"type":"chat","timestamp":1770814166,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0E81C750218A9192F28	https://teams.microsoft.com/meet/21066221310316?p=Ea8VvpnNua6taLtg0c	0	t	chat	\N	15	2026-02-12 00:59:35.129+00	2026-02-12 01:40:46.866+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3EB0E81C750218A9192F28","participant":{"server":"lid","user":"7202811162779","_serialized":"7202811162779@lid"},"_serialized":"false_120363405293949287@g.us_3EB0E81C750218A9192F28_7202811162779@lid"},"type":"chat","timestamp":1770814171,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB045BB0F6A0BDA4C79C8	Vou abrir no celular aqui.	0	t	chat	\N	15	2026-02-12 00:59:35.339+00	2026-02-12 01:40:46.866+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3EB045BB0F6A0BDA4C79C8","participant":{"server":"lid","user":"7202811162779","_serialized":"7202811162779@lid"},"_serialized":"false_120363405293949287@g.us_3EB045BB0F6A0BDA4C79C8_7202811162779@lid"},"type":"chat","timestamp":1770814205,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3BF4FABA61A1C95C49CE	@151909402964196 @164703422648560 Bora!	0	t	chat	\N	15	2026-02-12 00:59:35.555+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3BF4FABA61A1C95C49CE","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3BF4FABA61A1C95C49CE_189309424541837@lid"},"type":"chat","timestamp":1770814311,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},{"server":"lid","user":"151909402964196","_serialized":"151909402964196@lid"}],"isGif":false}	\N	\N	f	new	\N
A5480D0A4FF186A770D69957590485B2	Bora	0	t	chat	\N	15	2026-02-12 00:59:35.897+00	2026-02-12 01:40:46.866+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"A5480D0A4FF186A770D69957590485B2","participant":{"server":"lid","user":"164703422648560","_serialized":"164703422648560@lid"},"_serialized":"false_120363405293949287@g.us_A5480D0A4FF186A770D69957590485B2_164703422648560@lid"},"type":"chat","timestamp":1770814466,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"164703422648560@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A1D8B71443EF99D5399	Tamu esperando	0	t	chat	\N	15	2026-02-12 00:59:36.119+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A1D8B71443EF99D5399","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3A1D8B71443EF99D5399_189309424541837@lid"},"type":"chat","timestamp":1770814528,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AA0C9CD6476D14E5C06	Bora lá gente	0	t	chat	\N	15	2026-02-12 00:59:36.374+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AA0C9CD6476D14E5C06","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3AA0C9CD6476D14E5C06_189309424541837@lid"},"type":"chat","timestamp":1770814533,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A709BF60A092DE99489	Dia 28!	0	t	chat	\N	15	2026-02-12 00:59:39.555+00	2026-02-12 01:40:46.866+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3A709BF60A092DE99489","participant":{"server":"lid","user":"7202811162779","_serialized":"7202811162779@lid"},"_serialized":"false_120363405293949287@g.us_3A709BF60A092DE99489_7202811162779@lid"},"type":"chat","timestamp":1770815033,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3AAF481EE92A36BBCE73	Todas as lojas	0	t	chat	\N	15	2026-02-12 00:59:39.778+00	2026-02-12 01:40:46.866+00	f	f	16	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3AAF481EE92A36BBCE73","participant":{"server":"lid","user":"189309424541837","_serialized":"189309424541837@lid"},"_serialized":"false_120363405293949287@g.us_3AAF481EE92A36BBCE73_189309424541837@lid"},"type":"chat","timestamp":1770815321,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"189309424541837@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0416A354026532C6CB6	Feito, te envio o cronograma dia 13.	0	t	chat	\N	15	2026-02-12 00:59:39.98+00	2026-02-12 01:40:46.866+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3EB0416A354026532C6CB6","participant":{"server":"lid","user":"7202811162779","_serialized":"7202811162779@lid"},"_serialized":"false_120363405293949287@g.us_3EB0416A354026532C6CB6_7202811162779@lid"},"type":"chat","timestamp":1770815363,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB0971AC856F297570A05	Começamos a virar na segunda.	0	t	chat	\N	15	2026-02-12 00:59:40.189+00	2026-02-12 01:40:46.866+00	f	f	4	\N	1	\N	{"id":{"fromMe":false,"remote":"120363405293949287@g.us","id":"3EB0971AC856F297570A05","participant":{"server":"lid","user":"7202811162779","_serialized":"7202811162779@lid"},"_serialized":"false_120363405293949287@g.us_3EB0971AC856F297570A05_7202811162779@lid"},"type":"chat","timestamp":1770815386,"from":"120363405293949287@g.us","to":"556592694840@c.us","author":"7202811162779@lid","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A0BD7425F7AC6031B68		0	t	image	1770857953626-8jcxln.jpeg	13	2026-02-12 00:59:13.628+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A0BD7425F7AC6031B68","_serialized":"false_58939920105695@lid_3A0BD7425F7AC6031B68"},"type":"image","timestamp":1770643254,"from":"58939920105695@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A162D6F3FB0065FD4E0	Esse ?	0	t	chat	\N	13	2026-02-12 00:59:13.847+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A162D6F3FB0065FD4E0","_serialized":"false_58939920105695@lid_3A162D6F3FB0065FD4E0"},"type":"chat","timestamp":1770643255,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A63A140D5E440935FDB	BEGIN:VCARD\nVERSION:3.0\nN:;Convenio;;;\nFN:Convenio \nTEL;type=CELL;type=VOICE;waid=556592014523:+55 65 99201-4523\nEND:VCARD	0	t	vcard	\N	13	2026-02-12 00:59:17.874+00	2026-02-12 01:40:48.38+00	f	f	13	\N	1	\N	{"id":{"fromMe":false,"remote":"58939920105695@lid","id":"3A63A140D5E440935FDB","_serialized":"false_58939920105695@lid_3A63A140D5E440935FDB"},"type":"vcard","timestamp":1770643527,"from":"58939920105695@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":["BEGIN:VCARD\\nVERSION:3.0\\nN:;Convenio;;;\\nFN:Convenio \\nTEL;type=CELL;type=VOICE;waid=556592014523:+55 65 99201-4523\\nEND:VCARD"],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC16E32B3B41459752D38BC8CB83C997		0	t	video	1770857897545-6dn6fc.mp4	9	2026-02-12 00:58:17.562+00	2026-02-12 01:40:50.738+00	f	f	9	\N	1	\N	{"id":{"fromMe":false,"remote":"225606126018578@lid","id":"AC16E32B3B41459752D38BC8CB83C997","_serialized":"false_225606126018578@lid_AC16E32B3B41459752D38BC8CB83C997"},"type":"video","timestamp":1770829134,"from":"225606126018578@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"6","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC9459BC659AAD9D936A3D2D356E7F66	Não é self-service	0	t	chat	\N	9	2026-02-12 00:58:22.927+00	2026-02-12 01:40:50.738+00	f	f	9	\N	1	\N	{"id":{"fromMe":false,"remote":"225606126018578@lid","id":"AC9459BC659AAD9D936A3D2D356E7F66","_serialized":"false_225606126018578@lid_AC9459BC659AAD9D936A3D2D356E7F66"},"type":"chat","timestamp":1770829155,"from":"225606126018578@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC59A06C6CA6F6C580316E77F35CECFF	Ta	0	t	chat	\N	9	2026-02-12 00:58:23.84+00	2026-02-12 01:40:50.738+00	f	f	9	\N	1	\N	{"id":{"fromMe":false,"remote":"225606126018578@lid","id":"AC59A06C6CA6F6C580316E77F35CECFF","_serialized":"false_225606126018578@lid_AC59A06C6CA6F6C580316E77F35CECFF"},"type":"chat","timestamp":1770829161,"from":"225606126018578@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
ACB8E6B9609318EAFA880348384090BC		4	t	audio	1770857905533-kry1spd.oga	9	2026-02-12 00:58:25.535+00	2026-02-12 01:40:50.738+00	f	f	9	\N	1	\N	{"id":{"fromMe":false,"remote":"225606126018578@lid","id":"ACB8E6B9609318EAFA880348384090BC","_serialized":"false_225606126018578@lid_ACB8E6B9609318EAFA880348384090BC"},"type":"ptt","timestamp":1770829177,"from":"225606126018578@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":true,"hasQuotedMsg":false,"duration":"12","vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC8E75DA1515BDA2DB627B8A9C7AAB52	🙌🏻🙌🏻	0	t	chat	\N	9	2026-02-12 00:58:32.347+00	2026-02-12 01:40:50.738+00	f	f	9	\N	1	\N	{"id":{"fromMe":false,"remote":"225606126018578@lid","id":"AC8E75DA1515BDA2DB627B8A9C7AAB52","_serialized":"false_225606126018578@lid_AC8E75DA1515BDA2DB627B8A9C7AAB52"},"type":"chat","timestamp":1770833885,"from":"225606126018578@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
AC022B79A00FF155F15D95F083C895A4	Beleza	1	f	chat	\N	48	2026-02-12 12:53:03.386+00	2026-02-12 12:53:03.437+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC022B79A00FF155F15D95F083C895A4","_serialized":"false_2194761883822@lid_AC022B79A00FF155F15D95F083C895A4"},"type":"chat","timestamp":1770900782,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
AC759E1F1A6679B7FE9AB2F62F0DD04E	Mudei a porta mas está na mesma	1	f	chat	\N	48	2026-02-12 12:53:08.564+00	2026-02-12 12:53:08.584+00	f	f	56	\N	1	\N	{"id":{"fromMe":false,"remote":"2194761883822@lid","id":"AC759E1F1A6679B7FE9AB2F62F0DD04E","_serialized":"false_2194761883822@lid_AC759E1F1A6679B7FE9AB2F62F0DD04E"},"type":"chat","timestamp":1770900788,"from":"2194761883822@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
3AEA8086877C1BC7CA85	Ele me relatou já estava tendo episódio assim aqui	0	t	chat	\N	12	2026-02-12 00:58:55.658+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3AEA8086877C1BC7CA85","_serialized":"false_133865742024877@lid_3AEA8086877C1BC7CA85"},"type":"chat","timestamp":1770816942,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3A0E18993CC8AC7F94F4	Blz combinado	0	t	chat	\N	12	2026-02-12 00:58:58.762+00	2026-02-12 01:40:48.927+00	f	f	12	\N	1	\N	{"id":{"fromMe":false,"remote":"133865742024877@lid","id":"3A0E18993CC8AC7F94F4","_serialized":"false_133865742024877@lid_3A0E18993CC8AC7F94F4"},"type":"chat","timestamp":1770823716,"from":"133865742024877@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5EC3D1DE2FBD65E46BE49321EE926A2	65996132483	0	t	chat	\N	11	2026-02-12 00:58:35.005+00	2026-02-12 01:40:49.459+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5EC3D1DE2FBD65E46BE49321EE926A2","_serialized":"false_164703422648560@lid_A5EC3D1DE2FBD65E46BE49321EE926A2"},"type":"chat","timestamp":1770815482,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5F7A6FCED2F425C964F973C310F6311	Mas acho q ja esta no cnpj da matriz	0	t	chat	\N	11	2026-02-12 00:58:35.334+00	2026-02-12 01:40:49.459+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5F7A6FCED2F425C964F973C310F6311","_serialized":"false_164703422648560@lid_A5F7A6FCED2F425C964F973C310F6311"},"type":"chat","timestamp":1770815491,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A5DB5F782C628E97A1B6A3E9B57A3574	Fala com gerente pra baixar pra consumo	0	t	chat	\N	11	2026-02-12 00:58:38.515+00	2026-02-12 01:40:49.459+00	f	f	11	A559A1E4F8FFA4FCCCC4DC6205A4A3C7	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A5DB5F782C628E97A1B6A3E9B57A3574","_serialized":"false_164703422648560@lid_A5DB5F782C628E97A1B6A3E9B57A3574"},"type":"chat","timestamp":1770816698,"from":"164703422648560@lid","to":"556592694840@c.us","forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":true,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
A51FBFB009C0D4464B3E85EA2DEDDA86	Sobre remarcar a agenda, amanhã consigo às 17h,  16h de Cuiabá.	0	t	chat	\N	11	2026-02-12 00:58:39.817+00	2026-02-12 01:40:49.459+00	f	f	11	\N	1	\N	{"id":{"fromMe":false,"remote":"164703422648560@lid","id":"A51FBFB009C0D4464B3E85EA2DEDDA86","_serialized":"false_164703422648560@lid_A51FBFB009C0D4464B3E85EA2DEDDA86"},"type":"chat","timestamp":1770820065,"from":"164703422648560@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"broadcast":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	\N	f	new	\N
3EB00919C51EB27040CFC5	O protocolo do seu atendimento é: 26021209391008351	1	f	chat	\N	25	2026-02-12 12:54:53.076+00	2026-02-12 12:54:53.116+00	f	f	28	\N	1	\N	{"id":{"fromMe":false,"remote":"46733589512194@lid","id":"3EB00919C51EB27040CFC5","_serialized":"false_46733589512194@lid_3EB00919C51EB27040CFC5"},"type":"chat","timestamp":1770900892,"from":"46733589512194@lid","to":"556592694840@c.us","isForwarded":false,"forwardingScore":0,"isStatus":false,"isStarred":false,"hasMedia":false,"hasQuotedMsg":false,"vCards":[],"mentionedIds":[],"isGif":false}	\N	1	f	new	\N
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
13	13	1	\N	1	2026-02-12 00:59:04.471+00	2026-02-12 01:40:48.407+00	\N	2026-02-12 01:40:48.406+00	\N	\N	f	\N
33	33	1	\N	1	2026-02-12 01:06:58.338+00	2026-02-12 01:40:32.358+00	\N	2026-02-12 01:40:32.358+00	\N	\N	f	\N
1	1	1	\N	1	2026-02-12 00:33:15.117+00	2026-02-12 00:38:51.111+00	\N	2026-02-12 00:38:32.164+00	2026-02-12 00:38:50.798+00	\N	f	\N
2	2	1	\N	1	2026-02-12 00:41:04.608+00	2026-02-12 00:41:19.291+00	\N	2026-02-12 00:41:19.291+00	\N	\N	f	\N
32	32	1	\N	1	2026-02-12 01:06:21.675+00	2026-02-12 01:40:33.515+00	\N	2026-02-12 01:40:33.515+00	\N	\N	f	\N
3	3	1	\N	1	2026-02-12 00:41:38.53+00	2026-02-12 00:41:58.483+00	\N	2026-02-12 00:41:58.483+00	\N	\N	f	\N
5	5	1	\N	\N	2026-02-12 00:57:32.803+00	2026-02-12 00:57:32.803+00	\N	\N	\N	\N	f	\N
6	6	1	\N	\N	2026-02-12 00:57:40.195+00	2026-02-12 00:57:40.195+00	\N	\N	\N	\N	f	\N
7	7	1	\N	\N	2026-02-12 00:57:52.635+00	2026-02-12 00:57:52.635+00	\N	\N	\N	\N	f	\N
8	8	1	\N	\N	2026-02-12 00:58:04.583+00	2026-02-12 00:58:04.583+00	\N	\N	\N	\N	f	\N
12	12	1	\N	1	2026-02-12 00:58:48.642+00	2026-02-12 01:40:48.992+00	\N	2026-02-12 01:40:48.992+00	\N	\N	f	\N
45	45	1	\N	1	2026-02-12 01:17:07.021+00	2026-02-12 01:40:09.571+00	\N	2026-02-12 01:40:09.57+00	\N	\N	f	\N
31	31	1	\N	1	2026-02-12 01:05:59.446+00	2026-02-12 01:40:34.04+00	\N	2026-02-12 01:40:34.04+00	\N	\N	f	\N
44	44	1	\N	1	2026-02-12 01:16:25.979+00	2026-02-12 01:40:13.363+00	\N	2026-02-12 01:40:13.363+00	\N	\N	f	\N
29	29	1	\N	1	2026-02-12 01:04:38.965+00	2026-02-12 01:40:16.49+00	\N	2026-02-12 01:40:16.489+00	\N	\N	f	\N
30	30	1	\N	1	2026-02-12 01:05:19.065+00	2026-02-12 01:40:35.864+00	\N	2026-02-12 01:40:35.864+00	\N	\N	f	\N
23	23	1	\N	1	2026-02-12 01:02:43.433+00	2026-02-12 01:40:18.232+00	\N	2026-02-12 01:40:18.231+00	\N	\N	f	\N
11	11	1	\N	1	2026-02-12 00:58:34.995+00	2026-02-12 01:40:49.533+00	\N	2026-02-12 01:40:49.532+00	\N	\N	f	\N
46	46	1	\N	1	2026-02-12 01:17:54.66+00	2026-02-12 01:40:19.275+00	\N	2026-02-12 01:40:19.275+00	\N	\N	f	\N
28	28	1	\N	1	2026-02-12 01:04:20.063+00	2026-02-12 01:40:36.639+00	\N	2026-02-12 01:40:36.639+00	\N	\N	f	\N
47	47	1	\N	1	2026-02-12 01:18:31.783+00	2026-02-12 01:40:20.307+00	\N	2026-02-12 01:40:20.307+00	\N	\N	f	\N
4	4	1	\N	1	2026-02-12 00:57:11.159+00	2026-02-12 01:40:21.242+00	\N	2026-02-12 01:40:21.242+00	\N	\N	f	\N
27	27	1	\N	1	2026-02-12 01:03:42.048+00	2026-02-12 01:40:37.442+00	\N	2026-02-12 01:40:37.441+00	\N	\N	f	\N
43	43	1	\N	1	2026-02-12 01:15:32.759+00	2026-02-12 01:40:22.524+00	\N	2026-02-12 01:40:22.524+00	\N	\N	f	\N
10	10	1	\N	1	2026-02-12 00:58:32.621+00	2026-02-12 01:40:50.151+00	\N	2026-02-12 01:40:50.151+00	\N	\N	f	\N
42	42	1	\N	1	2026-02-12 01:11:46.889+00	2026-02-12 01:40:23.978+00	\N	2026-02-12 01:40:23.976+00	\N	\N	f	\N
26	26	1	\N	1	2026-02-12 01:03:19.909+00	2026-02-12 01:40:38.019+00	\N	2026-02-12 01:40:38.019+00	\N	\N	f	\N
41	41	1	\N	1	2026-02-12 01:11:45.566+00	2026-02-12 01:40:25.403+00	\N	2026-02-12 01:40:25.403+00	\N	\N	f	\N
40	40	1	\N	1	2026-02-12 01:11:03.225+00	2026-02-12 01:40:26.411+00	\N	2026-02-12 01:40:26.41+00	\N	\N	f	\N
25	25	1	\N	1	2026-02-12 01:03:16.341+00	2026-02-12 01:40:38.627+00	\N	2026-02-12 01:40:38.627+00	\N	\N	f	\N
39	39	1	\N	1	2026-02-12 01:10:08.43+00	2026-02-12 01:40:27.409+00	\N	2026-02-12 01:40:27.409+00	\N	\N	f	\N
9	9	1	\N	1	2026-02-12 00:58:16.15+00	2026-02-12 01:40:50.795+00	\N	2026-02-12 01:40:50.794+00	\N	\N	f	\N
38	38	1	\N	1	2026-02-12 01:09:32.833+00	2026-02-12 01:40:28.152+00	\N	2026-02-12 01:40:28.152+00	\N	\N	f	\N
24	24	1	\N	1	2026-02-12 01:02:59.125+00	2026-02-12 01:40:39.978+00	\N	2026-02-12 01:40:39.978+00	\N	\N	f	\N
37	37	1	\N	1	2026-02-12 01:08:41.141+00	2026-02-12 01:40:28.948+00	\N	2026-02-12 01:40:28.947+00	\N	\N	f	\N
48	48	1	\N	\N	2026-02-12 12:02:28.717+00	2026-02-12 12:02:28.717+00	\N	\N	\N	\N	f	\N
36	36	1	\N	1	2026-02-12 01:07:53.347+00	2026-02-12 01:40:29.825+00	\N	2026-02-12 01:40:29.825+00	\N	\N	f	\N
22	22	1	\N	1	2026-02-12 01:02:15.033+00	2026-02-12 01:40:40.788+00	\N	2026-02-12 01:40:40.788+00	\N	\N	f	\N
35	35	1	\N	1	2026-02-12 01:07:40.31+00	2026-02-12 01:40:30.606+00	\N	2026-02-12 01:40:30.606+00	\N	\N	f	\N
34	34	1	\N	1	2026-02-12 01:06:59.833+00	2026-02-12 01:40:31.649+00	\N	2026-02-12 01:40:31.644+00	\N	\N	f	\N
21	21	1	\N	1	2026-02-12 01:01:58.942+00	2026-02-12 01:40:41.595+00	\N	2026-02-12 01:40:41.595+00	\N	\N	f	\N
20	20	1	\N	1	2026-02-12 01:01:29.415+00	2026-02-12 01:40:42.501+00	\N	2026-02-12 01:40:42.501+00	\N	\N	f	\N
19	19	1	\N	1	2026-02-12 01:01:08.07+00	2026-02-12 01:40:43.639+00	\N	2026-02-12 01:40:43.639+00	\N	\N	f	\N
18	18	1	\N	1	2026-02-12 01:00:10.465+00	2026-02-12 01:40:44.439+00	\N	2026-02-12 01:40:44.438+00	\N	\N	f	\N
17	17	1	\N	1	2026-02-12 00:59:54.765+00	2026-02-12 01:40:44.886+00	\N	2026-02-12 01:40:44.885+00	\N	\N	f	\N
16	16	1	\N	1	2026-02-12 00:59:42.232+00	2026-02-12 01:40:46.083+00	\N	2026-02-12 01:40:46.082+00	\N	\N	f	\N
15	15	1	\N	1	2026-02-12 00:59:33.423+00	2026-02-12 01:40:46.968+00	\N	2026-02-12 01:40:46.968+00	\N	\N	f	\N
14	14	1	\N	1	2026-02-12 00:59:18.728+00	2026-02-12 01:40:47.928+00	\N	2026-02-12 01:40:47.928+00	\N	\N	f	\N
64	220	1	\N	\N	2026-02-12 23:48:52.808+00	2026-02-12 23:52:53.093+00	2026-02-12 23:52:53.003+00	\N	2026-02-12 23:52:52.973+00	\N	f	\N
63	215	1	\N	\N	2026-02-12 23:48:46.419+00	2026-02-12 23:52:54.751+00	2026-02-12 23:52:54.67+00	\N	2026-02-12 23:52:54.637+00	\N	f	\N
62	205	1	\N	\N	2026-02-12 23:48:39.352+00	2026-02-12 23:52:55.735+00	2026-02-12 23:52:55.696+00	\N	2026-02-12 23:52:55.688+00	\N	f	\N
61	204	1	\N	\N	2026-02-12 23:48:07.452+00	2026-02-12 23:52:56.706+00	2026-02-12 23:52:56.672+00	\N	2026-02-12 23:52:56.668+00	\N	f	\N
60	193	1	\N	\N	2026-02-12 23:47:59.413+00	2026-02-12 23:52:57.515+00	2026-02-12 23:52:57.464+00	\N	2026-02-12 23:52:57.459+00	\N	f	\N
59	189	1	\N	\N	2026-02-12 23:47:56.725+00	2026-02-12 23:52:58.494+00	2026-02-12 23:52:58.469+00	\N	2026-02-12 23:52:58.467+00	\N	f	\N
58	179	1	\N	\N	2026-02-12 23:47:46.811+00	2026-02-12 23:52:59.392+00	2026-02-12 23:52:59.351+00	\N	2026-02-12 23:52:59.346+00	\N	f	\N
57	169	1	\N	\N	2026-02-12 23:47:30.768+00	2026-02-12 23:53:00.71+00	2026-02-12 23:53:00.677+00	\N	2026-02-12 23:53:00.673+00	\N	f	\N
56	162	1	\N	\N	2026-02-12 23:47:23.955+00	2026-02-12 23:53:01.438+00	2026-02-12 23:53:01.393+00	\N	2026-02-12 23:53:01.389+00	\N	f	\N
55	152	1	\N	\N	2026-02-12 23:47:15.887+00	2026-02-12 23:53:02.249+00	2026-02-12 23:53:02.222+00	\N	2026-02-12 23:53:02.217+00	\N	f	\N
54	144	1	\N	\N	2026-02-12 23:47:08.629+00	2026-02-12 23:53:03.067+00	2026-02-12 23:53:03.015+00	\N	2026-02-12 23:53:03.008+00	\N	f	\N
53	128	1	\N	\N	2026-02-12 23:46:49.991+00	2026-02-12 23:53:03.841+00	2026-02-12 23:53:03.799+00	\N	2026-02-12 23:53:03.796+00	\N	f	\N
52	118	1	\N	\N	2026-02-12 23:46:43.087+00	2026-02-12 23:53:04.523+00	2026-02-12 23:53:04.493+00	\N	2026-02-12 23:53:04.49+00	\N	f	\N
51	108	1	\N	\N	2026-02-12 23:46:34.89+00	2026-02-12 23:53:05.23+00	2026-02-12 23:53:05.199+00	\N	2026-02-12 23:53:05.196+00	\N	f	\N
50	97	1	\N	\N	2026-02-12 23:46:22.115+00	2026-02-12 23:53:06.044+00	2026-02-12 23:53:06.014+00	\N	2026-02-12 23:53:06.01+00	\N	f	\N
49	73	1	\N	\N	2026-02-12 23:45:49.693+00	2026-02-12 23:53:06.686+00	2026-02-12 23:53:06.654+00	\N	2026-02-12 23:53:06.65+00	\N	f	\N
66	97	1	\N	\N	2026-02-12 23:56:21.71+00	2026-02-12 23:56:21.71+00	\N	\N	\N	\N	f	\N
65	228	1	\N	\N	2026-02-12 23:53:58.666+00	2026-02-12 23:56:42.697+00	2026-02-12 23:56:42.662+00	\N	2026-02-12 23:56:42.645+00	\N	f	\N
\.


--
-- Data for Name: Tickets; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Tickets" (id, status, "lastMessage", "contactId", "userId", "createdAt", "updatedAt", "whatsappId", "isGroup", "unreadMessages", "queueId", "companyId", uuid, chatbot, "queueOptionId", "amountUsedBotQueues", "fromMe", "useIntegration", "integrationId", "typebotSessionId", "typebotStatus", "promptId", "lastClientMessageAt", "lastAgentMessageAt", "pendingClientMessages") FROM stdin;
48	open	Obrigado	56	\N	2026-02-12 12:02:28.686+00	2026-02-12 15:05:48.39+00	\N	f	0	1	1	6e1f2727-c3a0-4621-897f-24ee488736a4	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
15	open	Mas pra evitar o spam aqui, te ligo depois.	15	1	2026-02-12 00:59:33.414+00	2026-02-12 12:03:26.001+00	\N	t	2	1	1	b3ea5876-89d4-49df-9999-807d23b324bc	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
13	open	Consegue me ajudar ?	13	1	2026-02-12 00:59:04.466+00	2026-02-12 12:32:33.69+00	\N	f	2	1	1	513b2f8c-2d8a-4abd-b4b5-123f8d8b7d81	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
25	open	O protocolo do seu atendimento é: 26021209391008351	28	1	2026-02-12 01:03:16.326+00	2026-02-12 12:54:53.121+00	\N	f	2	1	1	e3b9cf77-84a0-4338-8716-582b1a8b2fd9	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
7	pending	Sério 😟😟	7	\N	2026-02-12 00:57:52.624+00	2026-02-12 00:58:01.816+00	\N	f	2	1	1	7663b8f5-1a39-473d-82a0-caedf5f74bab	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
44	open	Sera feito nesse CNPJ ?	51	1	2026-02-12 01:16:25.967+00	2026-02-12 01:54:16.455+00	\N	f	2	1	1	bbee4b6a-0d47-4155-a668-e712a4adb224	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
45	open	Entendi, e claro precisa estabilizar...	52	1	2026-02-12 01:17:06.965+00	2026-02-12 01:54:17.096+00	\N	f	2	1	1	d3bd0bef-4c36-4326-8704-34801aea23fa	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
11	open	Vou logo la entao	11	1	2026-02-12 00:58:34.987+00	2026-02-12 12:57:38.502+00	\N	f	2	1	1	f22b2c52-26a8-4583-9c27-d598fc7aef85	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
21	open	*Nicole Assis - Consultora Comercial:*\nE os meninos do suporte conseguiram te ajudar no problema que estava tendo ?	22	1	2026-02-12 01:01:58.931+00	2026-02-12 01:40:41.478+00	\N	f	0	1	1	5b38e4c3-bd32-4cfb-bb79-076d3115b4a3	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
12	open	Blz combinado	12	1	2026-02-12 00:58:48.636+00	2026-02-12 01:40:48.954+00	\N	f	0	1	1	260b5c53-4bba-43d7-9125-e00d67c30e0c	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
2	open	chat	2	1	2026-02-12 00:41:04.586+00	2026-02-12 00:57:31.361+00	\N	f	2	1	1	6a0354a9-f65d-49c5-a449-416279f1ffe3	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
1	closed	Gostaria de uma avaliação sincera da sua parte sobre meu atendimento. Consegue me ajudar a ser um(a) profissional melhor?\n\nDigite 5️⃣ Muito satisfeito 😍\nDigite 4️⃣ Satisfeito 😀\nDigite 3️⃣ Indiferente 😐\nDigite 2️⃣ Insatisfeito ☹️\nDigite 1️⃣ Extremamente	1	\N	2026-02-12 00:33:15.017+00	2026-02-12 01:01:03.213+00	\N	f	2	1	1	583175cd-47ee-4bf0-9dee-999085f1dd08	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
19	open	Bom dia Marcos	20	1	2026-02-12 01:01:08.063+00	2026-02-12 01:40:43.457+00	\N	f	0	1	1	37cb7284-7cf5-4dc1-ad1d-98d5b97706ee	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
30	open	ok	32	1	2026-02-12 01:05:19.049+00	2026-02-12 01:40:35.72+00	\N	f	0	1	1	b6f38f49-c11b-438b-8493-3e600ac08aef	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
29	open	e esse aqui ne	27	1	2026-02-12 01:04:38.957+00	2026-02-12 01:54:08.399+00	\N	f	2	1	1	608b2ef1-5ff8-4a0c-b6ae-f721cdec374c	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
28	open	NOTA FISCAL Nº 10524.pdf	31	1	2026-02-12 01:04:20.054+00	2026-02-12 01:40:36.593+00	\N	f	0	1	1	476d8ca8-d82e-4a50-a9b9-a849e7e0c770	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
4	open	Boa	4	1	2026-02-12 00:57:11.089+00	2026-02-12 01:40:21.223+00	\N	f	0	1	1	e19100b6-9bb0-4c84-99bd-f70855a5d254	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
16	open	Nesses casos qdo o cliente manda não teria um meio de bloquear?	17	1	2026-02-12 00:59:42.216+00	2026-02-12 12:24:36.233+00	\N	f	2	1	1	c75b909a-e327-4c4e-aa28-ad625decba1d	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
9	open	🙌🏻🙌🏻	9	1	2026-02-12 00:58:16.136+00	2026-02-12 01:40:50.759+00	\N	f	0	1	1	0b8ea422-9490-44a4-8ea4-634aff5e2eaf	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
10	open	Oi	10	1	2026-02-12 00:58:32.606+00	2026-02-12 01:40:50.129+00	\N	f	0	1	1	5bf939ee-50ce-45d1-ad55-e1c67096e1cf	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
22	open	Bom dia \nCardápio do dia /10/02/2026\n\n*Arroz \n\n*Feijão \n\n*Macarrão \n\n*Mandioca cozida\n\n*Batata rústica \n\n*Maionese \n\n*Jiló \n\n*Purê \n\n*Feijão tropeiro \n\n*Mix de legumes\n\n*Salada \n\nOpção de mistura \n\n*Frango assado \n\n*Churrasco \n\n*Linguiça Toscana	23	1	2026-02-12 01:02:15.021+00	2026-02-12 01:40:40.748+00	\N	f	0	1	1	55a00fad-5f81-45f3-9496-dd06ca33e983	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
20	open	servidor finalizado!	21	1	2026-02-12 01:01:29.402+00	2026-02-12 01:40:42.423+00	\N	f	0	1	1	908dacf7-a276-4ff7-98ea-5b2c4ca21b81	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
27	open	ok	30	1	2026-02-12 01:03:41.984+00	2026-02-12 01:40:37.349+00	\N	f	0	1	1	bc292d08-e02f-4eda-975b-0c47be58c031	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
8	pending	- 17% $ 855,00	8	\N	2026-02-12 00:58:04.563+00	2026-02-12 00:58:15.406+00	\N	f	2	1	1	6d8134ab-d56a-45b1-92c5-40402d1fd881	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
31	open	*Jherik Jesus:* \nOlá, Marcos! Passados 15 minutos desde o nosso último contato, e como não recebemos os dados essenciais para iniciar o atendimento, estamos procedendo ao encerramento do chat por inatividade. Esta ação é necessária para liberar a fila de 	33	1	2026-02-12 01:05:59.43+00	2026-02-12 01:40:34.003+00	\N	f	0	1	1	ce955d15-a5d0-416b-a998-f9d9852e2fd5	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
18	open	audio	19	1	2026-02-12 01:00:10.449+00	2026-02-12 01:40:44.382+00	\N	f	0	1	1	11a39345-aef4-4a51-a60e-1b072e7e89b0	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
46	open	Precisaremos finalizar este atendimento devido à falta de interação. Caso queira prosseguir com o atendimento, faça o contato novamente que estaremos dispostos a lhe atender.  Agradecemos o contato, tenha um excelente dia!	53	1	2026-02-12 01:17:54.646+00	2026-02-12 01:40:19.242+00	\N	f	0	1	1	f4941ceb-2c3c-4c12-9ead-a73cf72abcf6	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
14	open	Ok, obrigado	14	1	2026-02-12 00:59:18.722+00	2026-02-12 01:40:47.862+00	\N	f	0	1	1	6fed9821-40e3-43e0-90c4-83b05583f29c	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
3	open	Momento que já conecto	3	1	2026-02-12 00:41:38.477+00	2026-02-12 12:04:54.676+00	\N	f	0	1	1	5ae8b2ae-d557-467f-9d8e-97f6a01eeb34	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
5	pending	Tá bem	5	\N	2026-02-12 00:57:32.789+00	2026-02-12 12:05:09.822+00	\N	f	2	1	1	8add191d-1516-4cce-9637-2c99eaa483b2	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
36	open	🤝	38	1	2026-02-12 01:07:53.323+00	2026-02-12 01:40:29.739+00	\N	f	0	1	1	4c3849ed-001c-4178-935a-234396665b87	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
24	open	image	25	1	2026-02-12 01:02:59.118+00	2026-02-12 11:31:20.226+00	\N	f	2	1	1	b80d41c7-df46-4e56-abde-f2dfffddbf08	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
26	open	Por nada	29	1	2026-02-12 01:03:19.901+00	2026-02-12 01:40:37.991+00	\N	f	0	1	1	5f0ad527-85d2-46a5-b943-9cb949e596b4	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
32	open	Ok	34	1	2026-02-12 01:06:21.658+00	2026-02-12 01:40:33.463+00	\N	f	0	1	1	f626c102-3c8a-4090-a2a0-86708758f275	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
34	open	Tudo bem? Precisa de alguma ajuda com o Instagram da Big Master?	36	1	2026-02-12 01:06:59.823+00	2026-02-12 01:40:31.572+00	\N	f	0	1	1	f6499691-1c5d-4d89-bd7a-6544dfea4a93	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
33	open	*LOJA SHANGRI-LA 02:*\nAgradecemos seu contato, e estaremos sempre à disposição.😉	35	1	2026-02-12 01:06:58.323+00	2026-02-12 01:40:32.32+00	\N	f	0	1	1	8c83af20-ac67-4a17-a969-48ed58712f5f	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
35	open	Ai,Não  sei qual foi o retorno	37	1	2026-02-12 01:07:40.301+00	2026-02-12 01:40:30.491+00	\N	f	0	1	1	1524b408-5fd2-4deb-b66a-3db6f6f1ba39	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
39	open	Qual foi o cliente que ficou sem resposta do atendimento de ontem?	41	1	2026-02-12 01:10:08.415+00	2026-02-12 01:40:27.366+00	\N	f	0	1	1	19156eae-4803-483b-948d-8caf9a2a51da	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
40	open	Viajei!	16	1	2026-02-12 01:11:03.217+00	2026-02-12 01:40:26.369+00	\N	f	0	1	1	787d1275-4592-46eb-b99a-66dc5186c880	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
37	open	uai, porque nao funciona a 13?	39	1	2026-02-12 01:08:41.128+00	2026-02-12 01:40:28.811+00	\N	f	0	1	1	e32aabef-7a6d-469b-bcb8-19b4811369e6	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
38	open	Laura	40	1	2026-02-12 01:09:32.822+00	2026-02-12 01:40:28.125+00	\N	f	0	1	1	4f704756-2060-4b4e-9789-6a83772af53c	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
23	open	Pode ser uma boa.	24	1	2026-02-12 01:02:43.405+00	2026-02-12 01:54:05.19+00	\N	t	2	1	1	a7349574-39e6-4aa8-8249-e7a4a8a0cd5b	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
41	open	*LJFER01:*\nAgradecemos seu contato, e estaremos sempre à disposição.😉	42	1	2026-02-12 01:11:45.554+00	2026-02-12 01:40:25.314+00	\N	f	0	1	1	ac125971-4d98-4df7-aaa6-8556b5293da6	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
42	open	Povo tá enrolado kkkk	43	1	2026-02-12 01:11:46.883+00	2026-02-12 01:40:23.87+00	\N	t	0	1	1	680aa605-9223-4d18-b70d-9e96f92d82a4	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
17	open	Pode usar os computadores né	18	1	2026-02-12 00:59:54.754+00	2026-02-12 01:40:44.854+00	\N	f	0	1	1	64de93e8-7b32-4d60-a691-d5e842870b16	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
47	open	Ana Beatriz Tavares Lima	54	1	2026-02-12 01:18:31.775+00	2026-02-12 01:40:20.249+00	\N	f	0	1	1	bd9a3f25-6c12-4814-91f2-a5403a9c676a	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
43	open	*Apolo*:\nPesquisa de satisfação encerrada por inatividade	50	1	2026-02-12 01:15:31.111+00	2026-02-12 01:40:22.463+00	\N	f	0	1	1	262eef32-8ae2-45c9-8ea3-7d0f9965f7d2	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
6	pending	Olá! 👋\n\nNosso horário de atendimento é de segunda a domingo, das 07:30 às 17:30.\nFora desse período, as respostas podem levar um pouco mais de tempo, mas nossa equipe retornará assim que possível.\n\nAgradecemos a compreensão! 😊\nRise Solutions Network	6	\N	2026-02-12 00:57:40.186+00	2026-02-12 23:31:33.454+00	\N	f	0	1	1	ea97fc09-2afe-4aff-99b4-47849e3ada7a	f	\N	0	f	f	\N	\N	f	\N	\N	\N	0
193	closed	Tmj	68	1	2026-02-12 23:47:59.345+00	2026-02-12 23:52:57.469+00	\N	f	0	2	1	666c8d56-ea71-47a9-bb5b-555e2b9e4a14	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:48:06.284+00	\N	5
189	closed	Não consigo, Luan.\nPode ser amanhã entre 9h e 10h?	67	1	2026-02-12 23:47:56.709+00	2026-02-12 23:52:58.471+00	\N	f	0	2	1	7c609577-bf83-43de-b27a-eaa4b5bb8288	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:47:57.896+00	\N	2
169	closed	pode resolver por ai mesmo	65	1	2026-02-12 23:47:30.753+00	2026-02-12 23:53:00.688+00	\N	f	0	2	1	c4dbd599-71b0-46b8-a428-481494711aca	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:47:38.982+00	\N	6
162	closed	Esse tipo de ação média 3 a 4k	64	1	2026-02-12 23:47:23.92+00	2026-02-12 23:53:01.411+00	\N	f	0	2	1	015f4599-4fe8-4063-8c96-3a4f5b0fa587	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:47:29.863+00	\N	8
152	closed	consigo	63	1	2026-02-12 23:47:15.819+00	2026-02-12 23:53:02.225+00	\N	f	0	2	1	7ac9d6e0-300a-416e-b779-279cbd550090	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:47:22.147+00	\N	7
144	closed	helio falou que ta fazendo outro bkp do performace	62	1	2026-02-12 23:47:08.609+00	2026-02-12 23:53:03.026+00	\N	f	0	2	1	8740e535-1965-419a-a4e4-faee810410e9	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:47:13.016+00	\N	4
73	closed	🎵 Áudio	57	1	2026-02-12 23:45:49.623+00	2026-02-12 23:53:06.657+00	\N	f	0	2	1	f4277ffb-446d-46ef-b00f-56aada1cff57	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:45:59.671+00	\N	7
128	closed	não	61	1	2026-02-12 23:46:49.973+00	2026-02-12 23:53:03.802+00	\N	f	0	2	1	70fe8dba-6680-4337-9690-f15a531e9d0e	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:46:54.917+00	\N	4
118	closed	Blz	60	1	2026-02-12 23:46:43.046+00	2026-02-12 23:53:04.496+00	\N	f	0	2	1	0885a6c8-a8fc-44b3-b670-8c713b067f7f	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:46:47.482+00	\N	4
108	closed	Ok	59	1	2026-02-12 23:46:34.603+00	2026-02-12 23:53:05.203+00	\N	f	0	2	1	7dd1ac9b-6c76-4b84-aba1-989cc701dfd4	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:46:41.357+00	\N	5
97	closed	Sim	58	\N	2026-02-12 23:46:22.095+00	2026-02-12 23:56:21.947+00	\N	f	2	\N	1	436d3982-9993-4b10-954d-ce6f8cd2faa5	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:56:21.868+00	\N	9
220	closed	Tem como mudar	72	1	2026-02-12 23:48:52.777+00	2026-02-12 23:52:53.013+00	\N	f	0	2	1	cb9bd89e-1898-4f15-bbc2-4ef311ff601e	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:48:59.886+00	\N	8
215	closed	Tranquilo, tmj	71	1	2026-02-12 23:48:46.39+00	2026-02-12 23:52:54.687+00	\N	f	0	2	1	d002fee1-efbb-4d27-93fe-218d698faf71	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:48:51.862+00	\N	8
204	closed	Olá, associado (a)\n\nQueremos saber como está sendo sua experiência com o Sicredi.\n\nLevará menos de 1 minuto e não precisamos de nenhum dado seu.\n\nEsta pesquisa fica ativa por 6 horas para que você possa participar e é direcionada à pessoa responsável pela	69	1	2026-02-12 23:48:07.435+00	2026-02-12 23:52:56.677+00	\N	f	0	2	1	231d822f-ebb6-40db-b5b1-260ea8bf8c2c	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:48:35.876+00	\N	8
179	closed	blz ... valeuw	66	1	2026-02-12 23:47:46.795+00	2026-02-12 23:52:59.36+00	\N	f	0	2	1	516f1870-dbcc-43b3-b390-e4220300b4c2	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:47:54.539+00	\N	8
205	closed	Em setembro de 2025 encaminhamos a cobrança referente a um serviço prestado presencialmente.\nNosso financeiro nos informou que, até o momento, o pagamento não foi identificado. Poderia verificar, por favor	70	1	2026-02-12 23:48:39.318+00	2026-02-12 23:52:55.703+00	\N	f	0	2	1	0a7b1c3d-f6b9-46c9-b659-cdc19e36ac37	f	\N	0	f	f	\N	\N	f	\N	2026-02-12 23:48:41.594+00	\N	4
228	closed	mel?	73	1	2026-02-12 23:53:58.641+00	2026-02-12 23:56:42.666+00	\N	f	0	2	1	3628c000-8d6e-41f8-aa6d-20767f3dbdae	f	\N	0	f	f	\N	\N	f	\N	\N	2026-02-12 23:53:58.78+00	0
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
\.


--
-- Data for Name: Whatsapps; Type: TABLE DATA; Schema: public; Owner: bigchat
--

COPY public."Whatsapps" (id, session, qrcode, status, battery, plugged, "createdAt", "updatedAt", name, "isDefault", retries, "greetingMessage", "companyId", "complationMessage", "outOfHoursMessage", "ratingMessage", token, "farewellMessage", provider, "sendIdQueue", "promptId", "integrationId", "maxUseBotQueues", "expiresTicket", "expiresInactiveMessage", "timeUseBotQueues", "transferQueueId", "timeToTransfer", "phoneNumberId", "businessAccountId", "accessToken", "webhookVerifyToken", "metaApiVersion", number) FROM stdin;
5	\N		OPENING	\N	\N	2026-02-14 21:15:03.087+00	2026-02-14 21:15:03.124+00	Atendimento	t	0	Olá seja bem vindo	1	Agradecemos seu contato					beta	\N	\N	\N	3	0		0	\N	\N	\N	\N	\N	\N	v18.0	\N
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

SELECT pg_catalog.setval('public."Contacts_id_seq"', 73, true);


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

SELECT pg_catalog.setval('public."TicketTraking_id_seq"', 66, true);


--
-- Name: Tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bigchat
--

SELECT pg_catalog.setval('public."Tickets_id_seq"', 382, true);


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

SELECT pg_catalog.setval('public."Whatsapps_id_seq"', 5, true);


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

\unrestrict FM3ImpHtWc09tumHSuGGZ8lZkxkWFp1cO4FH34hd9VGknHCV1nCS7NBENSNWRoY

