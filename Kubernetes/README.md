# Guia Rápido Kubernetes

## Índice
- [Instalação](#instalação)
- [Conceitos Básicos](#conceitos-básicos)
- [Comandos Essenciais](#comandos-essenciais)
- [Recursos do Kubernetes](#recursos-do-kubernetes)
- [Boas Práticas](#boas-práticas)
- [Troubleshooting](#troubleshooting)
- [Monitoramento](#monitoramento)
- [Segurança](#segurança)
- [Scripts Úteis](#scripts-úteis)
- [Recursos Adicionais](#recursos-adicionais)

## Instalação

### Windows
1. **Instalar Docker Desktop**
   - Baixe e instale o Docker Desktop
   - Ative o Kubernetes nas configurações

2. **Instalar kubectl**
```powershell
# Via Chocolatey
choco install kubernetes-cli

# Verificar instalação
kubectl version
```

### Linux
```bash
# Instalar kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Instalar Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

## Conceitos Básicos

### 1. Pod
- Menor unidade do Kubernetes
- Contém um ou mais containers
- Compartilha rede e armazenamento

### 2. Deployment
- Gerencia ReplicaSets
- Permite atualizações rolling
- Define estado desejado

### 3. Service
- Expõe pods
- Balanceamento de carga
- DNS interno

### 4. ConfigMap e Secret
- Configurações externalizadas
- Dados sensíveis
- Injeção em containers

## Comandos Essenciais

### Gerenciamento de Clusters
```bash
# Informações do cluster
kubectl cluster-info

# Listar nodes
kubectl get nodes

# Verificar componentes
kubectl get componentstatuses
```

### Gerenciamento de Recursos
```bash
# Criar recursos
kubectl apply -f arquivo.yaml

# Listar recursos
kubectl get [pods|deployments|services|all]

# Descrever recurso
kubectl describe [tipo] [nome]

# Deletar recursos
kubectl delete -f arquivo.yaml
```

### Logs e Debug
```bash
# Ver logs
kubectl logs pod-name

# Executar comando em pod
kubectl exec -it pod-name -- /bin/bash

# Port-forward
kubectl port-forward pod-name 8080:80
```

## Recursos do Kubernetes

### 1. Manifesto de Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: nginx:1.19
        ports:
        - containerPort: 80
```

### 2. Manifesto de Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: myapp
```

## Boas Práticas

### 1. Recursos e Limites
```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

### 2. Probes de Saúde
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
```

### 3. Estratégias de Deploy
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

## Troubleshooting

### Problemas Comuns
1. **Pod em CrashLoopBackOff**
   - Verificar logs: `kubectl logs pod-name`
   - Descrever pod: `kubectl describe pod pod-name`

2. **Service não acessível**
   - Verificar endpoints: `kubectl get endpoints`
   - Testar DNS: `kubectl run -it --rm debug --image=busybox -- nslookup service-name`

3. **Problemas de Volume**
   - Verificar PVC: `kubectl get pvc`
   - Verificar eventos: `kubectl get events`

## Monitoramento

### 1. Métricas Básicas
```bash
# CPU e Memória
kubectl top nodes
kubectl top pods

# Métricas detalhadas
kubectl describe node node-name
```

### 2. Ferramentas Recomendadas
- Prometheus
- Grafana
- Kubernetes Dashboard

## Segurança

### 1. RBAC
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

### 2. Network Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

## Scripts Úteis
Consulte a pasta `scripts/` para uma coleção de scripts úteis para automação de tarefas Kubernetes.

## Recursos Adicionais

### Documentação Oficial
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Blog](https://kubernetes.io/blog/)

### Ferramentas Úteis
1. **Lens**
   - IDE para Kubernetes
   - Interface gráfica completa

2. **k9s**
   - Interface terminal
   - Gerenciamento rápido

3. **Helm**
   - Gerenciador de pacotes
   - Templates de aplicações

### Comunidade
- [Kubernetes Slack](https://kubernetes.slack.com)
- [CNCF Forums](https://discuss.cncf.io)
- [Stack Overflow - Kubernetes](https://stackoverflow.com/questions/tagged/kubernetes)

---
**Dica**: Mantenha este guia atualizado conforme aprende novos conceitos e comandos Kubernetes. A documentação oficial do Kubernetes é sempre uma excelente fonte de referência para informações mais detalhadas.
