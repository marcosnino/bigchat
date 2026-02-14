#!/bin/bash

# Script de Restore - BigChat
# Para restaurar um backup do BigChat

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

BACKUP_DIR="/home/rise/bigchat-backups"

echo -e "${BLUE}🔄 Script de Restore do BigChat${NC}"

# Verificar se foi passado um arquivo de backup
if [ "$#" -ne 1 ]; then
    echo -e "${YELLOW}📋 Backups disponíveis:${NC}"
    ls -lah "${BACKUP_DIR}"/bigchat_backup_*.tar.gz 2>/dev/null || echo -e "${RED}❌ Nenhum backup encontrado${NC}"
    echo ""
    echo -e "${BLUE}💡 Uso: $0 <arquivo_backup.tar.gz>${NC}"
    echo -e "${BLUE}💡 Exemplo: $0 bigchat_backup_20260211_143025.tar.gz${NC}"
    exit 1
fi

BACKUP_FILE="$1"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# Verificar se o arquivo existe
if [ ! -f "$BACKUP_PATH" ]; then
    echo -e "${RED}❌ Arquivo de backup não encontrado: $BACKUP_PATH${NC}"
    exit 1
fi

echo -e "${YELLOW}⚠️  ATENÇÃO: Este processo irá substituir os dados atuais!${NC}"
echo -e "${YELLOW}⚠️  Backup atual: $BACKUP_FILE${NC}"
read -p "Deseja continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}❌ Operação cancelada${NC}"
    exit 1
fi

# Parar containers
echo -e "${BLUE}🛑 Parando containers...${NC}"
cd /home/rise/bigchat
docker compose down

# Extrair backup
echo -e "${BLUE}📦 Extraindo backup...${NC}"
cd "$BACKUP_DIR"
tar -xzf "$BACKUP_FILE"
EXTRACTED_DIR=$(basename "$BACKUP_FILE" .tar.gz)

# Restaurar arquivos do projeto
echo -e "${BLUE}📂 Restaurando arquivos do projeto...${NC}"
cd /home/rise/bigchat

# Fazer backup dos arquivos atuais
CURRENT_BACKUP="current_backup_$(date '+%Y%m%d_%H%M%S')"
mkdir -p "/tmp/$CURRENT_BACKUP"
cp -r . "/tmp/$CURRENT_BACKUP/"

# Restaurar arquivos
cp -r "${BACKUP_DIR}/${EXTRACTED_DIR}/backend/src" backend/
cp "${BACKUP_DIR}/${EXTRACTED_DIR}/backend/package*.json" backend/
cp "${BACKUP_DIR}/${EXTRACTED_DIR}/backend/tsconfig.json" backend/
cp "${BACKUP_DIR}/${EXTRACTED_DIR}/backend/"*.js backend/ 2>/dev/null || true

cp -r "${BACKUP_DIR}/${EXTRACTED_DIR}/frontend/src" frontend/
cp -r "${BACKUP_DIR}/${EXTRACTED_DIR}/frontend/public" frontend/
cp "${BACKUP_DIR}/${EXTRACTED_DIR}/frontend/package*.json" frontend/

cp "${BACKUP_DIR}/${EXTRACTED_DIR}/docker-compose.yml" .
cp "${BACKUP_DIR}/${EXTRACTED_DIR}/.env" . 2>/dev/null || true
cp -r "${BACKUP_DIR}/${EXTRACTED_DIR}/nginx" . 2>/dev/null || true

# Subir containers
echo -e "${BLUE}🚀 Iniciando containers...${NC}"
docker compose up -d postgres redis

# Aguardar PostgreSQL
echo -e "${BLUE}⏳ Aguardando PostgreSQL...${NC}"
sleep 10

# Restaurar banco de dados
echo -e "${BLUE}🗄️  Restaurando banco de dados...${NC}"
docker exec -i bigchat-postgres psql -U bigchat -d bigchat < "${BACKUP_DIR}/${EXTRACTED_DIR}/database_backup.sql"

# Restaurar Redis
if [ -f "${BACKUP_DIR}/${EXTRACTED_DIR}/redis_backup.rdb" ]; then
    echo -e "${BLUE}📦 Restaurando Redis...${NC}"
    docker cp "${BACKUP_DIR}/${EXTRACTED_DIR}/redis_backup.rdb" bigchat-redis:/data/dump.rdb
    docker restart bigchat-redis
fi

# Restaurar volumes
echo -e "${BLUE}💾 Restaurando volumes...${NC}"
if [ -f "${BACKUP_DIR}/${EXTRACTED_DIR}/volumes/postgres_data.tar.gz" ]; then
    docker run --rm -v bigchat_postgres_data:/target -v "${BACKUP_DIR}/${EXTRACTED_DIR}/volumes":/backup alpine tar xzf /backup/postgres_data.tar.gz -C /target
fi

# Subir todos os containers
echo -e "${BLUE}🚀 Iniciando todos os serviços...${NC}"
docker compose up -d

# Aguardar serviços
echo -e "${BLUE}⏳ Aguardando serviços iniciarem...${NC}"
sleep 20

# Verificar status
echo -e "${BLUE}✅ Verificando status dos serviços...${NC}"
docker compose ps

# Limpar arquivos temporários
rm -rf "${BACKUP_DIR}/${EXTRACTED_DIR}"

echo -e "${GREEN}🎉 Restore concluído com sucesso!${NC}"
echo -e "${BLUE}💾 Backup atual salvo em: /tmp/$CURRENT_BACKUP${NC}"
echo -e "${BLUE}🌐 Acesse: https://desk.drogariasbigmaster.com.br${NC}"
echo ""
echo -e "${GREEN}🔚 Processo de restore finalizado!${NC}"