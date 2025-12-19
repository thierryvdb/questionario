const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET todas as perguntas com suas categorias
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        q.id,
        q.question_text,
        q.order_number,
        c.id as category_id,
        c.name as category_name,
        c.description as category_description
      FROM questions q
      INNER JOIN categories c ON q.category_id = c.id
      ORDER BY q.order_number
    `);

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows
    });
  } catch (error) {
    console.error('Erro ao buscar perguntas:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar perguntas',
      message: error.message
    });
  }
});

// GET perguntas agrupadas por categoria
router.get('/by-category', async (req, res) => {
  try {
    const limitPerCategory = Number.parseInt(req.query.limit_per_category, 10)
    const questionsPerCategory = Number.isFinite(limitPerCategory) && limitPerCategory > 0
      ? limitPerCategory
      : 3 // 6 por categoria => 36 perguntas no total (6 categorias)

    const shuffleArray = (array) => {
      const arr = [...array]
      for (let i = arr.length - 1; i > 0; i -= 1) {
        const j = Math.floor(Math.random() * (i + 1))
        ;[arr[i], arr[j]] = [arr[j], arr[i]]
      }
      return arr
    }

    const categoriesResult = await pool.query(`
      SELECT id, name, description
      FROM categories
      ORDER BY id
    `);

    const questionsResult = await pool.query(`
      SELECT
        id,
        category_id,
        question_text,
        order_number
      FROM questions
      ORDER BY order_number
    `);

    const categoriesWithQuestions = categoriesResult.rows.map(category => ({
      ...category,
      questions: (() => {
        const list = questionsResult.rows.filter(q => q.category_id === category.id)
        if (list.length <= questionsPerCategory) return list
        return shuffleArray(list).slice(0, questionsPerCategory)
      })()
    }));

    res.json({
      success: true,
      data: categoriesWithQuestions,
      meta: {
        questions_per_category: questionsPerCategory,
        total_questions: categoriesWithQuestions.reduce((sum, cat) => sum + cat.questions.length, 0)
      }
    });
  } catch (error) {
    console.error('Erro ao buscar perguntas por categoria:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar perguntas por categoria',
      message: error.message
    });
  }
});

// GET categorias
router.get('/categories', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT id, name, description
      FROM categories
      ORDER BY id
    `);

    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows
    });
  } catch (error) {
    console.error('Erro ao buscar categorias:', error);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar categorias',
      message: error.message
    });
  }
});

module.exports = router;
