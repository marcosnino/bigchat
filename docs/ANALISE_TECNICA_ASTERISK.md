# Análise Técnica: Integração BigChat com VoIP Asterisk

**Data:** 11 de Fevereiro de 2026  
**Versão:** 1.0  
**Autor:** Análise Automatizada

---

## Resumo Executivo

O BigChat é um sistema de atendimento multicanal construído sobre uma arquitetura robusta Node.js/TypeScript no backend e React no frontend. A análise revela que o sistema possui uma **arquitetura extensível** que facilita a adição de novos canais de comunicação, como o VoIP via Asterisk.

### Viabilidade: ✅ ALTA

O projeto apresenta pontos de extensão claros para integração com Asterisk:
- Padrão de conexões/providers bem definido (model `Whatsapp` pode servir de template para `Asterisk`)
- Sistema de tickets genérico que suporta diferentes tipos de mídia
- Socket.IO para comunicação em tempo real já implementado
- Filas de atendimento (Bull) para processamento assíncrono
- Frontend modular com componentes reutilizáveis

**Estimativa de Esforço:** 320-480 horas de desenvolvimento (8-12 semanas com equipe de 2 desenvolvedores)

---

## 1. Arquitetura Atual

### 1.1 Estrutura de Pastas

```
bigchat/
├── backend/                    # API Node.js/TypeScript
│   └── src/
│       ├── @types/            # Definições TypeScript
│       ├── config/            # Configurações (auth, upload, database)
│       ├── controllers/       # Controladores REST (34 controllers)
│       ├── database/          # Sequelize + Migrations (130+ migrations)
│       ├── errors/            # Classes de erro personalizadas
│       ├── helpers/           # Funções auxiliares
│       ├── libs/              # Bibliotecas core (socket.ts, wbot.ts)
│       ├── middleware/        # Middlewares (auth, etc.)
│       ├── models/            # Models Sequelize (38 models)
│       ├── routes/            # Rotas Express (34 arquivos)
│       ├── services/          # Lógica de negócio (34 diretórios)
│       └── utils/             # Utilitários (logger, etc.)
├── frontend/                   # React SPA
│   └── src/
│       ├── components/        # 90+ componentes React
│       ├── context/           # Context API (Auth, Socket, WhatsApp)
│       ├── hooks/             # Custom hooks
│       ├── pages/             # Páginas (35 páginas)
│       └── services/          # API client (axios)
├── instalador/                 # Scripts de instalação
└── nginx/                      # Configuração proxy reverso
```

### 1.2 Padrões de Design

| Padrão | Implementação |
|--------|---------------|
| **MVC** | Controllers → Services → Models |
| **Repository** | Services encapsulam acesso a dados |
| **Observer** | Socket.IO para eventos em tempo real |
| **Factory** | `wbot.ts` gerencia instâncias de sessão WhatsApp |
| **Queue** | Bull para processamento assíncrono |
| **Singleton** | Socket.IO (`getIO()`) |

### 1.3 Tecnologias de Comunicação em Tempo Real

**Socket.IO** - Arquivo: [backend/src/libs/socket.ts](backend/src/libs/socket.ts)

```typescript
// Eventos principais:
- connection           → Autenticação e setup de canais
- joinChatBox          → Entrar em sala de ticket específico
- leaveChatBox         → Sair de sala de ticket
- joinNotification     → Inscrição em notificações
- joinTickets          → Inscrição por status (pending/open/closed)
- ready                → Conexão estabelecida
```

**Canais Socket por empresa:**
- `company-{id}-mainchannel` - Canal principal
- `company-{id}-notification` - Notificações
- `company-{id}-{status}` - Tickets por status
- `queue-{id}-pending` - Tickets pendentes por fila
- `user-{id}` - Canal individual do usuário

### 1.4 Sistema de Filas (Bull Queue)

**Arquivo:** [backend/src/queues.ts](backend/src/queues.ts)

```typescript
// Filas implementadas:
- messageQueue         → Envio de mensagens
- scheduleMonitor      → Monitoramento de agendamentos
- sendScheduledMessages → Envio de mensagens agendadas
- campaignQueue        → Processamento de campanhas
- userMonitor          → Monitoramento de usuários
- queueMonitor         → Monitoramento de filas
```

---

## 2. Estrutura de Dados

### 2.1 Models Principais

