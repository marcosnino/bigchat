# 🚦 Sistema de Semáforo WhatsApp.js - BigChat

## 📝 Visão Geral

O **Sistema de Semáforo** é uma funcionalidade avançada implementada no BigChat que fornece indicadores visuais em tempo real do status das mensagens WhatsApp, permitindo que os atendentes visualizem rapidamente quais conversas precisam de atenção imediata.

### 🎯 Objetivo
- **Uma fila única** com indicadores visuais inteligentes
- Sistema tipo **semáforo** para classificação de mensagens
- **Verde**: Mensagens novas (recém-chegadas)
- **Vermelho**: Mensagens não respondidas há mais de 5 minutos  
- **Cinza**: Mensagens já respondidas

---

## 🚦 Funcionamento do Semáforo

### Estados das Mensagens

| Cor | Status | Descrição | Ação Necessária |
|-----|--------|-----------|-----------------|
| 🟢 **Verde** | `new` | Mensagem nova do cliente | Responder em breve |
| 🔴 **Vermelho** | `waiting` | Aguardando resposta há +5min | **URGENTE** - Responder imediatamente |
| ⚪ **Cinza** | `replied` | Mensagem foi respondida | Nenhuma ação necessária |

### Animações Visuais
- **Verde**: Pulsação suave (2s) - Nova mensagem
- **Vermelho**: Pulsação rápida (1s) - Urgente!
- **Badges**: Contador de mensagens pendentes

---

## ⚙️ Arquitetura Técnica

### Backend

#### 🗃️ Novos Campos no Banco

**Tabela `Messages`:**
```sql
messageStatus ENUM('new', 'replied', 'waiting') DEFAULT 'new'
responseTime DATETIME NULL
```

**Tabela `Tickets`:**
```sql
lastClientMessageAt DATETIME NULL
lastAgentMessageAt DATETIME NULL  
pendingClientMessages INTEGER DEFAULT 0
```

#### 📋 Serviços Implementados

**MessageSemaphoreService.ts:**
- `processMessage()` - Processa nova mensagem
- `markPendingMessagesAsReplied()` - Marca como respondidas
- `checkMessageTimeout()` - Verifica timeout de 5 minutos
- `getTicketSemaphoreStats()` - Estatísticas por ticket
- `getCompanySemaphoreStats()` - Estatísticas globais
- `resetTicketSemaphore()` - Reset quando ticket é fechado

#### 🛣️ APIs Disponíveis

```typescript
GET /tickets/:id/semaphore/stats
// Retorna estatísticas do semáforo para um ticket
{
  newMessages: number,
  waitingMessages: number, 
  repliedMessages: number,
  averageResponseTime: number
}

GET /semaphore/stats  
// Estatísticas globais da empresa
{
  totalNewMessages: number,
  totalWaitingMessages: number,
  totalRepliedMessages: number,
  ticketsWithPendingMessages: number,
  averageResponseTime: number
}

PUT /tickets/:id/semaphore/mark-replied
// Marca mensagens como respondidas manualmente

PUT /tickets/:id/semaphore/reset
// Reset do semáforo para um ticket
```

### Frontend

#### 🎨 Componentes React

**MessageSemaphore/index.js:**
- Painel completo com estatísticas
- Controles manuais
- Métricas em tempo real
- Dashboard visual

**TicketSemaphore/index.js:**
- Ícone compacto para lista de tickets
- Indicador visual simples
- Tooltip informativo
- Badge com contador

#### 🔌 Integração

**TicketListItem/index.js:**
```jsx
import TicketSemaphore from "../TicketSemaphore";

// No render:
<ListItemAvatar>
  <Avatar src={ticket?.contact?.profilePicUrl} />
</ListItemAvatar>
<TicketSemaphore ticket={ticket} />
```

---

## 🔄 Fluxo de Funcionamento

### 1️⃣ **Cliente Envia Mensagem**
```
Mensagem Recebida
    ↓
Status: 'new' (🟢 Verde)
    ↓  
pendingClientMessages++
    ↓
lastClientMessageAt = now()
    ↓
Agenda timeout (5 min)
```

### 2️⃣ **Agente Responde**
```
Resposta Enviada
    ↓
Mensagens anteriores: 'replied'
    ↓
pendingClientMessages = 0
    ↓  
lastAgentMessageAt = now()
    ↓
responseTime definido
```

