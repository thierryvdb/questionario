# Estrutura do Projeto - Sistema de Questionário Técnico

## Visão Geral

```
questionario/
├── 📁 backend/              # API Node.js + Express + PostgreSQL
├── 📁 frontend/             # Aplicação Vue.js 3
├── 🐳 docker-compose.yml    # Orquestração de containers
├── 📝 README.md             # Documentação principal
├── 📖 GUIA_USO.md          # Guia completo de uso
├── 🧪 TESTE_RAPIDO.md      # Guia de testes
├── 📡 API_EXAMPLES.md       # Exemplos de uso da API
├── 🏗️ ESTRUTURA_PROJETO.md # Este arquivo
├── 🚀 start.sh              # Script de inicialização (Linux/Mac)
├── 🚀 start.bat             # Script de inicialização (Windows)
└── 🚫 .gitignore            # Arquivos ignorados pelo Git
```

## Backend (Node.js)

### Estrutura
```
backend/
├── routes/
│   ├── questions.js         # Rotas para perguntas e categorias
│   └── assessments.js       # Rotas para avaliações e análise
├── db.js                    # Conexão com PostgreSQL
├── server.js                # Servidor Express principal
├── init.sql                 # Schema e dados iniciais do banco
├── package.json             # Dependências Node.js
├── Dockerfile               # Container do backend
└── .env                     # Variáveis de ambiente
```

### Dependências Principais
```json
{
  "express": "^4.18.2",      // Framework web
  "pg": "^8.11.3",           // Driver PostgreSQL
  "cors": "^2.8.5",          // CORS middleware
  "dotenv": "^16.3.1",       // Variáveis de ambiente
  "body-parser": "^1.20.2",  // Parser de requisições
  "nodemon": "^3.0.1"        // Auto-reload (dev)
}
```

### Endpoints da API

#### Perguntas
- `GET /api/questions` - Lista todas as perguntas
- `GET /api/questions/by-category` - Perguntas agrupadas por categoria
- `GET /api/questions/categories` - Lista categorias

#### Avaliações
- `POST /api/assessments` - Cria nova avaliação
- `GET /api/assessments` - Lista todas as avaliações
- `GET /api/assessments/:id/analysis` - Obtém análise completa

#### Health Check
- `GET /api/health` - Verifica status da API
- `GET /` - Informações sobre endpoints

### Variáveis de Ambiente
```env
NODE_ENV=development
DB_HOST=postgres
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres123
DB_NAME=questionario
PORT=3000
```

## Frontend (Vue.js)

### Estrutura
```
frontend/
├── src/
│   ├── components/
│   │   └── ResultsView.vue  # Componente de resultados com gráfico
│   ├── App.vue              # Componente principal
│   └── main.js              # Entry point da aplicação
├── index.html               # HTML base
├── vite.config.js           # Configuração do Vite
├── package.json             # Dependências Vue.js
└── Dockerfile               # Container do frontend
```

### Dependências Principais
```json
{
  "vue": "^3.3.11",          // Framework Vue.js 3
  "axios": "^1.6.2",         // Cliente HTTP
  "chart.js": "^4.4.1",      // Biblioteca de gráficos
  "vite": "^5.0.8"           // Build tool
}
```

### Componentes

#### App.vue
- Componente principal
- Gerencia estado do questionário
- Formulário de perguntas
- Validação de respostas
- Envio de avaliação

**Funcionalidades:**
- Carregamento de perguntas da API
- Sistema de pontuação (0-5)
- Validação (todas perguntas devem ser respondidas)
- Integração com ResultsView

#### ResultsView.vue
- Exibição de resultados
- Gráfico de pizza (Chart.js)
- Análise por categoria
- Insights e recomendações

**Funcionalidades:**
- Resumo geral da avaliação
- Gráfico de pizza interativo com cores dinâmicas
- Cards de detalhamento por categoria
- Seção de pontos fortes e fracos
- Recomendações personalizadas
- Botão para nova avaliação