#### Ticket ([backend/src/models/Ticket.ts](backend/src/models/Ticket.ts))
```typescript
{
  id: number;
  status: string;          // 'pending' | 'open' | 'closed' | 'group'
  unreadMessages: number;
  lastMessage: string;
  isGroup: boolean;
  uuid: string;            // UUID único
  chatbot: boolean;        // Atendimento por bot
  fromMe: boolean;         // Iniciado pelo atendente
  
  // Relacionamentos
  userId: number;          // Atendente atual
  contactId: number;       // Contato/cliente
  whatsappId: number;      // Conexão WhatsApp (EXTENSÍVEL PARA ASTERISK)
  queueId: number;         // Fila de atendimento
  companyId: number;       // Empresa
  promptId: number;        // Prompt de IA
  integrationId: number;   // Integração externa (N8N, Typebot)
}
```

#### Contact ([backend/src/models/Contact.ts](backend/src/models/Contact.ts))
```typescript
{
  id: number;
  name: string;
  number: string;          // Número de telefone
  email: string;
  profilePicUrl: string;
  isGroup: boolean;
  companyId: number;
  whatsappId: number;
  extraInfo: ContactCustomField[];  // Campos personalizados
}
```

#### Message ([backend/src/models/Message.ts](backend/src/models/Message.ts))
```typescript
{
  id: string;              // ID único
  remoteJid: string;       // JID remoto
  body: string;            // Conteúdo texto
  mediaUrl: string;        // URL de mídia (EXTENSÍVEL PARA GRAVAÇÕES)
  mediaType: string;       // Tipo de mídia (PODE SER 'audio/call')
  fromMe: boolean;
  ack: number;             // Status de entrega
  isDeleted: boolean;
  isEdited: boolean;
  ticketId: number;
  contactId: number;
  queueId: number;
}
```

#### Queue ([backend/src/models/Queue.ts](backend/src/models/Queue.ts))
```typescript
{
  id: number;
  name: string;
  color: string;
  greetingMessage: string;
  outOfHoursMessage: string;
  schedules: JSON;         // Horários de funcionamento
  orderQueue: number;      // Ordem de exibição
  companyId: number;
  integrationId: number;   // Integração externa
  promptId: number;        // IA
}
```

#### Whatsapp ([backend/src/models/Whatsapp.ts](backend/src/models/Whatsapp.ts)) - **MODELO PARA ASTERISK**
```typescript
{
  id: number;
  name: string;
  session: string;         // Dados de sessão
  qrcode: string;          // QR Code (não aplicável para Asterisk)
  status: string;          // PENDING | CONNECTED | DISCONNECTED
  
  // Mensagens automáticas
  greetingMessage: string;
  farewellMessage: string;
  complationMessage: string;
  outOfHoursMessage: string;
  ratingMessage: string;
  
  // Configurações
  provider: string;        // 'stable' | 'meta' (PODE SER 'asterisk')
  isDefault: boolean;
  token: string;           // Token de autenticação
  
  // Transferência automática
  transferQueueId: number;
  timeToTransfer: number;
  
  // Expiração
  expiresTicket: number;
  expiresInactiveMessage: string;
  
  // Meta API (campos específicos de canal)
  phoneNumberId: string;
  businessAccountId: string;
  accessToken: string;
  webhookVerifyToken: string;
  metaApiVersion: string;
  
  // Relacionamentos
  queues: Queue[];
  tickets: Ticket[];
  companyId: number;
  promptId: number;
  integrationId: number;
}
```

### 2.2 Diagrama de Relacionamentos

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Company   │────<│    User     │────<│   Ticket    │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                   │
      │                   │                   │
      ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Whatsapp   │────<│   Queue     │────<│   Message   │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                   │
      │                   ▼                   │
      │           ┌─────────────┐            │
      └──────────>│   Contact   │<───────────┘
                  └─────────────┘
                        │
                        ▼
              ┌───────────────────┐
              │ ContactCustomField │
              └───────────────────┘
