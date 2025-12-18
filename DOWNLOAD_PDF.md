# Funcionalidade de Download de Relatório em PDF

## 📥 Visão Geral

A funcionalidade de download de PDF permite exportar o relatório completo de avaliação em formato PDF, incluindo todas as informações da análise.

## ✨ O Que Está Incluído no PDF

O relatório PDF gerado contém:

### 1. **Cabeçalho**
- Título do relatório
- Linha separadora decorativa

### 2. **Informações do Avaliado**
- Nome do candidato
- Email (se fornecido)
- Data e hora da avaliação

### 3. **Resumo Geral**
- Total de perguntas respondidas
- Pontuação total obtida
- Pontuação máxima possível
- Média geral (0-5)
- Percentual de aproveitamento (colorido)

### 4. **Desempenho por Categoria**
Para cada uma das 6 categorias:
- Nome da categoria
- Média de pontos
- Percentual de aproveitamento
- Classificação (Ponto Forte, Bom, Regular, Ponto Fraco)
- **Cores indicativas** do status

### 5. **Pontos Fortes**
- Lista de categorias com ≥80% de aproveitamento
- Percentual de cada categoria
- Cor verde para destaque

### 6. **Pontos a Melhorar**
- Lista de categorias com <60% de aproveitamento
- Percentual de cada categoria
- Cor vermelha para destaque

### 7. **Recomendações**
- Sugestões personalizadas de estudo
- Baseadas nos pontos fracos identificados
- Cor amarela para destaque

### 8. **Rodapé** (em todas as páginas)
- Numeração de páginas
- Texto de identificação do sistema

## 🎨 Características do PDF

### Design
- **Layout profissional** com formatação clara
- **Cores codificadas** para diferentes status:
  - 🟢 Verde: Excelente (≥80%)
  - 🔵 Azul: Bom (60-79%)
  - 🟡 Amarelo: Regular (40-59%)
  - 🔴 Vermelho: Fraco (<40%)
- **Múltiplas páginas** com quebra automática
- **Fonte legível** e hierarquia visual clara

### Formato
- **Tamanho**: A4
- **Orientação**: Retrato (Portrait)
- **Margens**: Padronizadas
- **Encoding**: UTF-8 (suporta caracteres especiais)

### Nome do Arquivo
O arquivo é salvo automaticamente com o formato:
```
Avaliacao_[Nome_do_Candidato]_[Data].pdf
```

**Exemplo:**
```
Avaliacao_Joao_Silva_2025-12-18.pdf
```

## 🚀 Como Usar

### Do Relatório de Resultados

1. Complete uma avaliação
2. Na tela de resultados, role até o final
3. Clique no botão **"📥 Baixar Relatório em PDF"**
4. O PDF será gerado e baixado automaticamente
5. Localize o arquivo na pasta de Downloads do seu navegador

### Da Lista de Avaliações

1. Acesse **"📋 Lista de Avaliações"** no menu
2. Clique em um card de candidato
3. No modal de detalhes, role até o final
4. Clique em **"📥 Baixar Relatório em PDF"**
5. O PDF será gerado e baixado

## 📊 Exemplo de Conteúdo do PDF

```
═══════════════════════════════════════════════════
    Relatório de Avaliação Técnica
═══════════════════════════════════════════════════

Informações do Avaliado:
Nome: João Silva
Email: joao@exemplo.com
Data: 18/12/2025 às 14:30

Resumo Geral:
Total de Perguntas: 18
Pontuação Total: 76 / 90
Média Geral: 4.2 / 5
Aproveitamento: 84% [VERDE]

Desempenho por Categoria:

1. Linux & Docker
   Média: 4.7 / 5
   Aproveitamento: 93.3%
   Status: Ponto Forte [VERDE]

2. Windows Server & Virtualização
   Média: 4.0 / 5
   Aproveitamento: 80.0%
   Status: Ponto Forte [VERDE]

[... continua com todas as categorias]

─────────────────── NOVA PÁGINA ───────────────────

Pontos Fortes: [VERDE]
• Linux & Docker (93%)
• Windows Server & Virtualização (80%)

Pontos a Melhorar: [VERMELHO]
• Switches & Protocolos de Comunicação (57%)

Recomendações: [AMARELO]
• Recomenda-se estudar mais sobre: Switches &
  Protocolos de Comunicação (57% de aproveitamento)

─────────────────────────────────────────────────
        Página 2 de 2
Gerado por Questionário Técnico - Infraestrutura TI
```

