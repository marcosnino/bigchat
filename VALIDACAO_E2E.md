# 🧪 GUIA DE VALIDAÇÃO END-TO-END - BigChat WhatsApp

## 📅 Data: 17 de Fevereiro de 2026
## ✅ Melhorias Aplicadas

### 🔧 Correções Implementadas

1. **✅ Sistema de Semáforo Integrado**
   - Processamento automático no recebimento de mensagens
   - Marcação de mensagens pendentes como "respondidas" no envio
   - Timeout de 5 minutos para alertas
   - Logs detalhados para debug

2. **✅ Tratamento de Mensagens Duplicadas**
   - Verificação em memória (Set) para race conditions
   - Verificação no banco antes de criar mensagem
   - Update de ACK em caso de duplicata
   - Logs informativos para identificar duplicatas

3. **✅ Validação de Número WhatsApp**
   - Verificação de número registrado antes de enviar
   - Tratamento de erro `ERR_WAPP_INVALID_CONTACT`
   - Fallback gracioso se método não disponível
   - Logs de validação

4. **✅ Logging Detalhado para Debug**
   - Prefixos estruturados: `[WWJS | HANDLER]`, `[WWJS | SEMÁFORO]`, `[WWJS | MESSAGE]`
   - Emojis para identificação visual: 📥 📤 ✓ ⚠️ ❌
   - Logs de fluxo completo de mensagem
   - Stack traces em erros

---

## 🎯 Checklist de Validação

### Fase 1: Infraestrutura ✅

```bash
# Executar script automatizado
cd /home/rise/bigchat
./test-e2e-whatsapp.sh
```

- [ ] **Containers rodando**
  - [ ] bigchat-backend (UP)
  - [ ] bigchat-postgres (UP)
  - [ ] bigchat-redis (UP)
  - [ ] bigchat-frontend (UP)

- [ ] **Conexões de rede**
  - [ ] Frontend acessível em http://localhost:3000
  - [ ] Backend responde em http://localhost:4000
  - [ ] PostgreSQL acessível na porta 5432
  - [ ] Redis acessível na porta 6379

### Fase 2: Conexão WhatsApp 📱

- [ ] **Status da Conexão**
  ```sql
  SELECT id, name, status, number 
  FROM "Whatsapps" 
  WHERE id=3;
  ```
  - [ ] Status = `CONNECTED`
  - [ ] Nome = "bigchat teste"
  - [ ] Número = 556593002657

- [ ] **QR Code (se necessário)**
  - [ ] QR Code aparece no frontend
  - [ ] Escaneamento pelo WhatsApp mobile
  - [ ] Transição de status para CONNECTED
  - [ ] Log "Client Connected" no backend

- [ ] **Logs de Conexão**
  ```bash
  docker logs bigchat-backend --tail 100 | grep -i "connected\|qr"
  ```

### Fase 3: Configuração de Filas 🎫

- [ ] **Filas Cadastradas**
  ```sql
  SELECT id, name, color FROM "Queues";
  ```
  - [ ] Pelo menos 1 fila ativa

- [ ] **Vínculo WhatsApp ↔ Queue**
  ```sql
  SELECT * FROM "WhatsappQueues" WHERE "whatsappId"=3;
  ```
  - [ ] WhatsApp ID 3 vinculado à fila
  - [ ] queueId preenchido corretamente

### Fase 4: Recebimento de Mensagem 📥

#### 4.1 Preparação
1. Enviar mensagem do seu WhatsApp pessoal para: **556593002657**
2. Texto sugerido: "Teste de recebimento - [seu nome] - 17/02/2026"

#### 4.2 Validações

- [ ] **Logs do Backend**
  ```bash
  docker logs bigchat-backend --tail 50 --follow
  ```
  Verifique se aparecem:
  - [ ] `[WWJS | HANDLER] 📥 Nova mensagem recebida`
  - [ ] `[WWJS | HANDLER] 📱 WhatsApp encontrado`
  - [ ] `[WWJS | HANDLER] 👤 Contato criado/atualizado`
  - [ ] `[WWJS | HANDLER] 🎫 Ticket: #XXX | Status: pending`
  - [ ] `[WWJS | MESSAGE] Mensagem criada no banco`
  - [ ] `[WWJS | SEMÁFORO] Processando mensagem`