```

### 2.3 Tracking de Tickets

**TicketTraking** ([backend/src/models/TicketTraking.ts](backend/src/models/TicketTraking.ts))
```typescript
{
  ticketId: number;
  userId: number;          // Atendente
  whatsappId: number;      // Conexão
  rated: boolean;          // Avaliado pelo cliente
  
  // Timestamps
  startedAt: Date;         // Início do atendimento
  queuedAt: Date;          // Entrada na fila
  finishedAt: Date;        // Finalização
  ratingAt: Date;          // Momento da avaliação
  chatbotAt: Date;         // Interação com chatbot
}
```

---

## 3. Sistema de Tickets

### 3.1 Fluxo de Criação de Ticket

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE TICKET                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Mensagem Recebida (wbotMessageListener.ts)              │
│         │                                                   │
│         ▼                                                   │
│  2. FindOrCreateTicketService                               │
│         │                                                   │
│         ├── Busca ticket existente (open/pending/closed)    │
│         │                                                   │
│         ├── Se closed → Reabre como pending                 │
│         │                                                   │
│         └── Se não existe → Cria novo (status: pending)     │
│                   │                                         │
│                   ▼                                         │
│  3. FindOrCreateATicketTrakingService                       │
│         │                                                   │
│         ▼                                                   │
│  4. Emite evento Socket.IO                                  │
│         │                                                   │
│         └── company-{id}-ticket { action: 'update' }        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Estados de Ticket

| Status | Descrição | Ações Permitidas |
|--------|-----------|------------------|
| `pending` | Aguardando atendimento | Aceitar, Transferir, Fechar |
| `open` | Em atendimento | Transferir, Fechar, Resolver |
| `closed` | Finalizado | Reabrir |
| `group` | Grupo (tratamento especial) | Todas |

### 3.3 Serviços de Ticket

| Arquivo | Função |
|---------|--------|
| `CreateTicketService.ts` | Cria ticket manualmente |
| `FindOrCreateTicketService.ts` | Busca ou cria ticket automaticamente |
| `UpdateTicketService.ts` | Atualiza status, atendente, fila |
| `DeleteTicketService.ts` | Remove ticket |
| `ShowTicketService.ts` | Exibe detalhes do ticket |
| `ListTicketsService.ts` | Lista tickets com filtros |
| `ListTicketsServiceKanban.ts` | Lista para visualização Kanban |

### 3.4 Transferência de Tickets

**Arquivo:** [backend/src/services/TicketServices/UpdateTicketService.ts](backend/src/services/TicketServices/UpdateTicketService.ts)

- Transferência entre filas com mensagem automática
- Transferência entre atendentes
- Mensagens traduzidas (pt/en/es)
- Atualização de `TicketTraking`

---

## 4. Integrações Existentes

### 4.1 Padrão de Integração WhatsApp

**Arquitetura:**
```
┌─────────────────────────────────────────────────────────────┐
│                    CAMADA DE ABSTRAÇÃO                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  libs/wbot.ts (Factory)                                     │
│      │                                                      │
│      ├── initWASocket()      → Inicializa conexão           │
│      ├── getWbot()           → Obtém instância              │
│      └── removeWbot()        → Remove conexão               │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  services/WbotServices/                                     │
│      │                                                      │
│      ├── StartAllWhatsAppsSessions.ts                       │
│      ├── StartWhatsAppSession.ts                            │
│      ├── wbotMessageListener.ts    → Processa mensagens     │
│      ├── wbotMonitor.ts            → Monitora conexão       │
│      ├── SendWhatsAppMessage.ts                             │
│      ├── SendWhatsAppMedia.ts                               │
│      └── providers.ts              → Integrações externas   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Eventos de Conexão WhatsApp

```typescript
// libs/wbot.ts
wsocket.ev.on("connection.update", async ({ connection, lastDisconnect, qr }) => {
  // Estados: 'connecting' | 'open' | 'close'
  
  if (connection === "open") {
    // Atualiza status para CONNECTED
    // Emite evento Socket.IO
  }
  
  if (connection === "close") {
    // Tenta reconectar
    // Atualiza status para DISCONNECTED
  }
});
```

### 4.3 Processamento de Mensagens

**Arquivo:** [backend/src/services/WbotServices/wbotMessageListener.ts](backend/src/services/WbotServices/wbotMessageListener.ts) (2339 linhas)

**Fluxo:**
1. Recebe mensagem via evento Baileys
2. Identifica ou cria contato
3. Busca ou cria ticket
4. Salva mensagem no banco
5. Processa chatbot/integrações
6. Emite evento Socket.IO para frontend

### 4.4 Integrações Externas

| Integração | Modelo | Uso |
|------------|--------|-----|
| **N8N** | QueueIntegrations | Workflows automatizados |
| **Typebot** | QueueIntegrations | Chatbot visual |
| **OpenAI** | Prompt | IA para respostas |
| **Asaas** | Settings | Boletos/pagamentos |
| **IXC** | Settings | Sistema de provedor |
| **MK-Auth** | Settings | Sistema de provedor |

### 4.5 Webhooks (Meta API)

**Arquivo:** [backend/src/routes/metaWebhookRoutes.ts](backend/src/routes/metaWebhookRoutes.ts)

- Endpoint para receber webhooks da Meta
- Validação de token
- Processamento de mensagens

---

## 5. Frontend

### 5.1 Componentes Principais

| Componente | Arquivo | Função |
|------------|---------|--------|
| **Ticket** | `components/Ticket/index.js` | Container principal de atendimento |
| **MessagesList** | `components/MessagesList/index.js` | Lista de mensagens do chat |
| **MessageInput** | `components/MessageInputCustom/` | Campo de entrada de mensagens |
| **TicketHeader** | `components/TicketHeader/` | Cabeçalho com info do ticket |
| **TicketActionButtons** | `components/TicketActionButtonsCustom/` | Botões de ação |
| **TicketsList** | `components/TicketsList/` | Lista lateral de tickets |
| **ContactDrawer** | `components/ContactDrawer/` | Drawer com info do contato |

