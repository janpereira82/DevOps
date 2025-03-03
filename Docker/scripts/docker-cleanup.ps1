# Script de Limpeza do Docker (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Remove containers parados, imagens não utilizadas, volumes e redes órfãs

Write-Host "🐳 Iniciando limpeza do ambiente Docker..." -ForegroundColor Cyan

# Remove containers parados
Write-Host "`n📦 Removendo containers parados..." -ForegroundColor Yellow
docker container prune -f

# Remove imagens não utilizadas
Write-Host "`n🗑️ Removendo imagens não utilizadas..." -ForegroundColor Yellow
docker image prune -a -f

# Remove volumes não utilizados
Write-Host "`n💾 Removendo volumes não utilizados..." -ForegroundColor Yellow
docker volume prune -f

# Remove redes não utilizadas
Write-Host "`n🌐 Removendo redes não utilizadas..." -ForegroundColor Yellow
docker network prune -f

# Exibe estatísticas após limpeza
Write-Host "`n📊 Estatísticas do sistema após limpeza:" -ForegroundColor Green
docker system df

Write-Host "`n✨ Limpeza concluída!" -ForegroundColor Cyan
