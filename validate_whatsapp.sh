#!/bin/bash

# Script para Validar WhatsApp "bigchat teste" + Fila "FernandoCorreia"
# Data: 2026-02-12
# Status: Validação Completa

echo "═══════════════════════════════════════════════════════════════"
echo "🔍 VALIDAÇÃO DO SISTEMA: BigChat WhatsApp + Fila Fernando Correa"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Database connection
DB_HOST="localhost"
DB_PORT="5432"
DB_USER="bigchat"
DB_NAME="bigchat"
DB_PASS="bigchat"

export PGPASSWORD=$DB_PASS

echo -e "${BLUE}1. VERIFICANDO WHATSAPP 'BIGCHAT TESTE'${NC}"
echo "───────────────────────────────────────────────────────────────"

WHATSAPP_DATA=$(docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT id, name, status, session FROM \"Whatsapps\" WHERE name = 'bigchat teste';" 2>&1)

if echo "$WHATSAPP_DATA" | grep -q "bigchat teste"; then
  echo -e "${GREEN}✓ WhatsApp encontrado${NC}"
  WA_ID=$(echo "$WHATSAPP_DATA" | grep "bigchat teste" | awk '{print $1}')
  WA_NAME=$(echo "$WHATSAPP_DATA" | grep "bigchat teste" | awk '{print $2}')
  WA_STATUS=$(echo "$WHATSAPP_DATA" | grep "bigchat teste" | awk '{print $3}')
  
  echo "  ID: $WA_ID"
  echo "  Nome: $WA_NAME"
  echo "  Status: $WA_STATUS"
  
  if [ "$WA_STATUS" = "CONNECTED" ]; then
    echo -e "${GREEN}  ✓ Status: CONECTADO${NC}"
  else
    echo -e "${RED}  ✗ Status: $WA_STATUS (NÃO CONECTADO)${NC}"
  fi
else
  echo -e "${RED}✗ WhatsApp 'bigchat teste' não encontrado${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}2. VERIFICANDO FILA 'FERNANDO CORREA'${NC}"
echo "───────────────────────────────────────────────────────────────"

QUEUE_DATA=$(docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT id, name FROM \"Queues\" WHERE name ILIKE '%fernando%';" 2>&1)

if echo "$QUEUE_DATA" | grep -q "FernandoCorreia\|Fernando"; then
  echo -e "${GREEN}✓ Fila encontrada${NC}"
  QUEUE_ID=$(echo "$QUEUE_DATA" | grep -i "fernando" | awk '{print $1}')
  QUEUE_NAME=$(echo "$QUEUE_DATA" | grep -i "fernando" | awk '{print $2}')
  
  echo "  ID: $QUEUE_ID"
  echo "  Nome: $QUEUE_NAME"
else
  echo -e "${RED}✗ Fila 'Fernando Correa' não encontrada${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}3. VERIFICANDO VINCULAÇÃO WHATSAPP-FILA${NC}"
echo "───────────────────────────────────────────────────────────────"

VINCULACAO=$(docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM \"WhatsappQueues\" WHERE \"whatsappId\" = $WA_ID AND \"queueId\" = $QUEUE_ID;" 2>&1)

if echo "$VINCULACAO" | grep -q "$WA_ID"; then
  echo -e "${GREEN}✓ Vinculação ativa${NC}"
  echo "  WhatsApp ($WA_ID) <-> Fila ($QUEUE_ID)"
  echo "  Criada em: $(echo "$VINCULACAO" | tail -1 | awk '{print $3}' | head -c 19)"
else
  echo -e "${RED}✗ Vinculação não encontrada${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}4. VERIFICANDO HISTÓRICO DE MENSAGENS${NC}"
echo "───────────────────────────────────────────────────────────────"

MSG_COUNT=$(docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM \"Messages\" WHERE \"whatsappId\" = $WA_ID;" 2>&1 | tail -2 | head -1)

echo "  Total de mensagens: $MSG_COUNT"

if [ "$MSG_COUNT" -gt 0 ]; then
  echo -e "${GREEN}  ✓ Mensagens processadas${NC}"
  
  # Últimas 5 mensagens
  echo ""
  echo "  Últimas 5 mensagens recentes:"
  docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT id, \"fromMe\", body, \"createdAt\" FROM \"Messages\" WHERE \"whatsappId\" = $WA_ID ORDER BY \"createdAt\" DESC LIMIT 5;" 2>&1 | grep -v "^$"
else
  echo -e "${YELLOW}  ⚠ Nenhuma mensagem processada ainda${NC}"
fi

echo ""
echo -e "${BLUE}5. VERIFICANDO TICKETS DA FILA${NC}"
echo "───────────────────────────────────────────────────────────────"

TICKETS=$(docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM \"Tickets\" WHERE \"queueId\" = $QUEUE_ID;" 2>&1 | tail -2 | head -1)