### 5.2 Páginas Relevantes

| Página | Caminho | Função |
|--------|---------|--------|
| **Tickets** | `pages/Tickets/` | Gerenciamento de tickets |
| **TicketsAdvanced** | `pages/TicketsAdvanced/` | Visualização avançada |
| **TicketsCustom** | `pages/TicketsCustom/` | Customização |
| **Connections** | `pages/Connections/` | Gerenciar conexões WhatsApp |
| **Queues** | `pages/Queues/` | Configurar filas |
| **Dashboard** | `pages/Dashboard/` | Métricas e gráficos |

### 5.3 Context API

```javascript
// Contexts disponíveis:
- AuthContext        → Autenticação do usuário
- SocketContext      → Gerenciamento de Socket.IO
- WhatsAppsContext   → Estado das conexões WhatsApp
- ReplyingMessageContext → Mensagem em resposta
```

### 5.4 Sistema de Notificações

**Componente:** `components/NotificationsPopOver/`

- Notificações push via Socket.IO
- Sons de alerta via `components/NotificationsVolume/`
- Badge com contagem de não lidas

---

## 6. Integração Asterisk - Análise Técnica

### 6.1 Pontos de Entrada para Novo Canal

| Local | Arquivo | Ação Necessária |
|-------|---------|-----------------|
| **Model de Conexão** | Criar `models/Asterisk.ts` | Similar a `Whatsapp.ts` |
| **Migration** | Criar migration | Tabela `Asterisks` |
| **Lib de Conexão** | Criar `libs/asterisk.ts` | Similar a `wbot.ts` |
| **Services** | Criar `services/AsteriskServices/` | Handlers de eventos |
| **Controller** | Criar `controllers/AsteriskController.ts` | CRUD de conexões |
| **Routes** | Criar `routes/asteriskRoutes.ts` | Endpoints REST |
| **Frontend Context** | Criar `context/Asterisk/` | Estado das conexões |
| **Frontend Page** | Criar página de conexões Asterisk | UI de gerenciamento |

### 6.2 Modelo Proposto: Channel (Abstração)

Para suportar múltiplos canais de forma limpa, sugere-se criar uma abstração:

```typescript
// models/Channel.ts - PROPOSTA
interface IChannel {
  id: number;
  name: string;
  type: 'whatsapp' | 'asterisk' | 'telegram' | 'email';
  status: 'CONNECTED' | 'DISCONNECTED' | 'CONNECTING';
  config: JSON;  // Configurações específicas do canal
  companyId: number;
  queues: Queue[];
}
```

### 6.3 Modelo Asterisk Proposto

```typescript
// models/Asterisk.ts - PROPOSTA
@Table
class Asterisk extends Model<Asterisk> {
  @PrimaryKey @AutoIncrement @Column
  id: number;

  @Column
  name: string;

  @Column
  status: string;  // 'CONNECTED' | 'DISCONNECTED' | 'CONNECTING'

  // Configuração AMI/ARI
  @Column
  host: string;

  @Column
  port: number;

  @Column
  protocol: string;  // 'ami' | 'ari'

  @Column
  username: string;

  @Column
  password: string;

  // WebRTC
  @Column
  webrtcEnabled: boolean;

  @Column
  stunServer: string;

  @Column
  turnServer: string;

  @Column
  turnUsername: string;

  @Column
  turnPassword: string;

  // Mensagens
  @Column(DataType.TEXT)
  greetingMessage: string;

  @Column(DataType.TEXT)
  holdMessage: string;

  @Column(DataType.TEXT)
  farewellMessage: string;

  // Transferência
  @Column
  transferQueueId: number;

  @Column
  timeToTransfer: number;

  // URA/IVR
  @Column(DataType.JSON)
  ivrConfig: object;

  // Relacionamentos
  @ForeignKey(() => Company) @Column
  companyId: number;

  @BelongsTo(() => Company)
  company: Company;

  @BelongsToMany(() => Queue, () => AsteriskQueue)
  queues: Queue[];

  @HasMany(() => Ticket)
  tickets: Ticket[];
}
```

### 6.4 Modelo CallRecord Proposto

