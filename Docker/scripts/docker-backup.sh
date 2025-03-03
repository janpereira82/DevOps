#!/bin/bash

# Script de Backup do Docker (Linux/Mac)
# Autor: DevOps Team
# Descrição: Realiza backup de containers e volumes Docker

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações
BACKUP_DIR="./docker-backups"
DATE=$(date +%Y-%m-%d_%H-%M)

# Criar diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

echo -e "${CYAN}📦 Iniciando backup do Docker...${NC}"

# Backup de volumes
echo -e "\n${YELLOW}💾 Realizando backup dos volumes...${NC}"
docker volume ls -q | while read -r volume; do
    echo -e "${GREEN}Backup do volume: $volume${NC}"
    docker run --rm -v "${volume}:/source" -v "${BACKUP_DIR}:/backup" alpine tar czf "/backup/volume_${volume}_${DATE}.tar.gz" -C /source .
done

# Backup de containers
echo -e "\n${YELLOW}🐳 Realizando backup dos containers...${NC}"
docker ps -a --format "{{.Names}}" | while read -r container; do
    echo -e "${GREEN}Backup do container: $container${NC}"
    docker commit "$container" "${container}_backup_${DATE}"
    docker save -o "${BACKUP_DIR}/${container}_${DATE}.tar" "${container}_backup_${DATE}"
    docker rmi "${container}_backup_${DATE}"
done

# Compactar todos os backups
echo -e "\n${YELLOW}🗜️ Compactando backups...${NC}"
cd "$BACKUP_DIR" || exit
tar czf "docker_backup_${DATE}.tar.gz" ./*
rm -f ./*.tar ./*.tar.gz
cd - || exit

echo -e "\n${GREEN}✅ Backup concluído!${NC}"
echo -e "${CYAN}📁 Local do backup: ${BACKUP_DIR}/docker_backup_${DATE}.tar.gz${NC}"
