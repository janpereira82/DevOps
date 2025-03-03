# Scripts Kubernetes para DevOps

Este diretório contém scripts úteis para automatizar tarefas comuns do Kubernetes em ambientes de desenvolvimento e produção.

## Scripts Disponíveis

### 1. Gerenciador de Cluster
- `k8s-cluster-manager.ps1` (Windows)
- `k8s-cluster-manager.sh` (Linux/Mac)
  
**Funcionalidades:**
- Mostra status geral do cluster
- Lista recursos por namespace
- Remove recursos por label
- Exibe logs de recursos

**Uso:**
```powershell
# Windows
.\k8s-cluster-manager.ps1 -action status
.\k8s-cluster-manager.ps1 -action resources -namespace default
.\k8s-cluster-manager.ps1 -action clean -namespace default -label app=myapp
.\k8s-cluster-manager.ps1 -action logs -namespace default -resource pod/mypod
```

```bash
# Linux/Mac
./k8s-cluster-manager.sh status
./k8s-cluster-manager.sh resources default
./k8s-cluster-manager.sh clean default app=myapp
./k8s-cluster-manager.sh logs default pod/mypod
```

### 2. Monitor de Recursos
- `k8s-resource-monitor.ps1` (Windows)
- `k8s-resource-monitor.sh` (Linux/Mac)

**Funcionalidades:**
- Monitora uso de CPU e memória
- Identifica pods problemáticos
- Mostra eventos do cluster
- Fornece recomendações

**Uso:**
```powershell
# Windows
.\k8s-resource-monitor.ps1
.\k8s-resource-monitor.ps1 -namespace default -pod mypod -threshold 80
```

```bash
# Linux/Mac
./k8s-resource-monitor.sh
./k8s-resource-monitor.sh default mypod 80
```

### 3. Gerenciador de Deployments
- `k8s-deployment-manager.ps1` (Windows)
- `k8s-deployment-manager.sh` (Linux/Mac)

**Funcionalidades:**
- Cria/atualiza deployments
- Gerencia réplicas
- Remove deployments
- Aplica configurações via arquivo

**Uso:**
```powershell
# Windows
.\k8s-deployment-manager.ps1 -action status
.\k8s-deployment-manager.ps1 -action update -deployment myapp -image nginx:latest -replicas 3
.\k8s-deployment-manager.ps1 -action delete -deployment myapp
.\k8s-deployment-manager.ps1 -action apply -configFile myapp.yaml
```

```bash
# Linux/Mac
./k8s-deployment-manager.sh status
./k8s-deployment-manager.sh update default myapp nginx:latest 3
./k8s-deployment-manager.sh delete default myapp
./k8s-deployment-manager.sh apply default "" "" "" myapp.yaml
```

## Observações Importantes

1. **Permissões**: 
   - Certifique-se de ter o kubectl configurado
   - Verifique as permissões no cluster
   - No Linux/Mac, dê permissão de execução aos scripts

2. **Configuração**:
   - Os scripts assumem configuração padrão do kubectl
   - Ajuste variáveis conforme necessário
   - Verifique o contexto atual do kubectl

3. **Monitoramento**:
   - Use thresholds apropriados para seu ambiente
   - Configure alertas conforme necessidade
   - Ajuste intervalos de verificação

4. **Segurança**:
   - Revise as permissões RBAC
   - Não exponha informações sensíveis
   - Mantenha logs seguros

## Customização

Todos os scripts podem ser customizados:
- Ajuste thresholds de monitoramento
- Modifique formatos de output
- Adicione novas funcionalidades
- Personalize verificações

## Suporte

Em caso de problemas:
1. Verifique a configuração do kubectl
2. Confirme acesso ao cluster
3. Verifique logs do Kubernetes
4. Consulte a documentação oficial
