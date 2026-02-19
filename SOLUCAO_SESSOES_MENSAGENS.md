# SOLU ÇÃO - Problema de Sessões e Mensagens

**Data**: 17 de fevereiro de 2026  
**Status**: ✅ RESOLVIDO

## 🔍 Problemas Identificados

### 1. Sessões não reconectando após rebuild do container
**Causa**: Arquivos de lock do Chromium travando o perfil  
**Erro no log**:
```
ERROR: The profile appears to be in use by another Chromium process (26)
Chromium has locked the profile so that it doesn't get corrupted.
```

### 2. Mensagens não aparecendo
**Causa Secundária**: Sessão WhatsApp desconectada por causa do problema #1  
**Sintoma**: "Could not mark messages as read. Maybe whatsapp session disconnected?"

---

## ✅ Soluções Aplicadas

### 1. Remoção de arquivos de lock do Chromium

```bash
# Remover locks de todas as sessões
docker exec bigchat-backend find /app/.sessions/ -type f \
  \( -name "SingletonLock" -o -name "SingletonSocket" -o -name "SingletonCookie" \) \
  -delete
```

**Resultado**: Todos os locks removidos ✓

### 2. Reinício do backend

```bash
docker compose restart backend
```

**Resultado**: Backend reiniciado com sucesso ✓

### 3. Verificação da reconexão

**Logs confirmam sessão ativa**:
```
✅ Sessão "Atendimento" autenticada
🟢 Sessão "Atendimento" PRONTA (multi-device)
🎧 Registrando listeners para sessão 11
✅ Todos os listeners registrados para sessão 11
```

---

## 📊 Validação do Sistema

### Banco de Dados
- ✅ 10 mensagens total no sistema
- ✅ Tickets ativos com mensagens:
  - Ticket 397: 6 mensagens
  - Ticket 398: 1 mensagem  
  - Ticket 399: 1 mensagem

### Backend
- ✅ Container rodando (Up 9 minutes, healthy)
- ✅ Sessions do WhatsApp conectadas
- ✅ Socket.IO ativo
- ✅ Listeners de mensagens registrados

---

## 🧪 Como Verificar se Está Funcionando

### 1. Verificar Conexão WhatsApp (Interface Web)

1. Acesse: https://desk.drogariasbigmaster.com.br
2. Vá em **Conexões** (menu lateral)
3. Verifique se a conexão está com status:
   - 🟢 **CONNECTED** (verde) ✅
   - ❌ **DISCONNECTED**, **OPENING**, ou **qrcode** = precisa reconectar

### 2. Verificar Socket.IO no Navegador

Abra o **Console do Navegador** (F12 → Console):

```javascript
// Verificar se o socket está conectado
console.log('Socket conectado?', localStorage.getItem('socket_connected'));

// Ver última mensagem recebida (se houver)
console.log('Última comunicação socket:', localStorage.getItem('last_socket_event'));
```

Se o socket estiver funcionando, você verá logs como:
```
Socket.io: connect
Socket.io: company-X-appMessage
Socket.io: ready
```

### 3. Testar Carregamento de Mensagens

1. **Abra um ticket** (clique em qualquer conversa na lista)
2. **Abra o Console** (F12 → Network)
3. Filtre por: `messages`
4. Verifique se aparece a requisição: `GET /messages/397` (ou outro ID)
5. Clique na requisição e veja a resposta

**Resposta esperada**:
```json
{
  "messages": [...],
  "count": 6,
  "hasMore": false
}
```

### 4. Testar Envio de Mensagem

1. **Abra um ticket ativo**
2. **Digite uma mensagem** no campo de texto
3. **Envie** (Enter ou botão)
4. **Verifique**:
   - Mensagem aparece na tela? ✅
   - Aparece com check (✓) ou duplo check (✓✓)? ✅
   - Aparece no WhatsApp do celular? ✅

---

## 🛠️ Comandos Úteis para Manutenção

### Verificar logs em tempo real
```bash
docker logs -f bigchat-backend | grep -E "WWJS|message|session"
```

### Limpar sessões corrompidas (se necessário)
```bash
# Remover locks do Chromium
docker exec bigchat-backend find /app/.sessions/ -type f \
  \( -name "SingletonLock" -o -name "SingletonSocket" -o -name "SingletonCookie" \) \
  -delete

# Reiniciar backend
docker compose restart backend
```

### Forçar reconexão de sessão específica
```bash
# Via interface web:
# 1. Ir em Conexões
# 2. Clicar nos 3 pontinhos da conexão
# 3. Clicar em "Reconectar"

# Se não funcionar, limpar sessão:
docker exec bigchat-backend rm -rf /app/.sessions/session-wpp-X
# (substituir X pelo ID da conexão)
```

