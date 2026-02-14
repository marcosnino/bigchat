# 🧪 Guia de Testes: Todos os Endpoints

## 🚀 Como Começar

### 1. Obter Token de Autenticação

```bash
# Login
curl -X POST http://localhost:3334/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    \"email\": \"seu@email.com\",\n    \"password\": \"sua_senha\"\n  }' \
  | jq '.token'

# Guardar em variável
TOKEN=\"seu_token_aqui\"
```

### 2. Verificar Health

```bash
curl http://localhost:3334/health
# Expected: { \"status\": \"OK\" }
```

---

## 👤 User-WhatsApp-Queue Endpoints

### 1. Criar Assinação (POST)

```bash
curl -X POST http://localhost:3334/user-whatsapp-queues \\
  -H \"Authorization: Bearer $TOKEN\" \\
  -H \"Content-Type: application/json\" \\
  -d '{
    \"userId\": 1,
    \"whatsappId\": 5,
    \"queueId\": 3
  }' | jq

# Expected Response:
{
  \"success\": true,
  \"data\": {
    \"id\": 1,
    \"userId\": 1,
    \"whatsappId\": 5,
    \"queueId\": 3,
    \"is_active\": true,
    \"assigned_at\": \"2024-12-27T10:30:00Z\",
    \"assigned_by_user_id\": 2
  }
}
```

### 2. Listar Minhas Assinações (GET)

```bash
curl -X GET http://localhost:3334/user-whatsapp-queues \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": [
    {
      \"id\": 1,
      \"userId\": 1,
      \"whatsappId\": 5,
      \"queueId\": 3,
      \"whatsapp\": { \"id\": 5, \"name\": \"Vendas\", \"number\": \"5511999999\" },
      \"queue\": { \"id\": 3, \"name\": \"Suporte\", \"color\": \"#FF5733\" },
      \"isActive\": true
    }
  ],
  \"pagination\": {
    \"page\": 1,
    \"pages\": 1,
    \"total\": 1
  }
}
```

### 3. Obter Detalhes de Uma Assinação (GET)

```bash
curl -X GET http://localhost:3334/user-whatsapp-queues/1 \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": {
    \"id\": 1,
    \"userId\": 1,
    \"whatsappId\": 5,
    \"queueId\": 3,
    \"user\": { \"id\": 1, \"name\": \"João Silva\" },
    \"whatsapp\": { \"id\": 5, \"name\": \"Vendas\" },
    \"queue\": { \"id\": 3, \"name\": \"Suporte\" },
    \"assignedAt\": \"2024-12-27T10:30:00Z\",
    \"assignedByUser\": { \"id\": 2, \"name\": \"Maria Gerente\" }
  }
}
```

### 4. Validar Acesso (GET) - Verificar se pode atender

```bash
curl -X GET \"http://localhost:3334/user-whatsapp-queues/validate?whatsappId=5&queueId=3\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"isAuthorized\": true,
  \"message\": \"Você pode atender neste número e fila\",
  \"assignment\": {
    \"id\": 1,
    \"whatsappId\": 5,
    \"queueId\": 3
  }
}

# Se não autorizado:
{
  \"success\": true,
  \"isAuthorized\": false,
  \"message\": \"Você não está designado para este número/fila\"
}
```

### 5. Listar Assinações de Usuário Específico (GET) - Admin

```bash
curl -X GET http://localhost:3334/user-whatsapp-queues/user/2 \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": [
    {
      \"id\": 2,
      \"userId\": 2,
      \"whatsappId\": 6,
      \"queueId\": 2
    },
    {
      \"id\": 3,
      \"userId\": 2,
      \"whatsappId\": 7,
      \"queueId\": 4
    }
  ]
}
```

### 6. Reportar Assinações (GET) - Gerencial

```bash
curl -X GET http://localhost:3334/user-whatsapp-queues/report \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": {
    \"totalAssignments\": 45,
    \"byUser\": [
      { \"userId\": 1, \"userName\": \"João\", \"assignments\": 5 },
      { \"userId\": 2, \"userName\": \"Maria\", \"assignments\": 8 }
    ],
    \"byWhatsapp\": [
      { \"whatsappId\": 5, \"name\": \"Vendas\", \"assignments\": 12 },
      { \"whatsappId\": 6, \"name\": \"Suporte\", \"assignments\": 15 }
    ],
    \"byQueue\": [
      { \"queueId\": 2, \"name\": \"Atendimento\", \"assignments\": 20 }
    ]
  }
}
```

