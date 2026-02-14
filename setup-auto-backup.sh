#!/bin/bash

# Script para configurar backup automático diário do BigChat
# Adiciona entrada no crontab para executar backup às 02:00

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}⏰ Configurando backup automático diário do BigChat${NC}"

# Verificar se o crontab já tem a entrada
if crontab -l 2>/dev/null | grep -q "bigchat.*backup.sh"; then
    echo -e "${YELLOW}⚠️  Backup automático já está configurado${NC}"
    echo -e "${BLUE}📋 Configuração atual:${NC}"
    crontab -l | grep "bigchat.*backup.sh"
    exit 0
fi

# Criar entrada temporária para o crontab
CRON_ENTRY="0 2 * * * cd /home/rise/bigchat && ./backup.sh >> /home/rise/bigchat-backups/backup.log 2>&1"

# Adicionar ao crontab existente
echo -e "${BLUE}📝 Adicionando entrada ao crontab...${NC}"

# Backup do crontab atual
crontab -l > /tmp/crontab_backup 2>/dev/null || touch /tmp/crontab_backup

# Adicionar nova entrada
echo "$CRON_ENTRY" >> /tmp/crontab_backup

# Instalar novo crontab
crontab /tmp/crontab_backup

# Verificar se foi adicionado
if crontab -l | grep -q "bigchat.*backup.sh"; then
    echo -e "${GREEN}✅ Backup automático configurado com sucesso!${NC}"
    echo -e "${BLUE}⏰ Horário: Todos os dias às 02:00${NC}"
    echo -e "${BLUE}📝 Log: /home/rise/bigchat-backups/backup.log${NC}"
    echo ""
    echo -e "${BLUE}📋 Crontab atual:${NC}"
    crontab -l
else
    echo -e "${RED}❌ Erro ao configurar backup automático${NC}"
    exit 1
fi

# Limpar arquivo temporário
rm -f /tmp/crontab_backup

echo -e "${GREEN}🔚 Configuração concluída!${NC}"