### Cores do Gráfico (Baseadas em Performance)
```javascript
≥ 80% → Verde   (#4CAF50) - Ponto Forte
≥ 60% → Azul    (#2196F3) - Bom
≥ 40% → Amarelo (#FFC107) - Regular
< 40% → Vermelho(#F44336) - Ponto Fraco
```

## Banco de Dados (PostgreSQL)

### Schema

#### Tabela: categories
```sql
id SERIAL PRIMARY KEY
name VARCHAR(255) NOT NULL
description TEXT
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

**Dados:**
1. Linux & Docker
2. Windows Server & Virtualização
3. Backups & Soluções Dell
4. Switches & Protocolos de Comunicação
5. VoIP & Firewall
6. Gestão de Chamados (Ivanti/ITIL)

#### Tabela: questions
```sql
id SERIAL PRIMARY KEY
category_id INTEGER REFERENCES categories(id)
question_text TEXT NOT NULL
order_number INTEGER NOT NULL
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

**Total:** 18 perguntas (3 por categoria)

#### Tabela: assessments
```sql
id SERIAL PRIMARY KEY
user_name VARCHAR(255)
user_email VARCHAR(255)
completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

#### Tabela: assessment_scores
```sql
id SERIAL PRIMARY KEY
assessment_id INTEGER REFERENCES assessments(id)
question_id INTEGER REFERENCES questions(id)
score INTEGER CHECK (score >= 0 AND score <= 5)
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

### Relacionamentos
```
categories (1) ──< (N) questions
assessments (1) ──< (N) assessment_scores
questions (1) ──< (N) assessment_scores
```

### Índices
```sql
idx_questions_category ON questions(category_id)
idx_assessment_scores_assessment ON assessment_scores(assessment_id)
idx_assessment_scores_question ON assessment_scores(question_id)
```

## Docker

### Containers

#### postgres
```yaml
Image: postgres:15-alpine
Porta: 5432
Volume: postgres_data:/var/lib/postgresql/data
Healthcheck: pg_isready
```

#### backend
```yaml
Build: ./backend
Porta: 3000
Depende de: postgres (healthcheck)
Comando: npm run dev
```

#### frontend
```yaml
Build: ./frontend
Porta: 5173
Depende de: backend
Comando: npm run dev
```

### Network
```yaml
questionario-network (bridge)
```

### Volumes
```yaml
postgres_data (persistência de dados)
```

## Fluxo de Dados

### 1. Carregamento de Perguntas
```
Frontend → GET /api/questions/by-category → Backend → PostgreSQL
PostgreSQL → Backend → Frontend (JSON) → Renderiza formulário
```

### 2. Envio de Avaliação
```
Frontend → POST /api/assessments → Backend
Backend → Valida dados
Backend → Inicia transação PostgreSQL
Backend → INSERT assessments
Backend → INSERT assessment_scores (18x)
Backend → Calcula análise
Backend → COMMIT transação
Backend → Retorna análise → Frontend
Frontend → Renderiza ResultsView
```

### 3. Análise de Resultados
```
Backend recebe scores
↓
Agrupa por categoria
↓
Calcula médias por categoria
↓
Calcula média geral
↓
Classifica cada categoria:
  - ≥80% = Ponto Forte
  - 60-79% = Bom
  - 40-59% = Regular
  - <40% = Ponto Fraco
↓
Identifica pontos fortes (≥80%)
↓
Identifica pontos fracos (<60%)
↓
Gera recomendações
↓
Retorna análise completa
```

## Sistema de Classificação

### Lógica de Cálculo

```javascript
// Por categoria
average_score = SUM(scores) / total_questions
percentage = (average_score / 5) * 100

if (percentage >= 80) classification = "Ponto Forte"
else if (percentage >= 60) classification = "Bom"
else if (percentage >= 40) classification = "Regular"
else classification = "Ponto Fraco"
```

