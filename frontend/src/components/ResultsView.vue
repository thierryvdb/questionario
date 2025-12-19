<template>
  <div class="results-view">
    <div class="results-header">
      <h2>🎯 Resultados da Avaliação</h2>
      <div class="user-info" v-if="analysis.assessment.user_name !== 'Anônimo'">
        <p><strong>Avaliado:</strong> {{ analysis.assessment.user_name }}</p>
        <p v-if="analysis.assessment.user_email">
          <strong>Email:</strong> {{ analysis.assessment.user_email }}
        </p>
      </div>
      <p class="completion-date">
        <strong>Data:</strong> {{ formatDate(analysis.assessment.completed_at) }}
      </p>
    </div>

    <div class="summary-card">
      <h3>📊 Resumo Geral</h3>
      <div class="summary-stats">
        <div class="stat-item">
          <span class="stat-label">Total de Perguntas</span>
          <span class="stat-value">{{ analysis.summary.total_questions }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Pontuação Total</span>
          <span class="stat-value">
            {{ analysis.summary.total_score }} / {{ analysis.summary.max_possible_score }}
          </span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Média Geral</span>
          <span class="stat-value">{{ analysis.summary.overall_average }} / 5</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">Aproveitamento</span>
          <span class="stat-value percentage" :class="getPerformanceClass(analysis.summary.overall_percentage)">
            {{ analysis.summary.overall_percentage }}%
          </span>
        </div>
      </div>
    </div>

    <div class="charts-section">
      <div class="chart-container">
        <h3>📈 Desempenho por Categoria</h3>
        <canvas ref="chartCanvas"></canvas>
      </div>
    </div>

    <div class="categories-detail">
      <h3>📋 Detalhamento por Categoria</h3>
      <div class="categories-grid">
        <div
          v-for="category in analysis.categories"
          :key="category.category_id"
          class="category-detail-card"
          :class="getClassificationClass(category.classification)"
        >
          <div class="category-detail-header">
            <h4>{{ category.category_name }}</h4>
            <span class="classification-badge" :class="getClassificationClass(category.classification)">
              {{ category.classification }}
            </span>
          </div>
          <p class="category-description">{{ category.category_description }}</p>

          <div class="category-stats">
            <div class="progress-bar-container">
              <div class="progress-bar" :style="{ width: category.percentage + '%' }"></div>
            </div>
            <div class="category-numbers">
              <span>{{ category.average_score.toFixed(1) }} / 5</span>
              <span class="percentage-text">{{ category.percentage.toFixed(0) }}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="insights-section">
      <div class="insights-grid">
        <div class="insight-card strong-points" v-if="analysis.insights.strong_points.length > 0">
          <h3>✅ Pontos Fortes</h3>
          <ul>
            <li v-for="point in analysis.insights.strong_points" :key="point.category_id">
              <strong>{{ point.category_name }}</strong>
              <span class="insight-percentage">{{ point.percentage.toFixed(0) }}%</span>
            </li>
          </ul>
        </div>

        <div class="insight-card weak-points" v-if="analysis.insights.weak_points.length > 0">
          <h3>⚠️ Pontos a Melhorar</h3>
          <ul>
            <li v-for="point in analysis.insights.weak_points" :key="point.category_id">
              <strong>{{ point.category_name }}</strong>
              <span class="insight-percentage">{{ point.percentage.toFixed(0) }}%</span>
            </li>
          </ul>
        </div>
      </div>

      <div class="recommendations-card" v-if="analysis.insights.recommendations.length > 0">
        <h3>💡 Recomendações</h3>
        <ul>
          <li v-for="(recommendation, index) in analysis.insights.recommendations" :key="index">
            {{ recommendation }}
          </li>
        </ul>
        </div> 
    </div>

    <div class="actions-section">
      <button @click="$emit('restart')" class="btn btn-restart">
        🔄 Fazer Nova Avaliação
      </button>
<!--      <button @click="printReport" class="btn btn-print">
        🖨️ Imprimir/Salvar PDF
      </button> -->
      <button @click="downloadPNG" class="btn btn-download-png">
        🖼️ Download PNG
      </button>
      <button @click="downloadPDF" class="btn btn-download">
        📥 Download PDF
      </button>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue'
import { Chart, registerables } from 'chart.js'
import ChartDataLabels from 'chartjs-plugin-datalabels'
import { jsPDF } from 'jspdf'
import html2canvas from 'html2canvas'

Chart.register(...registerables, ChartDataLabels)

export default {
  name: 'ResultsView',
  props: {
    analysis: {
      type: Object,
      required: true
    }
  },
  emits: ['restart'],
  setup(props) {
    const chartCanvas = ref(null)
    let chartInstance = null

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

    const getPerformanceClass = (percentage) => {
      if (percentage >= 80) return 'excellent'
      if (percentage >= 60) return 'good'
      if (percentage >= 40) return 'regular'
      return 'weak'
    }

    const getClassificationClass = (classification) => {
      const map = {
        'Ponto Forte': 'strong',
        'Bom': 'good',
        'Regular': 'regular',
        'Ponto Fraco': 'weak'
      }
      return map[classification] || 'regular'
    }

    const createChart = () => {
      if (!chartCanvas.value) return

      if (chartInstance) {
        chartInstance.destroy()
      }

      const ctx = chartCanvas.value.getContext('2d')

      const categories = props.analysis.categories
      const labels = categories.map(c => c.category_name)
      const data = categories.map(c => c.percentage)

      // Cores fixas e distintas para cada categoria (6 cores)
      const fixedColors = [
        { bg: 'rgba(76, 175, 80, 0.8)', border: 'rgba(76, 175, 80, 1)' },      // Verde - Linux & Docker
        { bg: 'rgba(33, 150, 243, 0.8)', border: 'rgba(33, 150, 243, 1)' },    // Azul - Windows Server
        { bg: 'rgba(255, 152, 0, 0.8)', border: 'rgba(255, 152, 0, 1)' },      // Laranja - Backups & Dell
        { bg: 'rgba(156, 39, 176, 0.8)', border: 'rgba(156, 39, 176, 1)' },    // Roxo - Switches & Protocolos
        { bg: 'rgba(244, 67, 54, 0.8)', border: 'rgba(244, 67, 54, 1)' },      // Vermelho - VoIP & Firewall
        { bg: 'rgba(255, 193, 7, 0.8)', border: 'rgba(255, 193, 7, 1)' }       // Amarelo - Gestão de Chamados
      ]

      const backgroundColors = categories.map((c, index) => fixedColors[index].bg)
      const borderColors = categories.map((c, index) => fixedColors[index].border)

      chartInstance = new Chart(ctx, {
        type: 'pie',
        data: {
          labels: labels,
          datasets: [{
            label: 'Aproveitamento (%)',
            data: data,
            backgroundColor: backgroundColors,
            borderColor: borderColors,
            borderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: true,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                padding: 15,
                font: {
                  size: 12
                }
              }
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  const label = context.label || ''
                  const value = context.parsed || 0
                  const category = categories[context.dataIndex]
                  return [
                    `${label}`,
                    `Aproveitamento: ${value.toFixed(1)}%`,
                    `Média: ${category.average_score.toFixed(1)} / 5`,
                    `Status: ${category.classification}`
                  ]
                }
              }
            },
            datalabels: {
              color: '#fff',
              font: {
                weight: 'bold',
                size: 14
              },
              formatter: (value, ctx) => {
                return value.toFixed(1) + '%'
              }
            }
          }
        }
      })
    }

    const downloadPDF = async () => {
      try {
        // Capturar o elemento inteiro dos resultados
        const element = document.querySelector('.results-view')
        if (!element) {
          alert('Erro: Elemento não encontrado')
          return
        }

        // Ocultar botões antes de capturar
        const actionsSection = element.querySelector('.actions-section')
        const originalDisplay = actionsSection ? actionsSection.style.display : null
        if (actionsSection) {
          actionsSection.style.display = 'none'
        }

        // Aguardar renderização
        await new Promise(resolve => setTimeout(resolve, 300))

        // Capturar usando html2canvas com opções simplificadas
        const canvas = await html2canvas(element, {
          scale: 2,
          backgroundColor: '#ffffff',
          logging: false,
          useCORS: false,
          allowTaint: true
        })

        // Restaurar botões
        if (actionsSection) {
          actionsSection.style.display = originalDisplay || 'flex'
        }

        console.log('PDF Canvas dimensions:', canvas.width, 'x', canvas.height)

        // Criar PDF com a imagem capturada
        const imgData = canvas.toDataURL('image/png')
        const imgWidth = 210 // A4 width in mm
        const imgHeight = (canvas.height * imgWidth) / canvas.width

        const doc = new jsPDF('p', 'mm', 'a4')
        const pageHeight = doc.internal.pageSize.getHeight()

        // Adicionar imagem ao PDF, dividindo em múltiplas páginas se necessário
        if (imgHeight > pageHeight) {
          // Multi-página: imagem é maior que uma página
          let heightLeft = imgHeight
          let position = 0

          // Primeira página
          doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight)
          heightLeft -= pageHeight

          // Páginas adicionais
          while (heightLeft > 0) {
            position = heightLeft - imgHeight
            doc.addPage()
            doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight)
            heightLeft -= pageHeight
          }
        } else {
          // Página única: imagem cabe em uma página
          doc.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight)
        }

        // Salvar PDF com nome personalizado
        const fileName = `Avaliacao_${props.analysis.assessment.user_name.replace(/\s+/g, '_')}_${new Date().toISOString().split('T')[0]}.pdf`
        doc.save(fileName)
      } catch (error) {
        console.error('Erro ao gerar PDF:', error)
        alert('Erro ao gerar PDF. Por favor, tente novamente.')
      }
    }

    const printReport = () => {
      // Ocultar botões temporariamente
      const actionsSection = document.querySelector('.actions-section')
      if (actionsSection) {
        actionsSection.style.display = 'none'
      }

      // Aguardar um pouco e abrir dialog de impressão
      setTimeout(() => {
        window.print()

        // Restaurar botões após fechar dialog
        setTimeout(() => {
          if (actionsSection) {
            actionsSection.style.display = 'flex'
          }
        }, 100)
      }, 100)
    }

    const downloadPNG = async () => {
      try {
        // Capturar o elemento inteiro dos resultados
        const element = document.querySelector('.results-view')
        if (!element) {
          alert('Erro: Elemento não encontrado')
          return
        }

        // Ocultar botões antes de capturar
        const actionsSection = element.querySelector('.actions-section')
        const originalDisplay = actionsSection ? actionsSection.style.display : null
        if (actionsSection) {
          actionsSection.style.display = 'none'
        }

        // Aguardar renderização
        await new Promise(resolve => setTimeout(resolve, 300))

        // Capturar usando html2canvas com opções simplificadas
        const canvas = await html2canvas(element, {
          scale: 2,
          backgroundColor: '#ffffff',
          logging: false,
          useCORS: false,
          allowTaint: true
        })

        // Restaurar botões
        if (actionsSection) {
          actionsSection.style.display = originalDisplay || 'flex'
        }

        // Verificar se o canvas foi criado corretamente
        console.log('Canvas dimensions:', canvas.width, 'x', canvas.height)

        // Converter canvas para blob PNG
        canvas.toBlob((blob) => {
          if (!blob) {
            alert('Erro ao gerar imagem. Tente usar o botão de impressão do navegador (Ctrl+P) como alternativa.')
            return
          }

          console.log('Blob size:', blob.size, 'bytes')

          // Criar link de download
          const url = URL.createObjectURL(blob)
          const link = document.createElement('a')
          const fileName = `Avaliacao_${props.analysis.assessment.user_name.replace(/\s+/g, '_')}_${new Date().toISOString().split('T')[0]}.png`

          link.href = url
          link.download = fileName
          document.body.appendChild(link)
          link.click()

          // Limpar
          setTimeout(() => {
            document.body.removeChild(link)
            URL.revokeObjectURL(url)
          }, 100)
        }, 'image/png', 1.0)

      } catch (error) {
        console.error('Erro ao gerar PNG:', error)
        alert('Erro ao gerar PNG: ' + error.message + '\n\nTente usar Ctrl+P (Imprimir) e salvar como PDF como alternativa.')
      }
    }

    onMounted(() => {
      createChart()
    })

    watch(() => props.analysis, () => {
      createChart()
    }, { deep: true })

    return {
      chartCanvas,
      formatDate,
      getPerformanceClass,
      getClassificationClass,
      downloadPDF,
      downloadPNG,
      printReport
    }
  }
}
</script>

