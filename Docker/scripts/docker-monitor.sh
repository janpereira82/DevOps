#!/bin/bash

# Script de Monitoramento do Docker (Linux/Mac)
# Autor: DevOps Team
# Descrição: Monitora recursos e status dos containers Docker

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🔍 Monitoramento Docker Iniciado${NC}"
echo -e "${CYAN}==============================${NC}\n"

# Status do Docker
echo -e "${YELLOW}📊 Status do Docker:${NC}"
echo "Containers: $(docker ps -q | wc -l) em execução"
echo "Imagens: $(docker images -q | wc -l) disponíveis"
echo "Volumes: $(docker volume ls -q | wc -l) criados"
echo "Redes: $(docker network ls -q | wc -l) configuradas\n"

# Monitoramento de Containers
echo -e "${YELLOW}🐋 Containers em Execução:${NC}"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# Uso de Disco
echo -e "\n${YELLOW}💾 Uso de Disco:${NC}"
docker system df

# Alertas
echo -e "\n${YELLOW}⚠️ Verificando Alertas:${NC}"
docker ps -a --format "{{.Status}},{{.Names}}" | while IFS=',' read -r status name; do
    if [[ $status == *"Exited"* ]]; then
        echo -e "${RED}Container $name está parado!${NC}"
    fi
done

echo -e "\n${GREEN}✅ Monitoramento Concluído${NC}"
