# Índice da Documentação

Guia completo de toda a documentação disponível no projeto.

## 📖 Documentação Principal

### [README.md](README.md) - Visão Geral do Projeto
**Conteúdo:**
- Visão geral e funcionalidades
- Tecnologias utilizadas
- Início rápido
- Sistema de classificação
- Categorias avaliadas
- Estrutura do projeto
- API endpoints
- Testes rápidos
- Solução de problemas
- Roadmap
- FAQ

**Para quem é:**
- Desenvolvedores iniciando no projeto
- Usuários querendo entender o sistema
- Pessoas buscando visão geral

---

## 🚀 Guias de Início

### [start.bat](start.bat) / [start.sh](start.sh) - Scripts de Inicialização
**Conteúdo:**
- Script automatizado para Windows/Linux
- Verifica dependências (Docker)
- Inicia containers
- Exibe URLs de acesso

**Para quem é:**
- Qualquer pessoa querendo iniciar rapidamente

### [GUIA_USO.md](GUIA_USO.md) - Guia Completo de Uso
**Conteúdo:**
- Pré-requisitos detalhados
- Instalação passo a passo
- Como usar o questionário
- Estrutura de avaliação
- Análise de resultados
- Comandos úteis
- Solução de problemas detalhada
- Limpeza e reset

**Para quem é:**
- Usuários finais
- Administradores do sistema
- Suporte técnico

### [TESTE_RAPIDO.md](TESTE_RAPIDO.md) - Guia de Testes
**Conteúdo:**
- Testes passo a passo
- Verificação de health check
- Teste de banco de dados
- Teste de frontend
- Teste de formulário
- Verificação de resultados
- Teste de API
- Checklist de funcionalidades
- Problemas comuns

**Para quem é:**
- QA/Testers
- Desenvolvedores verificando instalação
- Pessoas com problemas na aplicação

---

## 📊 Documentação Executiva

### [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) - Visão Executiva
**Conteúdo:**
- Objetivo do projeto
- O que foi implementado
- Sistema de classificação
- Categorias avaliadas
- Como usar (resumido)
- Exemplo de resultado visual
- Características do gráfico
- Fluxo de uso
- Cálculo inteligente
- Diferenciais
- Perguntas incluídas

**Para quem é:**
- Gestores
- Stakeholders
- Pessoas querendo visão de alto nível
- Apresentações do projeto

---

## 🔧 Documentação Técnica

### [ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md) - Documentação Técnica Completa
**Conteúdo:**
- Visão geral da arquitetura
- Estrutura completa do backend
- Estrutura completa do frontend
- Schema do banco de dados
- Relacionamentos de dados
- Fluxo de dados
- Sistema de classificação detalhado
- Recursos implementados
- Melhorias futuras (roadmap técnico)
- Comandos úteis
- Tecnologias e versões

**Para quem é:**
- Desenvolvedores
- Arquitetos de software
- DevOps
- Pessoas querendo entender a arquitetura

### [API_EXAMPLES.md](API_EXAMPLES.md) - Exemplos de Uso da API
**Conteúdo:**
- Base URL
- Health check
- Listar perguntas
- Listar por categoria
- Criar avaliação
- Listar avaliações
- Obter análise
- Exemplos com cURL
- Exemplos com JavaScript (Axios)
- Exemplos com Python (requests)
- Códigos de status HTTP
- Tratamento de erros

**Para quem é:**
- Desenvolvedores integrando com a API
- Frontend developers
- Backend developers
- Pessoas fazendo testes de API

### [PERSONALIZACAO.md](PERSONALIZACAO.md) - Guia de Personalização
**Conteúdo:**
- Personalizando perguntas
- Personalizando categorias
- Personalizando cores do gráfico
- Personalizando critérios de classificação
- Alterando escala de pontuação
- Personalizando interface
- Personalizando validações
- Personalizando relatórios
- Exemplos completos
- Checklist de personalização

**Para quem é:**
- Desenvolvedores customizando o sistema
- Pessoas adaptando para outras áreas
- Clientes querendo personalizar

---

## 📁 Arquivos de Configuração

### [docker-compose.yml](docker-compose.yml) - Orquestração Docker
**Conteúdo:**
- Configuração dos 3 containers (postgres, backend, frontend)
- Networks
- Volumes
- Healthchecks
- Variáveis de ambiente

### [.gitignore](.gitignore) - Arquivos Ignorados
**Conteúdo:**
- node_modules
- .env
- logs
- dist
- dados do PostgreSQL

---

## 🗂️ Estrutura por Audiência

### Para Usuários Finais
1. [README.md](README.md) - Começar aqui
2. [start.bat](start.bat) ou [start.sh](start.sh) - Executar
3. [GUIA_USO.md](GUIA_USO.md) - Como usar
4. [TESTE_RAPIDO.md](TESTE_RAPIDO.md) - Testar funcionalidade

### Para Gestores/Stakeholders
1. [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) - Visão geral
2. [README.md](README.md) - Funcionalidades
3. [GUIA_USO.md](GUIA_USO.md) - Como funciona

### Para Desenvolvedores
1. [README.md](README.md) - Visão geral
2. [ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md) - Arquitetura
3. [API_EXAMPLES.md](API_EXAMPLES.md) - API
4. [PERSONALIZACAO.md](PERSONALIZACAO.md) - Customização
5. Código-fonte em [backend/](backend/) e [frontend/](frontend/)

