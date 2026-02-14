#!/bin/bash

# BigChat - Script de Gestão do Projeto
# Facilita execução dos comandos mais comuns

set -e

show_help() {
    cat << EOF
BigChat - Gestão do Projeto v6.0.0

COMANDOS DISPONÍVEIS:
  validate     - Executar validação completa do projeto
  quick        - Validação rápida (apenas verificações básicas)
  test         - Testar conexões de banco e Redis
  start        - Iniciar todos os serviços
  stop         - Parar todos os serviços  
  restart      - Reiniciar todos os serviços
  status       - Verificar status dos containers
  logs         - Mostrar logs dos serviços
  build        - Construir imagens Docker
  clean        - Limpar containers e volumes
  install      - Instalar dependências
  help         - Mostrar esta ajuda

EXEMPLOS:
  $0 validate              # Validação completa
  $0 start                 # Iniciar projeto
  $0 logs backend          # Logs do backend
  $0 status                # Status dos containers

EOF
}

validate_project() {
    echo "🔍 Executando validação completa..."
    if [[ -f "scripts/quick-validate.sh" ]]; then
        ./scripts/quick-validate.sh
    else
        echo "❌ Script de validação não encontrado"
        exit 1
    fi
}

quick_validate() {
    echo "⚡ Validação rápida..."
    validate_project
}

test_connections() {
    echo "🔗 Testando conexões..."
    if [[ -f "scripts/test-connections.js" ]]; then
        cd backend && node ../scripts/test-connections.js
    else
        echo "❌ Script de teste de conexões não encontrado"
        exit 1
    fi
}

start_services() {
    echo "🚀 Iniciando serviços BigChat..."
    docker compose up -d
    echo "✅ Serviços iniciados!"
    echo ""
    echo "📍 Acesse:"
    echo "   Frontend: http://localhost (ou https://desk.drogariasbigmaster.com.br)"
    echo "   Backend: http://localhost:4000 (ou https://api.drogariasbigmaster.com.br)"
    echo ""
    echo "📊 Para ver status: $0 status"
    echo "📝 Para ver logs: $0 logs"
}

stop_services() {
    echo "🛑 Parando serviços..."
    docker compose down
    echo "✅ Serviços parados!"
}

restart_services() {
    echo "🔄 Reiniciando serviços..."
    stop_services
    start_services
}

show_status() {
    echo "📊 Status dos containers BigChat:"
    echo "=================================="
    docker compose ps
    echo ""
    echo "🔍 Containers em execução:"
    docker ps --filter "name=bigchat" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

show_logs() {
    local service="${1:-}"
    
    if [[ -n "$service" ]]; then
        echo "📝 Logs do serviço: $service"
        docker compose logs -f --tail=50 "$service"
    else
        echo "📝 Logs de todos os serviços:"
        echo "💡 Dica: Use '$0 logs <serviço>' para logs específicos"
        echo "   Serviços disponíveis: backend, frontend, postgres, redis, nginx"
        echo ""
        docker compose logs --tail=20
    fi
}

build_images() {
    echo "🏗️  Construindo imagens Docker..."
    docker compose build --no-cache
    echo "✅ Build concluído!"
}

clean_all() {
    echo "🧹 Limpando containers e volumes..."
    read -p "⚠️  Isso vai remover TODOS os dados. Continuar? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker compose down -v --remove-orphans
        docker system prune -f
        echo "✅ Limpeza concluída!"
    else
        echo "❌ Operação cancelada."
    fi
}

install_dependencies() {
    echo "📦 Instalando dependências..."
    
    echo "   Backend..."
    cd backend && npm install
    echo "✅ Backend dependencies instaladas!"
    
    echo "   Frontend..."
    cd ../frontend && npm install
    echo "✅ Frontend dependencies instaladas!"
    
    cd ..
    echo "🎉 Todas as dependências instaladas!"
}

# Processar argumentos
case "${1:-help}" in
    "validate")
        validate_project
        ;;
    "quick")
        quick_validate
        ;;
    "test")
        test_connections
        ;;
    "start")
        start_services
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        restart_services
        ;;
    "status")
        show_status
        ;;
    "logs")
        show_logs "$2"
        ;;
    "build")
        build_images
        ;;
    "clean")
        clean_all
        ;;
    "install")
        install_dependencies
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        echo "❌ Comando desconhecido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac