@echo off
echo ==================================
echo Iniciando Sistema de Questionario
echo ==================================
echo.

REM Verificar se Docker esta instalado
where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo X Docker nao esta instalado!
    echo Por favor, instale o Docker: https://docs.docker.com/get-docker/
    pause
    exit /b 1
)

where docker-compose >nul 2>nul
if %errorlevel% neq 0 (
    echo X Docker Compose nao esta instalado!
    echo Por favor, instale o Docker Compose: https://docs.docker.com/compose/install/
    pause
    exit /b 1
)

echo OK Docker instalado
echo OK Docker Compose instalado
echo.

REM Parar containers existentes
echo Parando containers existentes...
docker-compose down 2>nul

echo.
echo Iniciando containers...
docker-compose up --build -d

echo.
echo Aguardando servicos iniciarem...
timeout /t 10 /nobreak >nul

echo.
echo ==================================
echo OK Sistema iniciado com sucesso!
echo ==================================
echo.
echo Acesse a aplicacao em:
echo    Frontend: http://localhost:5173
echo    Backend API: http://localhost:3000/api
echo    PostgreSQL: localhost:5432
echo.
echo Para ver os logs:
echo    docker-compose logs -f
echo.
echo Para parar:
echo    docker-compose down
echo.
pause
