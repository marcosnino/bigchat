#!/bin/bash

# Script de Monitoramento de Crashes nas Conversas
# Verifica se os erros corrigidos ainda estão ocorrendo

echo "═══════════════════════════════════════════════════════════"
echo "  🔍 Monitoramento de Crashes - BigChat"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar erros
check_errors() {
    local error_pattern="$1"
    local error_name="$2"
    local time_range="${3:-10m}"
    
    echo -n "Verificando $error_name (últimos $time_range)... "
    
    local count=$(docker logs bigchat-backend --since "$time_range" 2>&1 | grep -c "$error_pattern")
    
    if [ "$count" -eq 0 ]; then
        echo -e "${GREEN}✅ OK (0 erros)${NC}"
        return 0
    else
        echo -e "${RED}❌ FALHA ($count erros)${NC}"
        return 1
    fi
}

# Verificar se o container está rodando
echo "1. Verificando status do container..."
if docker ps | grep -q bigchat-backend; then
    echo -e "${GREEN}✅ Container bigchat-backend está rodando${NC}"
else
    echo -e "${RED}❌ Container bigchat-backend NÃO está rodando${NC}"
    exit 1
fi
echo ""

# Verificar erros nos últimos 10 minutos
echo "2. Verificando erros nos últimos 10 minutos..."
check_errors "FOR UPDATE cannot be applied to the nullable side of an outer join" "FOR UPDATE Error"
check_errors "SequelizeUniqueConstraintError" "Duplicate Message Error"
check_errors "SequelizeDatabaseError" "Database Error"
echo ""

# Verificar erros na última 1 hora
echo "3. Verificando erros na última hora..."
check_errors "FOR UPDATE" "FOR UPDATE Error" "1h"
check_errors "SequelizeUniqueConstraintError" "Duplicate Message Error" "1h"
echo ""

# Contar total de erros
echo "4. Estatísticas gerais (última hora)..."
total_errors=$(docker logs bigchat-backend --since 1h 2>&1 | grep -c "ERROR")
echo "Total de ERRORs nos logs: $total_errors"
echo ""

# Verificar mensagens processadas com sucesso
echo "5. Verificando processamento de mensagens (últimos 10 min)..."
success_count=$(docker logs bigchat-backend --since 10m 2>&1 | grep -c "\[WWJS\] 📩 msg recebida")
echo "Mensagens recebidas: $success_count"
echo ""

# Resumo final
echo "═══════════════════════════════════════════════════════════"
echo "  📊 RESUMO"
echo "═══════════════════════════════════════════════════════════"

# Verificar se há erros críticos na última hora
critical_errors=$(docker logs bigchat-backend --since 1h 2>&1 | grep -E "FOR UPDATE|SequelizeUniqueConstraint" | wc -l)

if [ "$critical_errors" -eq 0 ]; then
    echo -e "${GREEN}✅ Sistema ESTÁVEL - Sem erros críticos detectados${NC}"
    echo "   As correções estão funcionando corretamente!"
else
    echo -e "${RED}⚠️  ATENÇÃO - $critical_errors erros críticos detectados${NC}"
    echo "   Verifique os logs para mais detalhes:"
    echo "   docker logs bigchat-backend --since 1h | grep -E 'FOR UPDATE|SequelizeUniqueConstraint'"
fi
echo ""

# Comando para monitoramento em tempo real
echo "═══════════════════════════════════════════════════════════"
echo "  📡 MONITORAMENTO EM TEMPO REAL"
echo "═══════════════════════════════════════════════════════════"
echo "Para monitorar logs em tempo real, execute:"
echo ""
echo "  docker logs -f bigchat-backend"
echo ""
echo "Para ver apenas erros:"
echo ""
echo "  docker logs -f bigchat-backend 2>&1 | grep ERROR"
echo ""
echo "═══════════════════════════════════════════════════════════"
