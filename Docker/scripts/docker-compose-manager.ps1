# Script de Gerenciamento de Docker Compose (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Facilita operações comuns com Docker Compose

param (
    [string]$action = "status",
    [string]$service = "",
    [string]$composeFile = "docker-compose.yml",
    [int]$scale = 1
)

# Verificar se o arquivo docker-compose existe
if (-not (Test-Path $composeFile)) {
    Write-Host "❌ Arquivo $composeFile não encontrado!" -ForegroundColor Red
    exit 1
}

# Função para exibir status dos serviços
function Show-Status {
    Write-Host "`n📊 Status dos Serviços:" -ForegroundColor Cyan
    docker-compose ps
    
    Write-Host "`n📈 Uso de Recursos:" -ForegroundColor Cyan
    docker-compose top
}

# Função para gerenciar logs
function Show-Logs {
    param($serviceName)
    if ($serviceName) {
        docker-compose logs -f --tail=100 $serviceName
    } else {
        docker-compose logs -f --tail=100
    }
}

# Processar ação solicitada
switch ($action.ToLower()) {
    "up" {
        Write-Host "🚀 Iniciando serviços..." -ForegroundColor Cyan
        if ($service) {
            docker-compose up -d --scale $service=$scale $service
        } else {
            docker-compose up -d
        }
        Show-Status
    }
    "down" {
        Write-Host "🛑 Parando serviços..." -ForegroundColor Yellow
        docker-compose down
    }
    "restart" {
        Write-Host "🔄 Reiniciando serviços..." -ForegroundColor Yellow
        if ($service) {
            docker-compose restart $service
        } else {
            docker-compose restart
        }
        Show-Status
    }
    "logs" {
        Write-Host "📝 Exibindo logs..." -ForegroundColor Cyan
        Show-Logs $service
    }
    "scale" {
        Write-Host "⚖️ Escalando serviço $service para $scale instâncias..." -ForegroundColor Cyan
        docker-compose up -d --scale $service=$scale $service
        Show-Status
    }
    "status" {
        Show-Status
    }
    default {
        Write-Host "❌ Ação inválida!" -ForegroundColor Red
        Write-Host "Ações disponíveis: up, down, restart, logs, scale, status" -ForegroundColor Yellow
    }
}
