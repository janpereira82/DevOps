#!/bin/bash

# Script de Gerenciamento de Cluster Kubernetes (Linux/Mac)
# Autor: DevOps Team
# Descrição: Facilita operações comuns de gerenciamento do cluster Kubernetes

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variáveis padrão
ACTION=${1:-"status"}
NAMESPACE=${2:-"default"}
RESOURCE=$3
LABEL=$4

# Função para verificar status do cluster
show_cluster_status() {
    echo -e "\n${CYAN}📊 Status do Cluster:${NC}"
    
    # Verificar nodes
    echo -e "\n${YELLOW}🖥️ Nodes:${NC}"
    kubectl get nodes -o wide

    # Verificar pods em todos os namespaces
    echo -e "\n${YELLOW}📦 Pods em estado não-Running:${NC}"
    kubectl get pods --all-namespaces | grep -v "Running\|Completed"

    # Verificar serviços
    echo -e "\n${YELLOW}🌐 Serviços:${NC}"
    kubectl get services --all-namespaces

    # Verificar eventos recentes
    echo -e "\n${YELLOW}📝 Eventos Recentes:${NC}"
    kubectl get events --sort-by='.metadata.creationTimestamp' | tail -n 10
}

# Função para mostrar recursos do namespace
show_namespace_resources() {
    local ns=$1
    echo -e "\n${CYAN}📋 Recursos no namespace $ns:${NC}"
    
    echo -e "\n${YELLOW}📦 Pods:${NC}"
    kubectl get pods -n "$ns"

    echo -e "\n${YELLOW}🚀 Deployments:${NC}"
    kubectl get deployments -n "$ns"

    echo -e "\n${YELLOW}🌐 Services:${NC}"
    kubectl get services -n "$ns"

    echo -e "\n${YELLOW}📝 ConfigMaps:${NC}"
    kubectl get configmaps -n "$ns"

    echo -e "\n${YELLOW}🔒 Secrets:${NC}"
    kubectl get secrets -n "$ns"
}

# Função para limpar recursos
remove_resources() {
    local ns=$1
    local label=$2
    
    if [ -n "$label" ]; then
        echo -e "${YELLOW}🗑️ Removendo recursos com label $label no namespace $ns...${NC}"
        kubectl delete all -l "$label" -n "$ns"
    else
        echo -e "${RED}⚠️ É necessário especificar um label para remoção de recursos!${NC}"
    fi
}

# Função para verificar logs
show_resource_logs() {
    local ns=$1
    local resource=$2
    
    if [ -n "$resource" ]; then
        echo -e "${YELLOW}📝 Exibindo logs do recurso $resource no namespace $ns...${NC}"
        kubectl logs "$resource" -n "$ns" --tail=100
    else
        echo -e "${RED}⚠️ É necessário especificar um recurso para visualizar logs!${NC}"
    fi
}

# Processar ação solicitada
case ${ACTION,,} in
    "status")
        show_cluster_status
        ;;
    "resources")
        show_namespace_resources "$NAMESPACE"
        ;;
    "clean")
        remove_resources "$NAMESPACE" "$LABEL"
        ;;
    "logs")
        show_resource_logs "$NAMESPACE" "$RESOURCE"
        ;;
    *)
        echo -e "${RED}❌ Ação inválida!${NC}"
        echo -e "${YELLOW}Ações disponíveis: status, resources, clean, logs${NC}"
        ;;
esac
