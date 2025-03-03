# Scripts Docker para DevOps

Este diretório contém scripts úteis para automatizar tarefas comuns do Docker em ambientes de desenvolvimento e produção.

## Scripts Disponíveis

### 1. Limpeza do Docker
- `docker-cleanup.ps1` (Windows)
- `docker-cleanup.sh` (Linux/Mac)
  
**Funcionalidades:**
- Remove containers parados
- Remove imagens não utilizadas
- Remove volumes órfãos
- Remove redes não utilizadas
- Exibe estatísticas após limpeza

### 2. Monitoramento do Docker
- `docker-monitor.ps1` (Windows)
- `docker-monitor.sh` (Linux/Mac)

**Funcionalidades:**
- Monitora status geral do Docker
- Exibe uso de recursos dos containers
- Monitora uso de disco
- Alerta sobre containers parados
- Fornece estatísticas em tempo real

### 3. Backup do Docker
- `docker-backup.ps1` (Windows)
- `docker-backup.sh` (Linux/Mac)

**Funcionalidades:**
- Backup de volumes Docker
- Backup de containers
- Compactação automática dos backups
- Organização por data/hora
- Limpeza automática de arquivos temporários

## Como Usar

### No Windows (PowerShell):
```powershell
# Execute os scripts do PowerShell
.\docker-cleanup.ps1
.\docker-monitor.ps1
.\docker-backup.ps1
```

### No Linux/Mac:
```bash
# Dê permissão de execução aos scripts
chmod +x *.sh

# Execute os scripts
./docker-cleanup.sh
./docker-monitor.sh
./docker-backup.sh
```

## Observações Importantes

1. **Permissões**: 
   - Certifique-se de ter permissões de administrador/root
   - O Docker daemon deve estar em execução
   - No Linux/Mac, os scripts precisam ter permissão de execução

2. **Backup**:
   - Os backups são salvos no diretório `docker-backups`
   - Cada backup é identificado com data e hora
   - Recomenda-se mover os backups para um local seguro

3. **Monitoramento**:
   - O script de monitoramento pode ser agendado para execução periódica
   - Recomenda-se ajustar os thresholds de alerta conforme necessário

4. **Limpeza**:
   - O script de limpeza remove recursos não utilizados
   - Certifique-se de que não há dados importantes antes da limpeza
   - Recomenda-se executar periodicamente para otimizar o uso de disco

## Customização

Todos os scripts podem ser customizados conforme necessidade:
- Ajuste os diretórios de backup
- Modifique os critérios de limpeza
- Personalize os alertas de monitoramento
- Adicione novas funcionalidades

## Suporte

Em caso de problemas:
1. Verifique as permissões
2. Confirme que o Docker está em execução
3. Verifique os logs do Docker
4. Consulte a documentação oficial do Docker
