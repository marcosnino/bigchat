# 🚀 Deploy Checklist: Sistema de Handoff + Histórico

## 📋 Pré-Deploy: Verificações Iniciais

### Backend

- [ ] **Compilação TypeScript**
  ```bash
  cd backend
  npm run build
  # Verificar se sem erros
  ```

- [ ] **Linting & Code Quality**
  ```bash
  npm run lint
  npm run prettier:check
  # Corrigir qualquer erro
  ```

- [ ] **Testes Unitários**
  ```bash
  npm test
  # Pelo menos 80% coverage
  ```

- [ ] **Verificação de Dependências**
  ```bash
  npm audit
  # Ser zero vulnerabilities críticas
  ```

### Frontend

- [ ] **Build Otimizado**
  ```bash
  cd frontend
  npm run build
  # Verificar se sem erros
  ```

- [ ] **Análise de Bundle**
  ```bash
  npm run analyze
  # Verificar se < 500KB gzip
  ```

- [ ] **Testes de ESLint**
  ```bash
  npm run lint
  ```

---

## 🔄 Deploy em Staging

### 1. Backend Staging Deploy

```bash
# 1. Backup do banco de dados
pg_dump bigchat_staging > backup_staging_$(date +%Y%m%d_%H%M%S).sql

# 2. Atualizar código
git pull origin main
npm install

# 3. Build
npm run build

# 4. Executar migrações
npm run migrations

# 5. Reiniciar servidor
pm2 restart bigchat-backend

# 6. Verificar logs
pm2 logs bigchat-backend --lines 50
```

### 2. Frontend Staging Deploy

```bash
# 1. Build
npm run build

# 2. Deploy para servidor web
# (Usando seu método: S3, GitHub Pages, Vercel, etc)
npm run deploy:staging

# 3. Verificar acesso
# Abrir http://staging.seu-dominio.com
# Testar páginas:
# - http://staging/.../user-whatsapp-queues
# - http://staging/.../closed-tickets
```

### 3. Testes em Staging

```bash
# 1. Login como usuário de teste
# 2. Testar UserWhatsappQueue
#    - Criar assinação
#    - Validar acesso
#    - Listar assinações
#    - Deletar assinação

# 3. Testar ClosedTicketHistory
#    - Fechar ticket (gera histórico)
#    - Buscar histórico
#    - Filtrar por data/número/fila/usuário/rating
#    - Exportar CSV
#    - Ver detalhes

# 4. Performance
#    - Carregar dashboard com 1000 registros
#    - Medir tempo de resposta
#    - Verificar memória

# 5. Stress test
#    - Simular 100 requisições simultâneas
#    - Apache Bench: ab -n 100 -c 10 http://staging/.../closed-tickets/history
```

---

## ✅ Checklist de Preparação

### Banco de Dados

- [ ] **Migrações criadas**
  ```bash
  ls -la database/migrations/ | grep -E "20260212000001|20260212000002"
  ```

- [ ] **Backup executado**
  ```bash
  pg_dump bigchat_production > backup_pre_deploy.sql
  gzip backup_pre_deploy.sql
  ```

- [ ] **Índices criados**
  ```sql
  SELECT * FROM pg_indexes 
  WHERE tablename = 'closed_ticket_histories';
  -- Deve retornar 7 linhas de índices
  ```

- [ ] **Relacionamentos validados**
  ```sql
  SELECT constraint_name, table_name 
  FROM information_schema.table_constraints 
  WHERE table_name = 'closed_ticket_histories';
  ```

### Backend

- [ ] **Variáveis de ambiente configuradas**
  ```bash
  env | grep -E "NODE_ENV|DB_|SENTRY|API"
  # Deve estar em production
  ```

- [ ] **Rotas registradas**
  ```bash
  grep -r "closedTicketHistoryRoutes\|userWhatsappQueueRoutes" src/routes/index.ts
  ```

- [ ] **Services carregam sem erro**
  ```bash
  npm run build 2>&1 | grep -i error
  # Deve retornar vazio
  ```

- [ ] **Controllers acessíveis**
  ```bash
  curl -X GET http://localhost:3334/closed-tickets/stats \
    -H "Authorization: Bearer test_token" \
    -w "\nStatus: %{http_code}\n"
  ```

### Frontend

- [ ] **Páginas dentro do router**
  ```bash
  grep -r "ClosedTicketHistory\|UserWhatsappQueue" src/routes
  ```

