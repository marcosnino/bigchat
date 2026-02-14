#!/bin/bash
set -euo pipefail

# =============================================
# BigChat — Deploy Script
# =============================================

cd "$(dirname "$0")"

DOMAIN_API="api.drogariasbigmaster.com.br"
DOMAIN_FRONT="desk.drogariasbigmaster.com.br"
EMAIL="admin@drogariasbigmaster.com.br"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
info() { echo -e "${CYAN}[i]${NC} $1"; }

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}       BigChat — Deploy Production      ${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# --- Pré-validações ---
command -v docker >/dev/null 2>&1 || err "Docker não encontrado."
docker compose version >/dev/null 2>&1 || err "Docker Compose V2 não encontrado."

[ -f ".env.production" ] || err "Arquivo .env.production não encontrado!"

log "Pré-validações OK"

# --- Carregar variáveis ---
set -a
source .env.production
set +a

# =============================================
# FASE 1: Build das imagens
# =============================================
info "Fase 1: Construindo imagens Docker..."
docker compose build --parallel 2>&1 | tail -5
log "Build concluído"

# =============================================
# FASE 2: Subir databases
# =============================================
info "Fase 2: Subindo PostgreSQL e Redis..."
docker compose up -d postgres redis

info "Aguardando PostgreSQL ficar saudável..."
ATTEMPTS=0
until docker compose exec -T postgres pg_isready -U "${DB_USER}" -d "${DB_NAME}" 2>/dev/null; do
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ $ATTEMPTS -gt 30 ]; then
        err "PostgreSQL não ficou saudável após 30 tentativas"
    fi
    sleep 2
done
log "PostgreSQL OK"

info "Aguardando Redis..."
ATTEMPTS=0
until docker compose exec -T redis redis-cli -a "${REDIS_PASSWORD}" ping 2>/dev/null | grep -q PONG; do
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ $ATTEMPTS -gt 20 ]; then
        err "Redis não respondeu após 20 tentativas"
    fi
    sleep 2
done
log "Redis OK"

# =============================================
# FASE 3: Backend
# =============================================
info "Fase 3: Subindo Backend..."
docker compose up -d backend
sleep 10

if docker compose ps backend 2>/dev/null | grep -q "Up"; then
    log "Backend running"
else
    warn "Backend pode não ter iniciado. Verificando logs..."
    docker compose logs --tail=30 backend
fi

# --- Rodar migrations ---
info "Executando migrations do banco de dados..."
docker compose exec -T backend npx sequelize db:migrate 2>&1 | tail -10 || warn "Migrations podem ter falhado — verifique logs"
log "Migrations executadas"

# --- Rodar seeds ---
info "Executando seeds..."
docker compose exec -T backend npx sequelize db:seed:all 2>&1 | tail -10 || warn "Seeds podem já existir — OK"
log "Seeds executados"

# =============================================
# FASE 4: Frontend
# =============================================
info "Fase 4: Subindo Frontend..."
docker compose up -d frontend
sleep 5
log "Frontend running"

# =============================================
# FASE 5: Nginx (HTTP apenas para bootstrap SSL)
# =============================================
info "Fase 5: Subindo Nginx (modo HTTP para ACME challenge)..."
docker compose up -d nginx
sleep 3
log "Nginx running"

# =============================================
# FASE 6: Emitir certificados SSL
# =============================================
info "Fase 6: Emitindo certificados Let's Encrypt..."

for domain in $DOMAIN_API $DOMAIN_FRONT; do
    # Checar se já existe
    CERT_EXISTS=$(docker compose exec -T nginx sh -c "test -f /etc/letsencrypt/live/$domain/fullchain.pem && echo yes || echo no" 2>/dev/null || echo "no")
    
    if [ "$CERT_EXISTS" = "yes" ]; then
        log "Certificado para $domain já existe"
    else
        info "Solicitando certificado para $domain..."
        docker compose run --rm certbot certonly \
            --webroot \
            --webroot-path=/var/www/certbot \
            --email "$EMAIL" \
            --agree-tos \
            --no-eff-email \
            --force-renewal \
            -d "$domain" 2>&1 | tail -5 \
            && log "Certificado emitido para $domain" \
            || warn "Falha ao emitir certificado para $domain — verifique DNS"
    fi
done

# =============================================
# FASE 7: Ativar SSL no Nginx
# =============================================
# Checar se os certificados foram criados
API_CERT=$(docker compose exec -T nginx sh -c "test -f /etc/letsencrypt/live/$DOMAIN_API/fullchain.pem && echo yes || echo no" 2>/dev/null || echo "no")
FRONT_CERT=$(docker compose exec -T nginx sh -c "test -f /etc/letsencrypt/live/$DOMAIN_FRONT/fullchain.pem && echo yes || echo no" 2>/dev/null || echo "no")

if [ "$API_CERT" = "yes" ] && [ "$FRONT_CERT" = "yes" ]; then
    info "Fase 7: Ativando SSL no Nginx..."
    # Copiar config com SSL
    docker cp nginx/nginx.conf bigchat-nginx:/etc/nginx/nginx.conf
    docker compose exec -T nginx nginx -t 2>&1 && {
        docker compose exec -T nginx nginx -s reload
        log "SSL ativado com sucesso!"
    } || {
        warn "Config SSL falhou no teste. Mantendo HTTP."
    }
else
    warn "Certificados SSL não foram gerados. Nginx rodando em HTTP."
    warn "Verifique se os domínios $DOMAIN_API e $DOMAIN_FRONT apontam para este servidor."
    warn "Após corrigir DNS, rode: ./deploy.sh novamente"
fi

# =============================================
# FASE 8: Certbot auto-renew
# =============================================
info "Subindo Certbot auto-renew..."
docker compose up -d certbot
log "Certbot auto-renew ativo"

# =============================================
# Status Final
# =============================================
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}         Status dos Serviços            ${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || docker compose ps

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}       Deploy concluído!                ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "  Backend:  https://$DOMAIN_API"
echo "  Frontend: https://$DOMAIN_FRONT"
echo ""
echo "  Comandos úteis:"
echo "    docker compose logs -f backend    # logs backend"
echo "    docker compose logs -f nginx      # logs proxy"
echo "    docker compose ps                 # status"
echo "    docker compose restart backend    # restart backend"
echo ""
