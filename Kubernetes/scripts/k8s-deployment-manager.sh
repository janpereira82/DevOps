#!/bin/bash

# Script de Gerenciamento de Deployments Kubernetes (Linux/Mac)
# Autor: DevOps Team
# Descrição: Facilita operações de deployment no Kubernetes

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variáveis padrão
ACTION=${1:-"status"}
NAMESPACE=${2:-"default"}
DEPLOYMENT=$3
IMAGE=$4
REPLICAS=${5:-1}
CONFIG_FILE=$6

# Função para verificar status do deployment
show_deployment_status() {
    local ns=$1
    local deploy=$2
    
    if [ -n "$deploy" ]; then
        echo -e "\n${CYAN}📊 Status do Deployment $deploy:${NC}"
        kubectl get deployment "$deploy" -n "$ns" -o wide
        
        echo -e "\n${YELLOW}📦 Pods do Deployment:${NC}"
        kubectl get pods -n "$ns" -l "app=$deploy"
        
        echo -e "\n${YELLOW}📝 Eventos relacionados:${NC}"
        kubectl get events -n "$ns" --field-selector "involvedObject.name=$deploy" --sort-by='.metadata.creationTimestamp'
    else
        echo -e "\n${CYAN}📊 Status de todos os Deployments:${NC}"
        kubectl get deployments -n "$ns" -o wide
    fi
}

# Função para criar/atualizar deployment
update_deployment() {
    local ns=$1
    local deploy=$2
    local img=$3
    local rep=$4
    
    if [ -z "$deploy" ] || [ -z "$img" ]; then
        echo -e "${RED}❌ Nome do deployment e imagem são obrigatórios!${NC}"
        return 1
    fi

    echo -e "${CYAN}🚀 Atualizando deployment $deploy...${NC}"
    
    # Verificar se deployment existe
    if kubectl get deployment "$deploy" -n "$ns" &>/dev/null; then
        # Atualizar imagem e replicas
        kubectl set image "deployment/$deploy" "$deploy=$img" -n "$ns"
        kubectl scale "deployment/$deploy" --replicas="$rep" -n "$ns"
    else
        # Criar novo deployment
        cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $deploy
  namespace: $ns
spec:
  replicas: $rep
  selector:
    matchLabels:
      app: $deploy
  template:
    metadata:
      labels:
        app: $deploy
    spec:
      containers:
      - name: $deploy
        image: $img
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
EOF
    fi
    
    # Verificar status
    echo -e "\n${YELLOW}📝 Aguardando rollout...${NC}"
    kubectl rollout status "deployment/$deploy" -n "$ns"
}

# Função para remover deployment
remove_deployment() {
    local ns=$1
    local deploy=$2
    
    if [ -z "$deploy" ]; then
        echo -e "${RED}❌ Nome do deployment é obrigatório!${NC}"
        return 1
    fi

    echo -e "${YELLOW}🗑️ Removendo deployment $deploy...${NC}"
    kubectl delete deployment "$deploy" -n "$ns"
}

# Função para aplicar configuração via arquivo
apply_config_file() {
    local file=$1
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Arquivo de configuração não encontrado!${NC}"
        return 1
    fi

    echo -e "${CYAN}📁 Aplicando configuração do arquivo $file...${NC}"
    kubectl apply -f "$file"
}

# Processar ação solicitada
case ${ACTION,,} in
    "status")
        show_deployment_status "$NAMESPACE" "$DEPLOYMENT"
        ;;
    "update")
        update_deployment "$NAMESPACE" "$DEPLOYMENT" "$IMAGE" "$REPLICAS"
        ;;
    "delete")
        remove_deployment "$NAMESPACE" "$DEPLOYMENT"
        ;;
    "apply")
        if [ -n "$CONFIG_FILE" ]; then
            apply_config_file "$CONFIG_FILE"
        else
            echo -e "${RED}❌ Arquivo de configuração não especificado!${NC}"
        fi
        ;;
    *)
        echo -e "${RED}❌ Ação inválida!${NC}"
        echo -e "${YELLOW}Ações disponíveis: status, update, delete, apply${NC}"
        ;;
esac