<style scoped>
.results-view {
  background-color: #fff;
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

.results-header {
  text-align: center;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 3px solid #667eea;
}

.results-header h2 {
  color: #667eea;
  font-size: 2rem;
  margin-bottom: 15px;
}

.user-info {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  margin: 15px 0;
}

.user-info p {
  margin: 5px 0;
  color: #555;
}

.completion-date {
  color: #666;
  font-size: 0.95rem;
}

.summary-card {
  background: #667eea;
  color: white;
  padding: 30px;
  border-radius: 15px;
  margin-bottom: 30px;
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
}

.summary-card h3 {
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.summary-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
}

.stat-label {
  font-size: 0.9rem;
  opacity: 0.9;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 1.8rem;
  font-weight: bold;
}

.stat-value.percentage.excellent {
  color: #4caf50;
  text-shadow: 0 0 10px rgba(76, 175, 80, 0.5);
}

.stat-value.percentage.good {
  color: #2196f3;
}

.stat-value.percentage.regular {
  color: #ffc107;
}

.stat-value.percentage.weak {
  color: #f44336;
}

.charts-section {
  margin-bottom: 30px;
}

.chart-container {
  background: white;
  padding: 30px;
  border-radius: 15px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  max-width: 500px;
  margin: 0 auto;
}

.chart-container h3 {
  color: #333;
  margin-bottom: 20px;
  text-align: center;
}

.chart-container canvas {
  max-width: 100%;
  height: auto !important;
}

.categories-detail {
  margin-bottom: 30px;
}

.categories-detail h3 {
  color: #333;
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.category-detail-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  border-left: 5px solid #ddd;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;
}

.category-detail-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
}

