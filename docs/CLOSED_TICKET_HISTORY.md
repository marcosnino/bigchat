# 📊 Sistema de Histórico de Chats Fechados

## 📋 Visão Geral

O **Sistema de Histórico de Chats Fechados** (`ClosedTicketHistory`) da BigChat v6.0.0 permite rastrear, filtrar e analisar todos os chats/tickets que foram fechados, com funcionalidades avançadas de reportagem e analytics.

**Últimas Atualizações:**
- ✅ Integração automática ao fechar tickets
- ✅ Filtros avançados por data, número, fila, usuário
- ✅ Estatísticas em tempo real (totais, médias, gráficos)
- ✅ Exportação em CSV
- ✅ Interface responsiva com Material-UI

---

## 🏗️ Arquitetura

### Backend (Node.js/TypeScript)

#### 1. **Model** - `ClosedTicketHistory.ts`
```
├── Campos Principais:
│   ├── ticketId (FK)
│   ├── userId (FK) - Agente que atendeu
│   ├── contactId (FK)
│   ├── whatsappId (FK) - Número WhatsApp
│   ├── queueId (FK) - Fila que atendeu
│   ├── ticketOpenedAt - Data de abertura
│   ├── ticketClosedAt - Data de fechamento
│   ├── durationSeconds - Duração do atendimento
│   ├── finalStatus - Status final (closed, completed, etc)
│   ├── closureReason - Motivo do fechamento
│   ├── totalMessages - Total de mensagens
│   ├── rating - Avaliação (1-3)
│   ├── feedback - Feedback do cliente
│   ├── tags - Tags/categorias
│   ├── closedByUserId - Quem fechou o ticket
│   └── semaphoreData - Dados do semáforo
```

**Índices para Performance:**
- `(companyId, ticketClosedAt)` - Queries por período
- `(companyId, ticketOpenedAt)` - Queries por abertura
- `whatsappId`, `queueId`, `userId` - Filtros individuais
- `ticketClosedAt`, `ticketOpenedAt` - Ordenações

#### 2. **Service** - `ClosedTicketHistoryService.ts`

```typescript
// Registrar fechamento
await ClosedTicketHistoryService.recordTicketClosure(
  ticketId,
  ticketData,
  companyId
);

// Buscar com filtros
const result = await ClosedTicketHistoryService.findClosed({
  companyId: 1,
  startDate: new Date("2024-01-01"),
  endDate: new Date("2024-01-31"),
  whatsappId: 5,
  queueId: 3,
  userId: 7,
  rating: 3,
  page: 1,
  limit: 50
});

// Obter estatísticas
const stats = await ClosedTicketHistoryService.getClosedStats({
  companyId: 1,
  startDate: new Date("2024-01-01"),
  endDate: new Date("2024-01-31")
});

// Exportar CSV
const csv = await ClosedTicketHistoryService.exportToCSV(filters);

// Limpar histórico antigo
await ClosedTicketHistoryService.cleanupOldRecords(companyId, 90); // Remove registros > 90 dias
```

#### 3. **Controller** - `ClosedTicketHistoryController.ts`

**GET `/closed-tickets/history`**
```
Query Parameters:
- startDate: Data início do fechamento (ISO)
- endDate: Data fim do fechamento (ISO)
- startOpenDate: Data início da abertura (ISO)
- endOpenDate: Data fim da abertura (ISO)
- whatsappId: ID do número WhatsApp
- queueId: ID da fila
- userId: ID do agente
- rating: Avaliação (1-3)
- page: Número da página (default: 1)
- limit: Itens por página (default: 50, máx: 500)
- sortBy: Campo para ordenação (default: ticketClosedAt)
- order: ASC ou DESC (default: DESC)

Response:
{
  "success": true,
  "data": [...],
  "pagination": {
    "page": 1,
    "pages": 5,
    "total": 247,
    "limit": 50
  }
}
```