### 3️⃣ **Timeout (5 minutos)**
```
Timer expira
    ↓
Mensagem ainda 'new'?
    ↓
Status: 'waiting' (🔴 Vermelho)
    ↓
Alerta Socket.IO emitido
```

### 4️⃣ **Ticket Fechado**
```
Ticket fechado
    ↓
Auto reset do semáforo
    ↓
Todas mensagens: 'replied'
    ↓
Contadores zerados
```

---

## 📊 Métricas e Estatísticas

### Por Ticket
- 📈 Mensagens novas
- ⏰ Mensagens aguardando
- ✅ Mensagens respondidas  
- 📏 Tempo médio de resposta

### Global (Empresa)
- 📊 Total de mensagens por status
- 🎯 Tickets com mensagens pendentes  
- ⚡ Performance média de resposta
- 📈 Relatórios em tempo real

---

## 🛠️ Como Ativar

### 1. **Executar Migrações**
```bash
cd backend
npm run db:migrate
```

### 2. **Restart dos Serviços**
```bash
cd /home/rise/bigchat
./bigchat.sh restart
```

### 3. **Verificar Funcionamento**
- Envie uma mensagem pelo WhatsApp
- Veja o ícone verde aparecer na lista
- Aguarde 5+ minutos → Ícone fica vermelho
- Responda → Ícone fica cinza

---

## 🔧 Configurações Avançadas

### Timeout Personalizado
```javascript
// Em MessageSemaphoreService.ts, linha 67:
setTimeout(() => {
  this.checkMessageTimeout(messageId, ticketId);
}, 5 * 60 * 1000); // Alterar este valor (5 minutos)
```

### Cores Customizadas
```javascript
// Em TicketSemaphore/index.js:
greenLight: {
  backgroundColor: green[500], // Alterar cor verde
  animation: '$pulse 2s infinite' // Alterar animação
},
redLight: {
  backgroundColor: red[500], // Alterar cor vermelha  
  animation: '$pulse 1s infinite'
}
```

---

## 🚨 Alertas e Notificações

### Socket.IO Events

**Atualização do Semáforo:**
```javascript
socket.on(`company-${companyId}-message-semaphore`, (data) => {
  // data.action = "update"
  // data.ticketId
  // data.messageId  
  // data.fromMe
});
```

**Timeout de Mensagem:**
```javascript
socket.on(`company-${companyId}-message-timeout`, (data) => {
  // data.action = "timeout"
  // data.ticketId
  // data.message
});
```

---

## 📱 Interface do Usuário

### Lista de Tickets
- **Ícone pequeno** ao lado do avatar
- **Badge** com número de mensagens pendentes
- **Cores piscantes** para chamar atenção
- **Tooltip** explicativo no hover

### Página do Ticket  
- **Painel completo** com estatísticas
- **Botões de ação** manual
- **Métricas em tempo real**
- **Gráficos visuais**

---

## 🔍 Troubleshooting

### Problemas Comuns

**1. Semáforo não aparece:**
- Verificar se migrações foram executadas
- Restart do backend necessário
- Verificar logs no console

**2. Cores não mudam:**
- Verificar Socket.IO funcionando
- Testar com mensagens reais
- Verificar campos no banco de dados

**3. Performance lenta:**
- Otimizar consultas de estatísticas  
- Implementar cache Redis
- Limitar histórico de mensagens

### Debug Mode
```javascript
// Ativar logs detalhados
// Em MessageSemaphoreService.ts:
logger.setLevel('debug');
```

---

## 📈 Roadmap Futuro

### Próximas Melhorias
- [ ] **Dashboard Analytics** - Gráficos avançados
- [ ] **Alertas por Email** - Notificações externas  
- [ ] **SLA Configurável** - Timeouts personalizados
- [ ] **Relatórios PDF** - Exportação de métricas
- [ ] **API Webhook** - Integração externa
- [ ] **Machine Learning** - Predição de demanda

### Integrações Planejadas
- [ ] **Telegram** - Suporte a outros canais
- [ ] **Instagram** - Semáforo para DMs
- [ ] **Facebook** - Mensagens do Messenger
- [ ] **Email** - Tickets de e-mail

---

## 📞 Suporte

Para dúvidas ou problemas:

1. **Verificar logs:** `./bigchat.sh logs backend`
2. **Consultar este README**
3. **Testar com dados reais**
4. **Verificar permissões de banco**

---

**🎉 Sistema implementado com sucesso!**  
*Uma fila única com indicadores visuais inteligentes para WhatsApp.js*