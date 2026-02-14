# 🔗 Sistema de Vinculação Usuário-Número-Fila (UserWhatsappQueue)

## 📋 Visão Geral

Sistema completo de gerenciamento de atribuições entre usuários, números WhatsApp e filas de atendimento, desenvolvido com critérios de desenvolvedor sênior.

## 🏛️ Arquitetura

### Modelo de Dados
```
User (1) ─── (M) UserWhatsappQueue (M) ─── (1) Whatsapp
  │                                             │
  └─── (M) UserQueue ──── (1) Queue ──────────┘
```

- **User**: Agente de atendimento
- **Whatsapp**: Número WhatsApp conectado
- **Queue**: Fila de atendimento (departamento)
- **UserWhatsappQueue**: Tabela de junção ternária

### Banco de Dados
```sql
CREATE TABLE UserWhatsappQueues (
  id INT PRIMARY KEY,
  userId INT NOT NULL,         -- FK para User
  whatsappId INT NOT NULL,     -- FK para Whatsapp
  queueId INT NOT NULL,        -- FK para Queue
  isActive BOOLEAN DEFAULT true,
  notes TEXT,
  createdAt TIMESTAMP,
  updatedAt TIMESTAMP,
  
  -- Índices para performance
  UNIQUE (userId, whatsappId, queueId),
  INDEX (userId),
  INDEX (whatsappId),
  INDEX (queueId),
  INDEX (isActive)
);
```

## ✅ Validações (Dev Sênior)

### 1. Verificação de Permissões
- ✓ Usuário deve pertencer à mesma company
- ✓ Número e fila devem pertencer à mesma company
- ✓ Usuário deve ter permissão na fila (estar em UserQueue)
- ✓ Sem atribuições fora da company

```typescript
// Validação de company
const user = await User.findOne({ 
  where: { id: userId, companyId } 
});
```

### 2. Validação de Status
- ✓ Número DEVE estar CONNECTED
- ✓ Aviso se número estiver DISCONNECTED mas com usuários atribuídos
- ✓ Impede novas atribuições em números desconectados

```typescript
if (whatsapp.status !== "CONNECTED") {
  throw new AppError(
    `Número não está conectado (${whatsapp.status})`
  );
}
```

### 3. Prevenção de Duplicatas
- ✓ Índice UNIQUE (userId, whatsappId, queueId)
- ✓ Verificação antes de criar
- ✓ Erro 409 Conflict se duplicata

```sql
UNIQUE INDEX unique_user_whatsapp_queue 
ON UserWhatsappQueues(userId, whatsappId, queueId)
```

### 4. Integridade Referencial
- ✓ ON DELETE CASCADE para User
- ✓ ON DELETE CASCADE para Whatsapp
- ✓ ON DELETE CASCADE para Queue
- ✓ Limpeza automática de órfãos

### 5. Validação de Relacionamento
```typescript
// Usuário deve estar em UserQueue da fila
const userHasQueueAccess = user.queues?.some(q => q.id === queueId);

if (!userHasQueueAccess) {
  throw new AppError(
    `Usuário não tem acesso à fila`
  );
}
```

## 🔌 APIs REST

### Criar Atribuição
```http
POST /user-whatsapp-queue
Content-Type: application/json

{
  "userId": 1,
  "whatsappId": 5,
  "queueId": 3,
  "notes": "Atende segunda a sexta"
}

Response: 201 Created
{
  "success": true,
  "message": "Vinculação criada com sucesso",
  "data": { id, userId, whatsappId, queueId, ... }
}
```

### Listar Atribuições
```http
GET /user-whatsapp-queue?userId=1&isActive=true
GET /user-whatsapp-queue?whatsappId=5
GET /user-whatsapp-queue?queueId=3

Response: 200 OK
{
  "success": true,
  "count": 5,
  "data": [{ ... }]
}
```

### Buscar Usuários Disponíveis
```http
GET /user-whatsapp-queue/available/:whatsappId/:queueId

Response:
{
  "success": true,
  "count": 10,
  "data": [
    { "id": 1, "name": "João", "assigned": true },
    { "id": 2, "name": "Maria", "assigned": false }
  ]
}
```

### Atualizar Atribuição
```http
PUT /user-whatsapp-queue/:id
{
  "isActive": false,
  "notes": "Em férias"
}
```

### Deletar Atribuição
```http
DELETE /user-whatsapp-queue/:id
```

### Verificar Avisos
```http
GET /user-whatsapp-queue/warnings

Response:
{
  "success": true,
  "count": 2,
  "message": "2 usuário(s) atribuído(s) a número(s) desconectado(s)",
  "data": [{ ... }]
}
```

### Obter Estatísticas
```http
GET /user-whatsapp-queue/statistics

Response:
{
  "success": true,
  "data": {
    "totalLinks": 15,
    "activeLinks": 12,
    "inactiveLinks": 3,
    "usersWithAssignments": 8
  }
}
```

## 🎯 Casos de Uso

