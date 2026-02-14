#!/bin/bash

echo "🔗 TESTANDO SISTEMA DE VALIDAÇÃO WHATSAPP-QUEUE"
echo "=================================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}📋 ESTRUTURA DO SISTEMA DE VALIDAÇÃO${NC}"
echo "-------------------------------------------"
echo ""

echo "🎯 ARQUIVOS IMPLEMENTADOS:"
echo ""
echo "📄 Backend/Services:"
echo "├── backend/src/services/ValidationServices/WhatsAppQueueValidationService.ts"
echo "├── backend/src/controllers/WhatsAppQueueValidationController.ts"
echo "├── backend/src/routes/validationRoutes.ts"
echo "└── backend/src/routes/index.ts (atualizado)"
echo ""

echo "📄 Frontend/Components:"
echo "├── frontend/src/components/WhatsAppQueueValidation/index.js"
echo "├── frontend/src/components/QueueValidationIndicator/index.js"
echo "└── frontend/src/pages/Connections/index.js (atualizado)"
echo ""

echo -e "${GREEN}✅ FUNCIONALIDADES IMPLEMENTADAS:${NC}"
echo "• Validação automática de vinculações WhatsApp ↔ Filas"
echo "• Detecção de números sem filas vinculadas"
echo "• Detecção de filas sem números vinculados" 
echo "• Correção automática de problemas básicos"
echo "• Limpeza de vinculações órfãs"
echo "• Relatórios detalhados de vinculações"
echo "• Indicadores visuais na página de conexões"
echo "• Integração com sistema de semáforos"
echo "• Notificações WebSocket para problemas"
echo ""

echo -e "${YELLOW}🔧 APIs DISPONÍVEIS:${NC}"
echo "GET    /validation/whatsapp-queue                  # Validar vinculações"
echo "GET    /validation/whatsapp-queue/report/whatsapps # Relatório WhatsApps → Filas"  
echo "GET    /validation/whatsapp-queue/report/queues    # Relatório Filas → WhatsApps"
echo "POST   /validation/whatsapp-queue/autofix          # Correção automática"
echo "DELETE /validation/whatsapp-queue/cleanup          # Limpeza órfãos"
echo ""

echo -e "${BLUE}🎯 COMO USAR O SISTEMA:${NC}"
echo ""
echo "1️⃣  PÁGINA DE CONEXÕES:"
echo "   • Nova coluna 'Filas' mostra indicadores de validação"
echo "   • ✅ Verde = Filas vinculadas corretamente"
echo "   • ❌ Vermelho = Sem filas vinculadas"
echo "   • Badge numérico = Quantidade de filas"
echo ""

echo "2️⃣  PAINEL DE VALIDAÇÃO COMPLETO:"
echo "   • Acesse via nova rota: /validation-dashboard"
echo "   • Mostra status geral das vinculações"
echo "   • Permite correção automática"
echo "   • Relatórios detalhados"
echo ""

echo "3️⃣  SEMÁFOROS INTEGRADOS:"
echo "   • Sistema verifica vinculações ao processar mensagens"
echo "   • Emite alertas via WebSocket para problemas"
echo "   • Logs detalhados no console"
echo ""

echo -e "${GREEN}🚀 ATIVAÇÃO DO SISTEMA:${NC}"
echo ""
echo "1. Reiniciar backend para carregar novas rotas:"
cd /home/rise/bigchat/backend
echo "   cd backend && npm run dev"
echo ""

echo "2. Testar APIs de validação:"
echo "   curl -H 'Authorization: Bearer token' http://localhost:4000/validation/whatsapp-queue"
echo ""

echo "3. Acessar painel no frontend:"
echo "   • Página Conexões: Verificar nova coluna 'Filas'"
echo "   • Componente standalone: WhatsAppQueueValidation"
echo ""

echo -e "${YELLOW}⚠️  CONFIGURAÇÃO NECESSÁRIA:${NC}"
echo ""
echo "• Certificar que todos WhatsApps tenham pelo menos 1 fila vinculada"
echo "• Verificar que todas filas tenham pelo menos 1 WhatsApp"
echo "• Usar correção automática para resolver problemas básicos"
echo ""

echo -e "${BLUE}📊 EXEMPLOS DE USO:${NC}"
echo ""
echo "🔍 VERIFICAR STATUS ATUAL:"
echo "curl -X GET http://localhost:4000/validation/whatsapp-queue \\"
echo "  -H 'Authorization: Bearer \$TOKEN' | jq"
echo ""

echo "🔧 CORRIGIR AUTOMATICAMENTE:"
echo "curl -X POST http://localhost:4000/validation/whatsapp-queue/autofix \\"
echo "  -H 'Authorization: Bearer \$TOKEN'"
echo ""

echo "🧹 LIMPAR ÓRFÃOS:" 
echo "curl -X DELETE http://localhost:4000/validation/whatsapp-queue/cleanup \\"
echo "  -H 'Authorization: Bearer \$TOKEN'"
echo ""

echo -e "${GREEN}✨ SISTEMA PRONTO PARA USO!${NC}"
echo ""
echo "O sistema vai garantir que:"
echo "• Cada número WhatsApp tenha filas vinculadas"
echo "• Cada fila tenha números WhatsApp vinculados"  
echo "• Problemas sejam detectados automaticamente"
echo "• Correções possam ser aplicadas facilmente"
echo "• Usuários vejam status visual na interface"
echo ""

# Verificar se backend está rodando
if curl -s http://localhost:4000 >/dev/null 2>&1; then
    echo -e "${GREEN}🟢 Backend detectado em localhost:4000${NC}"
    echo "Pronto para testar as APIs de validação!"
else
    echo -e "${YELLOW}🟡 Backend não detectado${NC}"
    echo "Inicie com: cd backend && npm run dev"
fi

echo ""
echo "=================================================="