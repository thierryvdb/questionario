# Exemplos de Uso da API

## Base URL
```
http://localhost:3000/api
```

## 1. Health Check

### Request
```bash
GET /api/health
```

### Response
```json
{
  "status": "OK",
  "message": "API do Questionário Técnico está funcionando",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

## 2. Listar Todas as Perguntas

### Request
```bash
GET /api/questions
```

### Response
```json
{
  "success": true,
  "count": 18,
  "data": [
    {
      "id": 1,
      "question_text": "Linux: Como você diagnosticaria...",
      "order_number": 1,
      "category_id": 1,
      "category_name": "Linux & Docker",
      "category_description": "Conhecimentos em sistemas Linux..."
    }
  ]
}
```

## 3. Listar Perguntas por Categoria

### Request
```bash
GET /api/questions/by-category
```

### Response
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Linux & Docker",
      "description": "Conhecimentos em sistemas Linux, containerização...",
      "questions": [
        {
          "id": 1,
          "category_id": 1,
          "question_text": "Linux: Como você diagnosticaria...",
          "order_number": 1
        },
        {
          "id": 2,
          "category_id": 1,
          "question_text": "Docker: Explique a diferença...",
          "order_number": 2
        }
      ]
    }
  ]
}
```

## 4. Criar Nova Avaliação

### Request
```bash
POST /api/assessments
Content-Type: application/json

{
  "user_name": "João Silva",
  "user_email": "joao@exemplo.com",
  "scores": [
    {
      "question_id": 1,
      "score": 4
    },
    {
      "question_id": 2,
      "score": 3
    },
    {
      "question_id": 3,
      "score": 5
    },
    {
      "question_id": 4,
      "score": 2
    },
    {
      "question_id": 5,
      "score": 3
    },
    {
      "question_id": 6,
      "score": 4
    },
    {
      "question_id": 7,
      "score": 5
    },
    {
      "question_id": 8,
      "score": 4
    },
    {
      "question_id": 9,
      "score": 3
    },
    {
      "question_id": 10,
      "score": 2
    },
    {
      "question_id": 11,
      "score": 3
    },
    {
      "question_id": 12,
      "score": 4
    },
    {
      "question_id": 13,
      "score": 5
    },
    {
      "question_id": 14,
      "score": 4
    },
    {
      "question_id": 15,
      "score": 3
    },
    {
      "question_id": 16,
      "score": 4
    },
    {
      "question_id": 17,
      "score": 5
    },
    {
      "question_id": 18,
      "score": 4
    }
  ]
}
```

### Response
```json
{
  "success": true,
  "message": "Avaliação criada com sucesso",
  "data": {
    "assessment_id": 1,
    "analysis": {
      "assessment": {
        "id": 1,
        "user_name": "João Silva",
        "user_email": "joao@exemplo.com",
        "completed_at": "2025-01-15T10:45:00.000Z"
      },
      "summary": {
        "total_questions": 18,
        "total_score": 67,
        "max_possible_score": 90,
        "overall_average": 3.72,
        "overall_percentage": 74.44
      },
      "categories": [
        {
          "category_id": 1,
          "category_name": "Linux & Docker",
          "category_description": "Conhecimentos em sistemas Linux...",
          "total_questions": 3,
          "total_score": 12,
          "average_score": 4.0,
          "max_possible_score": 15,
          "percentage": 80.0,
          "classification": "Ponto Forte"
        },
        {
          "category_id": 2,
          "category_name": "Windows Server & Virtualização",
          "category_description": "Active Directory, VMware/Hyper-V...",
          "total_questions": 3,
          "total_score": 9,
          "average_score": 3.0,
          "max_possible_score": 15,
          "percentage": 60.0,
          "classification": "Bom"
        }
      ],
      "insights": {
        "strong_points": [
          {
            "category_id": 1,
            "category_name": "Linux & Docker",
            "percentage": 80.0
          }
        ],
        "weak_points": [
          {
            "category_id": 4,
            "category_name": "Switches & Protocolos de Comunicação",
            "percentage": 56.67
          }
        ],
        "recommendations": [
          "Recomenda-se estudar mais sobre: Switches & Protocolos de Comunicação (57% de aproveitamento)"
        ]
      }
    }
  }
}
```

## 5. Listar Todas as Avaliações