**GET `/closed-tickets/stats`**
```
Retorna estatísticas agregadas:
{
  "success": true,
  "data": {
    "totalClosed": 247,
    "totalTime": 234560 (segundos),
    "averageTime": 950 (segundos),
    "totalMessages": 5432,
    "averageRating": 2.8,
    "byQueue": [...],
    "byWhatsapp": [...],
    "byUser": [...],
    "byDay": [...]
  }
}
```

**GET `/closed-tickets/:id`**
```
Obter detalhes completos de um ticket fechado
```

**GET `/closed-tickets/export/csv`**
```
Exportar histórico como arquivo CSV com todos os filtros aplicados
```

**POST `/closed-tickets/cleanup`** (Admin Only)
```
Body: { "daysToKeep": 90 }
Limpa registros mais antigos que X dias
```

#### 4. **Routes** - `closedTicketHistoryRoutes.ts`
- Integradas em `routes/index.ts`
- Todas as rotas requerem autenticação (`isAuth` middleware)

---

### Frontend (React/Material-UI)

#### Componente `ClosedTicketHistory.js`

**Funcionalidades:**
1. **Filtros Avançados**
   - Período de fechamento (data início/fim)
   - Período de abertura (data início/fim)
   - Número WhatsApp
   - Fila
   - Agente/Usuário
   - Rating

2. **Estatísticas Dashboard**
   - Total de chats fechados
   - Tempo médio de atendimento
   - Total de mensagens
   - Rating médio

3. **Tabela de Registros**
   - Paginação com 25/50/100 itens por página
   - Ordenação configurável
   - Loading states
   - Detalhes ao clicar

4. **Ações**
   - 👁️ Ver detalhes do ticket
   - 📥 Exportar como CSV
   - 🔄 Atualizar/Recarregar

5. **Dialog de Detalhes**
   - Informações completas do ticket
   - Datas, duração, mensagens
   - Rating e feedback
   - Tags associadas

---

## 🔄 Fluxo de Integração

### Quando um Ticket é Fechado:

```
UpdateTicketService.ts
  ├─ Valida status === "closed"
  ├─ Registra em TicketTraking (finishedAt)
  └─ Chama ClosedTicketHistoryService.recordTicketClosure()
         ├─ Calcula durationSeconds
         ├─ Conta totalMessages
         ├─ Extrai semaphoreData
         └─ Cria registro em ClosedTicketHistory
              ├─ Relaciona com Ticket, User, Contact, Whatsapp, Queue
              └─ Emite log no Sentry (se erro)
```

### Dados Capturados:
- ✅ Tempo de abertura e fechamento (para cálculo de duração)
- ✅ Qual agente atendeu
- ✅ Qual fila atendeu
- ✅ Contato/cliente
- ✅ Número WhatsApp
- ✅ Motivo do fechamento
- ✅ Total de mensagens
- ✅ Rating (se ativado)
- ✅ Feedback
- ✅ Tags/categorias
- ✅ Quem fechou o ticket

---

## 📊 Exemplos de Uso

### 1. Buscar Chats Fechados Hoje

```typescript
import ClosedTicketHistoryService from "./services/ClosedTicketHistoryService";

const today = new Date();
today.setHours(0, 0, 0, 0);
const tomorrow = new Date(today);
tomorrow.setDate(tomorrow.getDate() + 1);

const result = await ClosedTicketHistoryService.findClosed({
  companyId: 1,
  startDate: today,
  endDate: tomorrow,
  limit: 100
});

console.log(`Chats fechados hoje: ${result.total}`);
```

### 2. Relatório por Fila

```typescript
const stats = await ClosedTicketHistoryService.getClosedStats({
  companyId: 1,
  startDate: new Date("2024-01-01"),
  endDate: new Date("2024-01-31")
});

stats.byQueue.forEach(queueStat => {
  console.log(`${queueStat.queue.name}: ${queueStat.dataValues.total} chats, média: ${queueStat.dataValues.avgTime}s`);
});
```

