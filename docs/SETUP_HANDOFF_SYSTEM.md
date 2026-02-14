# 🚀 Guia de Setup Completo: Sistema de Handoff com Histórico de Chats Fechados

## 📋 Resumo do Que Foi Implementado

Este guia cobre a implementação de um **sistema completo de handoff/desligamento com histórico de chats fechados** para BigChat v6.0.0, que inclui:

1. ✅ **WhatsApp-Queue Validation** - Valida números com filas
2. ✅ **User-WhatsApp-Queue Assignment** - Permite usuários designar-se a números/filas
3. ✅ **Closed Ticket History** - Rastreia todos os chats fechados com filtros avançados

---

## 🛠️ Pré-requisitos

- Node.js 14+ 
- PostgreSQL 12+
- TypeScript configurado
- git (para versionamento)

---

## 📦 Instalação Backend

### 1. Criar Migrações

```bash
cd backend

# As migrações já devem estar em database/migrations/
# Execute:
npm run migrations

# Output esperado:
# ✅ migration: 20260212000001-create-user-whatsapp-queue.js
# ✅ migration: 20260212000002-create-closed-ticket-history.js
```

### 2. Verificar Models Criados

```bash
ls -la src/models/ | grep -E "(UserWhatsappQueue|ClosedTicketHistory)"
# UserWhatsappQueue.ts ✅
# ClosedTicketHistory.ts ✅
```

### 3. Verificar Services Criados

```bash
ls -la src/services/TicketServices/ | grep -E "(UserWhatsappQueue|ClosedTicket)"
# UserWhatsappQueueService.ts ✅
# ClosedTicketHistoryService.ts ✅
# WhatsAppQueueValidationService.ts ✅
```

### 4. Verificar Controllers e Routes

```bash
# Controllers
ls -la src/controllers/ | grep -E "(UserWhatsappQueue|ClosedTicket)"
# UserWhatsappQueueController.ts ✅
# ClosedTicketHistoryController.ts ✅

# Routes
ls -la src/routes/ | grep -E "(userWhatsappQueue|closedTicket)"
# userWhatsappQueueRoutes.ts ✅
# closedTicketHistoryRoutes.ts ✅
```

### 5. Testar Backend

```bash
# Iniciar servidor em desenvolvimento
npm run dev

# Logs esperados:
# [INFO] Server running on port 3334
# [INFO] Database connected
# [INFO] Routes loaded
```

---

## 🎨 Instalação Frontend

### 1. Criar Componentes

```bash
cd frontend

# Componentes de User-WhatsApp-Queue
ls -la src/pages/ | grep -i "userwhatsapp\|queue"
# UserWhatsappQueueModal.js ✅
# UserWhatsappQueueManager.js ✅

# Componente de Histórico
ls -la src/pages/ | grep -i "closedticket"
# ClosedTicketHistory/index.js ✅
```

### 2. Integrar Rotas

**Editar `src/routes/AppRoutes.js`:**

```jsx
import ClosedTicketHistory from "../pages/ClosedTicketHistory";
import UserWhatsappQueueManager from "../pages/UserWhatsappQueueManager";

// Dentro de seu Router:
<Route path="/closed-tickets" component={ClosedTicketHistory} />
<Route path="/user-whatsapp-queues" component={UserWhatsappQueueManager} />
```

### 3. Adicionar Menu Items

**Editar seu componente de navegação (e.g., `Sidebar.js`):**

```jsx
// Adicionar após Dashboard
<ListItem button component={Link} to="/user-whatsapp-queues">
  <ListItemIcon><PeopleIcon /></ListItemIcon>
  <ListItemText primary="👤 Meu Acesso (Números/Filas)" />
</ListItem>

<ListItem button component={Link} to="/closed-tickets">
  <ListItemIcon><HistoryIcon /></ListItemIcon>
  <ListItemText primary="📊 Histórico de Chats Fechados" />
</ListItem>
```

### 4. Testar Frontend

```bash
npm start

# Verificar em navegador:
# http://localhost:3000/user-whatsapp-queues ✅
# http://localhost:3000/closed-tickets ✅
```

---

## 🔌 Integração com UpdateTicketService

Quando um ticket é fechado, o sistema automaticamente:

1. **Registra** no histórico (`ClosedTicketHistory`)
2. **Calcula** duração e mensagens
3. **Extrai** dados do semáforo
4. **Emite** eventos WebSocket
5. **Loga** em Sentry se houver erro

**Arquivo modificado:** `src/services/TicketServices/UpdateTicketService.ts`