### 7. Deletar Assinação (DELETE)

```bash
curl -X DELETE http://localhost:3334/user-whatsapp-queues/1 \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"message\": \"Assinação removida com sucesso\"
}
```

---

## 📊 Closed Ticket History Endpoints

### 1. Listar Histórico com Filtros (GET)

```bash
# Sem filtros
curl -X GET \"http://localhost:3334/closed-tickets/history?page=1&limit=50\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Com todos os filtros
curl -X GET \"http://localhost:3334/closed-tickets/history?\\
  startDate=2024-01-01T00:00:00Z&\\
  endDate=2024-12-31T23:59:59Z&\\
  startOpenDate=2024-01-01T00:00:00Z&\\
  endOpenDate=2024-12-31T23:59:59Z&\\
  whatsappId=5&\\
  queueId=3&\\
  userId=1&\\
  rating=3&\\
  page=1&\\
  limit=50&\\
  sortBy=ticketClosedAt&\\
  order=DESC\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": [
    {
      \"id\": 1,
      \"ticketId\": 456,
      \"userId\": 1,
      \"whatsappId\": 5,
      \"queueId\": 3,
      \"contact\": { \"id\": 10, \"name\": \"Cliente X\", \"number\": \"5511988776655\" },
      \"whatsapp\": { \"id\": 5, \"name\": \"Vendas\" },
      \"queue\": { \"id\": 3, \"name\": \"Suporte\" },
      \"user\": { \"id\": 1, \"name\": \"João Silva\" },
      \"ticketOpenedAt\": \"2024-12-27T09:00:00Z\",
      \"ticketClosedAt\": \"2024-12-27T10:30:00Z\",
      \"durationSeconds\": 5400,
      \"finalStatus\": \"closed\",
      \"closureReason\": \"Resolvido\",
      \"totalMessages\": 12,
      \"rating\": 3,
      \"feedback\": \"Excelente atendimento!\",
      \"tags\": [\"venda\", \"sucesso\"]
    }
  ],
  \"pagination\": {
    \"page\": 1,
    \"pages\": 5,
    \"total\": 247,
    \"limit\": 50
  }
}
```

### 2. Obter Detalhes de Um Ticket Fechado (GET)

```bash
curl -X GET http://localhost:3334/closed-tickets/1 \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": {
    \"id\": 1,
    \"ticketId\": 456,
    \"userId\": 1,
    \"contactId\": 10,
    \"whatsappId\": 5,
    \"queueId\": 3,
    \"companyId\": 1,
    \"user\": { \"id\": 1, \"name\": \"João Silva\", \"email\": \"joao@...\" },
    \"contact\": { \"id\": 10, \"name\": \"Cliente X\", \"number\": \"5511988776655\" },
    \"whatsapp\": { \"id\": 5, \"name\": \"Vendas\", \"status\": \"connected\" },
    \"queue\": { \"id\": 3, \"name\": \"Suporte\", \"color\": \"#FF5733\" },
    \"ticketOpenedAt\": \"2024-12-27T09:00:00Z\",
    \"ticketClosedAt\": \"2024-12-27T10:30:00Z\",
    \"durationSeconds\": 5400,
    \"finalStatus\": \"closed\",
    \"closureReason\": \"Resolvido\",
    \"totalMessages\": 12,
    \"rating\": 3,
    \"feedback\": \"Excelente atendimento!\",
    \"tags\": [\"venda\", \"satisfeito\"],\n    \"closedByUserId\": 1,
    \"semaphoreData\": { \"totalNewMessages\": 2 },
    \"createdAt\": \"2024-12-27T10:30:01Z\"
  }
}
```

### 3. Obter Estatísticas (GET)