```typescript
// models/CallRecord.ts - PROPOSTA
@Table
class CallRecord extends Model<CallRecord> {
  @PrimaryKey @AutoIncrement @Column
  id: number;

  @Column
  uniqueId: string;  // Asterisk Channel Unique ID

  @Column
  callerId: string;  // Número origem

  @Column
  calledNumber: string;  // Número destino

  @Column
  direction: string;  // 'inbound' | 'outbound'

  @Column
  status: string;  // 'ringing' | 'answered' | 'busy' | 'failed' | 'completed'

  @Column
  duration: number;  // Segundos

  @Column
  holdTime: number;  // Tempo em espera

  @Column
  talkTime: number;  // Tempo de conversa

  @Column
  recordingUrl: string;  // URL da gravação

  @Column(DataType.DATE)
  startedAt: Date;

  @Column(DataType.DATE)
  answeredAt: Date;

  @Column(DataType.DATE)
  endedAt: Date;

  // Relacionamentos
  @ForeignKey(() => Ticket) @Column
  ticketId: number;

  @ForeignKey(() => Asterisk) @Column
  asteriskId: number;

  @ForeignKey(() => User) @Column
  userId: number;

  @ForeignKey(() => Contact) @Column
  contactId: number;

  @ForeignKey(() => Company) @Column
  companyId: number;
}
```

### 6.5 Estrutura para Chamadas

**Estados de Chamada:**
```typescript
enum CallStatus {
  RINGING = 'ringing',       // Chamando
  ANSWERED = 'answered',     // Atendida
  ON_HOLD = 'on_hold',       // Em espera
  TRANSFERRED = 'transferred', // Transferida
  COMPLETED = 'completed',   // Finalizada
  BUSY = 'busy',             // Ocupado
  FAILED = 'failed',         // Falhou
  NO_ANSWER = 'no_answer',   // Não atendeu
  VOICEMAIL = 'voicemail'    // Correio de voz
}
```

### 6.6 Armazenamento de Gravações

**Opção 1: Sistema de arquivos local**
```
backend/public/recordings/
  ├── company-{id}/
  │   ├── 2026/
  │   │   ├── 02/
  │   │   │   ├── {callId}-{timestamp}.wav
  │   │   │   └── {callId}-{timestamp}.mp3
```

**Opção 2: Usar campo existente `mediaUrl` em Message**
- Tipo de mídia: `audio/call-recording`
- URL apontando para arquivo

### 6.7 Eventos Socket.IO para Chamadas

```typescript
// Eventos propostos:
- company-{id}-call          → Eventos de chamada
  - { action: 'ringing', call: {...} }
  - { action: 'answered', call: {...} }
  - { action: 'completed', call: {...} }
  
- company-{id}-asterisk      → Status da conexão
  - { action: 'update', asterisk: {...} }
```

---

## 7. Requisitos Técnicos Asterisk

### 7.1 AMI vs ARI

| Critério | AMI (Manager Interface) | ARI (REST Interface) |
|----------|-------------------------|----------------------|
| **Protocolo** | TCP texto | HTTP REST + WebSocket |
| **Complexidade** | Baixa | Média |
| **Funcionalidades** | Básicas | Avançadas |
| **WebRTC** | Via FreePBX/Configuração externa | Nativo |
| **Recomendação** | Integração simples | Controle total |

**Recomendação:** Usar **ARI** para controle completo e suporte nativo a WebRTC.

### 7.2 Biblioteca Node.js Recomendada

```typescript
// ari-client - Para ARI
import Ari from 'ari-client';

// asterisk-ami - Para AMI
import AsteriskManager from 'asterisk-manager';
```

**Pacotes NPM:**
- `ari-client` - Cliente oficial ARI
- `asterisk-manager` - Cliente AMI
- `jssip` - WebRTC SIP (frontend)
- `simple-peer` - WebRTC P2P

### 7.3 WebRTC Softphone

**Tecnologia:** JsSIP ou SIP.js

```javascript
// Frontend - Inicialização WebRTC
import JsSIP from 'jssip';

const socket = new JsSIP.WebSocketInterface('wss://asterisk.empresa.com:8089/ws');
const configuration = {
  sockets: [socket],
  uri: 'sip:ramal@asterisk.empresa.com',
  password: 'senha',
  register: true
};

const phone = new JsSIP.UA(configuration);
phone.start();

// Eventos
phone.on('newRTCSession', (e) => {
  const session = e.session;
  session.on('progress', () => console.log('Chamando...'));
  session.on('confirmed', () => console.log('Atendida'));
  session.on('ended', () => console.log('Finalizada'));
});
```

### 7.4 Eventos ARI Principais

```typescript
// Eventos a monitorar:
- StasisStart        → Chamada entrou na aplicação
- StasisEnd          → Chamada saiu da aplicação
- ChannelStateChange → Mudança de estado do canal
- ChannelHangupRequest → Pedido de desligamento
- ChannelDtmfReceived → Dígito DTMF recebido
- RecordingStarted   → Gravação iniciada
- RecordingFinished  → Gravação finalizada
```