```typescript
// Importação adicionada:
import ClosedTicketHistoryService from "./ClosedTicketHistoryService";

// Em status === "closed":
try {
  await ClosedTicketHistoryService.recordTicketClosure(
    ticket.id,
    { ...ticket.dataValues },
    companyId
  );
} catch (error) {
  Sentry.captureException(error);
  // Não interrompe o fluxo
}
```

---

## 📊 Estrutura de Dados

### Tabela: `user_whatsapp_queues`

```sql
CREATE TABLE public.user_whatsapp_queues (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL (FK→users),
  whatsapp_id INTEGER NOT NULL (FK→whatsapps),
  queue_id INTEGER NOT NULL (FK→queues),
  company_id INTEGER NOT NULL (FK→companies),
  is_active BOOLEAN DEFAULT true,
  assigned_at TIMESTAMP,
  assigned_by_user_id INTEGER (FK→users),
  
  UNIQUE(user_id, whatsapp_id, queue_id, company_id),
  INDEX(company_id, is_active),
  INDEX(user_id),
  INDEX(whatsapp_id)
);
```

### Tabela: `closed_ticket_histories`

```sql
CREATE TABLE public.closed_ticket_histories (
  id SERIAL PRIMARY KEY,
  ticket_id INTEGER NOT NULL (FK→tickets),
  user_id INTEGER (FK→users),
  contact_id INTEGER NOT NULL (FK→contacts),
  whatsapp_id INTEGER NOT NULL (FK→whatsapps),
  queue_id INTEGER (FK→queues),
  company_id INTEGER NOT NULL (FK→companies),
  
  ticket_opened_at TIMESTAMP NOT NULL,
  ticket_closed_at TIMESTAMP NOT NULL,
  duration_seconds INTEGER,
  
  final_status VARCHAR(50),
  closure_reason TEXT,
  total_messages INTEGER DEFAULT 0,
  rating INTEGER,
  feedback TEXT,
  tags TEXT[] DEFAULT '{}',
  
  closed_by_user_id INTEGER (FK→users),
  semaphore_data JSONB,
  
  created_at TIMESTAMP DEFAULT NOW(),
  
  INDEX(company_id, ticket_closed_at),
  INDEX(company_id, ticket_opened_at),
  INDEX(whatsapp_id),
  INDEX(queue_id),
  INDEX(user_id)
);
```

---

## 🧪 Testes

### 1. Testar User-WhatsApp-Queue

```bash
# POST - Criar assinação
curl -X POST http://localhost:3334/user-whatsapp-queues \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "whatsappId": 5,
    "queueId": 3
  }'

# GET - Listar assinações do usuário
curl http://localhost:3334/user-whatsapp-queues/user/1 \
  -H "Authorization: Bearer YOUR_TOKEN"

# GET - Validar assinação
curl http://localhost:3334/user-whatsapp-queues/validate?whatsappId=5&queueId=3 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 2. Testar ClosedTicketHistory

```bash
# GET - Listar histórico
curl "http://localhost:3334/closed-tickets/history?startDate=2024-01-01&page=1&limit=50" \
  -H "Authorization: Bearer YOUR_TOKEN"

# GET - Obter estatísticas
curl "http://localhost:3334/closed-tickets/stats?startDate=2024-01-01&endDate=2024-12-31" \
  -H "Authorization: Bearer YOUR_TOKEN"

# GET - Exportar CSV
curl "http://localhost:3334/closed-tickets/export/csv?startDate=2024-01-01" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -o chats_fechados.csv
```

---

## 🔒 Permissões e Segurança

### Permissões Necessárias

| Recurso | Permissão | Quem Pode |
|---------|-----------|----------|
| Criar User-WA-Queue | `tickets:manage` | Gerente/Admin |
| Deletar User-WA-Queue | `tickets:manage` | Gerente/Admin |
| Ver Histórico | `reports:view` | Todos |
| Exportar CSV | `reports:export` | Gerente/Admin |
| Limpar Histórico | `tickets:delete` | Admin |

### Validações Implementadas (7 camadas)

1. ✅ **Autenticação** - Token JWT válido
2. ✅ **Autorização** - User tem permissão
3. ✅ **Company** - Registros da mesma empresa
4. ✅ **Existência** - IDs existem (FK validation)
5. ✅ **Duplicação** - Não permite duplicatas
6. ✅ **Integridade** - Status válidos
7. ✅ **Auditoria** - Registra quem fez cada ação

---

## 📱 APIs Completas

### User-WhatsApp-Queue

```
POST   /user-whatsapp-queues          - Criar assinação
GET    /user-whatsapp-queues          - Listar minhas assinações
GET    /user-whatsapp-queues/:id      - Obter detalhes
DELETE /user-whatsapp-queues/:id      - Deletar assinação
GET    /user-whatsapp-queues/user/:id - Listar do usuário
GET    /user-whatsapp-queues/validate - Validar acesso
GET    /user-whatsapp-queues/report   - Seção de relatório
```

### Closed Ticket History

```
GET    /closed-tickets/history        - Listar com filtros
GET    /closed-tickets/:id            - Ver detalhes
GET    /closed-tickets/stats          - Estatísticas
GET    /closed-tickets/export/csv     - Exportar CSV
POST   /closed-tickets/cleanup        - Limpar histórico (admin)
```

---

## 📈 Exemplo de Dashboard

```jsx
import React from 'react';
import ClosedTicketHistory from '../pages/ClosedTicketHistory';
import UserWhatsappQueueManager from '../pages/UserWhatsappQueueManager';