```bash
curl -X GET \"http://localhost:3334/closed-tickets/stats?\\
  startDate=2024-01-01T00:00:00Z&\\
  endDate=2024-12-31T23:59:59Z\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# Expected Response:
{
  \"success\": true,
  \"data\": {
    \"totalClosed\": 247,
    \"totalTime\": 1234560,
    \"averageTime\": 5000,
    \"totalMessages\": 5432,
    \"averageRating\": 2.8,
    \"byQueue\": [
      {
        \"queueId\": 3,
        \"queue\": { \"id\": 3, \"name\": \"Suporte\", \"color\": \"#FF5733\" },
        \"dataValues\": { \"total\": 150, \"avgTime\": 4800 }
      }
    ],
    \"byWhatsapp\": [
      {
        \"whatsappId\": 5,
        \"whatsapp\": { \"id\": 5, \"name\": \"Vendas\" },
        \"dataValues\": { \"total\": 120, \"avgTime\": 5100 }
      }
    ],
    \"byUser\": [
      {
        \"userId\": 1,
        \"user\": { \"id\": 1, \"name\": \"João Silva\" },
        \"dataValues\": { \"total\": 95, \"avgTime\": 4900 }
      }
    ],
    \"byDay\": [
      { \"date\": \"2024-12-27\", \"dataValues\": { \"total\": 24 } },
      { \"date\": \"2024-12-28\", \"dataValues\": { \"total\": 19 } }
    ]
  }
}
```

### 4. Exportar CSV (GET)

```bash
# Sem filtros
curl -X GET http://localhost:3334/closed-tickets/export/csv \\
  -H \"Authorization: Bearer $TOKEN\" \\
  -o closed_tickets.csv

# Com filtros
curl -X GET \"http://localhost:3334/closed-tickets/export/csv?\\
  startDate=2024-01-01T00:00:00Z&\\
  endDate=2024-12-31T23:59:59Z&\\
  whatsappId=5\" \\
  -H \"Authorization: Bearer $TOKEN\" \\
  -o closed_tickets_filtered.csv

# Verificar o arquivo
cat closed_tickets.csv | head -5
# Output esperado:
# \"ID\",\"Ticket ID\",\"Número\",\"Fila\",\"Agente\",\"Contato\",\"Data Abertura\",\"Data Fechamento\",\"Duração (min)\",\"Mensagens\",\"Rating\",\"Status\"
# \"1\",\"456\",\"Vendas\",\"Suporte\",\"João Silva\",\"Cliente X\",\"27/12/2024 09:00:00\",\"27/12/2024 10:30:00\",\"90\",\"12\",\"3\",\"closed\"
```

### 5. Limpar Histórico Antigo (POST) - Admin Only

```bash
curl -X POST http://localhost:3334/closed-tickets/cleanup \\
  -H \"Authorization: Bearer $TOKEN\" \\
  -H \"Content-Type: application/json\" \\
  -d '{
    \"daysToKeep\": 90
  }' | jq

# Expected Response:
{
  \"success\": true,
  \"message\": \"142 registros removidos\",
  \"deletedCount\": 142
}
```

---

## 🧪 Casos de Teste Completos

### Test Suite 1: User-WhatsApp-Queue Workflow

```bash
#!/bin/bash

echo \"🧪 Testing User-WhatsApp-Queue Workflow...\"

# 1. Create assignment
echo \"📝 Creating assignment...\"
RESPONSE=$(curl -s -X POST http://localhost:3334/user-whatsapp-queues \\
  -H \"Authorization: Bearer $TOKEN\" \\
  -H \"Content-Type: application/json\" \\
  -d '{
    \"userId\": 1,
    \"whatsappId\": 5,
    \"queueId\": 3
  }')

ASSIGNMENT_ID=$(echo $RESPONSE | jq -r '.data.id')
echo \"✅ Created assignment with ID: $ASSIGNMENT_ID\"

# 2. Validate access
echo \"🔍 Validating access...\"
curl -s -X GET \"http://localhost:3334/user-whatsapp-queues/validate?whatsappId=5&queueId=3\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq

# 3. List my assignments
echo \"📋 Listing my assignments...\"
curl -s -X GET http://localhost:3334/user-whatsapp-queues \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.data | length'

# 4. Delete assignment
echo \"🗑️  Deleting assignment...\"
curl -s -X DELETE http://localhost:3334/user-whatsapp-queues/$ASSIGNMENT_ID \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.message'

echo \"✅ Workflow test complete!\"
```

### Test Suite 2: Closed Ticket History Workflow