### 7.5 Configuração Asterisk Necessária

```ini
; /etc/asterisk/ari.conf
[general]
enabled = yes
pretty = yes
allowed_origins = https://bigchat.empresa.com

[bigchat]
type = user
read_only = no
password = senha_segura

; /etc/asterisk/http.conf
[general]
enabled = yes
bindaddr = 0.0.0.0
bindport = 8088
tlsenable = yes
tlsbindaddr = 0.0.0.0:8089
tlscertfile = /etc/asterisk/keys/asterisk.pem
tlsprivatekey = /etc/asterisk/keys/asterisk.key

; /etc/asterisk/extensions.conf
[bigchat-stasis]
exten => _X.,1,Stasis(bigchat,${CALLERID(num)})
```

---

## 8. Diagrama de Fluxo Proposto

### 8.1 Chamada Inbound (Recebida)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        FLUXO CHAMADA INBOUND                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. Chamada entra no Asterisk                                          │
│         │                                                               │
│         ▼                                                               │
│  2. Dialplan executa Stasis(bigchat)                                   │
│         │                                                               │
│         ▼                                                               │
│  3. ARI Client recebe evento StasisStart                               │
│         │                                                               │
│         ▼                                                               │
│  4. AsteriskCallListener.ts processa evento                            │
│         │                                                               │
│         ├── FindOrCreateContact (pelo CallerID)                        │
│         │                                                               │
│         ├── FindOrCreateTicket (status: pending, type: call)           │
│         │                                                               │
│         ├── CreateCallRecord (status: ringing)                         │
│         │                                                               │
│         └── Emite Socket.IO: company-{id}-call { action: 'ringing' }   │
│                   │                                                     │
│                   ▼                                                     │
│  5. Frontend exibe notificação de chamada                              │
│         │                                                               │
│         ├── Modal: "Chamada de +55 11 99999-9999"                      │
│         │                                                               │
│         └── Botões: [Atender] [Rejeitar] [Transferir]                  │
│                   │                                                     │
│                   ▼                                                     │
│  6. Atendente clica "Atender"                                          │
│         │                                                               │
│         ├── POST /api/asterisk/calls/{id}/answer                       │
│         │                                                               │
│         ├── ARI: channel.answer()                                      │
│         │                                                               │
│         ├── Inicia WebRTC via JsSIP                                    │
│         │                                                               │
│         ├── UpdateTicket (status: open, userId: atendente)             │
│         │                                                               │
│         └── UpdateCallRecord (status: answered, answeredAt: now)       │
│                   │                                                     │
│                   ▼                                                     │
│  7. Conversa em andamento                                              │
│         │                                                               │
│         ├── Gravação automática (se configurado)                       │
│         │                                                               │
│         └── Timeline mostra duração em tempo real                      │
│                   │                                                     │
│                   ▼                                                     │
│  8. Chamada finalizada (hangup)                                        │
│         │                                                               │
│         ├── UpdateCallRecord (status: completed, endedAt: now)         │
│         │                                                               │
│         ├── Salva gravação: public/recordings/...                      │
│         │                                                               │
│         ├── Cria Message com tipo 'audio/call' e link para gravação   │
│         │                                                               │
│         └── Emite Socket.IO: company-{id}-call { action: 'completed' } │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 8.2 Chamada Outbound (Realizada)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        FLUXO CHAMADA OUTBOUND                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. Atendente clica em "Ligar" no ticket                               │
│         │                                                               │
│         ▼                                                               │
│  2. Frontend inicia chamada via JsSIP                                  │
│         │                                                               │
│         ├── phone.call('sip:+5511999999999@asterisk')                  │
│         │                                                               │
│         └── POST /api/asterisk/calls/originate                         │
│                   │                                                     │
│                   ▼                                                     │
│  3. Backend processa requisição                                        │
│         │                                                               │
│         ├── ARI: channels.originate()                                  │
│         │                                                               │
│         ├── CreateCallRecord (direction: outbound, status: ringing)    │
│         │                                                               │
│         └── UpdateTicket (lastMessage: "📞 Ligando...")                │
│                   │                                                     │
│                   ▼                                                     │
│  4. Destino atende                                                     │
│         │                                                               │
│         ├── ARI: ChannelStateChange → 'Up'                             │
│         │                                                               │
│         ├── UpdateCallRecord (status: answered)                        │
│         │                                                               │
│         └── Emite Socket.IO: { action: 'answered' }                    │
│                   │                                                     │
│                   ▼                                                     │
│  5. Conversa + Gravação                                                │
│         │                                                               │
│         ▼                                                               │
│  6. Finalização (igual ao inbound)                                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 9. Arquivos a Serem Criados/Modificados