## 🔧 Tecnologia Utilizada

### jsPDF
- **Biblioteca**: jsPDF v2.5.1
- **Licença**: MIT
- **Site**: https://github.com/parallax/jsPDF
- **Funcionalidades utilizadas**:
  - Criação de documentos PDF
  - Adição de imagens
  - Múltiplas páginas automáticas
  - Download de arquivos

### html2canvas
- **Biblioteca**: html2canvas v1.4.1
- **Licença**: MIT
- **Site**: https://html2canvas.hertzen.com/
- **Funcionalidades utilizadas**:
  - Captura de elementos HTML como imagem
  - Renderização de gráficos Chart.js
  - Preservação de estilos CSS
  - Alta qualidade (scale: 2)

### Processo de Geração

1. **Oculta botões** da seção de ações temporariamente
2. **Captura todo o elemento** .results-view como imagem usando html2canvas
3. **Restaura botões** após captura
4. **Converte imagem** para formato base64 PNG
5. **Cria documento PDF** com jsPDF
6. **Adiciona imagem** ao PDF (múltiplas páginas se necessário)
7. **Download automático** do arquivo com nome personalizado

## ⚙️ Configuração

### Instalação das Dependências

As bibliotecas jsPDF e html2canvas já estão incluídas no projeto:

```json
// frontend/package.json
{
  "dependencies": {
    "jspdf": "^2.5.1",
    "html2canvas": "^1.4.1"
  }
}
```

### Import no Componente

```javascript
// frontend/src/components/ResultsView.vue
import { jsPDF } from 'jspdf'
import html2canvas from 'html2canvas'
```

## 🎯 Casos de Uso

### 1. Arquivo para o Candidato
- Candidato pode ter uma cópia física/digital
- Serve como comprovante da avaliação
- Pode ser anexado ao portfólio

### 2. Documentação para RH
- Registros permanentes de avaliações
- Comparação entre candidatos
- Arquivo para processos seletivos

### 3. Relatório para Gestores
- Apresentações de desempenho
- Planejamento de treinamentos
- Avaliações de equipe

### 4. Evidências para Auditorias
- Comprovação de avaliações realizadas
- Histórico de conhecimentos técnicos
- Documentação de processos

## 🔍 Solução de Problemas

### PDF não baixa

**Possível causa**: Bloqueador de pop-ups

**Solução**:
1. Verifique se o navegador está bloqueando downloads
2. Permita pop-ups para localhost:5173
3. Tente novamente

### Erro ao gerar PDF

**Possível causa**: Dados incompletos

**Solução**:
1. Verifique se a avaliação está completa
2. Recarregue a página
3. Tente gerar novamente
4. Veja o console do navegador (F12) para detalhes do erro

### Nome do arquivo com caracteres estranhos

**Possível causa**: Nome do candidato com caracteres especiais

**Solução**:
- O sistema já trata automaticamente substituindo espaços por underscores
- Caracteres especiais são mantidos (encoding UTF-8)

### PDF com layout quebrado

**Possível causa**: Conteúdo muito longo

**Solução**:
- O sistema já implementa quebra automática de página
- Se persistir, reporte o problema

## 📝 Personalização

### Modificar Cores

Edite [frontend/src/components/ResultsView.vue](frontend/src/components/ResultsView.vue):

```javascript
// Localizar função downloadPDF

// Modificar cores (RGB)
doc.setTextColor(76, 175, 80)  // Verde
doc.setTextColor(33, 150, 243)  // Azul
doc.setTextColor(255, 193, 7)   // Amarelo
doc.setTextColor(244, 67, 54)   // Vermelho
```

### Adicionar Logo

```javascript
// No início da função downloadPDF
const doc = new jsPDF()

// Adicionar imagem (necessita imagem em base64)
const logoBase64 = 'data:image/png;base64,...'
doc.addImage(logoBase64, 'PNG', 15, 10, 30, 30)
```

### Modificar Tamanho da Fonte

