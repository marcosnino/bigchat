#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════╗
# ║  GERADOR DE CERTIFICADOS SSL COM CERTBOT                      ║
# ║  Script para gerar certificados Let's Encrypt                 ║
# ╚═══════════════════════════════════════════════════════════════╝

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         🔒 GERADOR DE CERTIFICADOS SSL - BigChat              ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se está rodando como root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}⚠️  Não execute como root! Use o usuário normal.${NC}"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# CONFIGURAÇÃO
# ═══════════════════════════════════════════════════════════════

API_DOMAIN="api.drogariasbigmaster.com.br"
DESK_DOMAIN="desk.drogariasbigmaster.com.br"
EMAIL="suporte@drogariasbigmaster.com.br"

echo -e "${BLUE}${BOLD}Configuração:${NC}"
echo -e "  API Domain:  ${API_DOMAIN}"
echo -e "  Desk Domain: ${DESK_DOMAIN}"
echo -e "  Email:       ${EMAIL}"
echo ""

# ═══════════════════════════════════════════════════════════════
# VERIFICAR DOMÍNIOS
# ═══════════════════════════════════════════════════════════════

echo -e "${YELLOW}Verificando DNS dos domínios...${NC}"

API_IP=$(dig +short ${API_DOMAIN} A | tail -1)
DESK_IP=$(dig +short ${DESK_DOMAIN} A | tail -1)
SERVER_IP=$(curl -s ifconfig.me)

echo "  ${API_DOMAIN}: ${API_IP}"
echo "  ${DESK_DOMAIN}: ${DESK_IP}"
echo "  Servidor: ${SERVER_IP}"
echo ""

if [ -z "$API_IP" ] || [ -z "$DESK_IP" ]; then
    echo -e "${RED}❌ Domínios não resolvem. Verifique o DNS!${NC}"
    exit 1
fi

if [ "$API_IP" != "$SERVER_IP" ] || [ "$DESK_IP" != "$SERVER_IP" ]; then
    echo -e "${YELLOW}⚠️  ATENÇÃO: DNS não aponta para este servidor!${NC}"
    echo -e "${YELLOW}   DNS: ${API_IP} / Servidor: ${SERVER_IP}${NC}"
    echo ""
    read -p "Deseja continuar mesmo assim? (s/n): " -n 1 -r </dev/tty
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Abortado."
        exit 1
    fi
fi

# ═══════════════════════════════════════════════════════════════
# PREPARAR NGINX PARA HTTP (ACME CHALLENGE)
# ═══════════════════════════════════════════════════════════════

echo -e "${YELLOW}Preparando nginx para validação HTTP...${NC}"

# Criar configuração temporária apenas HTTP
cat > /tmp/nginx-temp.conf << 'EOF'
user nginx;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log warn;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent';
    access_log /var/log/nginx/access.log main;

    sendfile on;
    keepalive_timeout 65;

    # Apenas HTTP para ACME challenge
    server {
        listen 80;
        server_name api.drogariasbigmaster.com.br desk.drogariasbigmaster.com.br;

        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }

        location / {
            return 200 "Aguardando certificados SSL...\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Copiar para o container nginx
docker cp /tmp/nginx-temp.conf bigchat-nginx:/etc/nginx/nginx.conf

# Reload nginx
docker exec bigchat-nginx nginx -t && docker exec bigchat-nginx nginx -s reload

echo -e "${GREEN}✓ Nginx configurado para validação HTTP${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# GERAR CERTIFICADOS
# ═══════════════════════════════════════════════════════════════

echo -e "${YELLOW}Gerando certificados SSL...${NC}"
echo ""

# API Domain
echo -e "${BLUE}Gerando certificado para ${API_DOMAIN}...${NC}"
docker compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email ${EMAIL} \
    --agree-tos \
    --no-eff-email \
    --force-renewal \
    -d ${API_DOMAIN}

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Falha ao gerar certificado para ${API_DOMAIN}${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Certificado gerado para ${API_DOMAIN}${NC}"
echo ""

# DESK Domain
echo -e "${BLUE}Gerando certificado para ${DESK_DOMAIN}...${NC}"
docker compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email ${EMAIL} \
    --agree-tos \
    --no-eff-email \
    --force-renewal \
    -d ${DESK_DOMAIN}

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Falha ao gerar certificado para ${DESK_DOMAIN}${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Certificado gerado para ${DESK_DOMAIN}${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# RESTAURAR CONFIGURAÇÃO NGINX COMPLETA
# ═══════════════════════════════════════════════════════════════

echo -e "${YELLOW}Restaurando configuração nginx completa com HTTPS...${NC}"

# Copiar configuração original
docker cp /home/rise/bigchat/nginx/nginx.conf bigchat-nginx:/etc/nginx/nginx.conf

# Testar e reload
docker exec bigchat-nginx nginx -t

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro na configuração do nginx!${NC}"
    exit 1
fi

docker exec bigchat-nginx nginx -s reload

echo -e "${GREEN}✓ Nginx configurado com HTTPS${NC}"
echo ""

# ═══════════════════════════════════════════════════════════════
# VERIFICAR CERTIFICADOS
# ═══════════════════════════════════════════════════════════════

echo -e "${YELLOW}Verificando certificados instalados...${NC}"

docker exec bigchat-nginx ls -la /etc/letsencrypt/live/${API_DOMAIN}/
docker exec bigchat-nginx ls -la /etc/letsencrypt/live/${DESK_DOMAIN}/

echo ""

# ═══════════════════════════════════════════════════════════════
# TESTAR HTTPS
# ═══════════════════════════════════════════════════════════════

echo -e "${YELLOW}Testando HTTPS...${NC}"
echo ""

echo -e "${BLUE}Testando ${API_DOMAIN}:${NC}"
curl -I https://${API_DOMAIN} 2>&1 | head -5
echo ""

echo -e "${BLUE}Testando ${DESK_DOMAIN}:${NC}"
curl -I https://${DESK_DOMAIN} 2>&1 | head -5
echo ""

# ═══════════════════════════════════════════════════════════════
# RESUMO
# ═══════════════════════════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              ✅ CERTIFICADOS SSL INSTALADOS                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✓${NC} Certificados gerados e instalados com sucesso"
echo -e "${GREEN}✓${NC} Nginx configurado com HTTPS"
echo -e "${GREEN}✓${NC} Renovação automática configurada"
echo ""
echo -e "${BLUE}URLs:${NC}"
echo -e "  • https://${API_DOMAIN}"
echo -e "  • https://${DESK_DOMAIN}"
echo ""
echo -e "${YELLOW}Renovação Automática:${NC}"
echo "  O certbot tentará renovar automaticamente a cada 12h"
echo ""
echo -e "${YELLOW}Para renovar manualmente:${NC}"
echo "  docker compose run --rm certbot renew"
echo ""
echo -e "${YELLOW}Validade dos certificados:${NC}"
echo "  docker exec bigchat-nginx openssl x509 -in /etc/letsencrypt/live/${API_DOMAIN}/fullchain.pem -noout -dates"
echo ""
