#!/bin/bash

echo "🔗 SISTEMA DE VINCULAÇÃO USUÁRIO-NÚMERO-FILA"
echo "=============================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📋 ESTRUTURA IMPLEMENTADA${NC}"
echo ""

echo "🗄️  BANCO DE DADOS:"
echo "├── Model: backend/src/models/UserWhatsappQueue.ts"
echo "├── Migration: backend/src/database/migrations/20260212000002-create-user-whatsapp-queue.js"
echo "└── Índices: userId, whatsappId, queueId, isActive"
echo ""

echo "🔧 BACKEND:"
echo "├── Service: backend/src/services/UserServices/UserWhatsappQueueService.ts"
echo "├── Controller: backend/src/controllers/UserWhatsappQueueController.ts"
echo "├── Routes: backend/src/routes/userWhatsappQueueRoutes.ts"
echo "└── Integration: backend/src/routes/index.ts"
echo ""

echo "🎨 FRONTEND:"
echo "├── Modal: frontend/src/components/UserWhatsappQueueModal/index.js"
echo "└── Manager: frontend/src/components/UserWhatsappQueueManager/index.js"
echo ""

echo -e "${GREEN}✅ FUNCIONALIDADES${NC}"
echo ""
echo "✨ Validações de Dev Sênior:"
echo "  • Verificação de permissões (company, queue, user)"
echo "  • Status de número (deve estar CONNECTED)"
echo "  • Prevenção de duplicatas (índice UNIQUE)"
echo "  • Integridade referencial (CASCADE DELETE)"
echo "  • Logs de auditoria completos"
echo ""

echo "📊 Operações CRUD:"
echo "  • POST   /user-whatsapp-queue  - Criar atribuição"
echo "  • GET    /user-whatsapp-queue  - Listar com filtros"
echo "  • GET    /user-whatsapp-queue/user/:id - Buscar por usuário"
echo "  • PUT    /user-whatsapp-queue/:id - Atualizar"
echo "  • DELETE /user-whatsapp-queue/:id - Deletar"
echo ""

echo "🛡️  Endpoints de Validação:"
echo "  • GET  /user-whatsapp-queue/available/:id/:id - Usuários disponíveis"
echo "  • GET  /user-whatsapp-queue/warnings - Avisos de números desconectados"
echo "  • GET  /user-whatsapp-queue/statistics - Estatísticas gerais"
echo "  • DELETE /user-whatsapp-queue/user/:id/queue/:id - Desativar por fila"
echo ""

echo -e "${YELLOW}🚀 COMO USAR${NC}"
echo ""

echo "1️⃣  EXECUTAR MIGRATION:"
echo "   cd backend"
echo "   npm run db:migrate"
echo ""

echo "2️⃣  INICIAR BACKEND:"
echo "   npm run dev"
echo ""

echo "3️⃣  TESTAR CRIAR ATRIBUIÇÃO:"
echo "   curl -X POST http://localhost:4000/user-whatsapp-queue \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -H 'Authorization: Bearer TOKEN' \\"
echo "     -d '{\"userId\": 1, \"whatsappId\": 5, \"queueId\": 3}'"
echo ""

echo "4️⃣  TESTAR LISTAR:"
echo "   curl -X GET http://localhost:4000/user-whatsapp-queue \\"
echo "     -H 'Authorization: Bearer TOKEN'"
echo ""

echo "5️⃣  TESTAR USUÁRIOS DISPONÍVEIS:"
echo "   curl -X GET 'http://localhost:4000/user-whatsapp-queue/available/5/3' \\"
echo "     -H 'Authorization: Bearer TOKEN'"
echo ""

echo "6️⃣  FRONTEND - INTEGRAÇÃO:"
echo "   • User Config: Use <UserWhatsappQueueModal userId={id} />"
echo "   • Admin Panel: Use <UserWhatsappQueueManager />"
echo ""

echo -e "${BLUE}💡 CENÁRIOS DE TESTE${NC}"
echo ""

echo "Teste 1: Criar atribuição inválida (número desconectado)"
echo "  → Deve retornar erro 400"
echo "  → Mensagem: 'Número WhatsApp não está conectado'"
echo ""

echo "Teste 2: Criar duplicata"
echo "  → Deve retornar erro 409"
echo "  → Mensagem: 'Essa vinculação já existe'"
echo ""

echo "Teste 3: Usuário sem acesso à fila"
echo "  → Deve retornar erro 403"
echo "  → Mensagem: 'Usuário não tem permissão para a fila'"
echo ""

echo "Teste 4: Company mismatch"
echo "  → Deve retornar erro 403"
echo "  → Sistema bloqueia acesso entre companies"
echo ""

echo "Teste 5: Número desconectado com atribuições"
echo "  → GET /user-whatsapp-queue/warnings"
echo "  → Retorna lista de atribuições órfãs"
echo ""

echo -e "${GREEN}✨ SISTEMA PRONTO PARA USAR!${NC}"
echo ""
echo "Próximas etapas:"
echo "1. Executar migration de banco de dados"
echo "2. Reiniciar backend"
echo "3. Integrar componentes no frontend"
echo "4. Testar toda a funcionalidade"
echo ""
