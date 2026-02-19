#!/bin/bash

# Script de Teste - Sistema BigChat HTTP

echo "═══════════════════════════════════════════════════════════"
echo "  🔍 Teste de Conectividade - BigChat (HTTP)"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Teste 1: Containers Rodando
echo "1. Verificando containers..."
docker ps | grep -q "bigchat-nginx.*Up" && echo -e "${GREEN}✅ Nginx: Rodando${NC}" || echo -e "${RED}❌ Nginx: Parado${NC}"
docker ps | grep -q "bigchat-backend.*Up.*healthy" && echo -e "${GREEN}✅ Backend: Rodando (healthy)${NC}" || echo -e "${RED}❌ Backend: Problema${NC}"
docker ps | grep -q "bigchat-frontend.*Up.*healthy" && echo -e "${GREEN}✅ Frontend: Rodando (healthy)${NC}" || echo -e "${RED}❌ Frontend: Problema${NC}"
echo ""

# Teste 2: Frontend HTTP
echo "2. Testando Frontend HTTP (localhost)..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ 2>&1)
if [ "$STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Frontend HTTP: 200 OK${NC}"
else
    echo -e "${RED}❌ Frontend HTTP: Erro $STATUS${NC}"
fi
echo ""

# Teste 3: Backend HTTP (interno)
echo "3. Testando Backend HTTP (interno)..."
STATUS=$(docker exec bigchat-nginx curl -s -o /dev/null -w "%{http_code}" http://backend:4000/ 2>&1)
if [ "$STATUS" = "404" ] || [ "$STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Backend HTTP: Respondendo ($STATUS)${NC}"
else
    echo -e "${RED}❌ Backend HTTP: Erro $STATUS${NC}"
fi
echo ""

# Teste 4: Nginx para Frontend
echo "4. Testando Nginx → Frontend..."
STATUS=$(docker exec bigchat-nginx curl -s -o /dev/null -w "%{http_code}" http://frontend/ 2>&1)
if [ "$STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Nginx → Frontend: 200 OK${NC}"
else
    echo -e "${RED}❌ Nginx → Frontend: Erro $STATUS${NC}"
fi
echo ""

# Teste 5: Configuração Nginx
echo "5. Verificando Configuração Nginx..."
docker exec bigchat-nginx nginx -t >/dev/null 2>&1 && echo -e "${GREEN}✅ Configuração Nginx: Válida${NC}" || echo -e "${RED}❌ Configuração Nginx: Inválida${NC}"
echo ""

# Resumo
echo "═══════════════════════════════════════════════════════════"
echo "  📊 RESUMO"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Acesse o sistema em:${NC}"
echo "  🌐 http://localhost"
echo "  🌐 http://desk.drogariasbigmaster.com.br"
echo ""
echo -e "${YELLOW}API Backend disponível em:${NC}"
echo "  🔌 http://api.drogariasbigmaster.com.br"
echo ""
echo -e "${RED}⚠️  AVISO: Sistema rodando em HTTP (sem SSL)${NC}"
echo "   Para produção, configure SSL seguindo FIX_CONNECTION_REFUSED.md"
echo ""
echo "═══════════════════════════════════════════════════════════"