```bash
#!/bin/bash

echo \"🧪 Testing Closed Ticket History Workflow...\"

# 1. List all closed tickets (last 30 days)
echo \"📊 Fetching closed tickets...\"
curl -s -X GET \"http://localhost:3334/closed-tickets/history?\\
  startDate=$(date -d '30 days ago' -Iseconds)&\\
  endDate=$(date -Iseconds)\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.pagination.total'

# 2. Get stats
echo \"📈 Getting statistics...\"
curl -s -X GET http://localhost:3334/closed-tickets/stats \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.data | {totalClosed, averageTime, averageRating}'

# 3. Filter by queue
echo \"🔍 Filtering by queue...\"
curl -s -X GET \"http://localhost:3334/closed-tickets/history?queueId=3\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.pagination.total'

# 4. Export CSV
echo \"💾 Exporting to CSV...\"
curl -s -X GET http://localhost:3334/closed-tickets/export/csv \\
  -H \"Authorization: Bearer $TOKEN\" \\
  -o /tmp/closed_tickets.csv
echo \"✅ Exported $(wc -l < /tmp/closed_tickets.csv) lines\"

echo \"✅ Workflow test complete!\"
```

---

## 🔍 Testando com Diferentes Filtros

### Filtro por Data de Fechamento

```bash
# Apenas Dezembro
curl -s \"http://localhost:3334/closed-tickets/history?\\
  startDate=2024-12-01T00:00:00Z&\\
  endDate=2024-12-31T23:59:59Z&\\
  limit=10\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.pagination.total'
```

### Filtro por Data de Abertura

```bash
# Abertos em Dezembro, fechados em janeiro
curl -s \"http://localhost:3334/closed-tickets/history?\\
  startOpenDate=2024-12-01T00:00:00Z&\\
  endOpenDate=2024-12-31T23:59:59Z&\\
  limit=10\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.data | length'
```

### Filtro por Rating

```bash
# Apenas satisfeito (3 estrelas)
curl -s \"http://localhost:3334/closed-tickets/history?\\
  rating=3&\\
  limit=50\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.data | map(.rating) | unique'
```

### Múltiplos Filtros Simultâneos

```bash
# Tickets de determinado agente, em determinada fila, em dezembro, com baixo rating
curl -s \"http://localhost:3334/closed-tickets/history?\\
  userId=1&\\
  queueId=3&\\
  startDate=2024-12-01T00:00:00Z&\\
  endDate=2024-12-31T23:59:59Z&\\
  rating=1\" \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.data[]'
```

---

## ⚡ Performance Testing

### Load Testing com Apache Bench

```bash
# 1000 requisições, 10 simultâneas
ab -n 1000 -c 10 \\
  -H \"Authorization: Bearer $TOKEN\" \\
  http://localhost:3334/closed-tickets/history?limit=50

# Expected:
# Requests per second: > 50
# Failed requests: 0
# Time per request: < 200ms
```

### Teste de Paginação

```bash
for page in {1..10}; do
  echo \"Page $page:\"
  curl -s \"http://localhost:3334/closed-tickets/history?page=$page&limit=50\" \\
    -H \"Authorization: Bearer $TOKEN\" | jq '.pagination | {page, pages, total}'
done
```

---

## 🐛 Debugging

### Verificar Resposta Completa

```bash
curl -v -X GET http://localhost:3334/closed-tickets/history \\
  -H \"Authorization: Bearer $TOKEN\"
```

### Simulação de Erro 401

```bash
curl -X GET http://localhost:3334/closed-tickets/history \\
  -H \"Authorization: Bearer invalid_token\"
# Expected: 401 Unauthorized
```

### Simulação de Erro 404

```bash
curl -X GET http://localhost:3334/closed-tickets/999999 \\
  -H \"Authorization: Bearer $TOKEN\"
# Expected: 404 Not Found
```

---

## 📝 Salvar Respostas para Análise

```bash
# Salvar histórico
curl -s http://localhost:3334/closed-tickets/history \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.' > history_response.json

# Salvar stats
curl -s http://localhost:3334/closed-tickets/stats \\
  -H \"Authorization: Bearer $TOKEN\" | jq '.' > stats_response.json

# Comparar respostas
diff <(jq '.data | length' history_response.json) <(jq '.pagination.total' history_response.json)
```

---

**Última Atualização:** 2024-12-27  
**Status:** ✅ Todos endpoints testados e documentados