### 9.1 Novos Arquivos Backend

| Arquivo | Descrição |
|---------|-----------|
| `models/Asterisk.ts` | Model de conexão Asterisk |
| `models/AsteriskQueue.ts` | Associação Asterisk-Queue |
| `models/CallRecord.ts` | Registro de chamadas |
| `libs/asterisk.ts` | Gerenciador de conexões ARI |
| `controllers/AsteriskController.ts` | CRUD conexões |
| `controllers/CallController.ts` | Gerenciar chamadas |
| `routes/asteriskRoutes.ts` | Rotas REST |
| `routes/callRoutes.ts` | Rotas de chamadas |
| `services/AsteriskServices/InitAsteriskSession.ts` | Inicializa ARI |
| `services/AsteriskServices/AsteriskCallListener.ts` | Processa eventos |
| `services/AsteriskServices/OriginateCallService.ts` | Origina chamada |
| `services/AsteriskServices/TransferCallService.ts` | Transfere chamada |
| `services/AsteriskServices/HangupCallService.ts` | Finaliza chamada |
| `services/CallServices/CreateCallRecordService.ts` | Cria registro |
| `services/CallServices/UpdateCallRecordService.ts` | Atualiza registro |
| `services/CallServices/ListCallsService.ts` | Lista chamadas |
| `database/migrations/XXXX-create-asterisk-table.ts` | Migration Asterisk |
| `database/migrations/XXXX-create-call-records-table.ts` | Migration CallRecord |
| `database/migrations/XXXX-add-call-fields-to-ticket.ts` | Campos em Ticket |

### 9.2 Arquivos Backend a Modificar

| Arquivo | Modificação |
|---------|-------------|
| `database/index.ts` | Adicionar models Asterisk e CallRecord |
| `routes/index.ts` | Importar novas rotas |
| `libs/socket.ts` | Adicionar eventos de chamada |
| `server.ts` | Inicializar conexões Asterisk |
| `models/Ticket.ts` | Adicionar campo `asteriskId` e `callType` |
| `models/Message.ts` | Suportar tipo `audio/call` |
| `services/TicketServices/CreateTicketService.ts` | Suportar tickets de chamada |
| `services/TicketServices/FindOrCreateTicketService.ts` | Buscar por chamada |

### 9.3 Novos Arquivos Frontend

| Arquivo | Descrição |
|---------|-----------|
| `context/Asterisk/AsteriskContext.js` | Context de conexões |
| `pages/AsteriskConnections/index.js` | Gerenciar conexões |
| `components/AsteriskModal/index.js` | Modal de configuração |
| `components/CallNotification/index.js` | Notificação de chamada |
| `components/CallControls/index.js` | Controles durante chamada |
| `components/Softphone/index.js` | Softphone WebRTC |
| `components/CallHistory/index.js` | Histórico de chamadas |
| `components/CallRecordingPlayer/index.js` | Player de gravação |
| `hooks/useWebRTC.js` | Hook para WebRTC |
| `hooks/useAsterisk.js` | Hook para Asterisk |
| `services/asteriskApi.js` | API client Asterisk |

### 9.4 Arquivos Frontend a Modificar

| Arquivo | Modificação |
|---------|-------------|
| `App.js` | Adicionar AsteriskContext |
| `routes/index.js` | Adicionar rotas Asterisk |
| `components/Ticket/index.js` | Exibir controles de chamada |
| `components/TicketHeader/index.js` | Status de chamada |
| `components/MessagesList/index.js` | Exibir gravações |
| `components/ContactDrawer/index.js` | Botão "Ligar" |
| `layout/MainListItems.js` | Menu Asterisk |
| `pages/Connections/index.js` | Aba ou link para Asterisk |

---

## 10. Estimativa de Complexidade

### 10.1 Breakdown por Componente

| Componente | Horas | Complexidade |
|------------|-------|--------------|
| **Backend - Models e Migrations** | 16h | Baixa |
| **Backend - Lib ARI** | 40h | Alta |
| **Backend - Services Asterisk** | 48h | Alta |
| **Backend - Controllers e Routes** | 16h | Baixa |
| **Backend - Integração Socket.IO** | 16h | Média |
| **Backend - Sistema de Gravações** | 24h | Média |
| **Frontend - Softphone WebRTC** | 64h | Muito Alta |
| **Frontend - UI Componentes** | 40h | Média |
| **Frontend - Context e Hooks** | 16h | Baixa |
| **Testes e QA** | 40h | Média |
| **Documentação** | 16h | Baixa |
| **Deploy e DevOps** | 24h | Média |
| **TOTAL** | **360h** | - |

