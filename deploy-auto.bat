@echo off
:: ========================================================================
:: Script de despliegue automático de X20Edge Deploy Test desde GitHub
:: Requisitos: Docker y Git instalados
:: Uso: Simplemente ejecutar este archivo .bat
:: ========================================================================

setlocal EnableDelayedExpansion

:: Configuración
set REPO_URL=https://github.com/ragarse-es/DeployTest.git
set PROJECT_NAME=DeployTest
set TEMP_DIR=%TEMP%\%PROJECT_NAME%-deploy
set APP_PORT=3100

:: Colores para consola (usando echo con códigos ANSI)
echo [92m======================================================[0m
echo [92m  X20Edge Deploy Test - Despliegue Automatico[0m
echo [92m======================================================[0m
echo.

:: Verificar si Docker está instalado
echo [96mVerificando Docker...[0m
docker --version >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker no está instalado o no está en el PATH[0m
    echo [93mPor favor instala Docker Desktop desde: https://www.docker.com/products/docker-desktop[0m
    pause
    exit /b 1
)
echo [92m✓ Docker está disponible[0m

:: Verificar si Git está instalado
echo [96mVerificando Git...[0m
git --version >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Git no está instalado o no está en el PATH[0m
    echo [93mPor favor instala Git desde: https://git-scm.com/downloads[0m
    pause
    exit /b 1
)
echo [92m✓ Git está disponible[0m

:: Verificar si Docker daemon está ejecutándose
echo [96mVerificando Docker daemon...[0m
docker info >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker daemon no está ejecutándose[0m
    echo [93mPor favor inicia Docker Desktop[0m
    pause
    exit /b 1
)
echo [92m✓ Docker daemon está ejecutándose[0m

echo.
echo [96mIniciando despliegue...[0m
echo.

:: Limpiar directorio temporal si existe
if exist "%TEMP_DIR%" (
    echo [93mLimpiando directorio temporal existente...[0m
    rmdir /s /q "%TEMP_DIR%" 2>nul
)

:: Crear directorio temporal
mkdir "%TEMP_DIR%" 2>nul

:: Clonar repositorio
echo [96mClonando repositorio desde GitHub...[0m
echo Repositorio: %REPO_URL%
echo Destino: %TEMP_DIR%
echo.
git clone %REPO_URL% "%TEMP_DIR%"
if errorlevel 1 (
    echo [91mERROR: No se pudo clonar el repositorio[0m
    echo [93mVerifica tu conexión a internet y que el repositorio existe[0m
    pause
    exit /b 1
)
echo [92m✓ Repositorio clonado exitosamente[0m

:: Cambiar al directorio del proyecto
cd /d "%TEMP_DIR%"

:: Verificar que existe docker-compose.yml
if not exist "docker-compose.yml" (
    echo [91mERROR: No se encontró docker-compose.yml en el repositorio[0m
    pause
    exit /b 1
)
echo [92m✓ Archivo docker-compose.yml encontrado[0m

:: Parar cualquier contenedor previo (sin mostrar errores)
echo [96mLimpiando contenedores previos (si existen)...[0m
docker-compose down 2>nul

:: Construir y desplegar
echo.
echo [96m======================================================[0m
echo [96m  Construyendo y desplegando la aplicación...[0m
echo [96m======================================================[0m
echo.
docker-compose up -d --build
if errorlevel 1 (
    echo.
    echo [91mERROR: Falló el despliegue con Docker Compose[0m
    echo [93mRevisa los logs anteriores para más detalles[0m
    pause
    exit /b 1
)

:: Esperar unos segundos para que el contenedor se inicie
echo.
echo [96mEsperando que la aplicación se inicie...[0m
timeout /t 5 /nobreak >nul

:: Verificar que el contenedor está ejecutándose
docker ps --filter "name=x20edge-deploytest-app" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | findstr "x20edge-deploytest-app" >nul
if errorlevel 1 (
    echo [91mWARNING: El contenedor podría no estar ejecutándose correctamente[0m
    echo [93mVerifica con: docker ps[0m
) else (
    echo [92m✓ Contenedor ejecutándose correctamente[0m
)

:: Mostrar información final
echo.
echo [92m======================================================[0m
echo [92m  ¡DESPLIEGUE COMPLETADO EXITOSAMENTE![0m
echo [92m======================================================[0m
echo.
echo [96mInformación de la aplicación:[0m
echo   🌐 URL: [97mhttp://localhost:%APP_PORT%[0m
echo   📁 Directorio: %TEMP_DIR%
echo   🏷️  Imagen Docker: [97mdeploytest:latest[0m
echo.
echo [96mComandos útiles:[0m
echo   Ver logs:           [97mcd "%TEMP_DIR%" ^&^& docker-compose logs -f[0m
echo   Parar aplicación:   [97mcd "%TEMP_DIR%" ^&^& docker-compose down[0m
echo   Reiniciar:          [97mcd "%TEMP_DIR%" ^&^& docker-compose restart[0m
echo   Ver contenedores:   [97mdocker ps[0m
echo   Ver imágenes:       [97mdocker images ^| findstr deploytest[0m
echo.

:: Preguntar si abrir en navegador
set /p OPEN_BROWSER="¿Abrir la aplicación en el navegador? (S/N): "
if /i "!OPEN_BROWSER!"=="S" (
    start http://localhost:%APP_PORT%
    echo [92m✓ Abriendo navegador...[0m
)

:: Volver al directorio original
cd /d %~dp0

echo.
echo [93mNOTA: El directorio temporal se mantendrá en:[0m
echo [97m%TEMP_DIR%[0m
echo [93mPuedes eliminarlo manualmente cuando ya no lo necesites[0m
echo.
echo [96mPresiona cualquier tecla para continuar...[0m
pause >nul