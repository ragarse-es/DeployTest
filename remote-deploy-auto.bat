@echo off
:: ========================================================================
:: Script de despliegue automático REMOTO de X20Edge Deploy Test desde GitHub
:: Requisitos: SSH client (incluido en Windows 10+), Git y Docker en el servidor remoto
:: Uso: Simplemente ejecutar este archivo .bat
:: ========================================================================

setlocal EnableDelayedExpansion

:: Configuración del servidor remoto
set REMOTE_IP=10.10.10.207
set REMOTE_USER=admin
set REPO_URL=https://github.com/ragarse-es/DeployTest.git
set PROJECT_NAME=DeployTest
set REMOTE_DIR=/tmp/%PROJECT_NAME%-deploy
set APP_PORT=3100

:: Colores para consola (usando echo con códigos ANSI)
echo [92m======================================================[0m
echo [92m  X20Edge Deploy Test - Despliegue Remoto[0m
echo [92m======================================================[0m
echo.

echo [96mConfiguración del servidor remoto:[0m
echo   📍 IP: [97m%REMOTE_IP%[0m
echo   👤 Usuario: [97m%REMOTE_USER%[0m
echo   🚀 Puerto aplicación: [97m%APP_PORT%[0m
echo.

:: Verificar si SSH está disponible
echo [96mVerificando cliente SSH...[0m
ssh -V >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Cliente SSH no está disponible[0m
    echo [93mEn Windows 10+ SSH debería estar incluido. Si no:[0m
    echo [93m1. Habilita OpenSSH Client en Configuración Windows[0m
    echo [93m2. O instala Git Bash que incluye SSH[0m
    pause
    exit /b 1
)
echo [92m✓ Cliente SSH está disponible[0m

:: Verificar conectividad SSH
echo [96mVerificando conectividad SSH al servidor remoto...[0m
echo [93mSe solicitará la contraseña del usuario %REMOTE_USER%[0m
echo.

:: Test de conexión SSH simple
ssh -o ConnectTimeout=10 -o BatchMode=yes %REMOTE_USER%@%REMOTE_IP% "echo 'Conexión SSH exitosa'" >nul 2>&1
if errorlevel 1 (
    echo [93mPrimera conexión o requiere autenticación...[0m
    echo [96mProbando conexión interactiva...[0m
    ssh -o ConnectTimeout=10 %REMOTE_USER%@%REMOTE_IP% "echo 'Conexión SSH exitosa'"
    if errorlevel 1 (
        echo [91mERROR: No se puede conectar al servidor remoto[0m
        echo [93mVerifica:[0m
        echo [93m- IP del servidor: %REMOTE_IP%[0m
        echo [93m- Usuario: %REMOTE_USER%[0m
        echo [93m- Que el servidor SSH esté activo[0m
        echo [93m- Conectividad de red[0m
        pause
        exit /b 1
    )
)
echo [92m✓ Conexión SSH establecida correctamente[0m

echo.
echo [96mIniciando despliegue remoto...[0m
echo.

:: Verificar Docker en el servidor remoto
echo [96mVerificando Docker en el servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker --version" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker no está instalado en el servidor remoto[0m
    echo [93mInstala Docker en el servidor Linux:[0m
    echo [93mcurl -fsSL https://get.docker.com -o get-docker.sh[0m
    echo [93msudo sh get-docker.sh[0m
    pause
    exit /b 1
)
echo [92m✓ Docker está disponible en el servidor remoto[0m

:: Verificar Git en el servidor remoto
echo [96mVerificando Git en el servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "git --version" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Git no está instalado en el servidor remoto[0m
    echo [93mInstala Git en el servidor Linux:[0m
    echo [93msudo apt update ^&^& sudo apt install -y git  # Para Ubuntu/Debian[0m
    echo [93msudo yum install -y git                      # Para CentOS/RHEL[0m
    pause
    exit /b 1
)
echo [92m✓ Git está disponible en el servidor remoto[0m

:: Verificar Docker daemon en el servidor remoto
echo [96mVerificando Docker daemon en el servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker info" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker daemon no está ejecutándose en el servidor remoto[0m
    echo [93mInicia Docker en el servidor:[0m
    echo [93msudo systemctl start docker[0m
    echo [93msudo systemctl enable docker[0m
    pause
    exit /b 1
)
echo [92m✓ Docker daemon está ejecutándose en el servidor remoto[0m

:: Verificar Docker Compose en el servidor remoto
echo [96mVerificando Docker Compose en el servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker-compose --version || docker compose version" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker Compose no está instalado en el servidor remoto[0m
    echo [93mInstala Docker Compose en el servidor:[0m
    echo [93msudo apt install -y docker-compose-plugin  # Para Ubuntu/Debian recientes[0m
    echo [93m# O descarga manualmente desde GitHub[0m
    pause
    exit /b 1
)
echo [92m✓ Docker Compose está disponible en el servidor remoto[0m

:: Limpiar directorio temporal en el servidor remoto
echo [96mLimpiando directorio temporal en servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "rm -rf %REMOTE_DIR%"
echo [92m✓ Directorio temporal limpiado[0m

:: Clonar repositorio en el servidor remoto
echo [96mClonando repositorio en el servidor remoto...[0m
echo Repositorio: %REPO_URL%
echo Destino: %REMOTE_DIR%
echo.
ssh %REMOTE_USER%@%REMOTE_IP% "git clone %REPO_URL% %REMOTE_DIR%"
if errorlevel 1 (
    echo [91mERROR: No se pudo clonar el repositorio en el servidor remoto[0m
    echo [93mVerifica la conectividad del servidor a internet[0m
    pause
    exit /b 1
)
echo [92m✓ Repositorio clonado exitosamente en servidor remoto[0m

:: Verificar que existe docker-compose.yml en el servidor remoto
echo [96mVerificando archivo docker-compose.yml en servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "ls %REMOTE_DIR%/docker-compose.yml" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: No se encontró docker-compose.yml en el repositorio[0m
    pause
    exit /b 1
)
echo [92m✓ Archivo docker-compose.yml encontrado en servidor remoto[0m

:: Parar contenedores previos en el servidor remoto
echo [96mLimpiando contenedores previos en servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose down" 2>nul

:: Construir y desplegar en el servidor remoto
echo.
echo [96m======================================================[0m
echo [96m  Construyendo y desplegando en servidor remoto...[0m
echo [96m======================================================[0m
echo.
ssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose up -d --build"
if errorlevel 1 (
    echo.
    echo [91mERROR: Falló el despliegue con Docker Compose en servidor remoto[0m
    echo [93mRevisa los logs anteriores para más detalles[0m
    pause
    exit /b 1
)

:: Esperar unos segundos para que el contenedor se inicie
echo.
echo [96mEsperando que la aplicación se inicie en servidor remoto...[0m
timeout /t 8 /nobreak >nul

:: Verificar que el contenedor está ejecutándose en el servidor remoto
echo [96mVerificando estado del contenedor en servidor remoto...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker ps --filter 'name=x20edge-deploytest-app' --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
ssh %REMOTE_USER%@%REMOTE_IP% "docker ps --filter 'name=x20edge-deploytest-app'" | findstr "x20edge-deploytest-app" >nul
if errorlevel 1 (
    echo [91mWARNING: El contenedor podría no estar ejecutándose correctamente[0m
    echo [93mVerifica en el servidor con: docker ps[0m
) else (
    echo [92m✓ Contenedor ejecutándose correctamente en servidor remoto[0m
)

:: Mostrar información final
echo.
echo [92m======================================================[0m
echo [92m  ¡DESPLIEGUE REMOTO COMPLETADO EXITOSAMENTE![0m
echo [92m======================================================[0m
echo.
echo [96mInformación de la aplicación:[0m
echo   🌐 URL: [97mhttp://%REMOTE_IP%:%APP_PORT%[0m
echo   🖥️  Servidor: [97m%REMOTE_USER%@%REMOTE_IP%[0m
echo   📁 Directorio remoto: [97m%REMOTE_DIR%[0m
echo   🏷️  Imagen Docker: [97mdeploytest:latest[0m
echo.
echo [96mComandos útiles (ejecutar desde este Windows):[0m
echo   Ver logs:           [97mssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose logs -f"[0m
echo   Parar aplicación:   [97mssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose down"[0m
echo   Reiniciar:          [97mssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose restart"[0m
echo   Ver contenedores:   [97mssh %REMOTE_USER%@%REMOTE_IP% "docker ps"[0m
echo   Acceso SSH:         [97mssh %REMOTE_USER%@%REMOTE_IP%[0m
echo.

:: Preguntar si abrir en navegador
set /p OPEN_BROWSER="¿Abrir la aplicación remota en el navegador? (S/N): "
if /i "!OPEN_BROWSER!"=="S" (
    start http://%REMOTE_IP%:%APP_PORT%
    echo [92m✓ Abriendo navegador con URL remota...[0m
)

echo.
echo [93mNOTA: La aplicación está ejecutándose en el servidor remoto[0m
echo [93mEl directorio temporal se mantendrá en: %REMOTE_DIR%[0m
echo [93mPuedes eliminarlo desde el servidor cuando ya no lo necesites[0m
echo.
echo [96mPresiona cualquier tecla para continuar...[0m
pause >nul