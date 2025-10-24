@echo off
:: ========================================================================
:: Automatic deployment script for X20Edge Deploy Test from GitHub
:: Requirements: Docker and Git installed
:: Usage: Simply run this .bat file
:: ========================================================================

setlocal EnableDelayedExpansion

:: Configuration
set REPO_URL=https://github.com/ragarse-es/DeployTest.git
set PROJECT_NAME=DeployTest
set TEMP_DIR=%TEMP%\%PROJECT_NAME%-deploy
set APP_PORT=3100

:: Console colors (using echo with ANSI codes)
echo [92m======================================================[0m
echo [92m  X20Edge Deploy Test - Automatic Deployment[0m
echo [92m======================================================[0m
echo.

:: Verify if Docker is installed
echo [96mVerifying Docker...[0m
docker --version >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker is not installed or not in PATH[0m
    echo [93mPlease install Docker Desktop from: https://www.docker.com/products/docker-desktop[0m
    pause
    exit /b 1
)
echo [92m✓ Docker is available[0m

:: Verify if Git is installed
echo [96mVerifying Git...[0m
git --version >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Git is not installed or not in PATH[0m
    echo [93mPlease install Git from: https://git-scm.com/downloads[0m
    pause
    exit /b 1
)
echo [92m✓ Git is available[0m

:: Verify if Docker daemon is running
echo [96mVerifying Docker daemon...[0m
docker info >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker daemon is not running[0m
    echo [93mPlease start Docker Desktop[0m
    pause
    exit /b 1
)
echo [92m✓ Docker daemon is running[0m

echo.
echo [96mStarting deployment...[0m
echo.

:: Clean temporary directory if it exists
if exist "%TEMP_DIR%" (
    echo [93mCleaning existing temporary directory...[0m
    rmdir /s /q "%TEMP_DIR%" 2>nul
)

:: Create temporary directory
mkdir "%TEMP_DIR%" 2>nul

:: Clone repository
echo [96mCloning repository from GitHub...[0m
echo Repository: %REPO_URL%
echo Destination: %TEMP_DIR%
echo.
git clone %REPO_URL% "%TEMP_DIR%"
if errorlevel 1 (
    echo [91mERROR: Could not clone repository[0m
    echo [93mVerify your internet connection and that the repository exists[0m
    pause
    exit /b 1
)
echo [92m✓ Repository cloned successfully[0m

:: Change to project directory
cd /d "%TEMP_DIR%"

:: Verify docker-compose.yml exists
if not exist "docker-compose.yml" (
    echo [91mERROR: docker-compose.yml not found in repository[0m
    pause
    exit /b 1
)
echo [92m✓ docker-compose.yml file found[0m

:: Stop any previous containers (without showing errors)
echo [96mCleaning previous containers (if any)...[0m
docker-compose down 2>nul

:: Build and deploy
echo.
echo [96m======================================================[0m
echo [96m  Building and deploying application...[0m
echo [96m======================================================[0m
echo.
docker-compose up -d --build
if errorlevel 1 (
    echo.
    echo [91mERROR: Docker Compose deployment failed[0m
    echo [93mCheck the logs above for more details[0m
    pause
    exit /b 1
)

:: Wait a few seconds for the container to start
echo.
echo [96mWaiting for application to start...[0m
timeout /t 5 /nobreak >nul

:: Verify that the container is running
docker ps --filter "name=x20edge-deploytest-app" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | findstr "x20edge-deploytest-app" >nul
if errorlevel 1 (
    echo [91mWARNING: Container might not be running correctly[0m
    echo [93mVerify with: docker ps[0m
) else (
    echo [92m✓ Container running correctly[0m
)

:: Show final information
echo.
echo [92m======================================================[0m
echo [92m  DEPLOYMENT COMPLETED SUCCESSFULLY![0m
echo [92m======================================================[0m
echo.
echo [96mApplication information:[0m
echo   🌐 URL: [97mhttp://localhost:%APP_PORT%[0m
echo   📁 Directory: %TEMP_DIR%
echo   🏷️  Docker Image: [97mdeploytest:latest[0m
echo.
echo [96mUseful commands:[0m
echo   View logs:          [97mcd "%TEMP_DIR%" ^&^& docker-compose logs -f[0m
echo   Stop application:   [97mcd "%TEMP_DIR%" ^&^& docker-compose down[0m
echo   Restart:            [97mcd "%TEMP_DIR%" ^&^& docker-compose restart[0m
echo   View containers:    [97mdocker ps[0m
echo   View images:        [97mdocker images ^| findstr deploytest[0m
echo.

:: Ask if open in browser
set /p OPEN_BROWSER="Open application in browser? (Y/N): "
if /i "!OPEN_BROWSER!"=="Y" (
    start http://localhost:%APP_PORT%
    echo [92m✓ Opening browser...[0m
)

:: Return to original directory
cd /d %~dp0

echo.
echo [93mNOTE: Temporary directory will remain at:[0m
echo [97m%TEMP_DIR%[0m
echo [93mYou can delete it manually when no longer needed[0m
echo.
echo [96mPress any key to continue...[0m
pause >nul