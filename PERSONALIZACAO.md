# Guia de Personalização

Este guia mostra como personalizar o questionário para suas necessidades específicas.

## 📝 Personalizando Perguntas

### 1. Adicionar Novas Perguntas

Edite o arquivo [backend/init.sql](backend/init.sql):

```sql
-- Adicionar nova pergunta na categoria 1 (Linux & Docker)
INSERT INTO questions (category_id, question_text, order_number) VALUES
    (1, 'Sua nova pergunta aqui?', 19);
```

**Observações:**
- `category_id`: ID da categoria (1-6)
- `question_text`: Texto da pergunta
- `order_number`: Ordem de exibição (incremental)

### 2. Modificar Perguntas Existentes

Localize a pergunta em `init.sql` e edite o texto:

```sql
-- ANTES
INSERT INTO questions (category_id, question_text, order_number) VALUES
    (1, 'Linux: Como você diagnosticaria...', 1);

-- DEPOIS
INSERT INTO questions (category_id, question_text, order_number) VALUES
    (1, 'Sua pergunta modificada...', 1);
```

### 3. Remover Perguntas

Comente ou remova a linha da pergunta em `init.sql`:

```sql
-- INSERT INTO questions (category_id, question_text, order_number) VALUES
--     (1, 'Pergunta a remover', 1);
```

## 🗂️ Personalizando Categorias

### 1. Adicionar Nova Categoria

Em `backend/init.sql`:

```sql
-- Adicionar nova categoria
INSERT INTO categories (name, description) VALUES
    ('Nova Categoria', 'Descrição da nova categoria');

-- Adicionar perguntas para a nova categoria
INSERT INTO questions (category_id, question_text, order_number) VALUES
    (7, 'Pergunta 1 da nova categoria?', 19),
    (7, 'Pergunta 2 da nova categoria?', 20),
    (7, 'Pergunta 3 da nova categoria?', 21);
```

### 2. Modificar Categorias Existentes

```sql
-- Modificar nome e descrição
INSERT INTO categories (name, description) VALUES
    ('Novo Nome', 'Nova descrição da categoria');
```

### 3. Remover Categoria

**Atenção:** Isso removerá também todas as perguntas associadas!

```sql
-- Comentar ou remover
-- INSERT INTO categories (name, description) VALUES
--     ('Categoria a remover', 'Descrição');
```

## 🎨 Personalizando Cores do Gráfico

### Alterar Cores por Performance

Edite [frontend/src/components/ResultsView.vue](frontend/src/components/ResultsView.vue):

```javascript
// Localizar a função createChart
const backgroundColors = categories.map(c => {
  if (c.percentage >= 80) return 'rgba(76, 175, 80, 0.8)'    // Verde
  if (c.percentage >= 60) return 'rgba(33, 150, 243, 0.8)'   // Azul
  if (c.percentage >= 40) return 'rgba(255, 193, 7, 0.8)'    // Amarelo
  return 'rgba(244, 67, 54, 0.8)'                            // Vermelho
})
```

**Modificar para suas cores:**

```javascript
const backgroundColors = categories.map(c => {
  if (c.percentage >= 80) return 'rgba(46, 204, 113, 0.8)'   // Verde personalizado
  if (c.percentage >= 60) return 'rgba(52, 152, 219, 0.8)'   // Azul personalizado
  if (c.percentage >= 40) return 'rgba(241, 196, 15, 0.8)'   // Amarelo personalizado
  return 'rgba(231, 76, 60, 0.8)'                            // Vermelho personalizado
})
```

### Usar Cores Fixas por Categoria

```javascript
// Cores fixas independente de performance
const fixedColors = [
  'rgba(255, 99, 132, 0.8)',   // Categoria 1
  'rgba(54, 162, 235, 0.8)',   // Categoria 2
  'rgba(255, 206, 86, 0.8)',   // Categoria 3
  'rgba(75, 192, 192, 0.8)',   // Categoria 4
  'rgba(153, 102, 255, 0.8)',  // Categoria 5
  'rgba(255, 159, 64, 0.8)'    // Categoria 6
]

const backgroundColors = categories.map((c, index) => fixedColors[index])
```

## 🎯 Personalizando Critérios de Classificação

### Alterar Limites de Classificação

