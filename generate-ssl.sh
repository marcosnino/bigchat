#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════╗
# ║  GERADOR SIMPLES DE CERTIFICADOS SSL                          ║
# ╚═══════════════════════════════════════════════════════════════╝

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

API_DOMAIN="api.drogariasbigmaster.com.br"
DESK_DOMAIN="desk.drogariasbigmaster.com.br"
EMAIL="suporte@drogariasbigmaster.com.br"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         🔒 GERADOR DE CERTIFICADOS SSL - BigChat              ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Verificar DNS
echo -e "${BLUE}Verificando DNS...${NC}"
API_IP=$(dig +short ${API_DOMAIN} A | tail -1)
DESK_IP=$(dig +short ${DESK_DOMAIN} A | tail -1)
SERVER_IP=$(curl -s ifconfig.me)

echo "  ${API_DOMAIN}: ${API_IP}"
echo "  ${DESK_DOMAIN}: ${DESK_IP}"
echo "  Servidor: ${SERVER_IP}"
echo ""

if [ "$API_IP" != "$SERVER_IP" ] || [ "$DESK_IP" != "$SERVER_IP" ]; then
    echo -e "${YELLOW}⚠️  DNS não aponta para este servidor!${NC}"
    read -p "Continuar? (s/n): " -n 1 -r
    echo ""
    [[ ! $REPLY =~ ^[Ss]$ ]] && exit 1
fi

# Preparar nginx temporário
echo -e "${YELLOW}Configurando nginx para validação HTTP...${NC}"

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

docker cp /tmp/nginx-temp.conf bigchat-nginx:/etc/nginx/nginx.conf
docker exec bigchat-nginx nginx -t && docker exec bigchat-nginx nginx -s reload

echo -e "${GREEN}✓ Nginx configurado${NC}"
echo ""

# Gerar certificados usando docker run direto
echo -e "${YELLOW}Gerando certificados...${NC}"
echo ""

# API Domain
echo -e "${BLUE}Certificado para ${API_DOMAIN}...${NC}"
docker run --rm \
  --name certbot-temp \
  -v bigchat_certbot_conf:/etc/letsencrypt \
  -v bigchat_certbot_www:/var/www/certbot \
  --network bigchat_bigchat-net \
  certbot/certbot:latest \
  certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email ${EMAIL} \
  --agree-tos \
  --no-eff-email \
  --non-interactive \
  --force-renewal \
  -d ${API_DOMAIN}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Certificado gerado para ${API_DOMAIN}${NC}"
else
    echo -e "${RED}❌ Falha ao gerar certificado${NC}"
    exit 1
fi
echo ""

# DESK Domain
echo -e "${BLUE}Certificado para ${DESK_DOMAIN}...${NC}"
docker run --rm \
  --name certbot-temp \
  -v bigchat_certbot_conf:/etc/letsencrypt \
  -v bigchat_certbot_www:/var/www/certbot \
  --network bigchat_bigchat-net \
  certbot/certbot:latest \
  certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email ${EMAIL} \
  --agree-tos \
  --no-eff-email \
  --non-interactive \
  --force-renewal \
  -d ${DESK_DOMAIN}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Certificado gerado para ${DESK_DOMAIN}${NC}"
else
    echo -e "${RED}❌ Falha ao gerar certificado${NC}"
    exit 1
fi
echo ""

# Restaurar nginx com HTTPS
echo -e "${YELLOW}Configurando nginx com HTTPS...${NC}"
docker cp /home/rise/bigchat/nginx/nginx.conf bigchat-nginx:/etc/nginx/nginx.conf
docker exec bigchat-nginx nginx -t && docker exec bigchat-nginx nginx -s reload

echo -e "${GREEN}✓ Nginx configurado com HTTPS${NC}"
echo ""

# Verificar certificados
echo -e "${YELLOW}Verificando certificados...${NC}"
docker exec bigchat-nginx ls -la /etc/letsencrypt/live/${API_DOMAIN}/ || true
docker exec bigchat-nginx ls -la /etc/letsencrypt/live/${DESK_DOMAIN}/ || true
echo ""

# Testar HTTPS
echo -e "${YELLOW}Testando HTTPS...${NC}"
sleep 2
curl -I https://${API_DOMAIN} 2>&1 | head -5
echo ""
curl -I https://${DESK_DOMAIN} 2>&1 | head -5
echo ""

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              ✅ CERTIFICADOS SSL INSTALADOS                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}URLs:${NC}"
echo -e "  • https://${API_DOMAIN}"
echo -e "  • https://${DESK_DOMAIN}"
echo ""
echo -e "${YELLOW}Renovação manual:${NC}"
echo "  docker run --rm -v bigchat_certbot_conf:/etc/letsencrypt -v bigchat_certbot_www:/var/www/certbot certbot/certbot:latest renew"
echo ""
