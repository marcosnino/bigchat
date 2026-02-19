#!/bin/bash

# ============================================
# BigChat - Script de Validação Completa
# ============================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções utilitárias
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}🔍 $1${NC}"
}

COMPOSE_CMD=()

set_compose_cmd() {
    if docker compose version &> /dev/null; then
        COMPOSE_CMD=(docker compose)
        return 0
    fi

    if command -v docker-compose &> /dev/null; then
        COMPOSE_CMD=(docker-compose)
        return 0
    fi

    return 1
}

run_compose() {
    "${COMPOSE_CMD[@]}" "$@"
}

# Verificar se está no diretório correto
check_project_directory() {
    if [[ ! -f "docker-compose.yml" ]] || [[ ! -d "backend" ]] || [[ ! -d "frontend" ]]; then
        print_error "Execute este script na raiz do projeto BigChat"
        exit 1
    fi
    print_success "Diretório do projeto validado"
}

# Verificar se Docker está rodando
check_docker() {
    print_header "VERIFICANDO DOCKER"
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon não está rodando"
        return 1
    fi
    
    print_success "Docker daemon está rodando"
    
    if ! set_compose_cmd; then
        print_error "Docker Compose não está instalado (nem plugin 'docker compose' nem 'docker-compose')"
        return 1
    fi
    
    print_success "Docker Compose está disponível (${COMPOSE_CMD[*]})"
    return 0
}

# Verificar arquivos de configuração
check_config_files() {
    print_header "VERIFICANDO ARQUIVOS DE CONFIGURAÇÃO"
    
    local required_files=(
        ".env"
        ".env.production"
        "docker-compose.yml"
        "backend/package.json"
        "frontend/package.json"
        "nginx/nginx.conf"
    )
    
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_success "Arquivo encontrado: $file"
        else
            print_error "Arquivo obrigatório não encontrado: $file"
            missing_files+=("$file")
        fi
    done
    
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_error "Arquivos obrigatórios estão faltando"
        return 1
    fi
    
    return 0
}

