#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════╗
# ║  TESTE END-TO-END - BigChat WhatsApp                          ║
# ║  Script automatizado para validar todas as funcionalidades    ║
# ╚═══════════════════════════════════════════════════════════════╝

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         🧪 TESTE END-TO-END - BigChat WhatsApp                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# ═══════════════════════════════════════════════════════════════
# FUNÇÃO: Imprimir header de seção
# ═══════════════════════════════════════════════════════════════
print_header() {
    echo ""
    echo -e "${BLUE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}${BOLD}  $1${NC}"
    echo -e "${BLUE}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# FUNÇÃO: Verificar status
# ═══════════════════════════════════════════════════════════════
check_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
    else
        echo -e "${RED}✗ $2${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════
# 1. VERIFICAR CONTAINERS
# ═══════════════════════════════════════════════════════════════
print_header "1️⃣  INFRA: Verificando containers Docker"

docker compose ps

echo ""
echo -e "${YELLOW}Verificando status dos containers...${NC}"

# Verificar se containers estão rodando
BACKEND_STATUS=$(docker ps --filter "name=bigchat-backend" --format "{{.Status}}")
POSTGRES_STATUS=$(docker ps --filter "name=bigchat-postgres" --format "{{.Status}}")
REDIS_STATUS=$(docker ps --filter "name=bigchat-redis" --format "{{.Status}}")
FRONTEND_STATUS=$(docker ps --filter "name=bigchat-frontend" --format "{{.Status}}")

if [[ $BACKEND_STATUS == *"Up"* ]]; then
    echo -e "${GREEN}✓ Backend${NC}: $BACKEND_STATUS"
else
    echo -e "${RED}✗ Backend${NC}: Container não está rodando"
    exit 1
fi

if [[ $POSTGRES_STATUS == *"Up"* ]]; then
    echo -e "${GREEN}✓ PostgreSQL${NC}: $POSTGRES_STATUS"
else
    echo -e "${RED}✗ PostgreSQL${NC}: Container não está rodando"
    exit 1
fi

if [[ $REDIS_STATUS == *"Up"* ]]; then
    echo -e "${GREEN}✓ Redis${NC}: $REDIS_STATUS"
else
    echo -e "${RED}✗ Redis${NC}: Container não está rodando"
    exit 1
fi

if [[ $FRONTEND_STATUS == *"Up"* ]]; then
    echo -e "${GREEN}✓ Frontend${NC}: $FRONTEND_STATUS"
else
    echo -e "${RED}✗ Frontend${NC}: Container não está rodando"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# 2. VERIFICAR CONEXÃO WHATSAPP
# ═══════════════════════════════════════════════════════════════
print_header "2️⃣  WHATSAPP: Verificando conexão ativa"

echo "Consultando status no banco de dados..."
WHATSAPP_STATUS=$(docker exec bigchat-postgres psql -U bigchat -d bigchat -t -c \
    "SELECT status FROM \"Whatsapps\" WHERE id=3;" 2>/dev/null | xargs)

echo -e "Status atual: ${BOLD}$WHATSAPP_STATUS${NC}"

if [[ "$WHATSAPP_STATUS" == "CONNECTED" ]]; then
    echo -e "${GREEN}✓ WhatsApp conectado${NC}"
else
    echo -e "${YELLOW}⚠️  WhatsApp não conectado (Status: $WHATSAPP_STATUS)${NC}"
    echo ""
    echo -e "${YELLOW}📱 AÇÃO NECESSÁRIA:${NC}"
    echo "   1. Acesse o frontend em http://localhost:3000"
    echo "   2. Vá em Conexões > bigchat teste"
    echo "   3. Escaneie o QR Code com seu WhatsApp"
    echo ""
    read -p "Pressione ENTER depois de conectar o WhatsApp..." </dev/tty
    
    # Verificar novamente
    WHATSAPP_STATUS=$(docker exec bigchat-postgres psql -U bigchat -d bigchat -t -c \
        "SELECT status FROM \"Whatsapps\" WHERE id=3;" 2>/dev/null | xargs)
    
    if [[ "$WHATSAPP_STATUS" == "CONNECTED" ]]; then
        echo -e "${GREEN}✓ WhatsApp agora está conectado!${NC}"
    else
        echo -e "${RED}✗ WhatsApp ainda não conectado. Verifique logs:${NC}"
        echo "   docker logs bigchat-backend --tail 50 | grep -i 'qr\\|connected'"
        exit 1
    fi
fi

# Obter informações do WhatsApp
echo ""
echo "Detalhes da conexão:"
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
    "SELECT id, name, status, number FROM \"Whatsapps\" WHERE id=3;"

# ═══════════════════════════════════════════════════════════════
# 3. VERIFICAR FILAS E VÍNCULOS
# ═══════════════════════════════════════════════════════════════
print_header "3️⃣  FILAS: Verificando configuração de filas"

echo "Filas ativas:"
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
    "SELECT id, name, color FROM \"Queues\";"

echo ""
echo "Vínculos WhatsApp ↔ Queue:"
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
    "SELECT wq.\"whatsappId\", w.name as whatsapp_name, wq.\"queueId\", q.name as queue_name 
     FROM \"WhatsappQueues\" wq 
     JOIN \"Whatsapps\" w ON w.id = wq.\"whatsappId\" 
     JOIN \"Queues\" q ON q.id = wq.\"queueId\" 
     WHERE wq.\"whatsappId\" = 3;"

QUEUE_COUNT=$(docker exec bigchat-postgres psql -U bigchat -d bigchat -t -c \
    "SELECT COUNT(*) FROM \"WhatsappQueues\" WHERE \"whatsappId\"=3;" | xargs)

if [ "$QUEUE_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓ WhatsApp vinculado a $QUEUE_COUNT fila(s)${NC}"
else
    echo -e "${YELLOW}⚠️  WhatsApp não vinculado a nenhuma fila${NC}"
fi

# ═══════════════════════════════════════════════════════════════
# 4. VERIFICAR ÚLTIMAS MENSAGENS
# ═══════════════════════════════════════════════════════════════
print_header "4️⃣  MENSAGENS: Verificando últimas mensagens processadas"

echo "Últimas 5 mensagens no banco:"
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
    "SELECT 
        m.id, 
        m.\"fromMe\", 
        m.\"messageStatus\",
        LEFT(m.body, 30) as body_preview,
        m.\"createdAt\"
     FROM \"Messages\" m
     WHERE m.\"whatsappId\" = 3
     ORDER BY m.\"createdAt\" DESC
     LIMIT 5;"

# ═══════════════════════════════════════════════════════════════
# 5. VERIFICAR TICKETS ATIVOS
# ═══════════════════════════════════════════════════════════════
print_header "5️⃣  TICKETS: Verificando tickets ativos"

echo "Tickets pendentes:"
docker exec bigchat-postgres psql -U bigchat -d bigchat -c \
    "SELECT 
        t.id,
        t.status,
        t.\"pendingClientMessages\",
        t.\"lastClientMessageAt\",
        c.name as contact_name
     FROM \"Tickets\" t
     JOIN \"Contacts\" c ON c.id = t.\"contactId\"
     WHERE t.status = 'pending' AND t.\"whatsappId\" = 3
     ORDER BY t.\"updatedAt\" DESC
     LIMIT 5;"

PENDING_COUNT=$(docker exec bigchat-postgres psql -U bigchat -d bigchat -t -c \
    "SELECT COUNT(*) FROM \"Tickets\" WHERE status='pending' AND \"whatsappId\"=3;" | xargs)

echo ""
echo -e "Total de tickets pendentes: ${BOLD}$PENDING_COUNT${NC}"

# ═══════════════════════════════════════════════════════════════
# 6. VERIFICAR LOGS DO BACKEND
# ═══════════════════════════════════════════════════════════════
print_header "6️⃣  LOGS: Verificando logs recentes do backend"

echo -e "${YELLOW}Últimas 10 linhas de log (filtradas):${NC}"
docker logs bigchat-backend --tail 50 2>&1 | grep -i 'wwjs\|handler\|semáforo\|error' | tail -10

# ═══════════════════════════════════════════════════════════════
# 7. TESTE DE ENVIO (OPCIONAL)
# ═══════════════════════════════════════════════════════════════
print_header "7️⃣  TESTE: Envio de mensagem (opcional)"

echo -e "${YELLOW}Para testar o envio de mensagem:${NC}"
echo "   1. Envie uma mensagem de teste do seu WhatsApp para: 556593002657"
echo "   2. Aguarde a mensagem aparecer no sistema"
echo "   3. Responda pelo frontend"
echo ""
echo -e "${YELLOW}Logs em tempo real (Ctrl+C para sair):${NC}"
echo ""

read -p "Deseja executar teste de recebimento? (s/n): " -n 1 -r </dev/tty
echo ""

if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo ""
    echo -e "${GREEN}📡 Monitorando logs... Envie uma mensagem agora!${NC}"
    echo ""
    docker logs bigchat-backend --follow 2>&1 | grep --line-buffered -i 'handler\|mensagem'
fi

# ═══════════════════════════════════════════════════════════════
# RESUMO FINAL
# ═══════════════════════════════════════════════════════════════
print_header "✅ RESUMO DO TESTE"

echo -e "${GREEN}✓${NC} Containers: Todos operacionais"
echo -e "${GREEN}✓${NC} WhatsApp: Status verificado"
echo -e "${GREEN}✓${NC} Filas: Configuração validada"
echo -e "${GREEN}✓${NC} Banco de dados: Acessível e funcional"
echo ""
echo -e "${BOLD}Sistema pronto para testes end-to-end!${NC}"
echo ""
echo -e "${BLUE}Próximos passos:${NC}"
echo "  • Enviar mensagem de teste"
echo "  • Verificar sistema de semáforo"
echo "  • Testar resposta de agente"
echo "  • Validar Socket.IO tempo real"
echo ""
echo -e "${YELLOW}Para ver logs em tempo real:${NC}"
echo "  docker logs bigchat-backend --follow"
echo ""