### 3. Relatório por Agente

```typescript
const stats = await ClosedTicketHistoryService.getClosedStats({
  companyId: 1,
  userId: 5  // Filtrar por agente específico
});

stats.byUser.forEach(userStat => {
  console.log(`${userStat.user.name}: ${userStat.dataValues.total} chats`);
});
```

### 4. Tickets com Baixo Rating

```typescript
const poorRatingTickets = await ClosedTicketHistoryService.findClosed({
  companyId: 1,
  rating: 1,  // Insatisfeito
  limit: 500
});

console.log(`Chats com avaliação baixa: ${poorRatingTickets.total}`);
```

### 5. Performance de Número WhatsApp

```typescript
const stats = await ClosedTicketHistoryService.getClosedStats({
  companyId: 1,
  whatsappId: 5,
  startDate: new Date("2024-01-01")
});

console.log(`Total de chats: ${stats.totalClosed}`);
console.log(`Tempo médio: ${stats.averageTime} segundos`);
console.log(`Total de mensagens: ${stats.totalMessages}`);
```

---

## 🔧 Configuração

### 1. Executar Migração

```bash
cd backend
npm run migrations
```

Isso criará a tabela `closed_ticket_histories` com todos os índices.

### 2. Integrar Rotas

As rotas já estão integradas em `src/routes/index.ts`:
```typescript
import closedTicketHistoryRoutes from "./closedTicketHistoryRoutes";
routes.use(closedTicketHistoryRoutes);
```

### 3. Adicionar Menu no Frontend

```jsx
// Em seu componente de navegação
import ClosedTicketHistory from "../pages/ClosedTicketHistory";

// Adicionar route
<Route path="/closed-tickets" component={ClosedTicketHistory} />

// Adicionar menu item
<MenuItem to="/closed-tickets">
  📊 Histórico de Chats Fechados
</MenuItem>
```

---

## 📈 Dashboards Recomendados

### Dashboard Gerencial
- Total de chats fechados por período
- Tempo médio de atendimento
- Rating médio
- Top 5 agentes (por volume)
- Top 5 filas (por volume)

### Dashboard de Performance
- Tempo médio por fila
- Tempo médio por agente
- Taxa de avaliação
- Número de mensagens por chat

### Dashboard de Qualidade
- Chats com baixo rating (< 2)
- Taxa de satisfação (%)
- Feedback negativo
- Tendências ao longo do tempo

---

## 🛡️ Segurança

1. **Autenticação** - Todas as routes requerem `isAuth` middleware
2. **Autorização** - Cleanup (POST) requer `isAdmin`
3. **Validação** - Filtros validados no frontend e backend
4. **Privacidade** - Dados filtrados por `companyId`
5. **Limpeza** - Registros antigos removem-se automaticamente (> 90 dias)

---

## 📝 Log de Mudanças

### v1.0.0 (2024-12-27)
- ✅ Model com 14 campos principais + semaphoreData JSON
- ✅ Service com 6 métodos (record, findClosed, getStats, findById, exportCSV, cleanup)
- ✅ Controller com 5 endpoints
- ✅ Frontend com filtros, estatísticas e tabela
- ✅ Integração automática ao fechar tickets
- ✅ Índices para performance otimizada

---

## 🤝 Suporte

Para dúvidas ou issues:
1. Verificar logs em `console.error`
2. Verificar Sentry para erros remotos
3. Testar filtros individualmente
4. Validar dados em `ClosedTicketHistory` table

---

## 📚 Relacionados

- [UserWhatsappQueueService](./USER_WHATSAPP_QUEUE.md) - Sistema de assinação
- [WhatsAppQueueValidationService](./WHATSAPP_QUEUE_VALIDATION.md) - Validação
- [UpdateTicketService](./TICKET_SERVICES.md) - Fechamento de tickets

