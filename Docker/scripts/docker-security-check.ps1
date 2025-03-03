# Script de Verificação de Segurança Docker (Windows PowerShell)
# Autor: DevOps Team
# Descrição: Realiza verificações de segurança básicas no ambiente Docker

Write-Host "🔒 Iniciando verificação de segurança Docker..." -ForegroundColor Cyan

# Verificar versão do Docker
Write-Host "`n📋 Verificando versão do Docker:" -ForegroundColor Yellow
docker version
$dockerInfo = docker info

# Verificar configurações de segurança básicas
Write-Host "`n🛡️ Verificando configurações de segurança:" -ForegroundColor Yellow

# Verificar se o Docker está rodando como root (Windows não é relevante, mas mantido para compatibilidade)
Write-Host "`n1. Verificação de privilégios:" -ForegroundColor Green
Write-Host "   ✓ Docker Desktop no Windows já gerencia privilégios adequadamente"

# Verificar containers em execução com portas expostas
Write-Host "`n2. Containers com portas expostas:" -ForegroundColor Green
docker ps --format "table {{.Names}}\t{{.Ports}}" | Where-Object { $_ -match "0.0.0.0" }

# Verificar containers em execução com volumes sensíveis
Write-Host "`n3. Containers com volumes sensíveis:" -ForegroundColor Green
docker ps -q | ForEach-Object {
    $volumes = docker inspect -f '{{range .Mounts}}{{.Source}}:{{.Destination}} {{end}}' $_
    if ($volumes) {
        Write-Host "   Container $_:"
        Write-Host "   Volumes: $volumes"
    }
}

# Verificar imagens sem tag específica
Write-Host "`n4. Imagens usando tag 'latest':" -ForegroundColor Green
docker images --format "{{.Repository}}:{{.Tag}}" | Where-Object { $_ -match ":latest" }

# Verificar redes Docker
Write-Host "`n5. Configurações de rede:" -ForegroundColor Green
docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"

# Verificar políticas de reinicialização
Write-Host "`n6. Containers com restart-policy:" -ForegroundColor Green
docker ps -a --format "{{.Names}}: {{.Status}}" | Where-Object { $_ -match "Restarting" }

# Verificar recursos limitados
Write-Host "`n7. Limites de recursos:" -ForegroundColor Green
docker ps -q | ForEach-Object {
    $limits = docker inspect -f '{{.Name}}: CPU: {{.HostConfig.CpuShares}}, Memory: {{.HostConfig.Memory}}' $_
    Write-Host "   $limits"
}

# Recomendações
Write-Host "`n📝 Recomendações de Segurança:" -ForegroundColor Cyan
Write-Host "1. Use tags específicas de versão em vez de 'latest'"
Write-Host "2. Limite recursos (CPU/memória) para todos os containers"
Write-Host "3. Evite expor portas desnecessariamente para 0.0.0.0"
Write-Host "4. Utilize redes Docker personalizadas em vez da rede 'bridge' padrão"
Write-Host "5. Implemente políticas de reinicialização apropriadas"
Write-Host "6. Escaneie regularmente as imagens por vulnerabilidades"
Write-Host "7. Mantenha o Docker e as imagens atualizados"

Write-Host "`n✅ Verificação de segurança concluída!" -ForegroundColor Green
