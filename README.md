# Sistema de Questionário Técnico 📊

Sistema completo de questionário para avaliação de conhecimentos em infraestrutura de TI com análise gráfica de pontos fortes e fracos.

![Badge Node.js](https://img.shields.io/badge/Node.js-18-green)
![Badge Vue.js](https://img.shields.io/badge/Vue.js-3-blue)
![Badge PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)
![Badge Docker](https://img.shields.io/badge/Docker-Enabled-blue)

## 🎯 Visão Geral

Sistema web full-stack que permite avaliar conhecimentos técnicos através de um questionário interativo e gera análises visuais automáticas com gráficos de pizza coloridos, identificando pontos fortes e fracos do avaliado.

## ✨ Funcionalidades Principais

- ✅ **Questionário Interativo**: 18 perguntas técnicas divididas em 6 categorias
- ✅ **Sistema de Pontuação**: Escala de 0 a 5 pontos por pergunta
- ✅ **Gráfico de Pizza Colorido**: Visualização interativa com Chart.js
- ✅ **Análise Automática**: Cálculo de pontos fortes e fracos
- ✅ **Classificação Inteligente**: 4 níveis (Ponto Forte, Bom, Regular, Ponto Fraco)
- ✅ **Recomendações Personalizadas**: Sugestões de estudo baseadas nos resultados
- ✅ **Interface Responsiva**: Funciona em desktop, tablet e mobile
- ✅ **API RESTful**: Backend completo com 8 endpoints
- ✅ **Persistência de Dados**: Armazenamento de avaliações no PostgreSQL
- 🆕 **Download de Relatório em PDF**: Exporte relatórios completos em formato PDF profissional
- 🆕 **Lista de Avaliações**: Histórico completo de todos os candidatos avaliados
- 🆕 **Identificação de Candidatos**: Nome e email salvos para cada avaliação
- 🆕 **Navegação por Menu**: Alterne entre "Novo Questionário" e "Lista de Avaliações"
- 🆕 **Visualização Detalhada**: Modal com análise completa de cada candidato

## 🚀 Início Rápido

### Pré-requisitos
- Docker
- Docker Compose

### Instalação e Execução

**Windows:**
```batch
start.bat
```

**Linux/Mac:**
```bash
chmod +x start.sh
./start.sh
```

**Ou manualmente:**
```bash
docker-compose up --build
```

### Acessar a Aplicação

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000/api
- **Health Check**: http://localhost:3000/api/health

## 📊 Sistema de Classificação

O sistema classifica automaticamente cada categoria com base no aproveitamento:

| Aproveitamento | Classificação | Cor |
|---------------|---------------|-----|
| 80% - 100%    | **Ponto Forte** | 🟢 Verde |
| 60% - 79%     | **Bom** | 🔵 Azul |
| 40% - 59%     | **Regular** | 🟡 Amarelo |
| 0% - 39%      | **Ponto Fraco** | 🔴 Vermelho |

## 📋 Categorias Avaliadas

1. **Linux & Docker** (3 perguntas)
   - Diagnóstico de sistemas Linux
   - Containerização com Docker
   - Troubleshooting

2. **Windows Server & Virtualização** (3 perguntas)
   - Active Directory (FSMO)
   - VMware/Hyper-V (Ballooning)
   - Clusters (Quorum)

3. **Backups & Soluções Dell** (3 perguntas)
   - Estratégias de backup
   - Hardware Dell (iDRAC)
   - Storage (RAID)

4. **Switches & Protocolos de Comunicação** (3 perguntas)
   - STP (Spanning Tree Protocol)
   - VLANs (802.1Q)
   - Roteamento (OSPF vs BGP)

5. **VoIP & Firewall** (3 perguntas)
   - Parâmetros de rede (Jitter, Latência)
   - Protocolos SIP
   - Firewall (Stateful, DPI)

6. **Gestão de Chamados (Ivanti/ITIL)** (3 perguntas)
   - Framework ITIL
   - Gestão de SLA
   - CMDB

## 🛠️ Tecnologias

### Backend
- Node.js 18
- Express 4.18.2
- PostgreSQL 15
- pg (driver PostgreSQL)

### Frontend
- Vue.js 3.3.11
- Vite 5.0.8
- Chart.js 4.4.1 (gráficos)
- Axios 1.6.2

### DevOps
- Docker
- Docker Compose

## 📁 Estrutura do Projeto

```
questionario/
├── backend/                    # API Node.js + Express
│   ├── routes/
│   │   ├── questions.js        # Endpoints de perguntas
│   │   └── assessments.js      # Endpoints de avaliações
│   ├── db.js                   # Conexão PostgreSQL
│   ├── server.js               # Servidor Express
│   ├── init.sql                # Schema e dados iniciais
│   ├── Dockerfile
│   └── package.json
│
├── frontend/                   # Aplicação Vue.js
│   ├── src/
│   │   ├── App.vue            # Componente principal
│   │   ├── components/
│   │   │   └── ResultsView.vue # Resultados + Gráfico
│   │   └── main.js
│   ├── index.html
│   ├── vite.config.js
│   ├── Dockerfile
│   └── package.json
│
├── docker-compose.yml          # Orquestração dos containers
├── start.bat                   # Script Windows
├── start.sh                    # Script Linux/Mac
├── .gitignore
│
├── README.md                   # Este arquivo
├── GUIA_USO.md                # Guia completo de uso
├── TESTE_RAPIDO.md            # Guia de testes
├── API_EXAMPLES.md             # Exemplos de API
├── ESTRUTURA_PROJETO.md        # Documentação técnica
└── RESUMO_EXECUTIVO.md         # Resumo executivo
```

## 🖼️ Como Funciona

### 1. Responder o Questionário
![Questionário](https://via.placeholder.com/800x400?text=Formul%C3%A1rio+de+Question%C3%A1rio)

O usuário responde 18 perguntas, atribuindo uma nota de 0 a 5 para cada uma:
- **0**: Não tenho conhecimento
- **1**: Conhecimento muito básico
- **2**: Conhecimento básico
- **3**: Conhecimento intermediário
- **4**: Conhecimento avançado
- **5**: Domínio completo/expertise

### 2. Visualizar Resultados
![Resultados](https://via.placeholder.com/800x400?text=Tela+de+Resultados)

Após enviar, o sistema exibe:
- **Resumo Geral**: Pontuação total e aproveitamento
- **Gráfico de Pizza**: Visualização colorida por categoria
- **Detalhamento**: Cards com análise de cada categoria
- **Insights**: Pontos fortes, fracos e recomendações

## 📡 API Endpoints

### Perguntas
```bash
GET /api/questions              # Lista todas as perguntas
GET /api/questions/by-category  # Perguntas agrupadas
GET /api/questions/categories   # Lista categorias
```

### Avaliações
```bash
POST /api/assessments           # Cria nova avaliação
GET /api/assessments            # Lista avaliações
GET /api/assessments/:id/analysis  # Análise completa
```

### Health Check
```bash
GET /api/health                 # Status da API
```

## 🧪 Testes Rápidos

### Verificar Health
```bash
curl http://localhost:3000/api/health
```

### Listar Categorias
```bash
curl http://localhost:3000/api/questions/categories
```

### Criar Avaliação via API
```bash
curl -X POST http://localhost:3000/api/assessments \
  -H "Content-Type: application/json" \
  -d '{
    "user_name": "Teste",
    "user_email": "teste@exemplo.com",
    "scores": [
      {"question_id": 1, "score": 4},
      {"question_id": 2, "score": 5}
    ]
  }'
```

## 📖 Documentação Completa

- 🆕 **[NOVIDADES.md](NOVIDADES.md)**: Novas funcionalidades v1.2 (PDF) e v1.1 (Lista e Menu)
- 🆕 **[DOWNLOAD_PDF.md](DOWNLOAD_PDF.md)**: Guia completo de download de PDF
- **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)**: Visão executiva do projeto
- **[GUIA_USO.md](GUIA_USO.md)**: Guia completo de instalação e uso
- **[TESTE_RAPIDO.md](TESTE_RAPIDO.md)**: Guia para testar rapidamente
- **[API_EXAMPLES.md](API_EXAMPLES.md)**: Exemplos detalhados da API
- **[ESTRUTURA_PROJETO.md](ESTRUTURA_PROJETO.md)**: Documentação técnica completa
- **[PERSONALIZACAO.md](PERSONALIZACAO.md)**: Guia de personalização
- **[INDICE_DOCUMENTACAO.md](INDICE_DOCUMENTACAO.md)**: Índice completo da documentação

## 🐛 Solução de Problemas

### Container não inicia
```bash
docker-compose down -v
docker-compose up --build
```

### Porta em uso
```bash
# Windows
netstat -ano | findstr :5173
taskkill /PID [PID] /F

# Linux/Mac
lsof -i :5173
kill -9 [PID]
```

### Ver logs
```bash
docker-compose logs -f
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres
```

### Reset completo
```bash
docker-compose down -v
docker rmi questionario-backend questionario-frontend
docker-compose up --build
```

## 🔒 Segurança

- Validação de entrada no backend
- Constraints de banco de dados
- Transações ACID no PostgreSQL
- CORS configurado
- Preparação contra SQL Injection (pg parameterized queries)

## 🚦 Status do Projeto

- ✅ Backend API completo
- ✅ Frontend responsivo
- ✅ Banco de dados configurado
- ✅ Gráficos interativos
- ✅ Análise automática
- ✅ Dockerização completa
- ✅ Documentação completa

## 🗺️ Roadmap

### Próximas Versões
- [ ] Autenticação de usuários
- [ ] Dashboard administrativo
- [ ] Exportação de relatórios em PDF
- [ ] Histórico de avaliações por usuário
- [ ] Comparação entre avaliações
- [ ] Modo escuro
- [ ] Múltiplos idiomas (i18n)
- [ ] PWA (Progressive Web App)
- [ ] Testes automatizados
- [ ] CI/CD

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit suas mudanças: `git commit -m 'Adiciona nova funcionalidade'`
4. Push para a branch: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 👥 Autores

Desenvolvido para avaliação de conhecimentos técnicos em infraestrutura de TI.

## 📞 Suporte

Para dúvidas ou problemas:

1. Consulte a [documentação](GUIA_USO.md)
2. Execute o [teste rápido](TESTE_RAPIDO.md)
3. Verifique os logs: `docker-compose logs -f`
4. Abra uma issue no repositório

## 🎓 Exemplo de Uso

```javascript
// Exemplo de integração com a API
const axios = require('axios');

// Criar avaliação
const response = await axios.post('http://localhost:3000/api/assessments', {
  user_name: 'João Silva',
  user_email: 'joao@exemplo.com',
  scores: [
    { question_id: 1, score: 4 },
    { question_id: 2, score: 5 },
    // ... demais perguntas
  ]
});

console.log('Análise:', response.data.data.analysis);
```

## 💡 Perguntas Frequentes

**Q: Preciso instalar Node.js ou PostgreSQL?**
A: Não! Tudo roda em containers Docker.

**Q: Posso personalizar as perguntas?**
A: Sim! Edite o arquivo `backend/init.sql`.

**Q: Os dados são persistidos?**
A: Sim! O PostgreSQL usa volumes Docker.

**Q: Funciona em produção?**
A: O sistema está pronto para desenvolvimento. Para produção, configure HTTPS, variáveis de ambiente seguras e considere usar um banco de dados gerenciado.

**Q: Como adicionar mais categorias?**
A: Edite o arquivo `backend/init.sql` e adicione novas categorias e perguntas no schema.

---

⭐ **Se este projeto foi útil, considere dar uma estrela!**
