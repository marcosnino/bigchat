#!/bin/bash
# Script de Teste de API - BigChat
# Testa endpoints de Motivos de Encerramento e Relatórios

echo "🧪 TESTES DE API - BigChat"
echo "======================================"
echo ""

# Configuração
API_URL="http://localhost:8080"
TOKEN="SEU_TOKEN_JWT_AQUI"

# Função para fazer requisição
api_test() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    echo "📍 $description"
    echo "   $method $endpoint"
    
    if [ -z "$data" ]; then
        curl -X $method \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -s "$API_URL$endpoint" | jq '.'
    else
        curl -X $method \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "$data" \
            -s "$API_URL$endpoint" | jq '.'
    fi
    
    echo ""
    echo "---"
    echo ""
}

echo "📋 GRUPO 1: Motivos de Encerramento (CloseReasons)"
echo "======================================"
echo ""

# 1. Listar motivos
api_test "GET" "/close-reasons" "" "1. Listar todos os motivos de encerramento"

# 2. Criar motivo
NEW_REASON='{
  "name": "Cliente não respondeu",
  "description": "Cliente não respondeu após múltiplas tentativas",
  "queueId": 1,
  "isActive": true
}'
api_test "POST" "/close-reasons" "$NEW_REASON" "2. Criar novo motivo de encerramento"

# 3. Buscar motivo específico (ID 1)
api_test "GET" "/close-reasons/1" "" "3. Buscar motivo por ID"

# 4. Atualizar motivo
UPDATE_REASON='{
  "name": "Cliente ausente",
  "description": "Cliente não respondeu após várias tentativas de contato",
  "isActive": true
}'
api_test "PUT" "/close-reasons/1" "$UPDATE_REASON" "4. Atualizar motivo existente"

# 5. Desativar motivo
DEACTIVATE_REASON='{
  "isActive": false
}'
api_test "PUT" "/close-reasons/1" "$DEACTIVATE_REASON" "5. Desativar motivo (soft delete)"

echo ""
echo "📋 GRUPO 2: Fechamento de Tickets"
echo "======================================"
echo ""

# 6. Fechar ticket COM motivo (correto)
CLOSE_TICKET='{
  "status": "closed",
  "closeReasonId": 1
}'
api_test "PUT" "/tickets/123" "$CLOSE_TICKET" "6. Fechar ticket COM motivo (esperado: sucesso)"

# 7. Fechar ticket SEM motivo (erro esperado)
CLOSE_NO_REASON='{
  "status": "closed"
}'
echo "📍 7. Fechar ticket SEM motivo (esperado: erro 400)"
echo "   PUT /tickets/123"
curl -X PUT \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$CLOSE_NO_REASON" \
    -s "$API_URL/tickets/123" | jq '.'
echo ""
echo "✅ Esperado: { error: 'ERR_CLOSE_REASON_REQUIRED' }"
echo "---"
echo ""

# 8. Fechar ticket com motivo inválido (erro esperado)
CLOSE_INVALID='{
  "status": "closed",
  "closeReasonId": 99999
}'
echo "📍 8. Fechar ticket com motivo inválido (esperado: erro 404)"
echo "   PUT /tickets/123"
curl -X PUT \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$CLOSE_INVALID" \
    -s "$API_URL/tickets/123" | jq '.'
echo ""
echo "✅ Esperado: { error: 'ERR_CLOSE_REASON_NOT_FOUND' }"
echo "---"
echo ""

echo ""
echo "📋 GRUPO 3: Relatórios de Fechamento"
echo "======================================"
echo ""

# 9. Relatório básico (últimos 30 dias)
START_DATE=$(date -d "30 days ago" +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)
api_test "GET" "/closed-tickets/report?startDate=$START_DATE&endDate=$END_DATE&page=1&limit=10" "" "9. Relatório dos últimos 30 dias (10 primeiros)"

# 10. Relatório filtrado por fila
api_test "GET" "/closed-tickets/report?startDate=$START_DATE&endDate=$END_DATE&queueId=1" "" "10. Relatório filtrado por fila específica"

# 11. Relatório filtrado por usuário
api_test "GET" "/closed-tickets/report?startDate=$START_DATE&endDate=$END_DATE&userId=5" "" "11. Relatório filtrado por usuário específico"