### 1. Atribuir Usuário a Número-Fila
```
Admin seleciona:
- Usuário: João (dev do backend)
- Número: +55 11 98765-4321
- Fila: Suporte Técnico

Sistema valida:
✓ João tem acesso à fila Suporte Técnico
✓ Número está CONNECTED
✓ Não existe duplicata
✓ Mesma company

Resultado: Atribuição criada
```

### 2. Desconectar Número
```
Número é desconectado (Whatsapp.status = DISCONNECTED)

Sistema:
⚠️ Identifica usuários atribuídos
📢 Emite aviso via WebSocket
📊 API /warnings mostra problema
👤 Usuário ainda está atribuído (pode ser reativado)
```

### 3. Remover Usuário de Fila
```
Admin remove usuário de UserQueue

Sistema:
🔴 Desativa todas atribuições do usuário para essa fila
📧 Log de auditoria registrado
🔄 Número-Fila fica disponível para outro usuário
```

### 4. Roteamento de Ticket
```
Cliente envia mensagem no número +55 11 98765-4321
Ticket é criado com:
- whatsappId: 5
- queueId: 3
- userId: null (initial, sem atribuição)

Sistema pode:
✓ Buscar usuários atribuídos: 
  SELECT * FROM UserWhatsappQueues 
  WHERE whatsappId=5 AND queueId=3 AND isActive=true

✓ Atribuir automaticamente (round-robin)
✓ Sugerir para operador
```

## 📊 Performance

### Índices Otimizados
```sql
-- Busca rápida por usuário
INDEX idx_user_whatsapp_queue_user_id (userId)

-- Busca rápida por número
INDEX idx_user_whatsapp_queue_whatsapp_id (whatsappId)

-- Busca rápida por fila
INDEX idx_user_whatsapp_queue_queue_id (queueId)

-- Busca apenas ativos
INDEX idx_user_whatsapp_queue_active (isActive)

-- Prevenção de duplicatas
UNIQUE INDEX unique_user_whatsapp_queue (userId, whatsappId, queueId)
```

### Queries Otimizadas
```typescript
// Com includes eficientes
const assignments = await UserWhatsappQueue.findAll({
  where: { userId },
  include: [
    { model: User, attributes: ["id", "name"] },
    { model: Whatsapp, attributes: ["id", "name", "status"] },
    { model: Queue, attributes: ["id", "name", "color"] }
  ]
});
```

## 🔐 Segurança

### 1. Autenticação
- ✓ Todas as rotas requerem `isAuth` middleware
- ✓ Usuário só vê suas próprias atribuições

### 2. Autorização
- ✓ Admin pode gerenciar todas atribuições
- ✓ Usuário pode ver/editar itens da suas atribuições
- ✓ Validação de `companyId` em todas operações

### 3. Validação de Input
```typescript
if (!userId || !whatsappId || !queueId) {
  throw new AppError("Campos obrigatórios", 400);
}

// Validar tipos
userId = Number(userId);
whatsappId = Number(whatsappId);
queueId = Number(queueId);
```

### 4. Logs de Auditoria
```typescript
logger.info(
  `[UserWhatsappQueue] Criada: ` +
  `Usuário "${user.name}" → ` +
  `Número "${whatsapp.name}" → ` +
  `Fila "${queue.name}"`
);
```

## 📡 WebSocket Events

### Eventos Emitidos
```javascript
// Criar atribuição
io.emit("company-{id}-user-whatsapp-queue", {
  action: "create",
  data: userWhatsappQueue,
  message: "Usuário X atribuído..."
});

// Atualizar atribuição
io.emit("company-{id}-user-whatsapp-queue", {
  action: "update",
  data: userWhatsappQueue
});

// Deletar atribuição
io.emit("company-{id}-user-whatsapp-queue", {
  action: "delete",
  data: { id }
});
```

## 🚀 Fluxo de Implementação

### Backend
1. ✅ Model `UserWhatsappQueue`
2. ✅ Migration banco de dados
3. ✅ Service com validações
4. ✅ Controller CRUD
5. ✅ Rotas REST
6. ⏳ Integração com Ticket assignment

### Frontend
1. ✅ Componente Modal (User Config)
2. ✅ Componente Manager (Admin)
3. ⏳ Integração em Settings
4. ⏳ Integração em User Management
5. ⏳ Dashboard de estatísticas

## ⚠️ Edge Cases Tratados

| Caso | Solução |
|------|---------|
| Usuário sem fila em UserQueue | Erro 403 - Sem permissão |
| Número DISCONNECTED | Erro 400 - Não permitido |
| Duplicata (user+whatsapp+queue) | Erro 409 - Já existe |
| Company mismatch | Erro 403 - Sem permissão |
| Número deletado | CASCADE DELETE automático |
| Usuário deletado | CASCADE DELETE automático |
| Fila deletada | CASCADE DELETE automático |
| Atribuição órfã | Função de limpeza `cleanup()` |

## 📈 Próximas Melhorias

- [ ] Atribuição automática round-robin em roteamento
- [ ] Limite de atribuições por usuário
- [ ] Horários de disponibilidade
- [ ] Fila de espera para atribuições
- [ ] Analytics por usuário-número-fila
- [ ] A/B testing de distribuição de carga
- [ ] Machine learning para otimizar distribuição
