# Teste Rápido da Aplicação

Este guia fornece um passo a passo para testar rapidamente se a aplicação está funcionando corretamente.

## Passo 1: Iniciar a Aplicação

### Windows
```batch
start.bat
```

### Linux/Mac
```bash
chmod +x start.sh
./start.sh
```

Aguarde cerca de 10-15 segundos para os serviços iniciarem completamente.

## Passo 2: Verificar Health Check

Abra o navegador ou use curl:

```bash
curl http://localhost:3000/api/health
```

**Resposta esperada:**
```json
{
  "status": "OK",
  "message": "API do Questionário Técnico está funcionando",
  "timestamp": "2025-01-15T..."
}
```

## Passo 3: Verificar se o Banco de Dados Foi Inicializado

```bash
curl http://localhost:3000/api/questions/categories
```

**Resposta esperada:** Lista com 6 categorias
```json
{
  "success": true,
  "count": 6,
  "data": [...]
}
```

## Passo 4: Acessar o Frontend

Abra no navegador: **http://localhost:5173**

Você deve ver:
- ✅ Título: "Questionário Técnico - Infraestrutura TI"
- ✅ Campos para nome e email (opcionais)
- ✅ 6 categorias de perguntas
- ✅ 18 perguntas no total
- ✅ Botões de 0 a 5 para cada pergunta

## Passo 5: Testar o Formulário

1. **Preencha informações pessoais (opcional):**
   - Nome: "Teste Usuario"
   - Email: "teste@exemplo.com"

2. **Responda algumas perguntas:**
   - Clique nos botões de 0 a 5 para cada pergunta
   - Botão selecionado deve ficar com fundo roxo

3. **Tente enviar sem completar tudo:**
   - Deve aparecer aviso: "Por favor, responda todas as perguntas"
   - Botão "Enviar Avaliação" deve estar desabilitado

4. **Complete todas as perguntas**
   - Botão "Enviar Avaliação" deve ser habilitado
   - Clique no botão

## Passo 6: Verificar Resultado

Após enviar, você deve ver:

### ✅ Tela de Resultados com:

1. **Resumo Geral:**
   - Total de perguntas: 18
   - Pontuação total
   - Média geral
   - Aproveitamento percentual

2. **Gráfico de Pizza:**
   - Gráfico colorido com as 6 categorias
   - Cores indicando performance:
     - Verde = Ponto Forte (≥80%)
     - Azul = Bom (60-79%)
     - Amarelo = Regular (40-59%)
     - Vermelho = Ponto Fraco (<40%)

3. **Detalhamento por Categoria:**
   - Cards com cada categoria
   - Nota média
   - Barra de progresso
   - Badge com classificação

4. **Insights:**
   - Seção "Pontos Fortes" (se houver)
   - Seção "Pontos a Melhorar" (se houver)
   - Recomendações de estudo

5. **Botões:**
   - "Fazer Nova Avaliação"
   - "Baixar Relatório (Em breve)"

## Passo 7: Testar Nova Avaliação

1. Clique em "Fazer Nova Avaliação"
2. Deve voltar para o formulário inicial
3. Campos devem estar limpos
4. Faça outra avaliação para verificar que está funcionando

## Passo 8: Verificar Logs (Opcional)

```bash
docker-compose logs -f
```

Deve ver logs indicando:
- ✅ Backend conectado ao PostgreSQL
- ✅ Servidor rodando na porta 3000
- ✅ Frontend rodando na porta 5173
- ✅ Requisições sendo processadas

## Passo 9: Testar API Diretamente

### Criar avaliação via API:

```bash
curl -X POST http://localhost:3000/api/assessments \
  -H "Content-Type: application/json" \
  -d '{
    "user_name": "Teste API",
    "user_email": "api@teste.com",
    "scores": [
      {"question_id": 1, "score": 5},
      {"question_id": 2, "score": 4},
      {"question_id": 3, "score": 5},
      {"question_id": 4, "score": 3},
      {"question_id": 5, "score": 4},
      {"question_id": 6, "score": 3},
      {"question_id": 7, "score": 5},
      {"question_id": 8, "score": 4},
      {"question_id": 9, "score": 4},
      {"question_id": 10, "score": 3},
      {"question_id": 11, "score": 4},
      {"question_id": 12, "score": 3},
      {"question_id": 13, "score": 5},
      {"question_id": 14, "score": 4},
      {"question_id": 15, "score": 3},
      {"question_id": 16, "score": 4},
      {"question_id": 17, "score": 5},
      {"question_id": 18, "score": 4}
    ]
  }'
```

