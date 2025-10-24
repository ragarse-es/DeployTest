@echo off
:: Despliegue rápido de X20Edge Deploy Test
:: Requisitos: Docker y Git instalados

echo Desplegando X20Edge Deploy Test desde GitHub...
echo.

:: Configuración
set TEMP_DIR=%TEMP%\DeployTest-deploy

:: Limpiar y clonar
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
git clone https://github.com/ragarse-es/DeployTest.git "%TEMP_DIR%"

:: Desplegar
cd /d "%TEMP_DIR%"
docker-compose down 2>nul
docker-compose up -d --build

:: Resultado
if errorlevel 1 (
    echo ERROR: Falló el despliegue
    pause
    exit /b 1
) else (
    echo.
    echo ✓ DESPLIEGUE COMPLETADO!
    echo ✓ Aplicación disponible en: http://localhost:3100
    echo ✓ Imagen Docker: deploytest:latest
    echo.
    echo Para parar: cd "%TEMP_DIR%" ^&^& docker-compose down
    start http://localhost:3100
)

pause