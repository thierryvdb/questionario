#!/bin/bash

echo "=================================="
echo "Iniciando Sistema de Questionário"
echo "=================================="
echo ""

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado!"
    echo "Por favor, instale o Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado!"
    echo "Por favor, instale o Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker instalado"
echo "✓ Docker Compose instalado"
echo ""

# Parar containers existentes
echo "📦 Parando containers existentes..."
docker-compose down 2>/dev/null

echo ""
echo "🚀 Iniciando containers..."
docker-compose up --build -d

echo ""
echo "⏳ Aguardando serviços iniciarem..."
sleep 10

echo ""
echo "=================================="
echo "✅ Sistema iniciado com sucesso!"
echo "=================================="
echo ""
echo "🌐 Acesse a aplicação em:"
echo "   Frontend: http://localhost:5173"
echo "   Backend API: http://localhost:3000/api"
echo "   PostgreSQL: localhost:5432"
echo ""
echo "📊 Para ver os logs:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 Para parar:"
echo "   docker-compose down"
echo ""