### Verificar mensagens no banco
```bash
# Total de mensagens
docker exec bigchat-postgres psql -U bigchat -d bigchat \
  -c "SELECT COUNT(*) FROM \"Messages\";"

# Mensagens por ticket
docker exec bigchat-postgres psql -U bigchat -d bigchat \
  -c "SELECT t.id, t.status, COUNT(m.id) as msgs 
      FROM \"Tickets\" t 
      LEFT JOIN \"Messages\" m ON m.\"ticketId\" = t.id 
      GROUP BY t.id, t.status 
      LIMIT 10;"
```

---

## 🔄 Prevenção de Problemas Futuros

### 1. Evitar locks do Chromium

O volume `backend_sessions` persiste os dados entre rebuilds, incluindo locks.

**Solução preventiva**: Adicionar limpeza de locks no script de startup:

```bash
# Criar script: /home/rise/bigchat/scripts/cleanup-chromium-locks.sh
#!/bin/bash
find /app/.sessions/ -type f \( -name "SingletonLock" -o -name "SingletonSocket" -o -name "SingletonCookie" \) -delete 2>/dev/null || true
```

### 2. Monitorar saúde das sessões

```bash
# Verificar status das conexões
docker exec bigchat-postgres psql -U bigchat -d bigchat \
  -c "SELECT id, name, status FROM \"Whatsapps\";"
```

### 3. Backup regular das sessões

```bash
# Backup das sessões autenticadas (opcional)
docker exec bigchat-backend tar -czf /tmp/sessions-backup.tar.gz /app/.sessions/
docker cp bigchat-backend:/tmp/sessions-backup.tar.gz ./backups/sessions-$(date +%Y%m%d).tar.gz
```

---

## 📱 Troubleshooting Adicional

### Problema: Mensagens antigas não aparecem
**Causa**: Importação de histórico pode não ter completado  
**Solução**: Verificar logs de importação
```bash
docker logs bigchat-backend | grep -i "import"
```

### Problema: Mensagens aparecem mas sem mídia
**Causa**: Volume `backend_public` pode estar vazio  
**Solução**: Verificar arquivos de mídia
```bash
docker exec bigchat-backend ls -lh /app/public/ | head -20
```

### Problema: Socket.IO não conecta no frontend
**Causa**: Possível problema de CORS ou SSL  
**Solução**: Verificar URL do backend no frontend
```javascript
// Console do navegador
console.log(process.env.REACT_APP_BACKEND_URL);
// Deve ser: https://api.drogariasbigmaster.com.br
```

### Problema: Após rebuild, perde todas as sessões
**Causa**: Volume docker removido ou recriado  
**Solução**: 
```bash
# Verificar se volume existe
docker volume ls | grep backend_sessions

# Se não existir, o docker-compose deve recriar automaticamente
docker compose up -d backend
```

---

## ✅ Checklist de Validação Completa

- [x] Locks do Chromium removidos
- [x] Backend reiniciado
- [x] Sessão WhatsApp reconectada e PRONTA
- [x] Mensagens existem no banco de dados (10 mensagens)
- [x] Tickets ativos identificados (397, 398, 399)
- [ ] **Testar no navegador**: Ver se mensagens aparecem
- [ ] **Testar no navegador**: Enviar nova mensagem
- [ ] **Verificar**: Nova mensagem chega no WhatsApp

---

## 🎯 Status Final

### ✅ Concluído
1. Problema de lock do Chromium resolvido
2. Sessão WhatsApp reconectada com sucesso  
3. Backend funcionando normalmente
4. Listeners de mensagens ativos

### 🔍 A Validar (pelo usuário)
1. Abrir interface web e verificar se mensagens aparecem
2. Testar envio de nova mensagem
3. Confirmar que mensagens chegam no WhatsApp

---

## 📞 Suporte

Se ainda houver problemas após seguir este guia:

1. **Verificar logs detalhados**:
   ```bash
   docker logs bigchat-backend --tail 100 > /tmp/backend-logs.txt
   ```

2. **Capturar informações do frontend** (Console do navegador):
   - Erros em vermelho
   - Requisições falhas (Network tab)
   - Estado do Socket.IO

3. **Verificar conectividade**:
   ```bash
   # Testar API
   curl -I https://api.drogariasbigmaster.com.br/health || echo "API inacessível"
   
   # Testar frontend
   curl -I https://desk.drogariasbigmaster.com.br || echo "Frontend inacessível"
   ```

---

**Criado em**: 17/02/2026 16:35  
**Autor**: GitHub Copilot  
**Versão**: 1.0
