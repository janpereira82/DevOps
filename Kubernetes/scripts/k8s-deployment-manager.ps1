# Script de Gerenciamento de Deployments Kubernetes (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Facilita operações de deployment no Kubernetes

param (
    [string]$action = "status",
    [string]$namespace = "default",
    [string]$deployment = "",
    [string]$image = "",
    [int]$replicas = 1,
    [string]$configFile = ""
)

# Função para verificar status do deployment
function Show-DeploymentStatus {
    param($ns, $deploy)
    
    if ($deploy) {
        Write-Host "`n📊 Status do Deployment $deploy:" -ForegroundColor Cyan
        kubectl get deployment $deploy -n $ns -o wide
        
        Write-Host "`n📦 Pods do Deployment:" -ForegroundColor Yellow
        kubectl get pods -n $ns -l app=$deploy
        
        Write-Host "`n📝 Eventos relacionados:" -ForegroundColor Yellow
        kubectl get events -n $ns --field-selector involvedObject.name=$deploy --sort-by='.metadata.creationTimestamp'
    } else {
        Write-Host "`n📊 Status de todos os Deployments:" -ForegroundColor Cyan
        kubectl get deployments -n $ns -o wide
    }
}

# Função para criar/atualizar deployment
function Update-Deployment {
    param($ns, $deploy, $img, $rep)
    
    if (-not $deploy -or -not $img) {
        Write-Host "❌ Nome do deployment e imagem são obrigatórios!" -ForegroundColor Red
        return
    }

    Write-Host "🚀 Atualizando deployment $deploy..." -ForegroundColor Cyan
    
    # Verificar se deployment existe
    $exists = kubectl get deployment $deploy -n $ns 2>$null
    
    if ($exists) {
        # Atualizar imagem e replicas
        kubectl set image deployment/$deploy $deploy=$img -n $ns
        kubectl scale deployment/$deploy --replicas=$rep -n $ns
    } else {
        # Criar novo deployment
        $yaml = @"
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
"@
        $yaml | kubectl apply -f -
    }
    
    # Verificar status
    Write-Host "`n📝 Aguardando rollout..." -ForegroundColor Yellow
    kubectl rollout status deployment/$deploy -n $ns
}

# Função para remover deployment
function Remove-KubeDeployment {
    param($ns, $deploy)
    
    if (-not $deploy) {
        Write-Host "❌ Nome do deployment é obrigatório!" -ForegroundColor Red
        return
    }

    Write-Host "🗑️ Removendo deployment $deploy..." -ForegroundColor Yellow
    kubectl delete deployment $deploy -n $ns
}

# Função para aplicar configuração via arquivo
function Apply-ConfigFile {
    param($file)
    
    if (-not (Test-Path $file)) {
        Write-Host "❌ Arquivo de configuração não encontrado!" -ForegroundColor Red
        return
    }

    Write-Host "📁 Aplicando configuração do arquivo $file..." -ForegroundColor Cyan
    kubectl apply -f $file
}

# Processar ação solicitada
switch ($action.ToLower()) {
    "status" {
        Show-DeploymentStatus $namespace $deployment
    }
    "update" {
        Update-Deployment $namespace $deployment $image $replicas
    }
    "delete" {
        Remove-KubeDeployment $namespace $deployment
    }
    "apply" {
        if ($configFile) {
            Apply-ConfigFile $configFile
        } else {
            Write-Host "❌ Arquivo de configuração não especificado!" -ForegroundColor Red
        }
    }
    default {
        Write-Host "❌ Ação inválida!" -ForegroundColor Red
        Write-Host "Ações disponíveis: status, update, delete, apply" -ForegroundColor Yellow
    }
}
