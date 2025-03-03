# Script de Gerenciamento de Cluster Kubernetes (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Facilita operações comuns de gerenciamento do cluster Kubernetes

param (
    [string]$action = "status",
    [string]$namespace = "default",
    [string]$resource = "",
    [string]$label = ""
)

# Função para verificar status do cluster
function Show-ClusterStatus {
    Write-Host "`n📊 Status do Cluster:" -ForegroundColor Cyan
    
    # Verificar nodes
    Write-Host "`n🖥️ Nodes:" -ForegroundColor Yellow
    kubectl get nodes -o wide

    # Verificar pods em todos os namespaces
    Write-Host "`n📦 Pods em estado não-Running:" -ForegroundColor Yellow
    kubectl get pods --all-namespaces | Where-Object { $_ -notmatch "Running" -and $_ -notmatch "Completed" }

    # Verificar serviços
    Write-Host "`n🌐 Serviços:" -ForegroundColor Yellow
    kubectl get services --all-namespaces

    # Verificar eventos recentes
    Write-Host "`n📝 Eventos Recentes:" -ForegroundColor Yellow
    kubectl get events --sort-by='.metadata.creationTimestamp' | Select-Object -Last 10
}

# Função para mostrar recursos do namespace
function Show-NamespaceResources {
    param($ns)
    Write-Host "`n📋 Recursos no namespace $ns:" -ForegroundColor Cyan
    
    Write-Host "`n📦 Pods:" -ForegroundColor Yellow
    kubectl get pods -n $ns

    Write-Host "`n🚀 Deployments:" -ForegroundColor Yellow
    kubectl get deployments -n $ns

    Write-Host "`n🌐 Services:" -ForegroundColor Yellow
    kubectl get services -n $ns

    Write-Host "`n📝 ConfigMaps:" -ForegroundColor Yellow
    kubectl get configmaps -n $ns

    Write-Host "`n🔒 Secrets:" -ForegroundColor Yellow
    kubectl get secrets -n $ns
}

# Função para limpar recursos
function Remove-Resources {
    param($ns, $label)
    
    if ($label) {
        Write-Host "🗑️ Removendo recursos com label $label no namespace $ns..." -ForegroundColor Yellow
        kubectl delete all -l $label -n $ns
    } else {
        Write-Host "⚠️ É necessário especificar um label para remoção de recursos!" -ForegroundColor Red
    }
}

# Função para verificar logs
function Show-ResourceLogs {
    param($ns, $resource)
    
    if ($resource) {
        Write-Host "📝 Exibindo logs do recurso $resource no namespace $ns..." -ForegroundColor Yellow
        kubectl logs $resource -n $ns --tail=100
    } else {
        Write-Host "⚠️ É necessário especificar um recurso para visualizar logs!" -ForegroundColor Red
    }
}

# Processar ação solicitada
switch ($action.ToLower()) {
    "status" {
        Show-ClusterStatus
    }
    "resources" {
        Show-NamespaceResources $namespace
    }
    "clean" {
        Remove-Resources $namespace $label
    }
    "logs" {
        Show-ResourceLogs $namespace $resource
    }
    default {
        Write-Host "❌ Ação inválida!" -ForegroundColor Red
        Write-Host "Ações disponíveis: status, resources, clean, logs" -ForegroundColor Yellow
    }
}
