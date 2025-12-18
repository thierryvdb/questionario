<template>
  <div class="assessments-list">
    <div class="list-header">
      <h2>📋 Histórico de Avaliações</h2>
      <p class="subtitle">Visualize os resultados de todos os candidatos avaliados</p>
    </div>

    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>Carregando avaliações...</p>
    </div>

    <div v-else-if="error" class="error-message">
      <p>❌ {{ error }}</p>
      <button @click="loadAssessments" class="btn btn-retry">Tentar Novamente</button>
    </div>

    <div v-else-if="assessments.length === 0" class="empty-state">
      <div class="empty-icon">📭</div>
      <h3>Nenhuma avaliação encontrada</h3>
      <p>As avaliações realizadas aparecerão aqui.</p>
    </div>

    <div v-else class="assessments-grid">
      <div
        v-for="assessment in assessments"
        :key="assessment.id"
        class="assessment-card"
        @click="viewDetails(assessment.id)"
      >
        <div class="card-header">
          <div class="candidate-info">
            <h3>{{ assessment.user_name }}</h3>
            <p v-if="assessment.user_email" class="email">{{ assessment.user_email }}</p>
          </div>
          <div class="score-badge" :class="getScoreClass(assessment.average_score)">
            {{ assessment.average_score }}
          </div>
        </div>

        <div class="card-body">
          <div class="info-row">
            <span class="label">Data:</span>
            <span class="value">{{ formatDate(assessment.completed_at) }}</span>
          </div>
          <div class="info-row">
            <span class="label">Perguntas:</span>
            <span class="value">{{ assessment.total_questions }}</span>
          </div>
          <div class="info-row">
            <span class="label">Média:</span>
            <span class="value">{{ assessment.average_score }} / 5</span>
          </div>
          <div class="info-row">
            <span class="label">Aproveitamento:</span>
            <span class="value percentage" :class="getPerformanceClass((assessment.average_score / 5) * 100)">
              {{ ((assessment.average_score / 5) * 100).toFixed(1) }}%
            </span>
          </div>
        </div>

        <div class="card-footer">
          <button class="btn-view-details">
            Ver Detalhes Completos →
          </button>
        </div>
      </div>
    </div>

    <!-- Modal com detalhes da avaliação -->
    <div v-if="showDetails" class="modal-overlay" @click.self="closeDetails">
      <div class="modal-content">
        <button class="modal-close" @click="closeDetails">✕</button>

        <div v-if="loadingDetails" class="loading">
          <div class="spinner"></div>
          <p>Carregando detalhes...</p>
        </div>

        <ResultsView
          v-else-if="selectedAnalysis"
          :analysis="selectedAnalysis"
          @restart="closeDetailsAndRefresh"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import ResultsView from './ResultsView.vue'

