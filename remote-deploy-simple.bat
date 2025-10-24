@echo off
:: Despliegue remoto rápido de X20Edge Deploy Test
:: Requisitos: SSH client, Git y Docker en servidor Linux

echo Desplegando X20Edge Deploy Test remotamente desde GitHub...
echo.

:: Configuración
set REMOTE_IP=10.10.10.207
set REMOTE_USER=admin
set REMOTE_DIR=/tmp/DeployTest-deploy

echo Servidor: %REMOTE_USER%@%REMOTE_IP%
echo Se solicitará contraseña SSH...
echo.

:: Verificar conexión y desplegar
ssh %REMOTE_USER%@%REMOTE_IP% "rm -rf %REMOTE_DIR% && git clone https://github.com/ragarse-es/DeployTest.git %REMOTE_DIR% && cd %REMOTE_DIR% && docker-compose down 2>/dev/null && docker-compose up -d --build"

if errorlevel 1 (
    echo ERROR: Falló el despliegue remoto
    pause
    exit /b 1
) else (
    echo.
    echo ✓ DESPLIEGUE REMOTO COMPLETADO!
    echo ✓ Aplicación disponible en: http://%REMOTE_IP%:3100
    echo ✓ Imagen Docker: deploytest:latest
    echo.
    echo Para parar: ssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose down"
    start http://%REMOTE_IP%:3100
)

pause