# Validar variáveis de ambiente
validate_env_vars() {
    print_header "VALIDANDO VARIÁVEIS DE AMBIENTE"
    
    if [[ ! -f ".env.production" ]]; then
        print_error "Arquivo .env.production não encontrado"
        return 1
    fi
    
    source .env.production
    
    local required_vars=(
        "NODE_ENV"
        "BACKEND_URL"
        "FRONTEND_URL"
        "DB_DIALECT"
        "DB_HOST"
        "DB_PORT"
        "DB_USER"
        "DB_PASS"
        "DB_NAME"
        "REDIS_URI"
        "REDIS_PASSWORD"
        "JWT_SECRET"
        "JWT_REFRESH_SECRET"
    )
    
    local missing_vars=()
    local default_vars=()
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            missing_vars+=("$var")
            print_error "Variável não definida: $var"
        elif [[ "${!var}" == *"seu@gmail.com"* ]] || [[ "${!var}" == *"SuaSenha"* ]] || [[ "${!var}" == *"Client_Id_"* ]]; then
            default_vars+=("$var")
            print_warning "Variável com valor padrão: $var"
        else
            print_success "Variável configurada: $var"
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_error "Variáveis obrigatórias não definidas"
        return 1
    fi
    
    if [[ ${#default_vars[@]} -gt 0 ]]; then
        print_warning "Algumas variáveis precisam ser configuradas para produção"
    fi
    
    return 0
}

# Verificar portas disponíveis
check_ports() {
    print_header "VERIFICANDO PORTAS"
    
    local ports=("80:HTTP" "443:HTTPS" "5432:PostgreSQL" "6379:Redis")
    
    for port_info in "${ports[@]}"; do
        IFS=':' read -r port service <<< "$port_info"
        
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            print_warning "Porta $port ($service) está em uso"
        else
            print_success "Porta $port ($service) está disponível"
        fi
    done
}

# Verificar dependências Node.js
check_node_dependencies() {
    print_header "VERIFICANDO DEPENDÊNCIAS NODE.JS"
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js não está instalado"
        return 1
    fi
    
    local node_version=$(node --version)
    print_success "Node.js instalado: $node_version"
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        print_error "npm não está instalado"
        return 1
    fi
    
    local npm_version=$(npm --version)
    print_success "npm instalado: $npm_version"
    
    # Verificar dependências do backend
    if [[ -d "backend/node_modules" ]]; then
        print_success "Dependências do backend instaladas"
    else
        print_error "Dependências do backend não instaladas (execute: cd backend && npm install)"
    fi
    
    # Verificar dependências do frontend
    if [[ -d "frontend/node_modules" ]]; then
        print_success "Dependências do frontend instaladas"
    else
        print_error "Dependências do frontend não instaladas (execute: cd frontend && npm install)"
    fi
    
    return 0
}

# Verificar containers Docker
check_docker_containers() {
    print_header "VERIFICANDO CONTAINERS DOCKER"
    
    if docker ps &> /dev/null; then
        print_info "Containers rodando:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(bigchat|postgres|redis)" || print_info "Nenhum container BigChat rodando"
    else
        print_error "Não foi possível listar containers"
        return 1
    fi
    
    return 0
}

# Testar conexões (se os containers estiverem rodando)
test_connections() {
    print_header "TESTANDO CONEXÕES"
    
    # Verificar se o script de teste existe
    if [[ -f "scripts/test-connections.js" ]]; then
        print_info "Executando teste de conexões..."
        
        if cd backend && node ../scripts/test-connections.js; then
            print_success "Teste de conexões aprovado"
        else
            print_warning "Alguns testes de conexão falharam"
        fi
        cd ..
    else
        print_warning "Script de teste de conexões não encontrado"
    fi
}

# Verificar integridade do build
check_build_integrity() {
    print_header "VERIFICANDO INTEGRIDADE DO BUILD"
    
    # Verificar sintaxe do docker-compose
    if run_compose config &> /dev/null; then
        print_success "docker-compose.yml é válido"
    else
        print_error "docker-compose.yml tem erros de sintaxe"
        return 1
    fi
    
    # Verificar se as imagens podem ser construídas (dry-run)
    print_info "Verificando se as imagens podem ser construídas..."
    
    if run_compose config --services | while read -r service; do
        if run_compose build --dry-run "$service" &> /dev/null; then
            print_success "Build configurado corretamente: $service"
        else
            print_warning "Possível problema no build: $service"
        fi
    done
    then
        return 0
    else
        return 1
    fi
}

# Gerar relatório de segurança
security_check() {
    print_header "VERIFICAÇÃO DE SEGURANÇA"
    
    # Verificar se existem senhas padrão
    if grep -q "123" .env.production 2>/dev/null; then
        print_warning "Possíveis senhas padrão encontradas em .env.production"
    fi
    
    # Verificar permissões de arquivos sensíveis
    local sensitive_files=(".env" ".env.production")
    
    for file in "${sensitive_files[@]}"; do
        if [[ -f "$file" ]]; then
            local perms=$(stat -c "%a" "$file" 2>/dev/null || stat -f "%A" "$file" 2>/dev/null)
            if [[ "$perms" -le 600 ]]; then
                print_success "Permissões seguras: $file ($perms)"
            else
                print_warning "Permissões inseguras: $file ($perms) - considere chmod 600 $file"
            fi
        fi
    done
    
    print_success "Verificação de segurança concluída"
}

# Função principal
main() {
    local start_time=$(date +%s)
    
    echo -e "${BLUE}"
    cat << "EOF"
    ____  _       _____ _           _   
   |  _ \(_)     / ____| |         | |  
   | |_) |_  ___| |    | |__   __ _| |_ 
   |  _ <| |/ _ \ |    | '_ \ / _` | __|
   | |_) | |  __/ |____| | | | (_| | |_ 
   |____/|_|\___|\_____|_| |_|\__,_|\__|
                                       
            VALIDAÇÃO DO PROJETO
EOF
    echo -e "${NC}"
    
    local total_checks=0
    local passed_checks=0
    
    # Lista de verificações
    local checks=(
        "check_project_directory"
        "check_config_files" 
        "validate_env_vars"
        "check_docker"
        "check_ports"
        "check_node_dependencies"
        "check_docker_containers"
        "check_build_integrity"
        "test_connections"
        "security_check"
    )
    
    # Executar verificações
    for check in "${checks[@]}"; do
        total_checks=$((total_checks + 1))
        if $check; then
            passed_checks=$((passed_checks + 1))
        fi
        echo
    done
    
    # Relatório final
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    print_header "RELATÓRIO FINAL"
    
    echo -e "${BLUE}📊 RESUMO:${NC}"
    echo -e "   ✅ Verificações aprovadas: $passed_checks/$total_checks"
    echo -e "   ⏱️  Tempo de execução: ${duration}s"
    echo -e "   📅 Data/Hora: $(date)"
    
    if [[ $passed_checks -eq $total_checks ]]; then
        echo
        echo -e "${GREEN}🎉 PROJETO VALIDADO COM SUCESSO!${NC}"
        echo -e "${GREEN}O BigChat está pronto para deploy.${NC}"
        exit 0
    else
        echo
        echo -e "${YELLOW}⚠️  ALGUNS PROBLEMAS ENCONTRADOS${NC}"
        echo -e "${YELLOW}Revise as verificações que falharam.${NC}"
        exit 1
    fi
}

# Verificar argumentos
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "BigChat - Script de Validação"
    echo ""
    echo "Uso: $0 [opções]"
    echo ""
    echo "Opções:"
    echo "  --help, -h     Mostrar esta ajuda"
    echo "  --quick        Validação rápida (sem teste de conexões)"
    echo ""
    echo "Este script verifica:"
    echo "  • Arquivos de configuração"
    echo "  • Variáveis de ambiente"
    echo "  • Dependências"
    echo "  • Serviços Docker"
    echo "  • Conexões de banco e Redis"
    echo "  • Configurações de segurança"
    exit 0
fi

# Executar validação
main "$@"