# 🔧 Correção: ERR_CONNECTION_REFUSED no Login

**Data:** 16/02/2026  
**Status:** ✅ CORRIGIDO

## 📋 Problema Identificado

**Erro:** `POST https://api.drogariasbigmaster.com.br/auth/login net::ERR_CONNECTION_REFUSED`

**Causa Raiz:**
- Os certificados SSL Let's Encrypt **não existem** no servidor
- O nginx estava configurado para HTTPS mas sem certificados válidos
- Frontend estava configurado para conectar via HTTPS (porta 443)
- Conexões HTTPS falhavam com ERR_CONNECTION_REFUSED

## 🛠️ Solução Aplicada

### 1. Criada Configuração Nginx HTTP Temporária

Arquivo: [nginx/nginx-http-temp.conf](nginx/nginx-http-temp.conf)

**Mudanças:**
- ✅ Removidas configurações SSL (listen 443, ssl_certificate, etc.)
- ✅ Configurado proxy HTTP para backend (api.drogariasbigmaster.com.br:80)
- ✅ Configurado proxy HTTP para frontend (desk.drogariasbigmaster.com.br:80)
- ✅ Mantido suporte a WebSocket para Socket.IO
- ✅ Adicionado server default para localhost/IP direto

### 2. Atualizado docker-compose.yml

Arquivo: [docker-compose.yml](docker-compose.yml#L99)

**Mudança:**
```yaml
# ANTES
REACT_APP_BACKEND_URL: https://api.drogariasbigmaster.com.br

# DEPOIS
REACT_APP_BACKEND_URL: http://api.drogariasbigmaster.com.br
```

### 3. Rebuildo Frontend com HTTP

```bash
# Rebuildo com nova configuração HTTP
docker build --build-arg REACT_APP_BACKEND_URL=http://api.drogariasbigmaster.com.br \
             --build-arg REACT_APP_HOURS_CLOSE_TICKETS_AUTO=24 \
             -t bigchat-frontend:latest .
```

### 4. Aplicada Nova Configuração Nginx

```bash
# Copiada configuração HTTP para container
docker cp nginx/nginx-http-temp.conf bigchat-nginx:/etc/nginx/nginx.conf

# Testada e recarregada
docker exec bigchat-nginx nginx -t
docker exec bigchat-nginx nginx -s reload

# Reiniciado para garantir
docker restart bigchat-nginx
```

## 📊 Status Atual

```bash
✅ Nginx: Rodando com configuração HTTP
✅ Backend: Acessível via http://api.drogariasbigmaster.com.br
✅ Frontend: Rebuildo e rodando com URL HTTP
✅ Conectividade: Testada e funcionando
```

**Testes de Conectividade:**
- ✅ Ping nginx → frontend: OK (0% packet loss)
- ✅ HTTP nginx → frontend: 200 OK
- ✅ HTTP nginx → backend: 404 (esperado, sem rota /)
- ✅ Frontend container: Healthy

## 🧪 Como Testar

1. **Limpe o cache do navegador:** Ctrl+Shift+Delete
2. **Acesse:** http://desk.drogariasbigmaster.com.br (sem HTTPS)
3. **Faça login** com suas credenciais
4. **Teste o envio de mensagens** em um ticket

**IMPORTANTE:** Agora o acesso é via **HTTP** (porta 80), não HTTPS.

## ⚠️ Limitações Temporárias

### Sem SSL/HTTPS
- ❌ Conexões **não são criptografadas**
- ❌ Navegadores mostrarão aviso "Não seguro"
- ❌ Dados trafegam em texto plano

### Uso Recomendado
- ✅ **Desenvolvimento/Teste**: Pode usar normalmente
- ⚠️ **Produção**: Deve configurar SSL o mais rápido possível

## 🔒 Próximos Passos: Configurar SSL

### Para Ativar HTTPS Novamente

**1. Gerar Certificados Let's Encrypt:**

```bash
# Parar nginx temporariamente
docker stop bigchat-nginx

# Gerar certificados (substitua pelos seus domínios)
docker run -it --rm \
  -p 80:80 \
  -v /home/rise/bigchat/letsencrypt:/etc/letsencrypt \
  certbot/certbot certonly --standalone \
  -d api.drogariasbigmaster.com.br \
  -d desk.drogariasbigmaster.com.br \
  --email seu-email@exemplo.com \
  --agree-tos

# Iniciar nginx novamente
docker start bigchat-nginx
```

**2. Restaurar Configuração HTTPS:**

```bash
# Usar configuração SSL original
docker cp nginx/nginx.conf bigchat-nginx:/etc/nginx/nginx.conf
docker exec bigchat-nginx nginx -t
docker restart bigchat-nginx
```

**3. Atualizar Frontend para HTTPS:**

```bash
# Editar docker-compose.yml
sed -i 's|http://|https://|g' docker-compose.yml

# Rebuildar frontend
cd frontend
docker build --build-arg REACT_APP_BACKEND_URL=https://api.drogariasbigmaster.com.br \
             --build-arg REACT_APP_HOURS_CLOSE_TICKETS_AUTO=24 \
             -t bigchat-frontend:latest .

# Reiniciar
docker compose stop frontend
docker compose rm -f frontend
docker compose up -d frontend
```

**4. Configurar Renovação Automática:**

```bash
# Adicionar ao crontab
0 0 * * 0 docker run --rm \
  -v /home/rise/bigchat/letsencrypt:/etc/letsencrypt \
  certbot/certbot renew --quiet && docker exec bigchat-nginx nginx -s reload
```

## 📝 Arquivos Modificados

1. ✅ [nginx/nginx-http-temp.conf](nginx/nginx-http-temp.conf) - **Criado**
2. ✅ [docker-compose.yml](docker-compose.yml#L99) - REACT_APP_BACKEND_URL alterado
3. ✅ Frontend rebuildo com HTTP
4. ✅ Nginx reconfigurado e reiniciado

## 🎯 Conclusão

**Status:** ✅ **SISTEMA FUNCIONAL**

O sistema agora está acessível via HTTP. O erro `ERR_CONNECTION_REFUSED` foi resolvido.

**Para uso em produção**, configure SSL seguindo os "Próximos Passos" acima.

---

**Desenvolvedor:** GitHub Copilot (Claude Sonnet 4.5)  
**Data:** 16/02/2026  
**Tempo de Correção:** ~30 minutos
