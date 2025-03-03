# Script de Monitoramento do Docker (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Monitora recursos e status dos containers Docker

# Função para formatar tamanho em bytes
function Format-ByteSize {
    param([long]$bytes)
    $sizes = 'Bytes,KB,MB,GB,TB'
    $order = 0
    while ($bytes -ge 1024 -and $order -lt 4) {
        $bytes = $bytes / 1024
        $order++
    }
    return "{0:N2} {1}" -f $bytes, ($sizes -split ',')[$order]
}

Write-Host "🔍 Monitoramento Docker Iniciado" -ForegroundColor Cyan
Write-Host "==============================`n" -ForegroundColor Cyan

# Status do Docker
$dockerStatus = docker info
Write-Host "📊 Status do Docker:" -ForegroundColor Yellow
Write-Host "Containers: $((docker ps -q).Count) em execução"
Write-Host "Imagens: $((docker images -q).Count) disponíveis"
Write-Host "Volumes: $((docker volume ls -q).Count) criados"
Write-Host "Redes: $((docker network ls -q).Count) configuradas`n"

# Monitoramento de Containers
Write-Host "🐋 Containers em Execução:" -ForegroundColor Yellow
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# Uso de Disco
Write-Host "`n💾 Uso de Disco:" -ForegroundColor Yellow
$diskUsage = docker system df
Write-Host $diskUsage

# Alertas
Write-Host "`n⚠️ Verificando Alertas:" -ForegroundColor Yellow
$containers = docker ps -a --format "{{.Status}},{{.Names}}"
foreach ($container in $containers) {
    $status, $name = $container -split ","
    if ($status -like "*Exited*") {
        Write-Host "Container $name está parado!" -ForegroundColor Red
    }
}

Write-Host "`n✅ Monitoramento Concluído" -ForegroundColor Green
