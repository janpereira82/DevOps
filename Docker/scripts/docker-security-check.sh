#!/bin/bash

# Script de Verificação de Segurança Docker (Linux/Mac)
# Autor: DevOps Team
# Descrição: Realiza verificações de segurança básicas no ambiente Docker

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🔒 Iniciando verificação de segurança Docker...${NC}"

# Verificar versão do Docker
echo -e "\n${YELLOW}📋 Verificando versão do Docker:${NC}"
docker version
docker_info=$(docker info)

# Verificar configurações de segurança básicas
echo -e "\n${YELLOW}🛡️ Verificando configurações de segurança:${NC}"

# Verificar se o Docker está rodando como root
echo -e "\n${GREEN}1. Verificação de privilégios:${NC}"
if groups | grep -q docker; then
    echo "   ✓ Usuário atual está no grupo docker"
else
    echo -e "${RED}   ✗ Usuário atual não está no grupo docker${NC}"
fi

# Verificar containers em execução com portas expostas
echo -e "\n${GREEN}2. Containers com portas expostas:${NC}"
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep "0.0.0.0"

# Verificar containers em execução com volumes sensíveis
echo -e "\n${GREEN}3. Containers com volumes sensíveis:${NC}"
for container in $(docker ps -q); do
    volumes=$(docker inspect -f '{{range .Mounts}}{{.Source}}:{{.Destination}} {{end}}' "$container")
    if [ -n "$volumes" ]; then
        echo "   Container $container:"
        echo "   Volumes: $volumes"
    fi
done

# Verificar imagens sem tag específica
echo -e "\n${GREEN}4. Imagens usando tag 'latest':${NC}"
docker images --format "{{.Repository}}:{{.Tag}}" | grep ":latest"

# Verificar redes Docker
echo -e "\n${GREEN}5. Configurações de rede:${NC}"
docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"

# Verificar políticas de reinicialização
echo -e "\n${GREEN}6. Containers com restart-policy:${NC}"
docker ps -a --format "{{.Names}}: {{.Status}}" | grep "Restarting"

# Verificar recursos limitados
echo -e "\n${GREEN}7. Limites de recursos:${NC}"
for container in $(docker ps -q); do
    limits=$(docker inspect -f '{{.Name}}: CPU: {{.HostConfig.CpuShares}}, Memory: {{.HostConfig.Memory}}' "$container")
    echo "   $limits"
done

# Recomendações
echo -e "\n${CYAN}📝 Recomendações de Segurança:${NC}"
echo "1. Use tags específicas de versão em vez de 'latest'"
echo "2. Limite recursos (CPU/memória) para todos os containers"
echo "3. Evite expor portas desnecessariamente para 0.0.0.0"
echo "4. Utilize redes Docker personalizadas em vez da rede 'bridge' padrão"
echo "5. Implemente políticas de reinicialização apropriadas"
echo "6. Escaneie regularmente as imagens por vulnerabilidades"
echo "7. Mantenha o Docker e as imagens atualizados"

echo -e "\n${GREEN}✅ Verificação de segurança concluída!${NC}"