### Para QA/Testers
1. [TESTE_RAPIDO.md](TESTE_RAPIDO.md) - Guia de testes
2. [API_EXAMPLES.md](API_EXAMPLES.md) - Testar API
3. [GUIA_USO.md](GUIA_USO.md) - Casos de uso

### Para DevOps
1. [docker-compose.yml](docker-compose.yml) - Containers
2. [ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md) - Infraestrutura
3. [GUIA_USO.md](GUIA_USO.md) - Comandos úteis

---

## 📂 Estrutura de Pastas

```
questionario/
│
├── 📄 README.md                    # Visão geral
├── 📄 RESUMO_EXECUTIVO.md          # Resumo executivo
├── 📄 GUIA_USO.md                 # Guia completo
├── 📄 TESTE_RAPIDO.md             # Guia de testes
├── 📄 API_EXAMPLES.md              # Exemplos de API
├── 📄 ESTRUTURA_PROJETO.md         # Doc técnica
├── 📄 PERSONALIZACAO.md            # Guia de customização
├── 📄 INDICE_DOCUMENTACAO.md       # Este arquivo
│
├── 🐳 docker-compose.yml           # Orquestração
├── 🚀 start.bat                    # Script Windows
├── 🚀 start.sh                     # Script Linux/Mac
├── 🚫 .gitignore                   # Git ignore
│
├── 📁 backend/                     # API Node.js
│   ├── routes/
│   │   ├── questions.js           # Rotas de perguntas
│   │   └── assessments.js         # Rotas de avaliações
│   ├── db.js                      # Conexão DB
│   ├── server.js                  # Servidor Express
│   ├── init.sql                   # Schema + dados
│   ├── package.json               # Dependências
│   ├── Dockerfile                 # Container config
│   └── .env                       # Variáveis ambiente
│
└── 📁 frontend/                    # App Vue.js
    ├── src/
    │   ├── components/
    │   │   └── ResultsView.vue    # Resultados + gráfico
    │   ├── App.vue                # Componente principal
    │   └── main.js                # Entry point
    ├── index.html                 # HTML base
    ├── vite.config.js             # Config Vite
    ├── package.json               # Dependências
    └── Dockerfile                 # Container config
```

---

## 🔍 Busca Rápida

### Preciso saber como...

**...instalar o sistema**
→ [README.md](README.md) ou [GUIA_USO.md](GUIA_USO.md)

**...usar o questionário**
→ [GUIA_USO.md](GUIA_USO.md) seção "Como Usar"

**...entender a arquitetura**
→ [ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md)

**...usar a API**
→ [API_EXAMPLES.md](API_EXAMPLES.md)

**...personalizar perguntas**
→ [PERSONALIZACAO.md](PERSONALIZACAO.md) seção "Personalizando Perguntas"

**...alterar cores do gráfico**
→ [PERSONALIZACAO.md](PERSONALIZACAO.md) seção "Personalizando Cores"

**...resolver problemas**
→ [GUIA_USO.md](GUIA_USO.md) seção "Solução de Problemas"

**...testar o sistema**
→ [TESTE_RAPIDO.md](TESTE_RAPIDO.md)

**...apresentar o projeto**
→ [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)

**...entender o sistema de classificação**
→ [README.md](README.md) ou [ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md)

---

## 📊 Matriz de Documentação

| Documento | Técnico | Funcional | Executivo | Tutorial |
|-----------|---------|-----------|-----------|----------|
| README.md | ⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| RESUMO_EXECUTIVO.md | ⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐ |
| GUIA_USO.md | ⭐ | ⭐⭐⭐ | ⭐ | ⭐⭐⭐ |
| TESTE_RAPIDO.md | ⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐ |
| API_EXAMPLES.md | ⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐ |
| ESTRUTURA_PROJETO.md | ⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐ |
| PERSONALIZACAO.md | ⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐ |

---

## 🎯 Fluxo de Leitura Recomendado

### Novo no Projeto?
1. [README.md](README.md) - Entender o que é
2. [start.bat](start.bat) / [start.sh](start.sh) - Executar
3. Acessar http://localhost:5173 - Usar
4. [GUIA_USO.md](GUIA_USO.md) - Aprofundar

### Desenvolvedor Novo?
1. [README.md](README.md) - Visão geral
2. [ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md) - Arquitetura
3. Explorar código em [backend/](backend/) e [frontend/](frontend/)
4. [API_EXAMPLES.md](API_EXAMPLES.md) - API
5. [PERSONALIZACAO.md](PERSONALIZACAO.md) - Customizar

### Precisa Resolver Problema?
1. [GUIA_USO.md](GUIA_USO.md) - Solução de Problemas
2. [TESTE_RAPIDO.md](TESTE_RAPIDO.md) - Testar
3. Ver logs: `docker-compose logs -f`

### Vai Apresentar o Projeto?
1. [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) - Overview
2. [README.md](README.md) - Funcionalidades
3. Demo ao vivo em http://localhost:5173

---

## 📝 Atualização da Documentação

Última atualização: 2025-01-15

Para sugerir melhorias na documentação:
1. Identifique o arquivo relevante
2. Abra uma issue descrevendo a melhoria
3. Ou faça um Pull Request com as alterações

---

## 📞 Onde Buscar Ajuda

1. **Documentação**: Consulte este índice e os arquivos relevantes
2. **Logs**: `docker-compose logs -f`
3. **Issues**: Repositório do projeto
4. **API**: [API_EXAMPLES.md](API_EXAMPLES.md)
5. **Problemas**: [GUIA_USO.md](GUIA_USO.md) - Solução de Problemas

---

Este índice é um ponto de partida para navegar em toda a documentação do projeto.
