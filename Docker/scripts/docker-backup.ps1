# Script de Backup do Docker (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Realiza backup de containers e volumes Docker

# Configurações
$backupDir = ".\docker-backups"
$date = Get-Date -Format "yyyy-MM-dd_HH-mm"

# Criar diretório de backup se não existir
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

Write-Host "📦 Iniciando backup do Docker..." -ForegroundColor Cyan

# Backup de volumes
Write-Host "`n💾 Realizando backup dos volumes..." -ForegroundColor Yellow
$volumes = docker volume ls -q
foreach ($volume in $volumes) {
    Write-Host "Backup do volume: $volume" -ForegroundColor Green
    docker run --rm -v ${volume}:/source -v ${backupDir}:/backup alpine tar czf /backup/volume_${volume}_${date}.tar.gz -C /source .
}

# Backup de containers
Write-Host "`n🐳 Realizando backup dos containers..." -ForegroundColor Yellow
$containers = docker ps -a --format "{{.Names}}"
foreach ($container in $containers) {
    Write-Host "Backup do container: $container" -ForegroundColor Green
    docker commit $container "${container}_backup_${date}"
    docker save -o "${backupDir}\${container}_${date}.tar" "${container}_backup_${date}"
    docker rmi "${container}_backup_${date}"
}

# Compactar todos os backups
Write-Host "`n🗜️ Compactando backups..." -ForegroundColor Yellow
Compress-Archive -Path "${backupDir}\*" -DestinationPath "${backupDir}\docker_backup_${date}.zip" -Force

# Limpar arquivos temporários
Get-ChildItem -Path $backupDir -Exclude "docker_backup_${date}.zip" | Remove-Item -Force

Write-Host "`n✅ Backup concluído!" -ForegroundColor Green
Write-Host "📁 Local do backup: ${backupDir}\docker_backup_${date}.zip" -ForegroundColor Cyan
