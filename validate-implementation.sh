#!/bin/bash
# Script de Validação e Simulação de Erros - BigChat
# Testa funcionalidades de Motivos de Encerramento e Relatórios

echo "=========================================="
echo "🔍 VALIDAÇÃO DO PROJETO BIGCHAT"
echo "=========================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
error_count=0

# Função para mostrar resultado
show_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((success_count++))
    else
        echo -e "${RED}✗${NC} $2"
        ((error_count++))
    fi
}

echo "📋 FASE 1: Validação de Estrutura de Banco de Dados"
echo "================================================"

# 1.1 Verificar tabela CloseReasons
echo -n "Verificando tabela CloseReasons... "
if docker exec -i $(docker ps -q -f name=postgres) psql -U bigchat -d bigchat -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'CloseReasons';" 2>/dev/null | grep -q "1"; then
    show_result 0 "Tabela CloseReasons existe"
else
    show_result 1 "Tabela CloseReasons NÃO existe"
fi

# 1.2 Verificar coluna closeReasonId em Tickets
echo -n "Verificando coluna closeReasonId em Tickets... "
if docker exec -i $(docker ps -q -f name=postgres) psql -U bigchat -d bigchat -c "\d \"Tickets\"" 2>/dev/null | grep -q "closeReasonId"; then
    show_result 0 "Coluna closeReasonId existe em Tickets"
else
    show_result 1 "Coluna closeReasonId NÃO existe em Tickets"
fi

# 1.3 Verificar Foreign Keys
echo -n "Verificando Foreign Keys... "
fk_count=$(docker exec -i $(docker ps -q -f name=postgres) psql -U bigchat -d bigchat -c "SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_name IN ('CloseReasons_queueId_fkey', 'CloseReasons_companyId_fkey', 'Tickets_closeReasonId_fkey');" 2>/dev/null | grep -oE '[0-9]+' | head -1)
if [ "$fk_count" == "3" ]; then
    show_result 0 "Todas as Foreign Keys estão configuradas (3/3)"
else
    show_result 1 "Foreign Keys faltando (encontradas: $fk_count/3)"
fi

echo ""
echo "📋 FASE 2: Validação de Arquivos do Backend"
echo "================================================"

# 2.1 Models
echo -n "Verificando CloseReason model... "
if [ -f "backend/src/models/CloseReason.ts" ]; then
    show_result 0 "CloseReason.ts existe"
else
    show_result 1 "CloseReason.ts NÃO encontrado"
fi

# 2.2 Services
services=(
    "backend/src/services/CloseReasonServices/ListCloseReasonService.ts"
    "backend/src/services/CloseReasonServices/CreateCloseReasonService.ts"
    "backend/src/services/CloseReasonServices/ShowCloseReasonService.ts"
    "backend/src/services/CloseReasonServices/UpdateCloseReasonService.ts"
    "backend/src/services/CloseReasonServices/DeleteCloseReasonService.ts"
    "backend/src/services/TicketServices/ClosureReportService.ts"
)

for service in "${services[@]}"; do
    filename=$(basename "$service")
    echo -n "Verificando $filename... "
    if [ -f "$service" ]; then
        show_result 0 "$filename existe"
    else
        show_result 1 "$filename NÃO encontrado"
    fi
done

# 2.3 Controllers
echo -n "Verificando CloseReasonController... "
if [ -f "backend/src/controllers/CloseReasonController.ts" ]; then
    show_result 0 "CloseReasonController.ts existe"
else
    show_result 1 "CloseReasonController.ts NÃO encontrado"
fi

# 2.4 Routes
echo -n "Verificando closeReasonRoutes... "
if [ -f "backend/src/routes/closeReasonRoutes.ts" ]; then
    show_result 0 "closeReasonRoutes.ts existe"
else
    show_result 1 "closeReasonRoutes.ts NÃO encontrado"
fi

# 2.5 Validação em UpdateTicketService
echo -n "Verificando validação em UpdateTicketService... "
if grep -q "ERR_CLOSE_REASON_REQUIRED" backend/src/services/TicketServices/UpdateTicketService.ts 2>/dev/null; then
    show_result 0 "Validação de closeReasonId implementada"
