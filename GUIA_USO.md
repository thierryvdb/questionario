# Guia de Uso - Sistema de Questionário Técnico

## Sumário
1. [Pré-requisitos](#pré-requisitos)
2. [Instalação](#instalação)
3. [Como Usar](#como-usar)
4. [Estrutura de Avaliação](#estrutura-de-avaliação)
5. [Análise de Resultados](#análise-de-resultados)
6. [Comandos Úteis](#comandos-úteis)
7. [Solução de Problemas](#solução-de-problemas)

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Docker** (versão 20.10 ou superior)
  - Windows: [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
  - Linux: [Docker Engine](https://docs.docker.com/engine/install/)
  - macOS: [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)

- **Docker Compose** (geralmente já vem com Docker Desktop)
  - Verifique com: `docker-compose --version`

## Instalação

### Passo 1: Clonar ou baixar o projeto

```bash
cd questionario
```

### Passo 2: Iniciar a aplicação

**No Windows:**
```batch
start.bat
```

**No Linux/Mac:**
```bash
chmod +x start.sh
./start.sh
```

**Ou usando Docker Compose diretamente:**
```bash
docker-compose up --build
```

### Passo 3: Acessar a aplicação

Aguarde alguns segundos e acesse:
- **Frontend**: http://localhost:5173
- **API Backend**: http://localhost:3000/api
- **Health Check**: http://localhost:3000/api/health

## Como Usar

### 1. Preencher Informações Pessoais (Opcional)

Na página inicial, você pode informar:
- Nome do avaliado
- Email do avaliado

Estes campos são opcionais e servem apenas para identificação do resultado.

### 2. Responder o Questionário

O questionário está organizado em **6 categorias técnicas**:

1. **Linux & Docker** (3 perguntas)
2. **Windows Server & Virtualização** (3 perguntas)
3. **Backups & Soluções Dell** (3 perguntas)
4. **Switches & Protocolos de Comunicação** (3 perguntas)
5. **VoIP & Firewall** (3 perguntas)
6. **Gestão de Chamados (Ivanti/ITIL)** (3 perguntas)

**Total: 18 perguntas**

### 3. Atribuir Notas

Para cada pergunta, atribua uma nota de **0 a 5**:

- **0** = Não tenho conhecimento
- **1** = Conhecimento muito básico
- **2** = Conhecimento básico
- **3** = Conhecimento intermediário
- **4** = Conhecimento avançado
- **5** = Domínio completo/expertise

### 4. Enviar Avaliação

Após responder todas as perguntas, clique em **"Enviar Avaliação"**.

## Estrutura de Avaliação

### Critérios de Classificação

O sistema classifica automaticamente cada categoria com base no aproveitamento percentual:

| Aproveitamento | Classificação |
|---------------|---------------|
| 80% - 100%    | **Ponto Forte** 💪 |
| 60% - 79%     | **Bom** ✅ |
| 40% - 59%     | **Regular** ⚠️ |
| 0% - 39%      | **Ponto Fraco** 🔴 |

### Cálculo de Pontuação

- **Pontuação por pergunta**: 0 a 5 pontos
- **Pontuação máxima por categoria**: 15 pontos (3 perguntas × 5)
- **Pontuação máxima total**: 90 pontos (18 perguntas × 5)

## Análise de Resultados

Após enviar a avaliação, você terá acesso a:

### 1. Resumo Geral
- Total de perguntas respondidas
- Pontuação total obtida
- Média geral
- Percentual de aproveitamento

### 2. Gráfico de Pizza Interativo
- Visualização do desempenho em cada categoria
- Cores indicam o nível de performance:
  - **Verde**: Ponto Forte (≥80%)
  - **Azul**: Bom (60-79%)
  - **Amarelo**: Regular (40-59%)
  - **Vermelho**: Ponto Fraco (<40%)

### 3. Detalhamento por Categoria
- Nota média de cada categoria
- Percentual de aproveitamento
- Classificação (Ponto Forte, Bom, Regular ou Ponto Fraco)
- Barra de progresso visual

### 4. Insights e Recomendações
- **Pontos Fortes**: Categorias onde você se destacou
- **Pontos a Melhorar**: Categorias que precisam de atenção
- **Recomendações**: Sugestões personalizadas de estudo

## Comandos Úteis

### Ver logs dos containers
```bash
docker-compose logs -f
```

### Ver logs de um serviço específico
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

### Parar a aplicação
```bash
docker-compose down
```

### Parar e remover volumes (limpar banco de dados)
```bash
docker-compose down -v
```

### Reconstruir containers
```bash
docker-compose up --build
```

### Acessar o banco de dados PostgreSQL
```bash
docker exec -it questionario-db psql -U postgres -d questionario
```

### Comandos SQL úteis
```sql
-- Ver todas as avaliações
SELECT * FROM assessments;

-- Ver todas as categorias
SELECT * FROM categories;

-- Ver todas as perguntas
SELECT * FROM questions;

-- Ver scores de uma avaliação específica
SELECT * FROM assessment_scores WHERE assessment_id = 1;

-- Análise completa de uma avaliação
SELECT
    c.name as categoria,
    AVG(s.score) as media,
    COUNT(s.id) as total_perguntas
FROM categories c
JOIN questions q ON c.id = q.category_id
JOIN assessment_scores s ON q.id = s.question_id
WHERE s.assessment_id = 1
GROUP BY c.id, c.name;
```

## Solução de Problemas

### Erro: "Port already in use"

Se você receber um erro indicando que uma porta já está em uso:

**Porta 5173 (Frontend):**
```bash
# Windows
netstat -ano | findstr :5173
taskkill /PID [PID] /F

# Linux/Mac
lsof -i :5173
kill -9 [PID]
```

**Porta 3000 (Backend):**
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID [PID] /F

# Linux/Mac
lsof -i :3000
kill -9 [PID]
```

**Porta 5432 (PostgreSQL):**
```bash
# Pare outros serviços PostgreSQL ou altere a porta no docker-compose.yml
```

### Erro: "Cannot connect to backend"

1. Verifique se o backend está rodando:
   ```bash
   docker-compose ps
   ```

2. Verifique os logs do backend:
   ```bash
   docker-compose logs backend
   ```

3. Verifique a conexão com o banco:
   ```bash
   docker-compose logs postgres
   ```

### Erro: "Database connection failed"

1. Aguarde alguns segundos para o PostgreSQL inicializar completamente

2. Reinicie apenas o backend:
   ```bash
   docker-compose restart backend
   ```

3. Se persistir, recrie os containers:
   ```bash
   docker-compose down
   docker-compose up --build
   ```

### Limpeza Completa (Reset Total)

Se quiser começar do zero:

```bash
# Parar todos os containers
docker-compose down -v

# Remover imagens criadas
docker rmi questionario-backend questionario-frontend

# Remover volumes órfãos
docker volume prune

# Reconstruir tudo
docker-compose up --build
```

## Estrutura do Projeto

```
questionario/
├── backend/                 # API Node.js
│   ├── routes/             # Rotas da API
│   │   ├── questions.js    # Endpoints de perguntas
│   │   └── assessments.js  # Endpoints de avaliações
│   ├── db.js               # Conexão com PostgreSQL
│   ├── server.js           # Servidor Express
│   ├── init.sql            # Schema do banco
│   ├── Dockerfile          # Container do backend
│   └── package.json        # Dependências Node.js
│
├── frontend/               # Aplicação Vue.js
│   ├── src/
│   │   ├── components/
│   │   │   └── ResultsView.vue  # Página de resultados
│   │   ├── App.vue              # Componente principal
│   │   └── main.js              # Entry point
│   ├── index.html          # HTML base
│   ├── vite.config.js      # Configuração Vite
│   ├── Dockerfile          # Container do frontend
│   └── package.json        # Dependências Vue.js
│
├── docker-compose.yml      # Orquestração dos containers
├── start.sh               # Script de inicialização (Linux/Mac)
├── start.bat              # Script de inicialização (Windows)
├── README.md              # Documentação geral
└── GUIA_USO.md           # Este guia
```

## API Endpoints

### Perguntas

- `GET /api/questions` - Listar todas as perguntas
- `GET /api/questions/by-category` - Perguntas agrupadas por categoria
- `GET /api/questions/categories` - Listar categorias

### Avaliações

- `POST /api/assessments` - Criar nova avaliação
- `GET /api/assessments` - Listar todas as avaliações
- `GET /api/assessments/:id/analysis` - Obter análise de uma avaliação

### Health Check

- `GET /api/health` - Verificar status da API

## Tecnologias Utilizadas

### Backend
- Node.js 18
- Express.js
- PostgreSQL 15
- pg (driver PostgreSQL)

### Frontend
- Vue.js 3
- Vite
- Chart.js (para gráficos)
- Axios (requisições HTTP)

### DevOps
- Docker
- Docker Compose

## Contribuindo

Para contribuir com melhorias:

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## Suporte

Em caso de dúvidas ou problemas:

1. Verifique a seção [Solução de Problemas](#solução-de-problemas)
2. Verifique os logs: `docker-compose logs -f`
3. Abra uma issue no repositório do projeto

## Licença

Este projeto está sob a licença MIT.