export default {
  name: 'AssessmentsList',
  components: {
    ResultsView
  },
  emits: ['new-assessment'],
  setup(props, { emit }) {
    const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api'

    const assessments = ref([])
    const loading = ref(true)
    const error = ref(null)
    const showDetails = ref(false)
    const loadingDetails = ref(false)
    const selectedAnalysis = ref(null)

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      return date.toLocaleDateString('pt-BR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    }

    const getScoreClass = (score) => {
      const percentage = (score / 5) * 100
      if (percentage >= 80) return 'excellent'
      if (percentage >= 60) return 'good'
      if (percentage >= 40) return 'regular'
      return 'weak'
    }

    const getPerformanceClass = (percentage) => {
      if (percentage >= 80) return 'excellent'
      if (percentage >= 60) return 'good'
      if (percentage >= 40) return 'regular'
      return 'weak'
    }

    const loadAssessments = async () => {
      loading.value = true
      error.value = null

      try {
        const response = await axios.get(`${API_URL}/assessments`)
        assessments.value = response.data.data
      } catch (err) {
        error.value = 'Erro ao carregar avaliações. Verifique se o servidor está rodando.'
        console.error('Erro:', err)
      } finally {
        loading.value = false
      }
    }

    const viewDetails = async (assessmentId) => {
      showDetails.value = true
      loadingDetails.value = true
      selectedAnalysis.value = null

      try {
        const response = await axios.get(`${API_URL}/assessments/${assessmentId}/analysis`)
        selectedAnalysis.value = response.data.data
      } catch (err) {
        error.value = 'Erro ao carregar detalhes da avaliação.'
        console.error('Erro:', err)
      } finally {
        loadingDetails.value = false
      }
    }

    const closeDetails = () => {
      showDetails.value = false
      selectedAnalysis.value = null
    }

    const closeDetailsAndRefresh = () => {
      closeDetails()
      emit('new-assessment')
    }

    onMounted(() => {
      loadAssessments()
    })

    return {
      assessments,
      loading,
      error,
      showDetails,
      loadingDetails,
      selectedAnalysis,
      formatDate,
      getScoreClass,
      getPerformanceClass,
      loadAssessments,
      viewDetails,
      closeDetails,
      closeDetailsAndRefresh
    }
  }
}
</script>

<style scoped>
.assessments-list {
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

.list-header {
  text-align: center;
  margin-bottom: 30px;
}

.list-header h2 {
  color: #667eea;
  font-size: 2rem;
  margin-bottom: 10px;
}

.subtitle {
  color: #666;
  font-size: 1.1rem;
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

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: #666;
}

.empty-icon {
  font-size: 5rem;
  margin-bottom: 20px;
}

.empty-state h3 {
  font-size: 1.5rem;
  margin-bottom: 10px;
  color: #333;
}

.assessments-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 25px;
}

.assessment-card {
  background: white;
  border-radius: 15px;
  padding: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s;
  border: 2px solid transparent;
}

.assessment-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
  border-color: #667eea;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.candidate-info h3 {
  color: #333;
  font-size: 1.3rem;
  margin-bottom: 5px;
}

.email {
  color: #666;
  font-size: 0.9rem;
}

.score-badge {
  min-width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
}

.score-badge.excellent {
  background: linear-gradient(135deg, #4caf50, #66bb6a);
}

.score-badge.good {
  background: linear-gradient(135deg, #2196f3, #42a5f5);
}

.score-badge.regular {
  background: linear-gradient(135deg, #ff9800, #ffa726);
}

.score-badge.weak {
  background: linear-gradient(135deg, #f44336, #ef5350);
}

.card-body {
  margin-bottom: 20px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}

.info-row:last-child {
  border-bottom: none;
}

.label {
  color: #666;
  font-weight: 500;
}

.value {
  color: #333;
  font-weight: 600;
}

.value.percentage {
  padding: 3px 10px;
  border-radius: 12px;
  font-size: 0.9rem;
}

.value.percentage.excellent {
  background: #e8f5e9;
  color: #2e7d32;
}

.value.percentage.good {
  background: #e3f2fd;
  color: #1565c0;
}

.value.percentage.regular {
  background: #fff3e0;
  color: #e65100;
}

.value.percentage.weak {
  background: #ffebee;
  color: #c62828;
}

.card-footer {
  text-align: center;
}

.btn-view-details {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-view-details:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.btn {
  padding: 12px 30px;
  font-size: 1rem;
  font-weight: bold;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-retry {
  background: #f44336;
  color: white;
  margin-top: 15px;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
  overflow-y: auto;
}

.modal-content {
  background: white;
  border-radius: 15px;
  padding: 30px;
  max-width: 1200px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  position: relative;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
  animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-close {
  position: absolute;
  top: 15px;
  right: 15px;
  background: #f44336;
  color: white;
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;
}

.modal-close:hover {
  background: #d32f2f;
  transform: rotate(90deg);
}

@media (max-width: 768px) {
  .assessments-grid {
    grid-template-columns: 1fr;
  }

  .modal-content {
    padding: 20px;
    max-height: 95vh;
  }

  .modal-close {
    width: 35px;
    height: 35px;
    font-size: 1.2rem;
  }
}
</style>