### Request
```bash
GET /api/assessments
```

### Response
```json
{
  "success": true,
  "count": 3,
  "data": [
    {
      "id": 1,
      "user_name": "João Silva",
      "user_email": "joao@exemplo.com",
      "completed_at": "2025-01-15T10:45:00.000Z",
      "total_questions": 18,
      "average_score": 3.72
    },
    {
      "id": 2,
      "user_name": "Maria Santos",
      "user_email": "maria@exemplo.com",
      "completed_at": "2025-01-15T11:20:00.000Z",
      "total_questions": 18,
      "average_score": 4.22
    }
  ]
}
```

## 6. Obter Análise de Avaliação Específica

### Request
```bash
GET /api/assessments/1/analysis
```

### Response
```json
{
  "success": true,
  "data": {
    "assessment": {
      "id": 1,
      "user_name": "João Silva",
      "user_email": "joao@exemplo.com",
      "completed_at": "2025-01-15T10:45:00.000Z"
    },
    "summary": {
      "total_questions": 18,
      "total_score": 67,
      "max_possible_score": 90,
      "overall_average": 3.72,
      "overall_percentage": 74.44
    },
    "categories": [...],
    "insights": {...}
  }
}
```

## Exemplos com cURL

### Listar perguntas
```bash
curl http://localhost:3000/api/questions/by-category
```

### Criar avaliação
```bash
curl -X POST http://localhost:3000/api/assessments \
  -H "Content-Type: application/json" \
  -d '{
    "user_name": "João Silva",
    "user_email": "joao@exemplo.com",
    "scores": [
      {"question_id": 1, "score": 4},
      {"question_id": 2, "score": 3},
      {"question_id": 3, "score": 5}
    ]
  }'
```

### Buscar análise
```bash
curl http://localhost:3000/api/assessments/1/analysis
```

## Exemplos com JavaScript (Axios)

### Carregar perguntas
```javascript
const axios = require('axios');

async function loadQuestions() {
  try {
    const response = await axios.get('http://localhost:3000/api/questions/by-category');
    console.log('Perguntas:', response.data);
  } catch (error) {
    console.error('Erro:', error.message);
  }
}

loadQuestions();
```

### Enviar avaliação
```javascript
async function submitAssessment() {
  try {
    const response = await axios.post('http://localhost:3000/api/assessments', {
      user_name: 'João Silva',
      user_email: 'joao@exemplo.com',
      scores: [
        { question_id: 1, score: 4 },
        { question_id: 2, score: 3 },
        // ... demais perguntas
      ]
    });

    console.log('Avaliação criada:', response.data);
  } catch (error) {
    console.error('Erro:', error.response?.data || error.message);
  }
}

submitAssessment();
```

## Exemplos com Python (requests)

### Carregar perguntas
```python
import requests

response = requests.get('http://localhost:3000/api/questions/by-category')
data = response.json()

if data['success']:
    for category in data['data']:
        print(f"\n{category['name']}")
        for question in category['questions']:
            print(f"  - {question['question_text'][:50]}...")
```

### Enviar avaliação
```python
import requests

payload = {
    'user_name': 'João Silva',
    'user_email': 'joao@exemplo.com',
    'scores': [
        {'question_id': i, 'score': 4} for i in range(1, 19)
    ]
}

response = requests.post('http://localhost:3000/api/assessments', json=payload)
result = response.json()

if result['success']:
    analysis = result['data']['analysis']
    print(f"Média geral: {analysis['summary']['overall_average']}")
    print(f"Aproveitamento: {analysis['summary']['overall_percentage']}%")
```

## Códigos de Status HTTP

- `200 OK` - Requisição bem-sucedida
- `201 Created` - Recurso criado com sucesso
- `400 Bad Request` - Dados inválidos na requisição
- `404 Not Found` - Recurso não encontrado
- `500 Internal Server Error` - Erro no servidor

## Tratamento de Erros

### Exemplo de erro (400)
```json
{
  "success": false,
  "error": "Scores são obrigatórios e devem ser um array"
}
```

### Exemplo de erro (404)
```json
{
  "success": false,
  "error": "Avaliação não encontrada"
}
```

### Exemplo de erro (500)
```json
{
  "success": false,
  "error": "Erro ao criar avaliação",
  "message": "Connection refused"
}
```