```javascript
// Modificar tamanhos
doc.setFontSize(20)  // Título principal
doc.setFontSize(12)  // Subtítulos
doc.setFontSize(10)  // Texto normal
```

### Adicionar Seções Customizadas

```javascript
// Após as recomendações
yPos += 15
doc.setFontSize(12)
doc.setFont(undefined, 'bold')
doc.text('Observações Adicionais:', 20, yPos)
yPos += 8

doc.setFontSize(10)
doc.setFont(undefined, 'normal')
doc.text('Sua observação personalizada aqui', 20, yPos)
```

## 🧪 Testando

### Teste Básico

1. Faça uma avaliação de teste
2. Ao ver os resultados, clique em "Baixar Relatório em PDF"
3. Verifique se o PDF foi baixado
4. Abra o PDF e confirme:
   - ✅ Título correto
   - ✅ Nome do candidato
   - ✅ Todas as seções presentes
   - ✅ Cores aplicadas corretamente
   - ✅ Numeração de páginas

### Teste com Dados Completos

```bash
# Via API
curl -X POST http://localhost:3000/api/assessments \
  -H "Content-Type: application/json" \
  -d '{
    "user_name": "Teste PDF",
    "user_email": "teste@pdf.com",
    "scores": [
      {"question_id": 1, "score": 5},
      {"question_id": 2, "score": 4},
      ... todas as 18 perguntas
    ]
  }'
```

### Teste com Nome Complexo

- Nome com espaços: "João da Silva Santos"
- Nome com acentos: "José María Fernández"
- Nome com caracteres especiais: "O'Brien-Smith"

## 📊 Comparação: PDF vs Tela

| Recurso | Tela | PDF |
|---------|------|-----|
| Gráfico de Pizza | ✅ Interativo | ✅ Incluído como imagem |
| Resumo Geral | ✅ | ✅ |
| Categorias | ✅ | ✅ |
| Cores | ✅ | ✅ |
| Pontos Fortes | ✅ | ✅ |
| Pontos Fracos | ✅ | ✅ |
| Recomendações | ✅ | ✅ |
| Estilos CSS | ✅ | ✅ Preservados |
| Portabilidade | ❌ | ✅ |
| Impressão | Regular | ✅ Excelente |
| Compartilhamento | ❌ | ✅ |

**Nota:** O PDF agora captura a página inteira de resultados como imagem, incluindo o gráfico de pizza com todas as cores e estilos!

## 🚀 Melhorias Futuras

### Planejado
- [x] ~~Incluir gráfico de pizza no PDF~~ **✅ IMPLEMENTADO!**
- [ ] Adicionar tabela detalhada por pergunta
- [ ] Opção de incluir/excluir seções
- [ ] Template de PDF customizável
- [ ] Exportar múltiplas avaliações em um único PDF
- [ ] Gráfico comparativo entre avaliações
- [ ] Assinatura digital do avaliador
- [ ] Watermark customizável
- [ ] Opção para escolher entre PDF imagem ou PDF texto

### Em Consideração
- [ ] Exportar em outros formatos (DOCX, Excel)
- [ ] Envio automático por email
- [ ] Impressão direta
- [ ] QR Code com link para visualização online

## 📚 Recursos Adicionais

- **jsPDF Documentação**: https://artskydj.github.io/jsPDF/docs/
- **jsPDF Examples**: https://github.com/parallax/jsPDF/tree/master/examples
- **PDF Specification**: https://www.adobe.com/devnet/pdf/pdf_reference.html

## 💡 Dicas

1. **Tamanho do arquivo**: PDFs gerados têm ~50KB em média
2. **Compatibilidade**: Funciona em todos os navegadores modernos
3. **Mobile**: Funciona também em dispositivos móveis
4. **Sem backend**: Geração 100% no cliente (não sobrecarrega servidor)
5. **Offline**: Funciona mesmo sem conexão (após carregar os dados)

## 🎉 Conclusão

A funcionalidade de download de PDF oferece uma maneira profissional e conveniente de exportar relatórios de avaliação, permitindo:

- ✅ Documentação permanente
- ✅ Compartilhamento fácil
- ✅ Impressão de qualidade
- ✅ Arquivo portátil
- ✅ Profissionalismo

---

**Pronto para usar!** Basta reconstruir o container frontend e testar! 🚀
