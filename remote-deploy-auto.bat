@echo off
:: ========================================================================
:: REMOTE automatic deployment script for X20Edge Deploy Test from GitHub
:: Requirements: SSH client (included in Windows 10+), Git and Docker on remote server
:: Usage: Simply run this .bat file
:: ========================================================================

setlocal EnableDelayedExpansion

:: Remote server configuration
set REMOTE_IP=10.10.10.207
set REMOTE_USER=admin
set REPO_URL=https://github.com/ragarse-es/DeployTest.git
set PROJECT_NAME=DeployTest
set REMOTE_DIR=/tmp/%PROJECT_NAME%-deploy
set APP_PORT=3100

:: Console colors (using echo with ANSI codes)
echo [92m======================================================[0m
echo [92m  X20Edge Deploy Test - Remote Deployment[0m
echo [92m======================================================[0m
echo.

echo [96mRemote server configuration:[0m
echo   📍 IP: [97m%REMOTE_IP%[0m
echo   👤 User: [97m%REMOTE_USER%[0m
echo   🚀 Application port: [97m%APP_PORT%[0m
echo.

:: Verify if SSH is available
echo [96mVerifying SSH client...[0m
ssh -V >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: SSH client is not available[0m
    echo [93mIn Windows 10+ SSH should be included. If not:[0m
    echo [93m1. Enable OpenSSH Client in Windows Settings[0m
    echo [93m2. Or install Git Bash which includes SSH[0m
    pause
    exit /b 1
)
echo [92m✓ SSH client is available[0m

:: Verify SSH connectivity
echo [96mVerifying SSH connectivity to remote server...[0m
echo [93mPassword for user %REMOTE_USER% will be requested[0m
echo.

:: Simple SSH connection test
ssh -o ConnectTimeout=10 -o BatchMode=yes %REMOTE_USER%@%REMOTE_IP% "echo 'SSH connection successful'" >nul 2>&1
if errorlevel 1 (
    echo [93mFirst connection or requires authentication...[0m
    echo [96mTrying interactive connection...[0m
    ssh -o ConnectTimeout=10 %REMOTE_USER%@%REMOTE_IP% "echo 'SSH connection successful'"
    if errorlevel 1 (
        echo [91mERROR: Cannot connect to remote server[0m
        echo [93mVerify:[0m
        echo [93m- Server IP: %REMOTE_IP%[0m
        echo [93m- User: %REMOTE_USER%[0m
        echo [93m- That SSH server is active[0m
        echo [93m- Network connectivity[0m
        pause
        exit /b 1
    )
)
echo [92m✓ SSH connection established correctly[0m

echo.
echo [96mStarting remote deployment...[0m
echo.

:: Verify Docker on remote server
echo [96mVerifying Docker on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker --version" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker is not installed on remote server[0m
    echo [93mInstall Docker on Linux server:[0m
    echo [93mcurl -fsSL https://get.docker.com -o get-docker.sh[0m
    echo [93msudo sh get-docker.sh[0m
    pause
    exit /b 1
)
echo [92m✓ Docker is available on remote server[0m

:: Verify Git on remote server
echo [96mVerifying Git on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "git --version" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Git is not installed on remote server[0m
    echo [93mInstall Git on Linux server:[0m
    echo [93msudo apt update ^&^& sudo apt install -y git  # For Ubuntu/Debian[0m
    echo [93msudo yum install -y git                      # For CentOS/RHEL[0m
    pause
    exit /b 1
)
echo [92m✓ Git is available on remote server[0m

:: Verify Docker daemon on remote server
echo [96mVerifying Docker daemon on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker info" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker daemon is not running on remote server[0m
    echo [93mStart Docker on server:[0m
    echo [93msudo systemctl start docker[0m
    echo [93msudo systemctl enable docker[0m
    pause
    exit /b 1
)
echo [92m✓ Docker daemon is running on remote server[0m

:: Verify Docker Compose on remote server
echo [96mVerifying Docker Compose on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker-compose --version || docker compose version" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: Docker Compose is not installed on remote server[0m
    echo [93mInstall Docker Compose on server:[0m
    echo [93msudo apt install -y docker-compose-plugin  # For recent Ubuntu/Debian[0m
    echo [93m# Or download manually from GitHub[0m
    pause
    exit /b 1
)
echo [92m✓ Docker Compose is available on remote server[0m

:: Clean temporary directory on remote server
echo [96mCleaning temporary directory on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "rm -rf %REMOTE_DIR%"
echo [92m✓ Temporary directory cleaned[0m

:: Clone repository on remote server
echo [96mCloning repository on remote server...[0m
echo Repository: %REPO_URL%
echo Destination: %REMOTE_DIR%
echo.
ssh %REMOTE_USER%@%REMOTE_IP% "git clone %REPO_URL% %REMOTE_DIR%"
if errorlevel 1 (
    echo [91mERROR: Could not clone repository on remote server[0m
    echo [93mVerify server's internet connectivity[0m
    pause
    exit /b 1
)
echo [92m✓ Repository cloned successfully on remote server[0m

:: Verify docker-compose.yml exists on remote server
echo [96mVerifying docker-compose.yml file on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "ls %REMOTE_DIR%/docker-compose.yml" >nul 2>&1
if errorlevel 1 (
    echo [91mERROR: docker-compose.yml not found in repository[0m
    pause
    exit /b 1
)
echo [92m✓ docker-compose.yml file found on remote server[0m

:: Stop previous containers on remote server
echo [96mCleaning previous containers on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose down" 2>nul

:: Build and deploy on remote server
echo.
echo [96m======================================================[0m
echo [96m  Building and deploying on remote server...[0m
echo [96m======================================================[0m
echo.
ssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose up -d --build"
if errorlevel 1 (
    echo.
    echo [91mERROR: Docker Compose deployment failed on remote server[0m
    echo [93mCheck the logs above for more details[0m
    pause
    exit /b 1
)

:: Wait a few seconds for the container to start
echo.
echo [96mWaiting for application to start on remote server...[0m
timeout /t 8 /nobreak >nul

:: Verify that the container is running on remote server
echo [96mVerifying container status on remote server...[0m
ssh %REMOTE_USER%@%REMOTE_IP% "docker ps --filter 'name=x20edge-deploytest-app' --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
ssh %REMOTE_USER%@%REMOTE_IP% "docker ps --filter 'name=x20edge-deploytest-app'" | findstr "x20edge-deploytest-app" >nul
if errorlevel 1 (
    echo [91mWARNING: Container might not be running correctly[0m
    echo [93mVerify on server with: docker ps[0m
) else (
    echo [92m✓ Container running correctly on remote server[0m
)

:: Show final information
echo.
echo [92m======================================================[0m
echo [92m  REMOTE DEPLOYMENT COMPLETED SUCCESSFULLY![0m
echo [92m======================================================[0m
echo.
echo [96mApplication information:[0m
echo   🌐 URL: [97mhttp://%REMOTE_IP%:%APP_PORT%[0m
echo   🖥️  Server: [97m%REMOTE_USER%@%REMOTE_IP%[0m
echo   📁 Remote directory: [97m%REMOTE_DIR%[0m
echo   🏷️  Docker Image: [97mdeploytest:latest[0m
echo.
echo [96mUseful commands (run from this Windows):[0m
echo   View logs:          [97mssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose logs -f"[0m
echo   Stop application:   [97mssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose down"[0m
echo   Restart:            [97mssh %REMOTE_USER%@%REMOTE_IP% "cd %REMOTE_DIR% && docker-compose restart"[0m
echo   View containers:    [97mssh %REMOTE_USER%@%REMOTE_IP% "docker ps"[0m
echo   SSH access:         [97mssh %REMOTE_USER%@%REMOTE_IP%[0m
echo.

:: Ask if open in browser
set /p OPEN_BROWSER="Open remote application in browser? (Y/N): "
if /i "!OPEN_BROWSER!"=="Y" (
    start http://%REMOTE_IP%:%APP_PORT%
    echo [92m✓ Opening browser with remote URL...[0m
)

echo.
echo [93mNOTE: Application is running on remote server[0m
echo [93mTemporary directory will remain at: %REMOTE_DIR%[0m
echo [93mYou can delete it from the server when no longer needed[0m
echo.
echo [96mPress any key to continue...[0m
pause >nul