### Exemplo de Cálculo

**Categoria: Linux & Docker (3 perguntas)**
- Pergunta 1: 4 pontos
- Pergunta 2: 5 pontos
- Pergunta 3: 4 pontos

```
Total: 13 pontos
Máximo possível: 15 pontos (3 × 5)
Média: 13 / 3 = 4.33
Percentual: (4.33 / 5) × 100 = 86.67%
Classificação: Ponto Forte (≥80%)
```

## Recursos Implementados

### ✅ Backend
- [x] API RESTful completa
- [x] Validação de dados
- [x] Transações de banco de dados
- [x] Cálculo automático de análise
- [x] Sistema de classificação
- [x] Health check
- [x] CORS configurado
- [x] Tratamento de erros

### ✅ Frontend
- [x] Interface responsiva
- [x] Formulário com validação
- [x] Sistema de pontuação visual
- [x] Gráfico de pizza interativo
- [x] Análise detalhada por categoria
- [x] Insights automáticos
- [x] Recomendações personalizadas
- [x] Botão para nova avaliação

### ✅ Banco de Dados
- [x] Schema completo
- [x] Dados iniciais (6 categorias, 18 perguntas)
- [x] Índices para performance
- [x] Constraints de integridade
- [x] Persistência com volumes

### ✅ DevOps
- [x] Docker Compose configurado
- [x] Healthchecks
- [x] Scripts de inicialização
- [x] Documentação completa

## Melhorias Futuras (Roadmap)

### Backend
- [ ] Autenticação de usuários
- [ ] Exportação de relatórios em PDF
- [ ] Histórico de avaliações por usuário
- [ ] Comparação entre avaliações
- [ ] API de estatísticas gerais
- [ ] Paginação de resultados
- [ ] Cache de perguntas (Redis)

### Frontend
- [ ] Dashboard administrativo
- [ ] Modo escuro
- [ ] Múltiplos idiomas (i18n)
- [ ] Impressão de resultados
- [ ] Compartilhamento de resultados
- [ ] Gráficos adicionais (barra, radar)
- [ ] Animações de transição
- [ ] Progressive Web App (PWA)

### Banco de Dados
- [ ] Auditoria de mudanças
- [ ] Backup automatizado
- [ ] Versionamento de perguntas
- [ ] Perguntas personalizáveis
- [ ] Categorias customizáveis

### DevOps
- [ ] CI/CD (GitHub Actions)
- [ ] Testes automatizados
- [ ] Monitoring (Prometheus/Grafana)
- [ ] Logs centralizados
- [ ] Deploy em produção (AWS/Azure)
- [ ] HTTPS/SSL
- [ ] Load balancer

## Comandos Rápidos

### Iniciar
```bash
docker-compose up -d
```

### Parar
```bash
docker-compose down
```

### Logs
```bash
docker-compose logs -f
```

### Rebuild
```bash
docker-compose up --build
```

### Reset completo
```bash
docker-compose down -v
docker-compose up --build
```

## Portas Utilizadas

| Serviço    | Porta | URL                     |
|------------|-------|-------------------------|
| Frontend   | 5173  | http://localhost:5173   |
| Backend    | 3000  | http://localhost:3000   |
| PostgreSQL | 5432  | localhost:5432          |

## Tecnologias e Versões

| Tecnologia | Versão      |
|------------|-------------|
| Node.js    | 18-alpine   |
| Vue.js     | 3.3.11      |
| PostgreSQL | 15-alpine   |
| Express    | 4.18.2      |
| Chart.js   | 4.4.1       |
| Vite       | 5.0.8       |

## Licença

MIT License

## Contato e Suporte

Para dúvidas, problemas ou sugestões:
1. Consulte [GUIA_USO.md](GUIA_USO.md)
2. Execute [TESTE_RAPIDO.md](TESTE_RAPIDO.md)
3. Verifique logs: `docker-compose logs -f`
4. Abra uma issue no repositório
