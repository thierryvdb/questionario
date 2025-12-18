<template>
  <div class="app-container">
    <header class="app-header">
      <h1>📊 Questionário Técnico - Infraestrutura TI</h1>
      <p>Avalie seus conhecimentos técnicos em 6 áreas essenciais</p>

      <!-- Menu de Navegação -->
      <nav class="main-nav">
        <button
          @click="currentView = 'questionnaire'"
          :class="['nav-btn', { active: currentView === 'questionnaire' }]"
        >
          📝 Novo Questionário
        </button>
        <button
          @click="currentView = 'list'"
          :class="['nav-btn', { active: currentView === 'list' }]"
        >
          📋 Lista de Avaliações
        </button>
      </nav>
    </header>

    <main class="app-main">
      <!-- Lista de Avaliações -->
      <div v-if="currentView === 'list'" class="list-container">
        <AssessmentsList @new-assessment="goToNewAssessment" />
      </div>

      <!-- Questionário -->
      <div v-else-if="currentView === 'questionnaire' && !showResults" class="questionnaire-container">
        <div class="user-info-section">
          <h2>Informações do Avaliado</h2>
          <div class="form-group">
            <label>Nome (opcional):</label>
            <input
              v-model="userName"
              type="text"
              placeholder="Digite seu nome"
              class="input-field"
            />
          </div>
          <div class="form-group">
            <label>Email (opcional):</label>
            <input
              v-model="userEmail"
              type="email"
              placeholder="seuemail@exemplo.com"
              class="input-field"
            />
          </div>
        </div>

        <div v-if="loading" class="loading">
          <div class="spinner"></div>
          <p>Carregando perguntas...</p>
        </div>

        <div v-else-if="error" class="error-message">
          <p>❌ {{ error }}</p>
          <button @click="loadQuestions" class="btn btn-retry">Tentar Novamente</button>
        </div>

        <div v-else class="categories-list">
          <div
            v-for="category in categories"
            :key="category.id"
            class="category-card"
          >
            <div class="category-header">
              <h3>{{ category.name }}</h3>
              <p class="category-description">{{ category.description }}</p>
            </div>

            <div class="questions-list">
              <div
                v-for="question in category.questions"
                :key="question.id"
                class="question-item"
              >
                <p class="question-text">{{ question.question_text }}</p>

                <div class="score-selector">
                  <label>Nota (0-5):</label>
                  <div class="score-buttons">
                    <button
                      v-for="score in [0, 1, 2, 3, 4, 5]"
                      :key="score"
                      @click="setScore(question.id, score)"
                      :class="['score-btn', { active: scores[question.id] === score }]"
                    >
                      {{ score }}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!loading && categories.length > 0" class="submit-section">
          <div v-if="!allQuestionsAnswered" class="warning-message">
            ⚠️ Por favor, responda todas as perguntas antes de enviar
          </div>
          <button
            @click="submitAssessment"
            :disabled="!allQuestionsAnswered || submitting"
            class="btn btn-submit"
          >
            {{ submitting ? 'Enviando...' : 'Enviar Avaliação' }}
          </button>
        </div>
      </div>

      <!-- Resultados -->
      <div v-else-if="currentView === 'questionnaire' && showResults" class="results-container">
        <ResultsView :analysis="analysisData" @restart="restartQuestionnaire" />
      </div>
    </main>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import ResultsView from './components/ResultsView.vue'
import AssessmentsList from './components/AssessmentsList.vue'