.category-detail-card.strong {
  border-left-color: #4caf50;
}

.category-detail-card.good {
  border-left-color: #2196f3;
}

.category-detail-card.regular {
  border-left-color: #ffc107;
}

.category-detail-card.weak {
  border-left-color: #f44336;
}

.category-detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.category-detail-header h4 {
  color: #333;
  font-size: 1.1rem;
}

.classification-badge {
  padding: 5px 12px;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: bold;
}

.classification-badge.strong {
  background: #4caf50;
  color: white;
}

.classification-badge.good {
  background: #2196f3;
  color: white;
}

.classification-badge.regular {
  background: #ffc107;
  color: #333;
}

.classification-badge.weak {
  background: #f44336;
  color: white;
}

.category-description {
  color: #666;
  font-size: 0.9rem;
  margin-bottom: 15px;
}

.category-stats {
  margin-top: 15px;
}

.progress-bar-container {
  width: 100%;
  height: 10px;
  background: #e0e0e0;
  border-radius: 5px;
  overflow: hidden;
  margin-bottom: 10px;
}

.progress-bar {
  height: 100%;
  background: #667eea;
  transition: width 0.5s ease;
}

.category-numbers {
  display: flex;
  justify-content: space-between;
  font-weight: bold;
  color: #333;
}

