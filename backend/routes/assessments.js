const express = require('express');
const router = express.Router();
const pool = require('../db');

// POST criar nova avaliação
router.post('/', async (req, res) => {
  const client = await pool.connect();

  try {
    const { user_name, user_email, scores } = req.body;

    if (!scores || !Array.isArray(scores) || scores.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Scores são obrigatórios e devem ser um array'
      });
    }

    await client.query('BEGIN');

    // Inserir avaliação
    const assessmentResult = await client.query(
      'INSERT INTO assessments (user_name, user_email) VALUES ($1, $2) RETURNING id',
      [user_name || 'Anônimo', user_email || null]
    );

    const assessmentId = assessmentResult.rows[0].id;

    // Inserir scores
    for (const scoreData of scores) {
      await client.query(
        'INSERT INTO assessment_scores (assessment_id, question_id, score) VALUES ($1, $2, $3)',
        [assessmentId, scoreData.question_id, scoreData.score]
      );
    }

    await client.query('COMMIT');

    // Buscar análise completa
    const analysis = await getAssessmentAnalysis(assessmentId);

    res.status(201).json({
      success: true,
      message: 'Avaliação criada com sucesso',
      data: {
        assessment_id: assessmentId,
        analysis
      }
    });

  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Erro ao criar avaliação:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao criar avaliação',
      message: error.message
    });
  } finally {
    client.release();
  }
});

// GET análise de uma avaliação específica
router.get('/:id/analysis', async (req, res) => {
  try {
    const { id } = req.params;
    const analysis = await getAssessmentAnalysis(id);

    if (!analysis) {
      return res.status(404).json({
        success: false,
        error: 'Avaliação não encontrada'
      });
    }

    res.json({
      success: true,
      data: analysis
    });

  } catch (error) {
    console.error('Erro ao buscar análise:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar análise',
      message: error.message
    });
  }
});

// GET todas as avaliações
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        a.id,
        a.user_name,
        a.user_email,
        a.completed_at,
        COUNT(s.id) as total_questions,
        ROUND(AVG(s.score), 2) as average_score
      FROM assessments a
      LEFT JOIN assessment_scores s ON a.id = s.assessment_id
      GROUP BY a.id
      ORDER BY a.completed_at DESC
    `);

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows
    });

  } catch (error) {
    console.error('Erro ao buscar avaliações:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar avaliações',
      message: error.message
    });
  }
});

// Função auxiliar para calcular análise
async function getAssessmentAnalysis(assessmentId) {
  const client = await pool.connect();

  try {
    // Buscar informações da avaliação
    const assessmentInfo = await client.query(
      'SELECT id, user_name, user_email, completed_at FROM assessments WHERE id = $1',
      [assessmentId]
    );

    if (assessmentInfo.rows.length === 0) {
      return null;
    }

    // Buscar scores agrupados por categoria
    const categoryScores = await client.query(`
      SELECT
        c.id as category_id,
        c.name as category_name,
        c.description as category_description,
        COUNT(s.id) as total_questions,
        SUM(s.score) as total_score,
        ROUND(AVG(s.score), 2) as average_score,
        MAX(s.score) as max_score,
        MIN(s.score) as min_score
      FROM categories c
      INNER JOIN questions q ON c.id = q.category_id
      INNER JOIN assessment_scores s ON q.id = s.question_id
      WHERE s.assessment_id = $1
      GROUP BY c.id, c.name, c.description
      ORDER BY c.id
    `, [assessmentId]);

    // Calcular score total
    const totalResult = await client.query(`
      SELECT
        COUNT(s.id) as total_questions,
        SUM(s.score) as total_score,
        ROUND(AVG(s.score), 2) as overall_average
      FROM assessment_scores s
      WHERE s.assessment_id = $1
    `, [assessmentId]);

    const categories = categoryScores.rows.map(cat => {
      const percentage = (parseFloat(cat.average_score) / 5) * 100;
      let classification;

      if (percentage >= 80) {
        classification = 'Ponto Forte';
      } else if (percentage >= 60) {
        classification = 'Bom';
      } else if (percentage >= 40) {
        classification = 'Regular';
      } else {
        classification = 'Ponto Fraco';
      }

      return {
        category_id: cat.category_id,
        category_name: cat.category_name,
        category_description: cat.category_description,
        total_questions: parseInt(cat.total_questions),
        total_score: parseInt(cat.total_score),
        average_score: parseFloat(cat.average_score),
        max_possible_score: parseInt(cat.total_questions) * 5,
        percentage: parseFloat(percentage.toFixed(2)),
        classification
      };
    });

    // Separar pontos fortes e fracos
    const strongPoints = categories.filter(c => c.percentage >= 80);
    const weakPoints = categories.filter(c => c.percentage < 60);

    return {
      assessment: assessmentInfo.rows[0],
      summary: {
        total_questions: parseInt(totalResult.rows[0].total_questions),
        total_score: parseInt(totalResult.rows[0].total_score),
        max_possible_score: parseInt(totalResult.rows[0].total_questions) * 5,
        overall_average: parseFloat(totalResult.rows[0].overall_average),
        overall_percentage: parseFloat(((parseFloat(totalResult.rows[0].overall_average) / 5) * 100).toFixed(2))
      },
      categories,
      insights: {
        strong_points: strongPoints,
        weak_points: weakPoints,
        recommendations: generateRecommendations(weakPoints)
      }
    };

  } finally {
    client.release();
  }
}

// Função para gerar recomendações
function generateRecommendations(weakPoints) {
  if (weakPoints.length === 0) {
    return ['Excelente desempenho geral! Continue aprimorando seus conhecimentos.'];
  }

  return weakPoints.map(point =>
    `Recomenda-se estudar mais sobre: ${point.category_name} (${point.percentage.toFixed(0)}% de aproveitamento)`
  );
}

module.exports = router;