- [ ] **Menu items configurados**
  ```bash
  grep -r "closed-tickets\|user-whatsapp-queues" src/layout
  ```

- [ ] **Assets compilados**
  ```bash
  ls -la build/ | wc -l
  # Deve ter > 50 arquivos
  ```

- [ ] **Service workers atualizados**
  ```bash
  grep -l "closed-tickets\|user-whatsapp-queues" build/precache-manifest*
  ```

---

## 🚀 Deploy em Produção

### Fase 1: Preparação (2-3 horas antes)

```bash
#!/bin/bash
# deploy_prepare.sh

set -e

echo "🔄 Starting pre-deployment checklist..."

# 1. Database backup
echo "📦 Creating database backup..."
BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql.gz"
pg_dump $DATABASE_URL | gzip > /backups/$BACKUP_FILE
echo "✅ Backup created: $BACKUP_FILE"

# 2. Current state snapshot
echo "📸 Taking code snapshot..."
git log --oneline -1 > /backups/current_commit.txt
git status > /backups/current_status.txt

# 3. Health check
echo "💚 Checking server health..."
curl -f http://localhost:3334/health || exit 1
echo "✅ Server healthy"

echo "✅ Pre-deployment checklist complete!"
```

### Fase 2: Deploy (app downtime: ~10 min)

```bash
#!/bin/bash
# deploy_production.sh

set -e

echo "🚀 Starting production deployment..."

# 1. Stop application
echo "⏹️  Stopping application..."
pm2 stop bigchat-backend
pm2 stop bigchat-frontend

# 2. Update code
echo "📥 Pulling latest code..."
cd /app/backend
git pull origin main
npm install

cd /app/frontend
git pull origin main
npm install

# 3. Build
echo "🔨 Building..."
cd /app/backend
npm run build
npm run build:migrations

cd /app/frontend
npm run build

# 4. Database migrations
echo "🗄️  Running migrations..."
cd /app/backend
npm run migrations

# 5. Start application
echo "▶️  Starting application..."
pm2 start bigchat-backend
pm2 start bigchat-frontend

# 6. Health check
echo "💚 Waiting for health..."
sleep 10
curl -f http://localhost:3334/health || exit 1
curl -f http://localhost:3000/closed-tickets || exit 1

echo "✅ Deployment complete!"
```

### Fase 3: Validação Pós-Deploy (30 min)

```bash
#!/bin/bash
# deployment_validation.sh

set -e

echo "🔍 Post-deployment validation..."

# 1. Database check
echo "📊 Checking database..."
psql $DATABASE_URL -c "SELECT COUNT(*) FROM closed_ticket_histories;"
echo "✅ Database accessible"

# 2. API endpoints
echo "🔗 Testing API endpoints..."
curl -f http://localhost:3334/closed-tickets/stats || exit 1
echo "✅ API working"

# 3. Frontend accessibility
echo "🌐 Testing frontend..."
curl -f http://localhost:3000/closed-tickets || exit 1
echo "✅ Frontend working"

# 4. Performance metrics
echo "⚡ Checking performance..."
LOAD_TIME=$(curl -o /dev/null -s -w '%{time_total}' http://localhost:3334/closed-tickets/history)
echo "Load time: ${LOAD_TIME}s"
if (( $(echo "$LOAD_TIME > 2" | bc -l) )); then
  echo "⚠️  Performance issue detected!"
  exit 1
fi
echo "✅ Performance acceptable"

# 5. Error tracking
echo "🐛 Checking error tracking..."
curl -f http://localhost:3334/health || exit 1
echo "✅ Error tracking active"

echo "✅ All validations passed!"
```

---

## 📊 Rollback Procedure

**SE ALGO DER ERRADO:**

```bash
#!/bin/bash
# rollback.sh

set -e

echo "⚠️  INITIATING ROLLBACK..."

# 1. Stop application
pm2 stop bigchat-backend
pm2 stop bigchat-frontend

# 2. Restore database
echo "🔄 Restoring database..."
psql $DATABASE_URL < /backups/backup_pre_deploy.sql.gz
echo "✅ Database restored"

# 3. Checkout previous code
echo "🔙 Reverting code..."
cd /app/backend
git reset --hard $(cat /backups/current_commit.txt | cut -d' ' -f1)

cd /app/frontend
git reset --hard $(cat /backups/current_commit.txt | cut -d' ' -f1)

# 4. Rebuild
echo "🔨 Rebuilding..."
cd /app/backend
npm install
npm run build

cd /app/frontend
npm install
npm run build

# 5. Start
echo "▶️  Starting application..."
pm2 start bigchat-backend
pm2 start bigchat-frontend

# 6. Health check
sleep 10
curl -f http://localhost:3334/health || exit 1

echo "✅ Rollback complete!"
echo "⚠️  PLEASE REVIEW WHAT WENT WRONG BEFORE RE-DEPLOYING"
```