# 12. Relatório filtrado por motivo
api_test "GET" "/closed-tickets/report?startDate=$START_DATE&endDate=$END_DATE&closeReasonId=1" "" "12. Relatório filtrado por motivo específico"

# 13. Relatório com múltiplos filtros
api_test "GET" "/closed-tickets/report?startDate=$START_DATE&endDate=$END_DATE&queueId=1&userId=5&page=1&limit=50" "" "13. Relatório com múltiplos filtros"

# 14. Export CSV
echo "📍 14. Exportar relatório para CSV"
echo "   GET /closed-tickets/report/export"
curl -X GET \
    -H "Authorization: Bearer $TOKEN" \
    -s "$API_URL/closed-tickets/report/export?startDate=$START_DATE&endDate=$END_DATE" \
    -o "relatorio-teste-$(date +%Y%m%d).csv"
echo "✅ Arquivo salvo: relatorio-teste-$(date +%Y%m%d).csv"
echo ""
echo "---"
echo ""

echo ""
echo "📋 GRUPO 4: Validações de Edge Cases"
echo "======================================"
echo ""

# 15. Página com limite alto (deve limitar a 500)
api_test "GET" "/closed-tickets/report?startDate=$START_DATE&endDate=$END_DATE&limit=10000" "" "15. Teste de limite de paginação (esperado: max 500)"

# 16. Data sem hora (deve ajustar para 23:59:59)
api_test "GET" "/closed-tickets/report?startDate=2026-02-01&endDate=2026-02-15" "" "16. Teste de ajuste de data (fim do dia)"

# 17. Relatório vazio (período sem dados)
api_test "GET" "/closed-tickets/report?startDate=2020-01-01&endDate=2020-01-02" "" "17. Relatório com período vazio"

# 18. Criar motivo duplicado (erro esperado)
DUPLICATE_REASON='{
  "name": "Cliente não respondeu",
  "queueId": 1,
  "isActive": true
}'
echo "📍 18. Criar motivo duplicado (esperado: erro 400)"
echo "   POST /close-reasons"
curl -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$DUPLICATE_REASON" \
    -s "$API_URL/close-reasons" | jq '.'
echo ""
echo "✅ Esperado: { error: 'ERR_DUPLICATED_CLOSE_REASON' }"
echo "---"
echo ""

echo ""
echo "📋 GRUPO 5: Testes de Segurança"
echo "======================================"
echo ""

# 19. Requisição sem token (erro 401)
echo "📍 19. Requisição sem autenticação (esperado: erro 401)"
echo "   GET /close-reasons (sem token)"
curl -X GET \
    -H "Content-Type: application/json" \
    -s "$API_URL/close-reasons" | jq '.'
echo ""
echo "✅ Esperado: { error: 'Unauthorized' ou 'No token provided' }"
echo "---"
echo ""

# 20. Requisição com token inválido (erro 401)
echo "📍 20. Requisição com token inválido (esperado: erro 401)"
echo "   GET /close-reasons (token inválido)"
curl -X GET \
    -H "Authorization: Bearer INVALID_TOKEN_123" \
    -H "Content-Type: application/json" \
    -s "$API_URL/close-reasons" | jq '.'
echo ""
echo "✅ Esperado: { error: 'Invalid token' ou 'Token expired' }"
echo "---"
echo ""

echo ""
echo "======================================"
echo "✅ TESTES CONCLUÍDOS"
echo "======================================"
echo ""
echo "📝 Resumo:"
echo "  - Grupo 1: CRUD de Motivos (5 testes)"
echo "  - Grupo 2: Fechamento de Tickets (3 testes)"
echo "  - Grupo 3: Relatórios (6 testes)"
echo "  - Grupo 4: Edge Cases (4 testes)"
echo "  - Grupo 5: Segurança (2 testes)"
echo ""
echo "  Total: 20 testes de API"
echo ""
echo "🔍 Para executar este script:"
echo "  1. Atualize API_URL com o endereço do servidor"
echo "  2. Obtenha um token JWT válido (login)"
echo "  3. Atualize a variável TOKEN"
echo "  4. Execute: ./api-tests.sh"
echo ""
echo "📦 Dependências:"
echo "  - curl"
echo "  - jq (para formatação JSON)"
echo ""