echo "  Total de tickets na fila '$QUEUE_NAME': $TICKETS"

if [ "$TICKETS" -gt 0 ]; then
  echo -e "${GREEN}  ✓ Fila com atividades${NC}"
  
  echo ""
  echo "  Últimos 5 tickets:"
  docker exec bigchat-postgres psql -U $DB_USER -d $DB_NAME -c "SELECT id, status, \"createdAt\" FROM \"Tickets\" WHERE \"queueId\" = $QUEUE_ID ORDER BY \"createdAt\" DESC LIMIT 5;" 2>&1 | grep -v "^$"
else
  echo -e "${YELLOW}  ⚠ Nenhum ticket na fila ainda${NC}"
fi

echo ""
echo -e "${BLUE}6. VERIFICANDO STATUS DE CONEXÃO NO BACKEND${NC}"
echo "───────────────────────────────────────────────────────────────"

# Verificar logs do backend para conectividade
BACKEND_LOGS=$(docker logs bigchat-backend --tail 200 2>&1 | grep -i "client connected\|connected\|whatsapp" | tail -10)

if echo "$BACKEND_LOGS" | grep -qi "connected"; then
  echo -e "${GREEN}✓ Backend com conexões WhatsApp ativas${NC}"
  echo ""
  echo "  Últimas atividades:"
  echo "$BACKEND_LOGS" | head -5 | sed 's/^/  /'
else
  echo -e "${YELLOW}⚠ Nenhuma conexão ativa detectada nos logs recentes${NC}"
fi

echo ""
echo -e "${BLUE}7. VALIDAÇÃO DE ENVIO/RECEBIMENTO${NC}"
echo "───────────────────────────────────────────────────────────────"

# Procura por erros relacionado a mensagens
ERROR_LOGS=$(docker logs bigchat-backend --tail 300 2>&1 | grep -i "error\|erro" | grep -i "message\|mensagem" | tail -5)

if [ -z "$ERROR_LOGS" ]; then
  echo -e "${GREEN}✓ Nenhum erro recente de mensagens${NC}"
else
  echo -e "${YELLOW}⚠ Alguns erros detectados:${NC}"
  echo "$ERROR_LOGS" | sed 's/^/  /'
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${BLUE}📊 RESUMO FINAL${NC}"
echo "═══════════════════════════════════════════════════════════════"

SUMMARY_PASS=0
SUMMARY_FAIL=0
SUMMARY_WARN=0

if [ "$WA_STATUS" = "CONNECTED" ]; then
  echo -e "${GREEN}✓ WhatsApp Status:${NC} CONECTADO"
  ((SUMMARY_PASS++))
else
  echo -e "${RED}✗ WhatsApp Status:${NC} DESCONECTADO"
  ((SUMMARY_FAIL++))
fi

if echo "$VINCULACAO" | grep -q "$WA_ID"; then
  echo -e "${GREEN}✓ Vinculação:${NC} ATIVA"
  ((SUMMARY_PASS++))
else
  echo -e "${RED}✗ Vinculação:${NC} INATIVA"
  ((SUMMARY_FAIL++))
fi

if [ "$MSG_COUNT" -gt 0 ]; then
  echo -e "${GREEN}✓ Histórico de Mensagens:${NC} OK ($MSG_COUNT mensagens)"
  ((SUMMARY_PASS++))
else
  echo -e "${YELLOW}⚠ Histórico de Mensagens:${NC} SEM ATIVIDADE"
  ((SUMMARY_WARN++))
fi

if [ "$TICKETS" -gt 0 ]; then
  echo -e "${GREEN}✓ Fila Fernando Correa:${NC} COM TICKETS ($TICKETS)"
  ((SUMMARY_PASS++))
else
  echo -e "${YELLOW}⚠ Fila Fernando Correa:${NC} VAZIA"
  ((SUMMARY_WARN++))
fi

echo ""
echo "Status: ${GREEN}PASS: $SUMMARY_PASS${NC} ${YELLOW}WARN: $SUMMARY_WARN${NC} ${RED}FAIL: $SUMMARY_FAIL${NC}"

if [ "$SUMMARY_FAIL" -eq 0 ]; then
  if [ "$SUMMARY_WARN" -eq 0 ]; then
    echo -e "\n${GREEN}🎉 VALIDAÇÃO 100% OK - SISTEMA FUNCIONANDO NORMALMENTE${NC}"
  else
    echo -e "\n${YELLOW}⚠️  VALIDAÇÃO COM AVISOS - FUNCIONAL COM RESSALVAS${NC}"
  fi
else
  echo -e "\n${RED}❌ VALIDAÇÃO COM ERROS - REQUER ATENÇÃO${NC}"
  exit 1
fi

echo "═══════════════════════════════════════════════════════════════"
echo ""