---

## 📱 Monitoramento Pós-Deploy (1-7 dias)

### 1º Dia (Horas críticas)

- [ ] **A cada 30 min**
  - Verificar logs de erro
  - Monitor de CPU/Memória
  - Monitor de requisições

- [ ] **4 vezes ao dia**
  - Teste manual de usuário
  - Verificar storage de histórico
  - Validar backups

### 1ª Semana

- [ ] **Diário**
  - Metrics no Sentry
  - Error rate < 1%
  - Response time < 500ms
  - Database size growth normal

- [ ] **Cada 3 dias**
  - Teste de performance com carga
  - Validar relacionamentos FKs
  - Verificar índices em uso

### 1º Mês

- [ ] **Semanal**
  - Limpeza automática funcionando
  - Histórico crescendo normalmente
  - Stats computadas corretamente

---

## 🔒 Pós-Deploy Security Checks

```bash
# 1. Verificar permissões
psql $DATABASE_URL -c "SELECT * FROM pg_default_acl 
WHERE defaclobjtype = 't' LIMIT 10;"

# 2. Verificar logs de acesso
tail -f /var/log/nginx/access.log | grep closed-tickets

# 3. Verificar token expiration
curl http://localhost:3334/closed-tickets/history \
  -H "Authorization: Bearer expired_token" \
  -w "\nStatus: %{http_code}\n"
# Deve retornar 401

# 4. Verificar SQL injection protection
curl "http://localhost:3334/closed-tickets/history?whatsappId=1;DROP TABLE users" \
  -H "Authorization: Bearer valid_token" \
  -w "\nStatus: %{http_code}\n"
# Deve retornar 400 ou 500, não executar query

# 5. Verificar rate limiting
for i in {1..100}; do
  curl http://localhost:3334/closed-tickets/history \
    -H "Authorization: Bearer valid_token" &
done
# Deve retornar 429 após limite
```

---

## 📞 Contatos de Emergência

```
ESCALATION CHAIN:
1. DevOps Lead: +55-XXXX-XXXX
2. Tech Lead: +55-XXXX-XXXX  
3. CTO: +55-XXXX-XXXX
4. PagerDuty: https://...

MONITORING DASHBOARDS:
- Grafana: https://monitoring.seu-dominio.com
- Datadog: https://app.datadoghq.com
- Sentry: https://sentry.seu-dominio.com
```

---

## ✅ Checklist Final

**Antes de fazer deploy:**

- [ ] Todas as mudanças no git
- [ ] Testes passando (npm test)
- [ ] Build sem avisos (npm run build)
- [ ] Migrations criadas e testadas
- [ ] Documentação atualizada
- [ ] Team informado do tempo de downtime
- [ ] Backup feito
- [ ] Rollback script testado
- [ ] Monitoramento configurado
- [ ] On-call engineer designado

**Durante o deploy:**

- [ ] Tempo de início registrado
- [ ] Logs sendo monitorados
- [ ] Equipe em standby

**Após o deploy:**

- [ ] Health checks passando
- [ ] Integrações funcionando
- [ ] Performance aceitável
- [ ] Erros dentro do esperado
- [ ] Usuários reportando OK

---

## 📊 Métricas de Sucesso

| Métrica | Antes | Depois | Goal |
|---------|-------|--------|------|
| Response Time | ~300ms | ? | < 500ms |
| Error Rate | < 0.5% | ? | < 0.1% |
| Uptime | 99.9% | ? | 99.95% |
| CPU Usage (avg) | 45% | ? | < 60% |
| Memory Usage | 2GB | ? | < 2.5GB |
| DB Connections | 5 | ? | < 10 |

---

## 🎉 Conclusão

Once everything is validated:

1. **Announce success**
   - Notificar stakeholders
   - Update status page
   - Create release notes

2. **Document lessons learned**
   - Postmortem se houver issues
   - Update runbooks
   - Training para time

3. **Monitor daily por 7 dias**
   - Alertas ativados
   - Logs analisados
   - Performance tracked

---

**Deploy Reference:** v1.0.0  
**Last Updated:** 2024-12-27  
**Approved By:** [Tech Lead Name]

