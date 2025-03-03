#!/bin/bash

# Script de Limpeza do Docker (Linux/Mac)
# Autor: DevOps Team
# Descrição: Remove containers parados, imagens não utilizadas, volumes e redes órfãs

echo -e "\033[36m🐳 Iniciando limpeza do ambiente Docker...\033[0m"

# Remove containers parados
echo -e "\n\033[33m📦 Removendo containers parados...\033[0m"
docker container prune -f

# Remove imagens não utilizadas
echo -e "\n\033[33m🗑️ Removendo imagens não utilizadas...\033[0m"
docker image prune -a -f

# Remove volumes não utilizados
echo -e "\n\033[33m💾 Removendo volumes não utilizados...\033[0m"
docker volume prune -f

# Remove redes não utilizadas
echo -e "\n\033[33m🌐 Removendo redes não utilizadas...\033[0m"
docker network prune -f

# Exibe estatísticas após limpeza
echo -e "\n\033[32m📊 Estatísticas do sistema após limpeza:\033[0m"
docker system df

echo -e "\n\033[36m✨ Limpeza concluída!\033[0m"
