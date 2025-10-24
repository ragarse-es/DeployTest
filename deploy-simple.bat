@echo off
:: Quick deployment of X20Edge Deploy Test
:: Requirements: Docker and Git installed

echo Deploying X20Edge Deploy Test from GitHub...
echo.

:: Configuration
set TEMP_DIR=%TEMP%\DeployTest-deploy

:: Clean and clone
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
git clone https://github.com/ragarse-es/DeployTest.git "%TEMP_DIR%"

:: Deploy
cd /d "%TEMP_DIR%"
docker-compose down 2>nul
docker-compose up -d --build

:: Result
if errorlevel 1 (
    echo ERROR: Deployment failed
    pause
    exit /b 1
) else (
    echo.
    echo ✓ DEPLOYMENT COMPLETED!
    echo ✓ Application available at: http://localhost:3100
    echo ✓ Docker Image: deploytest:latest
    echo.
    echo To stop: cd "%TEMP_DIR%" ^&^& docker-compose down
    start http://localhost:3100
)

pause