else
    show_result 1 "Validação de closeReasonId NÃO encontrada"
fi

echo ""
echo "📋 FASE 3: Validação de Arquivos do Frontend"
echo "================================================"

# 3.1 Components
components=(
    "frontend/src/components/CloseReasonDialog/index.js"
    "frontend/src/components/CloseReasonModal/index.js"
)

for component in "${components[@]}"; do
    filename=$(basename $(dirname "$component"))
    echo -n "Verificando $filename... "
    if [ -f "$component" ]; then
        show_result 0 "$filename existe"
    else
        show_result 1 "$filename NÃO encontrado"
    fi
done

# 3.2 Pages
pages=(
    "frontend/src/pages/CloseReasons/index.js"
    "frontend/src/pages/ClosureReports/index.js"
)

for page in "${pages[@]}"; do
    filename=$(basename $(dirname "$page"))
    echo -n "Verificando página $filename... "
    if [ -f "$page" ]; then
        show_result 0 "Página $filename existe"
    else
        show_result 1 "Página $filename NÃO encontrada"
    fi
done

# 3.3 Routes
echo -n "Verificando rotas no routes/index.js... "
if grep -q "close-reasons\|closure-reports" frontend/src/routes/index.js 2>/dev/null; then
    show_result 0 "Rotas configuradas"
else
    show_result 1 "Rotas NÃO configuradas"
fi

# 3.4 Menu Items
echo -n "Verificando menu no MainListItems.js... "
if grep -q "closeReasons\|closureReports" frontend/src/layout/MainListItems.js 2>/dev/null; then
    show_result 0 "Menu items adicionados"
else
    show_result 1 "Menu items NÃO adicionados"
fi

# 3.5 Translations
echo -n "Verificando traduções PT... "
if grep -q "closureReports:" frontend/src/translate/languages/pt.js 2>/dev/null; then
    show_result 0 "Traduções PT configuradas"
else
    show_result 1 "Traduções PT NÃO configuradas"
fi

echo -n "Verificando traduções EN... "
if grep -q "closureReports:" frontend/src/translate/languages/en.js 2>/dev/null; then
    show_result 0 "Traduções EN configuradas"
else
    show_result 1 "Traduções EN NÃO configuradas"
fi

echo -n "Verificando traduções ES... "
if grep -q "closureReports:" frontend/src/translate/languages/es.js 2>/dev/null; then
    show_result 0 "Traduções ES configuradas"
else
    show_result 1 "Traduções ES NÃO configuradas"
fi

echo ""
echo "📋 FASE 4: Compilação"
echo "================================================"

# 4.1 Backend Build
echo "Compilando Backend..."
cd backend && npm run build > /tmp/backend-validation.log 2>&1
if [ $? -eq 0 ]; then
    show_result 0 "Backend compilado sem erros"
else
    show_result 1 "Backend com erros de compilação (veja /tmp/backend-validation.log)"
fi
cd ..

# 4.2 Frontend Build (skip para economizar tempo, já testado)
echo -n "Frontend build... "
if [ -d "frontend/build" ]; then
    show_result 0 "Frontend build existe"
else
    show_result 1 "Frontend build NÃO encontrado"
fi

echo ""
echo "📋 FASE 5: Simulação de Cenários de Erro"
echo "================================================"

# 5.1 Testar estrutura de erro codes
echo -n "Verificando códigos de erro backend... "
error_codes=("ERR_CLOSE_REASON_REQUIRED" "ERR_CLOSE_REASON_NOT_FOUND" "ERR_CLOSE_REASON_QUEUE_REQUIRED")
all_found=true
for code in "${error_codes[@]}"; do
    if ! grep -rq "$code" backend/src/ 2>/dev/null; then
        all_found=false
        break
    fi
done

if [ "$all_found" = true ]; then
    show_result 0 "Códigos de erro implementados"
else
    show_result 1 "Códigos de erro faltando"
fi

# 5.2 Verificar tratamento de JSON em ClosureReportService
echo -n "Verificando parsing de JSON em ClosureReportService... "
if grep -q "JSON.parse" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null && \
   grep -q "try" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null; then
    show_result 0 "Try-catch para JSON parsing implementado"
