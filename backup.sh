#!/bin/bash

# Script de Backup Completo - BigChat
# Data: $(date '+%Y-%m-%d %H:%M:%S')

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configurações
BACKUP_DIR="/home/rise/bigchat-backups"
DATE=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="bigchat_backup_${DATE}"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo -e "${BLUE}🔄 Iniciando backup completo do BigChat...${NC}"

# Criar diretório de backup
mkdir -p "$BACKUP_PATH"
cd "$(dirname "$0")"

echo -e "${YELLOW}📁 Criando estrutura de backup em: $BACKUP_PATH${NC}"

# 1. Backup do Banco de Dados PostgreSQL
echo -e "${BLUE}🗄️  Fazendo backup do banco de dados...${NC}"
docker exec bigchat-postgres pg_dump -U bigchat -d bigchat > "$BACKUP_PATH/database_backup.sql"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Backup do banco de dados concluído${NC}"
else
    echo -e "${RED}❌ Erro no backup do banco de dados${NC}"
    exit 1
fi

# 2. Backup do Redis (se houver dados importantes)
echo -e "${BLUE}📦 Fazendo backup do Redis...${NC}"
docker exec bigchat-redis redis-cli BGSAVE
sleep 5
docker cp bigchat-redis:/data/dump.rdb "$BACKUP_PATH/redis_backup.rdb" 2>/dev/null || echo -e "${YELLOW}⚠️  Redis backup opcional não executado${NC}"

# 3. Backup dos arquivos do projeto
echo -e "${BLUE}📂 Copiando arquivos do projeto...${NC}"

# Backend
mkdir -p "$BACKUP_PATH/backend"
cp -r backend/src "$BACKUP_PATH/backend/"
cp backend/package*.json "$BACKUP_PATH/backend/"
cp backend/tsconfig.json "$BACKUP_PATH/backend/"
cp backend/jest.config.js "$BACKUP_PATH/backend/"
cp backend/prettier.config.js "$BACKUP_PATH/backend/"
cp -r backend/public "$BACKUP_PATH/backend/" 2>/dev/null || true

# Frontend  
mkdir -p "$BACKUP_PATH/frontend"
cp -r frontend/src "$BACKUP_PATH/frontend/"
cp -r frontend/public "$BACKUP_PATH/frontend/"
cp frontend/package*.json "$BACKUP_PATH/frontend/"

# Arquivos de configuração raiz
cp docker-compose.yml "$BACKUP_PATH/"
cp .env "$BACKUP_PATH/" 2>/dev/null || true
cp README.md "$BACKUP_PATH/" 2>/dev/null || true
cp -r docs "$BACKUP_PATH/" 2>/dev/null || true
cp -r nginx "$BACKUP_PATH/"
cp -r instalador "$BACKUP_PATH/" 2>/dev/null || true

# Scripts de deploy
cp *.sh "$BACKUP_PATH/" 2>/dev/null || true
cp *.bat "$BACKUP_PATH/" 2>/dev/null || true
cp *.ps1 "$BACKUP_PATH/" 2>/dev/null || true

echo -e "${GREEN}✅ Arquivos do projeto copiados${NC}"

# 4. Backup das configurações do sistema
echo -e "${BLUE}⚙️  Salvando configurações do sistema...${NC}"

# Docker info
docker ps > "$BACKUP_PATH/docker_containers.txt"
docker images > "$BACKUP_PATH/docker_images.txt"
docker-compose config > "$BACKUP_PATH/docker-compose-parsed.yml"

# Variáveis de ambiente (sem senhas sensíveis)
cat > "$BACKUP_PATH/environment_info.txt" << EOF
Data do Backup: $(date)
Versão do Docker: $(docker --version)
Versão do Docker Compose: $(docker-compose --version)
Sistema Operacional: $(uname -a)
Usuário: $(whoami)
Diretório: $(pwd)
EOF

# Log de containers
docker logs bigchat-backend --tail 100 > "$BACKUP_PATH/logs_backend.txt" 2>&1
docker logs bigchat-frontend --tail 100 > "$BACKUP_PATH/logs_frontend.txt" 2>&1
docker logs bigchat-postgres --tail 100 > "$BACKUP_PATH/logs_postgres.txt" 2>&1
docker logs bigchat-redis --tail 100 > "$BACKUP_PATH/logs_redis.txt" 2>&1 || true

echo -e "${GREEN}✅ Configurações salvas${NC}"

# 5. Backup dos volumes Docker (dados persistentes)
echo -e "${BLUE}💾 Fazendo backup dos volumes Docker...${NC}"

mkdir -p "$BACKUP_PATH/volumes"

# Volume do PostgreSQL (dados)
docker run --rm -v bigchat_postgres_data:/source -v "$BACKUP_PATH/volumes":/backup alpine tar czf /backup/postgres_data.tar.gz -C /source .

# Volume do backend (uploads/public)
docker run --rm -v bigchat_backend_public:/source -v "$BACKUP_PATH/volumes":/backup alpine tar czf /backup/backend_public.tar.gz -C /source . 2>/dev/null || echo -e "${YELLOW}⚠️  Volume backend_public não encontrado${NC}"

echo -e "${GREEN}✅ Volumes Docker salvos${NC}"

# 6. Criar arquivo compactado final
echo -e "${BLUE}🗜️  Compactando backup final...${NC}"

cd "$BACKUP_DIR"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"

if [ $? -eq 0 ]; then
    # Remover pasta temporária
    rm -rf "$BACKUP_NAME"
    
    # Informações do backup
    BACKUP_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
    
    echo -e "${GREEN}🎉 Backup completo realizado com sucesso!${NC}"
    echo -e "${BLUE}📄 Arquivo: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz${NC}"
    echo -e "${BLUE}📏 Tamanho: ${BACKUP_SIZE}${NC}"
    echo -e "${BLUE}📅 Data: $(date '+%d/%m/%Y às %H:%M:%S')${NC}"
    
    # Manter apenas os 5 backups mais recentes
    echo -e "${YELLOW}🧹 Limpando backups antigos (mantendo os 5 mais recentes)...${NC}"
    ls -t "${BACKUP_DIR}"/bigchat_backup_*.tar.gz | tail -n +6 | xargs -r rm -f
    
    echo -e "${GREEN}✅ Backup finalizado: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz${NC}"
    
    # Listar backups disponíveis
    echo -e "${BLUE}📋 Backups disponíveis:${NC}"
    ls -lah "${BACKUP_DIR}"/bigchat_backup_*.tar.gz | tail -5
    
else
    echo -e "${RED}❌ Erro ao compactar o backup${NC}"
    exit 1
fi

echo -e "${GREEN}🔚 Processo de backup concluído!${NC}"