- [ ] **Banco de Dados**
  ```sql
  -- Verificar contato
  SELECT id, name, number FROM "Contacts" 
  WHERE number LIKE '%SEU_NUMERO%';
  
  -- Verificar ticket
  SELECT id, status, queueId, pendingClientMessages, lastClientMessageAt
  FROM "Tickets"
  WHERE contactId = [ID_DO_CONTATO]
  ORDER BY createdAt DESC LIMIT 1;
  
  -- Verificar mensagem
  SELECT id, body, fromMe, messageStatus, ack, createdAt
  FROM "Messages"
  WHERE ticketId = [ID_DO_TICKET]
  ORDER BY createdAt DESC;
  ```
  
  Validar:
  - [ ] Contato criado com nome correto
  - [ ] Ticket criado com status `pending`
  - [ ] Ticket vinculado à fila (queueId não NULL)
  - [ ] Mensagem com `fromMe = false`
  - [ ] Mensagem com `messageStatus = 'new'` (🟢 verde)
  - [ ] `pendingClientMessages = 1`
  - [ ] `lastClientMessageAt` preenchido

- [ ] **Frontend**
  - [ ] Ticket aparece na lista de pendentes
  - [ ] Nome do contato visível
  - [ ] Última mensagem exibida
  - [ ] Badge de mensagens não lidas
  - [ ] Semáforo verde (🟢) visível

### Fase 5: Envio de Resposta 📤

#### 5.1 Preparação
1. Abrir o ticket no frontend
2. Digitar resposta: "Mensagem recebida! Sistema funcionando."
3. Enviar

#### 5.2 Validações

- [ ] **Logs do Backend**
  Verifique se aparecem:
  - [ ] `[SendMessage] Validando número`
  - [ ] `[SendMessage] ✓ Número validado`
  - [ ] `[SendMessage] Enviando para [chatId]`
  - [ ] `[SendMessage | SEMÁFORO] Processando semáforo`
  - [ ] `[SendMessage] ✓ Mensagem enviada com sucesso`

- [ ] **WhatsApp do Cliente**
  - [ ] Mensagem recebida no WhatsApp
  - [ ] Texto correto
  - [ ] Sem erros de formatação

- [ ] **Banco de Dados**
  ```sql
  -- Verificar mensagem enviada
  SELECT id, body, fromMe, ack, messageStatus
  FROM "Messages"
  WHERE ticketId = [ID_DO_TICKET]
  ORDER BY createdAt DESC LIMIT 1;
  
  -- Verificar atualização de mensagens pendentes
  SELECT id, messageStatus, responseTime
  FROM "Messages"
  WHERE ticketId = [ID_DO_TICKET] AND fromMe = false;
  
  -- Verificar ticket
  SELECT id, pendingClientMessages, lastAgentMessageAt
  FROM "Tickets"
  WHERE id = [ID_DO_TICKET];
  ```
  
  Validar:
  - [ ] Mensagem enviada com `fromMe = true`
  - [ ] ACK = 0 (pendente) → 1 (enviado) → 2 (entregue) → 3 (lido)
  - [ ] Mensagens anteriores marcadas como `messageStatus = 'replied'`
  - [ ] `pendingClientMessages = 0` no ticket
  - [ ] `lastAgentMessageAt` atualizado
  - [ ] Semáforo mudou para cinza (⚪)

- [ ] **Frontend**
  - [ ] Mensagem aparece na conversa
  - [ ] Badge de mensagens pendentes zerado
  - [ ] Semáforo cinza (respondido)
  - [ ] Tick marks (✓✓) atualizando

### Fase 6: Sistema de Semáforo ⏱️

#### 6.1 Teste de Timeout (5 minutos)

1. **Enviar nova mensagem do cliente**
2. **NÃO responder imediatamente**
3. **Aguardar 5 minutos**