export default {
  name: 'App',
  components: {
    ResultsView,
    AssessmentsList
  },
  setup() {
    const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api'

    const currentView = ref('questionnaire')
    const categories = ref([])
    const scores = ref({})
    const userName = ref('')
    const userEmail = ref('')
    const loading = ref(true)
    const error = ref(null)
    const submitting = ref(false)
    const showResults = ref(false)
    const analysisData = ref(null)

    const allQuestionsAnswered = computed(() => {
      const totalQuestions = categories.value.reduce(
        (sum, cat) => sum + cat.questions.length,
        0
      )
      return Object.keys(scores.value).length === totalQuestions
    })

    const loadQuestions = async () => {
      loading.value = true
      error.value = null

      try {
        const response = await axios.get(`${API_URL}/questions/by-category`)
        categories.value = response.data.data
      } catch (err) {
        error.value = 'Erro ao carregar perguntas. Verifique se o servidor está rodando.'
        console.error('Erro:', err)
      } finally {
        loading.value = false
      }
    }

    const setScore = (questionId, score) => {
      scores.value[questionId] = score
    }

    const submitAssessment = async () => {
      if (!allQuestionsAnswered.value) return

      submitting.value = true

      try {
        const scoresArray = Object.entries(scores.value).map(([question_id, score]) => ({
          question_id: parseInt(question_id),
          score
        }))

        const response = await axios.post(`${API_URL}/assessments`, {
          user_name: userName.value || 'Anônimo',
          user_email: userEmail.value || null,
          scores: scoresArray
        })

        analysisData.value = response.data.data.analysis
        showResults.value = true

      } catch (err) {
        alert('Erro ao enviar avaliação: ' + (err.response?.data?.message || err.message))
        console.error('Erro:', err)
      } finally {
        submitting.value = false
      }
    }

    const restartQuestionnaire = () => {
      showResults.value = false
      analysisData.value = null
      scores.value = {}
      userName.value = ''
      userEmail.value = ''
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }

    const goToNewAssessment = () => {
      currentView.value = 'questionnaire'
      restartQuestionnaire()
    }

    onMounted(() => {
      loadQuestions()
    })

    return {
      currentView,
      categories,
      scores,
      userName,
      userEmail,
      loading,
      error,
      submitting,
      showResults,
      analysisData,
      allQuestionsAnswered,
      loadQuestions,
      setScore,
      submitAssessment,
      restartQuestionnaire,
      goToNewAssessment
    }
  }
}
</script>

<style scoped>
.app-container {
  max-width: 1200px;
  margin: 0 auto;
}

.app-header {
  text-align: center;
  color: white;
  margin-bottom: 30px;
}

.app-header h1 {
  font-size: 2.5rem;
  margin-bottom: 10px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.app-header p {
  font-size: 1.2rem;
  opacity: 0.9;
  margin-bottom: 20px;
}

/* Menu de Navegação */
.main-nav {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 25px;
}

.nav-btn {
  padding: 12px 30px;
  font-size: 1rem;
  font-weight: bold;
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.nav-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
  transform: translateY(-2px);
}

.nav-btn.active {
  background: white;
  color: #667eea;
  border-color: white;
  box-shadow: 0 4px 15px rgba(255, 255, 255, 0.3);
}

.app-main {
  background: white;
  border-radius: 15px;
  padding: 30px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.user-info-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 10px;
  margin-bottom: 30px;
}

.user-info-section h2 {
  color: #333;
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  color: #555;
  font-weight: 500;
}

.input-field {
  width: 100%;
  padding: 12px;
  border: 2px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.input-field:focus {
  outline: none;
  border-color: #667eea;
}

.loading {
  text-align: center;
  padding: 60px 20px;
}

.spinner {
  width: 50px;
  height: 50px;
  margin: 0 auto 20px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-message {
  text-align: center;
  padding: 40px 20px;
  color: #d32f2f;
}

.category-card {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 25px;
  margin-bottom: 25px;
  border: 2px solid #e0e0e0;
}

.category-header h3 {
  color: #667eea;
  font-size: 1.5rem;
  margin-bottom: 10px;
}

.category-description {
  color: #666;
  font-size: 0.95rem;
  margin-bottom: 20px;
}

.questions-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.question-item {
  background: white;
  padding: 20px;
  border-radius: 10px;
  border-left: 4px solid #667eea;
}

.question-text {
  color: #333;
  margin-bottom: 15px;
  line-height: 1.6;
  font-size: 1rem;
}

.score-selector label {
  display: block;
  margin-bottom: 10px;
  color: #555;
  font-weight: 600;
}

.score-buttons {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.score-btn {
  min-width: 50px;
  height: 50px;
  border: 2px solid #ddd;
  background: white;
  border-radius: 8px;
  font-size: 1.2rem;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
}

.score-btn:hover {
  transform: translateY(-2px);
  border-color: #667eea;
}

.score-btn.active {
  background: #667eea;
  color: white;
  border-color: #667eea;
}

.submit-section {
  margin-top: 30px;
  text-align: center;
}

.warning-message {
  background: #fff3cd;
  border: 1px solid #ffc107;
  color: #856404;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.btn {
  padding: 15px 40px;
  font-size: 1.1rem;
  font-weight: bold;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-submit {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-submit:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.btn-submit:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-retry {
  background: #f44336;
  color: white;
  margin-top: 15px;
}

/* Lista de Avaliações */
.list-container {
  animation: fadeIn 0.5s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .app-header h1 {
    font-size: 1.8rem;
  }

  .app-main {
    padding: 20px;
  }

  .score-buttons {
    justify-content: center;
  }

  .main-nav {
    flex-direction: column;
    gap: 10px;
  }

  .nav-btn {
    width: 100%;
  }
}
</style>
