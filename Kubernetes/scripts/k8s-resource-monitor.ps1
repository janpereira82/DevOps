# Script de Monitoramento de Recursos Kubernetes (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Monitora recursos e performance do cluster Kubernetes

param (
    [string]$namespace = "default",
    [string]$pod = "",
    [int]$threshold = 80
)

# Função para formatar bytes
function Format-Bytes {
    param([long]$bytes)
    $sizes = 'Bytes,KB,MB,GB,TB'
    $order = 0
    while ($bytes -ge 1024 -and $order -lt 4) {
        $bytes = $bytes / 1024
        $order++
    }
    return "{0:N2} {1}" -f $bytes, ($sizes -split ',')[$order]
}

Write-Host "🔍 Iniciando monitoramento do Kubernetes..." -ForegroundColor Cyan

# Verificar nodes
Write-Host "`n📊 Métricas dos Nodes:" -ForegroundColor Yellow
kubectl top nodes | Format-Table -AutoSize

# Verificar pods com alto consumo
Write-Host "`n⚠️ Pods com alto consumo de recursos:" -ForegroundColor Yellow
$highUsagePods = kubectl top pods --all-namespaces | Where-Object {
    $line = $_ -split "\s+"
    $cpu = $line[2] -replace "[^0-9.]"
    $memory = $line[3] -replace "[^0-9.]"
    [double]$cpu -gt $threshold -or [double]$memory -gt $threshold
}
$highUsagePods | Format-Table -AutoSize

# Verificar pods em estados não desejados
Write-Host "`n🚨 Pods em estados problemáticos:" -ForegroundColor Yellow
kubectl get pods --all-namespaces | Where-Object { $_ -notmatch "Running" -and $_ -notmatch "Completed" }

# Se um pod específico foi especificado, mostrar detalhes
if ($pod) {
    Write-Host "`n📝 Detalhes do pod $pod:" -ForegroundColor Yellow
    
    # Métricas do pod
    Write-Host "`nMétricas:" -ForegroundColor Cyan
    kubectl top pod $pod -n $namespace
    
    # Descrição do pod
    Write-Host "`nDescrição:" -ForegroundColor Cyan
    kubectl describe pod $pod -n $namespace
    
    # Logs recentes
    Write-Host "`nLogs recentes:" -ForegroundColor Cyan
    kubectl logs $pod -n $namespace --tail=50
}

# Verificar eventos recentes
Write-Host "`n📋 Eventos recentes do cluster:" -ForegroundColor Yellow
kubectl get events --sort-by='.metadata.creationTimestamp' | Select-Object -Last 10

# Verificar status dos deployments
Write-Host "`n🚀 Status dos Deployments:" -ForegroundColor Yellow
kubectl get deployments --all-namespaces | Format-Table -AutoSize

# Verificar status dos serviços
Write-Host "`n🌐 Status dos Services:" -ForegroundColor Yellow
kubectl get services --all-namespaces | Format-Table -AutoSize

# Verificar Persistent Volumes
Write-Host "`n💾 Status dos Persistent Volumes:" -ForegroundColor Yellow
kubectl get pv | Format-Table -AutoSize

# Recomendações baseadas na análise
Write-Host "`n📝 Recomendações:" -ForegroundColor Cyan

# Verificar pods sem limites de recursos
$podsWithoutLimits = kubectl get pods --all-namespaces -o json | 
    ConvertFrom-Json | 
    Select-Object -ExpandProperty items | 
    Where-Object { -not $_.spec.containers[0].resources.limits }

if ($podsWithoutLimits) {
    Write-Host "⚠️ Pods sem limites de recursos definidos:" -ForegroundColor Yellow
    $podsWithoutLimits | ForEach-Object { Write-Host "   - $($_.metadata.name)" }
}

# Verificar pods com muitas reinicializações
$podsWithRestarts = kubectl get pods --all-namespaces -o json |
    ConvertFrom-Json |
    Select-Object -ExpandProperty items |
    Where-Object { $_.status.containerStatuses.restartCount -gt 5 }

if ($podsWithRestarts) {
    Write-Host "⚠️ Pods com muitas reinicializações:" -ForegroundColor Yellow
    $podsWithRestarts | ForEach-Object { 
        Write-Host "   - $($_.metadata.name): $($_.status.containerStatuses.restartCount) reinícios" 
    }
}

Write-Host "`n✅ Monitoramento concluído!" -ForegroundColor Green