**Resposta esperada:**
```json
{
  "success": true,
  "message": "Avaliação criada com sucesso",
  "data": {
    "assessment_id": 1,
    "analysis": {...}
  }
}
```

### Listar avaliações:

```bash
curl http://localhost:3000/api/assessments
```

Deve mostrar todas as avaliações criadas.

## Passo 10: Acessar Banco de Dados (Opcional)

```bash
docker exec -it questionario-db psql -U postgres -d questionario
```

**Comandos SQL para testar:**

```sql
-- Ver categorias
SELECT * FROM categories;

-- Ver perguntas
SELECT * FROM questions;

-- Ver avaliações
SELECT * FROM assessments;

-- Ver scores
SELECT * FROM assessment_scores;

-- Sair
\q
```

## Checklist de Funcionalidades

- [ ] Docker containers inicializam sem erros
- [ ] Backend responde no health check
- [ ] Banco de dados contém 6 categorias e 18 perguntas
- [ ] Frontend carrega corretamente
- [ ] Formulário exibe todas as perguntas organizadas por categoria
- [ ] Botões de pontuação (0-5) funcionam
- [ ] Validação impede envio com perguntas não respondidas
- [ ] Envio de avaliação funciona
- [ ] Tela de resultados é exibida
- [ ] Gráfico de pizza é renderizado
- [ ] Cálculos de pontuação estão corretos
- [ ] Classificações (Ponto Forte, Bom, etc) estão corretas
- [ ] Insights e recomendações aparecem
- [ ] Botão "Fazer Nova Avaliação" limpa o formulário
- [ ] API retorna dados corretos

## Problemas Comuns

### Frontend não carrega
```bash
# Verificar se o container está rodando
docker-compose ps

# Ver logs
docker-compose logs frontend
```

### Backend retorna erro 500
```bash
# Verificar conexão com banco
docker-compose logs postgres
docker-compose logs backend
```

### Porta já em uso
```bash
# Parar containers
docker-compose down

# Verificar portas
netstat -ano | findstr :5173
netstat -ano | findstr :3000
netstat -ano | findstr :5432
```

### Reset completo
```bash
docker-compose down -v
docker-compose up --build
```

## Teste Automatizado com Script

Crie um arquivo `test.sh`:

```bash
#!/bin/bash

echo "Testando API..."

# Test 1: Health Check
echo "1. Health Check..."
curl -s http://localhost:3000/api/health | grep -q "OK"
if [ $? -eq 0 ]; then
    echo "✅ Health Check OK"
else
    echo "❌ Health Check FALHOU"
    exit 1
fi

# Test 2: Categorias
echo "2. Verificando categorias..."
COUNT=$(curl -s http://localhost:3000/api/questions/categories | grep -o '"count":[0-9]*' | cut -d: -f2)
if [ "$COUNT" = "6" ]; then
    echo "✅ 6 categorias encontradas"
else
    echo "❌ Número incorreto de categorias: $COUNT"
    exit 1
fi

# Test 3: Perguntas
echo "3. Verificando perguntas..."
COUNT=$(curl -s http://localhost:3000/api/questions | grep -o '"count":[0-9]*' | cut -d: -f2)
if [ "$COUNT" = "18" ]; then
    echo "✅ 18 perguntas encontradas"
else
    echo "❌ Número incorreto de perguntas: $COUNT"
    exit 1
fi

echo ""
echo "✅ Todos os testes passaram!"
```

Execute:
```bash
chmod +x test.sh
./test.sh
```

## Resultado Esperado Final

Se tudo estiver funcionando:

1. ✅ Aplicação inicia sem erros
2. ✅ Health check retorna OK
3. ✅ Frontend acessível em http://localhost:5173
4. ✅ Backend acessível em http://localhost:3000
5. ✅ Banco de dados populado com perguntas
6. ✅ Formulário funcional com validação
7. ✅ Envio de avaliação funciona
8. ✅ Gráfico de pizza renderiza corretamente
9. ✅ Análise de pontos fortes e fracos funciona
10. ✅ Sistema de classificação funcionando (0-39% = Fraco, 40-59% = Regular, 60-79% = Bom, 80-100% = Forte)

## Próximos Passos

Após confirmar que tudo está funcionando:

1. Compartilhe o link com os usuários
2. Colete avaliações
3. Analise resultados através da API
4. Use os dados para identificar necessidades de treinamento

## Suporte

Se algum teste falhar, consulte:
- [GUIA_USO.md](GUIA_USO.md) - Guia completo de uso
- [API_EXAMPLES.md](API_EXAMPLES.md) - Exemplos de uso da API
- Logs: `docker-compose logs -f`
