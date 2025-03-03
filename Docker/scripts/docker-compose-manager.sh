#!/bin/bash

# Script de Gerenciamento de Docker Compose (Linux/Mac)
# Autor: DevOps Team
# Descrição: Facilita operações comuns com Docker Compose

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variáveis padrão
ACTION=${1:-"status"}
SERVICE=$2
COMPOSE_FILE="docker-compose.yml"
SCALE=${3:-1}

# Verificar se o arquivo docker-compose existe
if [ ! -f "$COMPOSE_FILE" ]; then
    echo -e "${RED}❌ Arquivo $COMPOSE_FILE não encontrado!${NC}"
    exit 1
fi

# Função para exibir status dos serviços
show_status() {
    echo -e "\n${CYAN}📊 Status dos Serviços:${NC}"
    docker-compose ps
    
    echo -e "\n${CYAN}📈 Uso de Recursos:${NC}"
    docker-compose top
}

# Função para gerenciar logs
show_logs() {
    local service=$1
    if [ -n "$service" ]; then
        docker-compose logs -f --tail=100 "$service"
    else
        docker-compose logs -f --tail=100
    fi
}

# Processar ação solicitada
case ${ACTION,,} in
    "up")
        echo -e "${CYAN}🚀 Iniciando serviços...${NC}"
        if [ -n "$SERVICE" ]; then
            docker-compose up -d --scale "$SERVICE=$SCALE" "$SERVICE"
        else
            docker-compose up -d
        fi
        show_status
        ;;
    "down")
        echo -e "${YELLOW}🛑 Parando serviços...${NC}"
        docker-compose down
        ;;
    "restart")
        echo -e "${YELLOW}🔄 Reiniciando serviços...${NC}"
        if [ -n "$SERVICE" ]; then
            docker-compose restart "$SERVICE"
        else
            docker-compose restart
        fi
        show_status
        ;;
    "logs")
        echo -e "${CYAN}📝 Exibindo logs...${NC}"
        show_logs "$SERVICE"
        ;;
    "scale")
        echo -e "${CYAN}⚖️ Escalando serviço $SERVICE para $SCALE instâncias...${NC}"
        docker-compose up -d --scale "$SERVICE=$SCALE" "$SERVICE"
        show_status
        ;;
    "status")
        show_status
        ;;
    *)
        echo -e "${RED}❌ Ação inválida!${NC}"
        echo -e "${YELLOW}Ações disponíveis: up, down, restart, logs, scale, status${NC}"
        ;;
esac