Edite [backend/routes/assessments.js](backend/routes/assessments.js):

```javascript
// Localizar a função que calcula classificação
if (percentage >= 80) {
  classification = 'Ponto Forte';
} else if (percentage >= 60) {
  classification = 'Bom';
} else if (percentage >= 40) {
  classification = 'Regular';
} else {
  classification = 'Ponto Fraco';
}
```

**Modificar para critérios mais rigorosos:**

```javascript
if (percentage >= 90) {
  classification = 'Excelente';
} else if (percentage >= 75) {
  classification = 'Bom';
} else if (percentage >= 50) {
  classification = 'Regular';
} else {
  classification = 'Precisa Melhorar';
}
```

### Adicionar Mais Níveis

```javascript
if (percentage >= 95) {
  classification = 'Excepcional';
} else if (percentage >= 85) {
  classification = 'Excelente';
} else if (percentage >= 70) {
  classification = 'Bom';
} else if (percentage >= 50) {
  classification = 'Regular';
} else if (percentage >= 30) {
  classification = 'Fraco';
} else {
  classification = 'Muito Fraco';
}
```

**Não esqueça de atualizar o frontend:**

Em [frontend/src/components/ResultsView.vue](frontend/src/components/ResultsView.vue):

```javascript
const getClassificationClass = (classification) => {
  const map = {
    'Excepcional': 'exceptional',
    'Excelente': 'excellent',
    'Bom': 'good',
    'Regular': 'regular',
    'Fraco': 'weak',
    'Muito Fraco': 'very-weak'
  }
  return map[classification] || 'regular'
}
```

E adicione os estilos CSS correspondentes.

## 📊 Alterando Escala de Pontuação

### Mudar de 0-5 para 0-10

**1. Banco de Dados ([backend/init.sql](backend/init.sql)):**

```sql
CREATE TABLE IF NOT EXISTS assessment_scores (
    score INTEGER CHECK (score >= 0 AND score <= 10),  -- Alterar para 10
);
```

**2. Frontend ([frontend/src/App.vue](frontend/src/App.vue)):**

```vue
<button
  v-for="score in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]"  <!-- Adicionar mais botões -->
  :key="score"
  @click="setScore(question.id, score)"
  :class="['score-btn', { active: scores[question.id] === score }]"
>
  {{ score }}
</button>
```

**3. Backend ([backend/routes/assessments.js](backend/routes/assessments.js)):**

```javascript
// Modificar cálculo de percentual
percentage = (parseFloat(cat.average_score) / 10) * 100;  // Dividir por 10

// Modificar cálculo geral
overall_percentage = parseFloat(((parseFloat(totalResult.rows[0].overall_average) / 10) * 100).toFixed(2))
```

## 🌐 Personalizando Interface

### Alterar Título e Descrição

Edite [frontend/index.html](frontend/index.html):

```html
<title>Seu Título Personalizado</title>
```

Edite [frontend/src/App.vue](frontend/src/App.vue):

```vue
<h1>📊 Seu Título Personalizado</h1>
<p>Sua descrição personalizada</p>
```

### Alterar Tema de Cores

Em [frontend/src/App.vue](frontend/src/App.vue), localize:

