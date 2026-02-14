#!/bin/bash

# BigChat - Validação Rápida
echo "🔍 BigChat - Validação Rápida do Projeto"
echo "========================================"

ERRORS=0
WARNINGS=0

# Função para log
log_success() { echo "✅ $1"; }
log_error() { echo "❌ $1"; ERRORS=$((ERRORS + 1)); }
log_warning() { echo "⚠️  $1"; WARNINGS=$((WARNINGS + 1)); }
log_info() { echo "ℹ️  $1"; }

echo ""
echo "1. Verificando arquivos essenciais..."

# Verificar arquivos
[[ -f ".env.production" ]] && log_success "Arquivo .env.production encontrado" || log_error "Arquivo .env.production não encontrado"
[[ -f "docker-compose.yml" ]] && log_success "Arquivo docker-compose.yml encontrado" || log_error "Arquivo docker-compose.yml não encontrado"
[[ -f "backend/package.json" ]] && log_success "Arquivo backend/package.json encontrado" || log_error "Arquivo backend/package.json não encontrado"
[[ -f "frontend/package.json" ]] && log_success "Arquivo frontend/package.json encontrado" || log_error "Arquivo frontend/package.json não encontrado"

echo ""
echo "2. Verificando estrutura de diretórios..."

[[ -d "backend/src" ]] && log_success "Diretório backend/src encontrado" || log_error "Diretório backend/src não encontrado"
[[ -d "frontend/src" ]] && log_success "Diretório frontend/src encontrado" || log_error "Diretório frontend/src não encontrado"
[[ -d "nginx" ]] && log_success "Diretório nginx encontrado" || log_error "Diretório nginx não encontrado"

echo ""
echo "3. Verificando dependências..."

if [[ -d "backend/node_modules" ]]; then
    log_success "Dependências do backend instaladas"
else
    log_warning "Dependências do backend não instaladas"
    log_info "Execute: cd backend && npm install"
fi

if [[ -d "frontend/node_modules" ]]; then
    log_success "Dependências do frontend instaladas"
else
    log_warning "Dependências do frontend não instaladas"
    log_info "Execute: cd frontend && npm install"
fi

echo ""
echo "4. Verificando Docker..."

if command -v docker &> /dev/null; then
    if docker info &> /dev/null 2>&1; then
        log_success "Docker está rodando"
    else
        log_error "Docker daemon não está rodando"
    fi
else
    log_error "Docker não está instalado"
fi

if command -v docker-compose &> /dev/null; then
    log_success "Docker Compose encontrado"
elif docker compose version &> /dev/null 2>&1; then
    log_success "Docker Compose (v2) encontrado"
    log_info "Use 'docker compose' em vez de 'docker-compose'"
else
    log_warning "Docker Compose não encontrado"
fi

echo ""
echo "5. Verificando variáveis de ambiente..."

if [[ -f ".env.production" ]]; then
    source .env.production
    
    # Verificar variáveis essenciais
    [[ -n "$BACKEND_URL" ]] && log_success "BACKEND_URL configurado: $BACKEND_URL" || log_error "BACKEND_URL não configurado"
    [[ -n "$FRONTEND_URL" ]] && log_success "FRONTEND_URL configurado: $FRONTEND_URL" || log_error "FRONTEND_URL não configurado"
    [[ -n "$DB_HOST" ]] && log_success "DB_HOST configurado: $DB_HOST" || log_error "DB_HOST não configurado"
    [[ -n "$REDIS_URI" ]] && log_success "REDIS_URI configurado" || log_error "REDIS_URI não configurado"
    [[ -n "$JWT_SECRET" ]] && log_success "JWT_SECRET configurado" || log_error "JWT_SECRET não configurado"
    
    # Verificar se há valores padrão
    if [[ "$MAIL_USER" == *"seu@gmail.com"* ]]; then
        log_warning "Configuração de email usando valor padrão"
    fi
    
    if [[ "$GERENCIANET_CLIENT_ID" == "Client_Id_Gerencianet" ]]; then
        log_warning "Configuração Gerencianet usando valor padrão"
    fi
fi

echo ""
echo "6. Testando conectividade básica..."

# Testar se as portas estão disponíveis
for port in 80 443 5432 6379; do
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
        log_info "Porta $port em uso"
    else
        log_success "Porta $port disponível"
    fi
done

echo ""
echo "========================================"
echo "📊 RESUMO DA VALIDAÇÃO"
echo "========================================"

TOTAL=$((ERRORS + WARNINGS))

if [[ $ERRORS -eq 0 ]]; then
    if [[ $WARNINGS -eq 0 ]]; then
        echo "🎉 Projeto validado com sucesso!"
        echo "✅ 0 erros, 0 avisos"
        echo ""
        echo "O projeto está pronto. Para iniciar:"
        echo "  docker compose up -d"
        exit 0
    else
        echo "⚡ Projeto quase pronto!"
        echo "✅ 0 erros, ⚠️  $WARNINGS avisos"
        echo ""
        echo "Verifique os avisos acima antes do deploy."
        exit 0
    fi
else
    echo "🚨 Projeto com problemas!"
    echo "❌ $ERRORS erros, ⚠️  $WARNINGS avisos"
    echo ""
    echo "Corrija os erros antes de continuar."
    exit 1
fi