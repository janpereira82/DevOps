# Guia Rápido Docker

## Índice
- [Instalação](#instalação)
- [Conceitos Básicos](#conceitos-básicos)
- [Comandos Essenciais](#comandos-essenciais)
- [Exemplos Práticos](#exemplos-práticos)
- [Boas Práticas](#boas-práticas)
- [Troubleshooting](#troubleshooting)
- [Docker Compose](#docker-compose)
- [Docker Networking](#docker-networking)
- [Segurança](#segurança)
- [Scripts Úteis](#scripts-úteis)
- [Recursos Adicionais](#recursos-adicionais)

## Instalação

### Windows
1. Baixe o Docker Desktop para Windows em https://www.docker.com/products/docker-desktop
2. Execute o instalador
3. Siga as instruções do assistente de instalação
4. Reinicie o computador
5. Verifique a instalação: `docker --version`

### Linux (Ubuntu/Debian)
```bash
# Remover versões antigas
sudo apt-get remove docker docker-engine docker.io containerd runc

# Atualizar repositórios
sudo apt-get update

# Instalar dependências
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Adicionar chave GPG oficial Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configurar repositório estável
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Verificar instalação
sudo docker run hello-world
```

### macOS
1. Baixe o Docker Desktop para Mac em https://www.docker.com/products/docker-desktop
2. Arraste o Docker.app para a pasta Applications
3. Inicie o Docker Desktop
4. Verifique a instalação: `docker --version`

## Conceitos Básicos

- **Container**: Ambiente isolado que executa uma aplicação e suas dependências
- **Imagem**: Template somente leitura com instruções para criar um container
- **Dockerfile**: Arquivo de configuração para construir uma imagem
- **Registry**: Repositório de imagens Docker (ex: Docker Hub)
- **Volume**: Mecanismo para persistir dados gerados em containers

## Comandos Essenciais

### Gerenciamento de Imagens
```bash
# Listar imagens
docker images

# Baixar uma imagem
docker pull nome_imagem:tag

# Remover uma imagem
docker rmi nome_imagem:tag

# Construir uma imagem
docker build -t nome_imagem:tag .
```

### Gerenciamento de Containers
```bash
# Listar containers em execução
docker ps

# Listar todos os containers
docker ps -a

# Criar e iniciar um container
docker run -d --name meu_container nome_imagem:tag

# Parar um container
docker stop container_id

# Iniciar um container parado
docker start container_id

# Remover um container
docker rm container_id

# Executar comando dentro do container
docker exec -it container_id comando
```

### Redes e Volumes
```bash
# Criar uma rede
docker network create minha_rede

# Criar um volume
docker volume create meu_volume

# Listar volumes
docker volume ls

# Inspecionar rede
docker network inspect minha_rede
```

## Exemplos Práticos

### 1. Executando um servidor web Nginx
```bash
# Baixar e executar Nginx
docker run -d -p 80:80 --name webserver nginx

# Acessar logs
docker logs webserver

# Parar o servidor
docker stop webserver
```

### 2. Banco de dados PostgreSQL com volume
```bash
# Criar volume para dados
docker volume create postgres_data

# Executar PostgreSQL com volume
docker run -d \
    --name postgres \
    -e POSTGRES_PASSWORD=minhasenha \
    -v postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:latest
```

### 3. Aplicação com Redis
```bash
# Criar rede para comunicação
docker network create app_network

# Executar Redis
docker run -d \
    --name redis \
    --network app_network \
    redis:latest

# Executar aplicação conectada ao Redis
docker run -d \
    --name minha_app \
    --network app_network \
    minha_app:latest
```

## Boas Práticas

1. **Sempre especifique tags de versão**
   - Evite usar `latest`
   - Use tags específicas para garantir consistência

2. **Otimize camadas da imagem**
   - Combine comandos RUN usando &&
   - Remova arquivos desnecessários
   - Use .dockerignore

3. **Segurança**
   - Não execute containers como root
   - Escaneie imagens por vulnerabilidades
   - Mantenha imagens atualizadas

4. **Volumes e Persistência**
   - Use volumes nomeados em vez de bind mounts
   - Backup regular dos volumes
   - Documente pontos de montagem

## Troubleshooting

### Problemas Comuns e Soluções

1. **Container não inicia**
   ```bash
   # Verificar logs
   docker logs container_id
   
   # Verificar status
   docker inspect container_id
   ```

2. **Problemas de rede**
   ```bash
   # Verificar redes
   docker network ls
   
   # Testar conectividade
   docker network inspect rede_id
   ```

3. **Problemas de espaço**
   ```bash
   # Limpar recursos não utilizados
   docker system prune -a
   
   # Verificar uso de disco
   docker system df
   ```

### Comandos Úteis para Debug
```bash
# Inspecionar container
docker inspect container_id

# Ver estatísticas de uso
docker stats

# Histórico de camadas da imagem
docker history nome_imagem:tag
```

## Docker Compose

### Estrutura Básica do docker-compose.yml
```yaml
version: '3.8'
services:
  webapp:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./app:/usr/share/nginx/html
    environment:
      - NODE_ENV=production
```

### Comandos Principais
```bash
# Iniciar todos os serviços
docker-compose up -d

# Parar todos os serviços
docker-compose down

# Visualizar logs
docker-compose logs -f

# Escalar serviços
docker-compose up -d --scale webapp=3
```

### Exemplos Comuns
1. **Stack Web Básica**
```yaml
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
  
  api:
    build: ./api
    ports:
      - "3000:3000"
  
  db:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: exemplo
```

2. **Stack de Desenvolvimento**
```yaml
version: '3.8'
services:
  web:
    build: 
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "3000:3000"
```

## Docker Networking

### Tipos de Rede
1. **Bridge Network** (Padrão)
   - Rede isolada para containers
   - Comunicação via portas expostas

2. **Host Network**
   - Compartilha rede com host
   - Melhor performance

3. **Overlay Network**
   - Para Docker Swarm
   - Comunicação entre nodes

### Comandos de Rede
```bash
# Criar rede
docker network create minha-rede

# Conectar container
docker network connect minha-rede container1

# Inspecionar rede
docker network inspect minha-rede
```

## Segurança

### Boas Práticas
1. **Imagens**
   - Use imagens oficiais
   - Mantenha versões atualizadas
   - Escaneie vulnerabilidades

2. **Containers**
   - Limite recursos (CPU/memória)
   - Não execute como root
   - Use secrets para senhas

3. **Rede**
   - Isole redes sensíveis
   - Limite exposição de portas
   - Use TLS em produção

### Comandos de Segurança
```bash
# Limitar recursos
docker run -m 512m --cpu-quota 50000 nginx

# Escanear vulnerabilidades
docker scan minha-imagem

# Inspecionar configurações
docker inspect --format='{{.HostConfig.SecurityOpt}}' container
```

## Scripts Úteis
Consulte a pasta `scripts/` para uma coleção de scripts úteis para automação de tarefas Docker.

## Recursos Adicionais

### Ferramentas Úteis
1. **Portainer**
   - Interface web para Docker
   - Gerenciamento visual

2. **Lazydocker**
   - Interface TUI para Docker
   - Monitoramento em terminal

3. **Docker Scout**
   - Análise de segurança
   - Recomendações de melhoria

### Documentação Oficial
- [Docker Docs](https://docs.docker.com)
- [Docker Hub](https://hub.docker.com)
- [Docker Compose](https://docs.docker.com/compose)
- [Docker Security](https://docs.docker.com/security)

### Comunidade
- [Docker Forums](https://forums.docker.com)
- [Stack Overflow - Docker](https://stackoverflow.com/questions/tagged/docker)
- [Reddit - r/docker](https://reddit.com/r/docker)

---
**Dica**: Mantenha este guia atualizado conforme aprende novos conceitos e comandos Docker. A documentação oficial do Docker (https://docs.docker.com) é sempre uma excelente fonte de referência para informações mais detalhadas.