```css
body {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

**Modificar para suas cores:**

```css
body {
  background: linear-gradient(135deg, #4A90E2 0%, #7B68EE 100%);
}
```

### Alterar Logo/Ícones

Substitua os emojis por ícones ou imagens:

```vue
<!-- ANTES -->
<h1>📊 Questionário Técnico</h1>

<!-- DEPOIS -->
<h1><img src="/logo.png" alt="Logo"> Questionário Técnico</h1>
```

## 🔧 Personalizando Validações

### Tornar Campos Obrigatórios

Em [frontend/src/App.vue](frontend/src/App.vue):

```javascript
const submitAssessment = async () => {
  // Adicionar validação de nome e email
  if (!userName.value || !userEmail.value) {
    alert('Nome e email são obrigatórios!');
    return;
  }

  // ... resto do código
}
```

### Validar Email

```javascript
const isValidEmail = (email) => {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

const submitAssessment = async () => {
  if (!isValidEmail(userEmail.value)) {
    alert('Email inválido!');
    return;
  }
  // ... resto do código
}
```

## 📈 Personalizando Relatórios

### Adicionar Mais Estatísticas

Em [backend/routes/assessments.js](backend/routes/assessments.js):

```javascript
// Adicionar estatísticas personalizadas
const customStats = {
  highest_category: categories.reduce((max, cat) =>
    cat.average_score > max.average_score ? cat : max
  ),
  lowest_category: categories.reduce((min, cat) =>
    cat.average_score < min.average_score ? cat : min
  ),
  variance: calculateVariance(categories),
  // ... mais estatísticas
};
```

### Modificar Recomendações

```javascript
function generateRecommendations(weakPoints) {
  if (weakPoints.length === 0) {
    return ['Parabéns! Excelente desempenho em todas as áreas!'];
  }

  return weakPoints.map(point => {
    // Recomendações personalizadas por categoria
    const recommendations = {
      'Linux & Docker': 'Recomendamos o curso X ou a certificação Y',
      'Windows Server': 'Estude para a certificação MCSA',
      // ... mais recomendações específicas
    };

    return recommendations[point.category_name] ||
           `Recomenda-se estudar mais sobre: ${point.category_name}`;
  });
}
```

## 🔄 Aplicando Alterações

Após fazer qualquer personalização:

### 1. Reconstruir Containers

```bash
docker-compose down -v
docker-compose up --build
```

### 2. Verificar Alterações

- Acesse http://localhost:5173
- Teste o questionário
- Verifique os resultados

### 3. Ver Logs de Erro

```bash
docker-compose logs -f
```

## 📝 Checklist de Personalização

- [ ] Perguntas personalizadas
- [ ] Categorias ajustadas
- [ ] Cores do gráfico modificadas
- [ ] Critérios de classificação ajustados
- [ ] Escala de pontuação alterada (se necessário)
- [ ] Interface personalizada
- [ ] Validações configuradas
- [ ] Relatórios customizados
- [ ] Containers reconstruídos
- [ ] Testes realizados

## 🎨 Exemplos Completos

### Exemplo 1: Questionário de Inglês

```sql
-- Categorias
INSERT INTO categories (name, description) VALUES
    ('Grammar', 'Gramática e estrutura'),
    ('Vocabulary', 'Vocabulário e expressões'),
    ('Listening', 'Compreensão auditiva'),
    ('Reading', 'Compreensão de texto'),
    ('Writing', 'Produção escrita'),
    ('Speaking', 'Conversação');

-- Perguntas
INSERT INTO questions (category_id, question_text, order_number) VALUES
    (1, 'How well do you understand English tenses?', 1),
    (2, 'How extensive is your English vocabulary?', 4),
    -- ... mais perguntas
```

### Exemplo 2: Avaliação de Soft Skills

```sql
-- Categorias
INSERT INTO categories (name, description) VALUES
    ('Communication', 'Habilidades de comunicação'),
    ('Teamwork', 'Trabalho em equipe'),
    ('Leadership', 'Liderança'),
    ('Problem Solving', 'Resolução de problemas'),
    ('Time Management', 'Gestão de tempo'),
    ('Adaptability', 'Adaptabilidade');
```

## 🚨 Avisos Importantes

1. **Backup**: Sempre faça backup antes de modificar arquivos
2. **Testes**: Teste todas as alterações em ambiente de desenvolvimento
3. **Consistência**: Mantenha consistência entre backend e frontend
4. **Validações**: Atualize validações ao mudar escalas ou critérios
5. **Documentação**: Documente suas personalizações

## 📚 Recursos Adicionais

- [Chart.js Documentação](https://www.chartjs.org/docs/latest/)
- [Vue.js Guia](https://vuejs.org/guide/)
- [Express.js Documentação](https://expressjs.com/)
- [PostgreSQL Documentação](https://www.postgresql.org/docs/)

## 💡 Dicas

- Use ferramentas de desenvolvimento do navegador para testar mudanças no frontend
- Use `console.log()` para debug
- Consulte os logs do Docker para debug no backend
- Teste com diferentes conjuntos de dados
- Mantenha uma cópia do `init.sql` original

---

Se precisar de ajuda com personalizações mais avançadas, consulte a [documentação completa](ESTRUTURA_PROJETO.md).
