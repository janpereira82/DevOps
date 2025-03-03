#!/bin/bash

# Script de Monitoramento de Recursos Kubernetes (Linux/Mac)
# Autor: DevOps Team
# Descrição: Monitora recursos e performance do cluster Kubernetes

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variáveis padrão
NAMESPACE=${1:-"default"}
POD=$2
THRESHOLD=${3:-80}

echo -e "${CYAN}🔍 Iniciando monitoramento do Kubernetes...${NC}"

# Verificar nodes
echo -e "\n${YELLOW}📊 Métricas dos Nodes:${NC}"
kubectl top nodes

# Verificar pods com alto consumo
echo -e "\n${YELLOW}⚠️ Pods com alto consumo de recursos:${NC}"
kubectl top pods --all-namespaces | awk -v threshold="$THRESHOLD" '
    NR>1 {
        split($3,cpu,"%")
        split($4,mem,"%")
        if (cpu[1] > threshold || mem[1] > threshold) 
            print
    }'

# Verificar pods em estados não desejados
echo -e "\n${YELLOW}🚨 Pods em estados problemáticos:${NC}"
kubectl get pods --all-namespaces | grep -v "Running\|Completed"

# Se um pod específico foi especificado, mostrar detalhes
if [ -n "$POD" ]; then
    echo -e "\n${YELLOW}📝 Detalhes do pod $POD:${NC}"
    
    # Métricas do pod
    echo -e "\n${CYAN}Métricas:${NC}"
    kubectl top pod "$POD" -n "$NAMESPACE"
    
    # Descrição do pod
    echo -e "\n${CYAN}Descrição:${NC}"
    kubectl describe pod "$POD" -n "$NAMESPACE"
    
    # Logs recentes
    echo -e "\n${CYAN}Logs recentes:${NC}"
    kubectl logs "$POD" -n "$NAMESPACE" --tail=50
fi

# Verificar eventos recentes
echo -e "\n${YELLOW}📋 Eventos recentes do cluster:${NC}"
kubectl get events --sort-by='.metadata.creationTimestamp' | tail -n 10

# Verificar status dos deployments
echo -e "\n${YELLOW}🚀 Status dos Deployments:${NC}"
kubectl get deployments --all-namespaces

# Verificar status dos serviços
echo -e "\n${YELLOW}🌐 Status dos Services:${NC}"
kubectl get services --all-namespaces

# Verificar Persistent Volumes
echo -e "\n${YELLOW}💾 Status dos Persistent Volumes:${NC}"
kubectl get pv

# Recomendações baseadas na análise
echo -e "\n${CYAN}📝 Recomendações:${NC}"

# Verificar pods sem limites de recursos
echo -e "\n${YELLOW}⚠️ Pods sem limites de recursos definidos:${NC}"
kubectl get pods --all-namespaces -o json | jq -r '
    .items[] | 
    select(.spec.containers[0].resources.limits == null) |
    .metadata.name'

# Verificar pods com muitas reinicializações
echo -e "\n${YELLOW}⚠️ Pods com muitas reinicializações:${NC}"
kubectl get pods --all-namespaces -o json | jq -r '
    .items[] | 
    select(.status.containerStatuses[0].restartCount > 5) |
    "\(.metadata.name): \(.status.containerStatuses[0].restartCount) reinícios"'

echo -e "\n${GREEN}✅ Monitoramento concluído!${NC}"