.percentage-text {
  color: #667eea;
}

.insights-section {
  margin-bottom: 30px;
}

.insights-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.insight-card {
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.insight-card h3 {
  margin-bottom: 15px;
  font-size: 1.3rem;
}

.insight-card ul {
  list-style: none;
}

.insight-card li {
  padding: 10px;
  margin-bottom: 10px;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.strong-points {
  background: #c8e6c9;
  color: #2e7d32;
}

.weak-points {
  background: linear-gradient(135deg, #ffcdd2 0%, #ef9a9a 100%);
  color: #c62828;
}

.insight-percentage {
  font-weight: bold;
  font-size: 1.1rem;
}

.recommendations-card {
  background: linear-gradient(135deg, #fff9c4 0%, #fff59d 100%);
  padding: 25px;
  border-radius: 12px;
  border-left: 5px solid #fbc02d;
}

.recommendations-card h3 {
  color: #f57f17;
  margin-bottom: 15px;
  font-size: 1.3rem;
}

.recommendations-card ul {
  list-style: none;
}

.recommendations-card li {
  padding: 10px;
  margin-bottom: 10px;
  background: white;
  border-radius: 8px;
  color: #555;
}

.actions-section {
  display: flex;
  gap: 15px;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 30px;
  padding-top: 30px;
  border-top: 2px solid #e0e0e0;
}

.btn {
  padding: 15px 30px;
  font-size: 1rem;
  font-weight: bold;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-restart {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-restart:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.btn-print {
  background: #ff9800;
  color: white;
}

.btn-print:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 152, 0, 0.4);
}

.btn-download-png {
  background: #2196f3;
  color: white;
}

.btn-download-png:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
}

.btn-download {
  background: #4caf50;
  color: white;
}

.btn-download:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
}

@media (max-width: 768px) {
  .summary-stats {
    grid-template-columns: 1fr;
  }

  .categories-grid,
  .insights-grid {
    grid-template-columns: 1fr;
  }

  .actions-section {
    flex-direction: column;
  }

  .btn {
    width: 100%;
  }
}

/* Estilos para impressão */
@media print {
  * {
    -webkit-print-color-adjust: exact !important;
    print-color-adjust: exact !important;
  }

  .actions-section {
    display: none !important;
  }

  .results-view {
    background: white !important;
    padding: 20px !important;
  }

  .results-header,
  .summary-card,
  .charts-section,
  .categories-detail,
  .insights-section {
    page-break-inside: avoid !important;
    break-inside: avoid !important;
  }

  .chart-container,
  .category-detail-card,
  .insight-card,
  .recommendations-card {
    page-break-inside: avoid !important;
    break-inside: avoid !important;
    margin-bottom: 15px !important;
  }

  .summary-card {
    background: #667eea !important;
    -webkit-print-color-adjust: exact !important;
  }

  /* Garantir que cores de fundo sejam impressas */
  .strong-points {
    background: #c8e6c9 !important;
  }

  .weak-points {
    background: #ffcdd2 !important;
  }

  .recommendations-card {
    background: #fff9c4 !important;
  }
}
</style>