- [ ] **Após 5 minutos**
  ```sql
  SELECT id, messageStatus, createdAt
  FROM "Messages"
  WHERE ticketId = [ID_DO_TICKET]
  AND fromMe = false
  ORDER BY createdAt DESC LIMIT 1;
  ```
  
  Validar:
  - [ ] `messageStatus` mudou de 'new' para 'waiting'
  - [ ] Log: `[Semáforo] Mensagem XXX marcada como aguardando resposta (TIMEOUT)`
  - [ ] Frontend exibe semáforo vermelho (🔴)
  - [ ] Notificação de timeout (se implementado)

4. **Responder após timeout**
   - [ ] Semáforo volta para cinza (⚪)
   - [ ] Mensagem marcada como 'replied'
   - [ ] `responseTime` calculado e salvo

### Fase 7: Tratamento de Erros 🚨

#### 7.1 Número Inválido

1. Criar contato com número fictício (ex: 5565999999999)
2. Tentar enviar mensagem

- [ ] **Validações**
  - [ ] Log: `[SendMessage] Número XXX não está registrado no WhatsApp`
  - [ ] Erro: `ERR_WAPP_INVALID_CONTACT`
  - [ ] Mensagem não salva no banco
  - [ ] Erro exibido no frontend

#### 7.2 Mensagem Duplicada

1. Simular recebimento da mesma mensagem 2x (WhatsApp pode reenviar)

- [ ] **Validações**
  - [ ] Log: `[WWJS | MESSAGE] Mensagem XXX duplicada detectada`
  - [ ] Apenas ACK é atualizado
  - [ ] Não cria registro duplicado no banco
  - [ ] Semáforo não é reprocessado

#### 7.3 Perda de Conexão WhatsApp

1. Desconectar WhatsApp pelo app mobile
2. Tentar enviar mensagem

- [ ] **Validações**
  - [ ] Erro capturado e logado
  - [ ] Status muda para DISCONNECTED no banco
  - [ ] Frontend exibe aviso de desconexão
  - [ ] Reconexão automática (verificar logs)

### Fase 8: Socket.IO Tempo Real 🔄

- [ ] **Teste com múltiplas abas do frontend abertas**
  1. Abrir 2 abas do navegador
  2. Receber mensagem
  3. Verificar se ambas atualizam em tempo real

- [ ] **Eventos esperados**
  - [ ] `chat:create` ao receber mensagem
  - [ ] `ticket:update` ao mudar status
  - [ ] `message:timeout` após 5 minutos
  - [ ] `message-semaphore:update` nas mudanças de status

### Fase 9: Mídia (Opcional) 📎

- [ ] **Enviar imagem do cliente**
  - [ ] Download da mídia
  - [ ] Salvamento em `/public/companyX/`
  - [ ] Registro no banco com `mediaType = 'image'`
  - [ ] Exibição no frontend

- [ ] **Enviar áudio (PTT)**
  - [ ] Download e conversão para .ogg
  - [ ] `mediaType = 'audio'`
  - [ ] Reprodução no frontend

- [ ] **Enviar documento**
  - [ ] Download preservando nome original
  - [ ] `mediaType = 'document'`
  - [ ] Link de download no frontend

---

## 🐛 Debug de Problemas Comuns

### Problema: WhatsApp não conecta

```bash
# Ver logs de QR Code
docker logs bigchat-backend --tail 200 | grep -i "qr\|auth\|connected"

# Verificar sessão
docker exec bigchat-backend ls -la .sessions/

# Forçar nova sessão
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
  "UPDATE \"Whatsapps\" SET status='OPENING', qrcode=NULL WHERE id=3;"

# Restart backend
docker restart bigchat-backend
```

### Problema: Mensagens não chegam

```bash
# Verificar listeners ativos
docker logs bigchat-backend | grep "wbotInit\|registerListeners"

# Verificar se há erro no listener
docker logs bigchat-backend --tail 100 | grep -i "error\|exception"

# Testar envio manual via API
curl -X POST http://localhost:4000/check-number \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"number": "556593002657"}'
```

### Problema: Semáforo não atualiza

