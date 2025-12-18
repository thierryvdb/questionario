const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Importar rotas
const questionsRoutes = require('./routes/questions');
const assessmentsRoutes = require('./routes/assessments');

// Usar rotas
app.use('/api/questions', questionsRoutes);
app.use('/api/assessments', assessmentsRoutes);

// Rota de health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'API do Questionário Técnico está funcionando',
    timestamp: new Date().toISOString()
  });
});

// Rota raiz
app.get('/', (req, res) => {
  res.json({
    message: 'API do Questionário Técnico',
    endpoints: {
      health: '/api/health',
      questions: '/api/questions',
      assessments: '/api/assessments'
    }
  });
});

// Tratamento de erros 404
app.use((req, res) => {
  res.status(404).json({ error: 'Rota não encontrada' });
});

// Tratamento de erros gerais
app.use((err, req, res, next) => {
  console.error('Erro:', err.stack);
  res.status(500).json({
    error: 'Erro interno do servidor',
    message: err.message
  });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Servidor rodando na porta ${PORT}`);
  console.log(`📍 URL: http://localhost:${PORT}`);
  console.log(`🏥 Health check: http://localhost:${PORT}/api/health\n`);
});