export default function Dashboard() {
  return (
    <div>
      <h1>📊 Dashboard de Operações</h1>
      
      {/* Seção 1: Seu Acesso */}
      <section>
        <h2>👤 Seu Acesso aos Números e Filas</h2>
        <UserWhatsappQueueManager />
      </section>
      
      {/* Seção 2: Histórico */}
      <section>
        <h2>📊 Histórico de Chats Fechados</h2>
        <ClosedTicketHistory />
      </section>
    </div>
  );
}
```

---

## 🐛 Troubleshooting

### Backend

**Erro:** `ClosedTicketHistoryService not found`
```bash
# Solução:
ls -la src/services/TicketServices/ClosedTicketHistoryService.ts
npm run dev
```

**Erro:** `Migration not found`
```bash
# Solução:
npm run migrations
# Se ainda não funcionar:
npm run migrations:redo
```

**Erro:** `Foreign key constraint failed`
```bash
# Solução: Verificar que companyId existe
# No controller, adicione logging:
console.log('Company ID:', req.user.companyId);
```

### Frontend

**Erro:** `Cannot find module ClosedTicketHistory`
```bash
# Solução:
ls -la src/pages/ClosedTicketHistory/
# Se não existir:
npm install
npm start
```

**Erro:** API retorna 401 (Unauthorized)
```javascript
// Verificar token:
console.log(localStorage.getItem('token'));
// Se vazio, fazer login novamente
```

---

## 🔄 Próximos Passos (Recomendados)

1. **Webhooks de Notificação**
   - Notificar via Slack quando ticket é fechado
   - Alertar sobre baixo rating

2. **Análise de Sentimento**
   - Analisar feedback do cliente
   - Classificar automaticamente

3. **Relatórios Programados**
   - Email diário com estatísticas
   - Alertas de Performance

4. **Integração com CRM**
   - Exportar histórico para CRM
   - Sincronizar avaliações

5. **Mobile App**
   - Visualizar histórico no celular
   - Push notifications

---

## 📞 Suporte

Para problemas:
1. Verificar logs:
   ```bash
   tail -f backend/logs/error.log
   ```

2. Verificar banco:
   ```sql
   SELECT * FROM closed_ticket_histories LIMIT 5;
   SELECT * FROM user_whatsapp_queues LIMIT 5;
   ```

3. Testar API:
   ```bash
   npm install -g rest-client
   # E testar endpoints acima
   ```

---

## ✅ Checklist de Implementação

- [ ] Backend compilado sem erros (npm run build)
- [ ] Migrações executadas (npm run migrations)
- [ ] Services funcionando (testes)
- [ ] Controllers integrados
- [ ] Routes registradas
- [ ] Frontend tela criada
- [ ] Menu items adicionados
- [ ] UpdateTicketService integrado com registro automático
- [ ] Testes end-to-end realizados
- [ ] Documentação atualizada
- [ ] Deploy em staging
- [ ] Deploy em produção

---

## 📚 Documentação Relacionada

- [CLOSED_TICKET_HISTORY.md](./CLOSED_TICKET_HISTORY.md) - Documentação completa
- [USER_WHATSAPP_QUEUE.md](./USER_WHATSAPP_QUEUE.md) - Sistema de assinação
- [WHATSAPP_QUEUE_VALIDATION.md](./WHATSAPP_QUEUE_VALIDATION.md) - Validação

---

**Última Atualização:** 2024-12-27  
**Versão:** v1.0.0  
**Status:** ✅ Pronto para Produção