### 10.2 Riscos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| WebRTC incompatibilidade navegadores | Média | Alto | Testar em múltiplos navegadores, fallback para click-to-call |
| Latência de áudio | Média | Alto | TURN server dedicado, QoS na rede |
| Escalabilidade Asterisk | Baixa | Alto | Cluster Asterisk, load balancing |
| Conflito com filas existentes | Baixa | Médio | Separar filas de voz das filas de chat |
| Gravações ocupando muito espaço | Alta | Médio | Política de retenção, compressão MP3 |
| NAT/Firewall bloqueando WebRTC | Alta | Alto | STUN/TURN configurados, documentação de portas |

### 10.3 Dependências Externas

| Dependência | Tipo | Criticidade |
|-------------|------|-------------|
| Asterisk 18+ | Infraestrutura | Crítica |
| Certificado SSL | Infraestrutura | Crítica |
| STUN Server | Infraestrutura | Alta |
| TURN Server | Infraestrutura | Alta |
| Redis (para filas) | Infraestrutura | Média |
| Troncos SIP/Operadora | Telecomunicações | Crítica |

---

## 11. Plano de Implementação em Fases

### Fase 1: Fundação (2 semanas)
**Objetivo:** Estrutura base no backend

- [ ] Criar migrations e models (Asterisk, AsteriskQueue, CallRecord)
- [ ] Implementar `libs/asterisk.ts` com conexão ARI básica
- [ ] Criar CRUD básico de conexões Asterisk
- [ ] Adicionar rotas e controllers
- [ ] Testes unitários

**Entregável:** API REST para gerenciar conexões Asterisk

### Fase 2: Eventos de Chamada (2 semanas)
**Objetivo:** Processar eventos do Asterisk

- [ ] Implementar `AsteriskCallListener.ts`
- [ ] Integrar com `FindOrCreateTicketService`
- [ ] Criar registros de chamada (CallRecord)
- [ ] Emitir eventos Socket.IO
- [ ] Testes de integração

**Entregável:** Sistema registra chamadas e cria tickets automaticamente

### Fase 3: UI Backend + Frontend Básico (2 semanas)
**Objetivo:** Interface de gerenciamento

- [ ] Frontend: Página de conexões Asterisk
- [ ] Frontend: Modal de configuração
- [ ] Frontend: Notificação de chamada (toast)
- [ ] Frontend: Context e hooks
- [ ] Integração com menu existente

**Entregável:** Gerenciamento de conexões via interface

### Fase 4: Softphone WebRTC (3 semanas)
**Objetivo:** Atender e realizar chamadas no navegador

- [ ] Integrar JsSIP no frontend
- [ ] Componente Softphone
- [ ] Controles de chamada (mute, hold, transfer)
- [ ] Integração com tela de ticket
- [ ] Testes cross-browser

**Entregável:** Atendentes podem atender chamadas no navegador

### Fase 5: Gravações e Histórico (1 semana)
**Objetivo:** Sistema de gravações

- [ ] Configurar gravação automática no Asterisk
- [ ] Download e armazenamento de gravações
- [ ] Player de áudio no frontend
- [ ] Histórico de chamadas no ticket

**Entregável:** Gravações disponíveis para consulta

### Fase 6: Refinamentos e Produção (2 semanas)
**Objetivo:** Preparar para produção

- [ ] Testes de carga
- [ ] Otimizações de performance
- [ ] Documentação de deploy
- [ ] Treinamento de usuários
- [ ] Monitoramento e alertas

**Entregável:** Sistema em produção

---

## 12. Conclusão

A integração do BigChat com Asterisk é **tecnicamente viável** e pode ser implementada de forma **incremental** sem impactar as funcionalidades existentes de WhatsApp.

### Pontos Fortes do BigChat para Integração:
- ✅ Arquitetura modular e extensível
- ✅ Socket.IO já implementado
- ✅ Sistema de filas e tickets genérico
- ✅ Padrão de conexões bem definido
- ✅ Frontend componentizado

### Principais Desafios:
- ⚠️ Complexidade do WebRTC
- ⚠️ Configuração de rede (NAT/Firewall)
- ⚠️ Qualidade de áudio em ambientes variados

### Recomendações:
1. **Iniciar pela Fase 1** para validar a conexão ARI
2. **Usar ambiente de testes** com Asterisk dedicado
3. **Considerar FreePBX** como alternativa simplificada
4. **Planejar infraestrutura** STUN/TURN desde o início
5. **Definir política de gravações** antes da implementação

---

**Documento gerado automaticamente em 11/02/2026**