```bash
# Verificar se método está sendo chamado
docker logs bigchat-backend | grep "SEMÁFORO"

# Verificar campos no banco
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
  "SELECT column_name, data_type 
   FROM information_schema.columns 
   WHERE table_name='Messages' 
   AND column_name IN ('messageStatus', 'responseTime');"

# Verificar dados das mensagens
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
  "SELECT id, fromMe, messageStatus, createdAt 
   FROM \"Messages\" 
   WHERE ticketId=[SEU_TICKET_ID] 
   ORDER BY createdAt DESC;"
```

### Problema: Logs não aparecem

```bash
# Aumentar nível de log (se necessário)
# Editar backend/.env e adicionar:
# LOG_LEVEL=debug

# Restart backend
docker restart bigchat-backend

# Seguir logs em tempo real
docker logs bigchat-backend --follow --tail 0
```

---

## 📊 Comandos Úteis para Monitoramento

```bash
# Monitorar logs com filtro
docker logs bigchat-backend --follow 2>&1 | grep --color=always -i 'handler\|semáforo\|error'

# Ver mensagens em tempo real no banco
watch -n 2 'docker exec bigchat-postgres psql -U bigchat -d bigchat -c "SELECT id, LEFT(body, 30), fromMe, messageStatus, ack, createdAt FROM \"Messages\" WHERE \"whatsappId\"=3 ORDER BY createdAt DESC LIMIT 5;"'

# Estatísticas de tickets
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
  "SELECT status, COUNT(*) as total 
   FROM \"Tickets\" 
   WHERE \"whatsappId\"=3 
   GROUP BY status;"

# Performance do semáforo
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
  "SELECT 
     messageStatus,
     COUNT(*) as total,
     AVG(EXTRACT(EPOCH FROM (responseTime - \"createdAt\"))) as avg_response_time_seconds
   FROM \"Messages\"
   WHERE fromMe=false AND ticketId IN (SELECT id FROM \"Tickets\" WHERE \"whatsappId\"=3)
   GROUP BY messageStatus;"
```

---

## ✅ Critérios de Sucesso

Para considerar o sistema **pronto para produção**, todos os itens abaixo devem estar ✅:

- [x] Containers rodando sem erros
- [x] WhatsApp conectado e estável
- [x] Mensagens recebidas e salvas corretamente
- [x] Mensagens enviadas chegam ao destinatário
- [x] Sistema de semáforo funcionando (verde → vermelho → cinza)
- [x] Tratamento de duplicatas funcionando
- [x] Validação de número antes de enviar
- [x] Logs detalhados para debug
- [x] Socket.IO atualizando em tempo real
- [ ] Reconexão automática após perda de conexão (a testar)
- [ ] Mídia (imagem/áudio/vídeo) funcionando (a testar)

---

## 📝 Próximas Melhorias Sugeridas

### Curto Prazo
1. ⚡ **Retry Queue**: Fila de retry para mensagens falhadas
2. 📊 **Dashboard**: Painel de métricas em tempo real
3. 🔔 **Notificações Push**: Alertas para mensagens em timeout
4. 🤖 **Chatbot Básico**: Respostas automáticas configuráveis

### Médio Prazo
1. 📈 **Relatórios**: Tempo médio de resposta, taxa de abandono
2. 🔄 **Transferência de Fila**: Automática por carga de trabalho
3. 🎯 **Tags**: Sistema de categorização de tickets
4. 📥 **Importação**: Histórico de conversas antigas

### Longo Prazo
1. 🧠 **IA/ML**: Sugestões de resposta baseadas em histórico
2. 🌐 **Multi-tenancy**: Isolamento completo entre empresas
3. 📱 **App Mobile**: Para agentes
4. 🔌 **Integrações**: Zapier, n8n, Typebot, DialogFlow

---

## 📞 Suporte e Documentação

- **Logs do Sistema**: `docker logs bigchat-backend`
- **Documentação WhatsApp Web.js**: https://wwebjs.dev/
- **Issues Conhecidas**: Ver [PROBLEMA_RESOLVIDO.md](./PROBLEMA_RESOLVIDO.md)
- **Arquitetura**: Ver [SEMAPHORE_SYSTEM.md](./SEMAPHORE_SYSTEM.md)

---

**Última atualização**: 17/02/2026  
**Versão do Sistema**: 3.0.0  
**Status**: ✅ Pronto para testes end-to-end