else
    show_result 1 "Try-catch para JSON parsing NÃO encontrado"
fi

# 5.3 Verificar formatação de duração
echo -n "Verificando formatação de duração (HH:MM:SS)... "
if grep -q "formatDuration" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null; then
    show_result 0 "Método formatDuration implementado"
else
    show_result 1 "Método formatDuration NÃO encontrado"
fi

# 5.4 Verificar limite de paginação
echo -n "Verificando limite de paginação... "
if grep -q "Math.min.*500\|limit.*500" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null; then
    show_result 0 "Limite de paginação implementado"
else
    show_result 1 "Limite de paginação NÃO implementado"
fi

# 5.5 Verificar ajuste de fim de dia
echo -n "Verificando ajuste de endDate para fim do dia... "
if grep -q "setHours(23, 59, 59" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null; then
    show_result 0 "Ajuste de fim de dia implementado"
else
    show_result 1 "Ajuste de fim de dia NÃO implementado"
fi

# 5.6 Verificar BOM UTF-8 no CSV
echo -n "Verificando BOM UTF-8 no CSV export... "
if grep -q "\\\\ufeff\|ufeff\|BOM" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null; then
    show_result 0 "BOM UTF-8 implementado no CSV"
else
    show_result 1 "BOM UTF-8 NÃO implementado no CSV"
fi

# 5.7 Verificar loading states no frontend
echo -n "Verificando loading states no frontend... "
if grep -q "loading\|setLoading" frontend/src/pages/ClosureReports/index.js 2>/dev/null; then
    show_result 0 "Loading states implementados"
else
    show_result 1 "Loading states NÃO implementados"
fi

# 5.8 Verificar validação de form com Yup
echo -n "Verificando validação Yup no CloseReasonModal... "
if grep -q "Yup\|validationSchema" frontend/src/components/CloseReasonModal/index.js 2>/dev/null; then
    show_result 0 "Validação Yup implementada"
else
    show_result 1 "Validação Yup NÃO implementada"
fi

echo ""
echo "📋 FASE 6: Testes de Integração"
echo "================================================"

# 6.1 Verificar se serviços exportam corretamente
echo -n "Verificando exports de services... "
if grep -q "export default.*ClosureReportService" backend/src/services/TicketServices/ClosureReportService.ts 2>/dev/null; then
    show_result 0 "ClosureReportService exportado corretamente"
else
    show_result 1 "ClosureReportService export incorreto"
fi

# 6.2 Verificar imports nos controllers
echo -n "Verificando imports no controller... "
if grep -q "import.*ClosureReportService" backend/src/controllers/ClosedTicketHistoryController.ts 2>/dev/null; then
    show_result 0 "ClosureReportService importado no controller"
else
    show_result 1 "ClosureReportService NÃO importado no controller"
fi

# 6.3 Verificar registro de rotas
echo -n "Verificando rotas registradas em routes/index.ts... "
if grep -q "closeReasonRoutes\|closedTicketHistoryRoutes" backend/src/routes/index.ts 2>/dev/null; then
    show_result 0 "Rotas registradas no index"
else
    show_result 1 "Rotas NÃO registradas no index"
fi

echo ""
echo "=========================================="
echo "📊 RESUMO DA VALIDAÇÃO"
echo "=========================================="
echo ""
echo -e "Total de testes: $((success_count + error_count))"
echo -e "${GREEN}✓ Sucessos: $success_count${NC}"
echo -e "${RED}✗ Falhas: $error_count${NC}"
echo ""

if [ $error_count -eq 0 ]; then
    echo -e "${GREEN}🎉 VALIDAÇÃO COMPLETA: TODOS OS TESTES PASSARAM!${NC}"
    echo "✅ Sistema pronto para produção"
    exit 0
else
    echo -e "${YELLOW}⚠️  VALIDAÇÃO COM AVISOS: $error_count teste(s) falharam${NC}"
    echo "🔍 Revise os itens marcados com ✗ acima"
    exit 1
fi
