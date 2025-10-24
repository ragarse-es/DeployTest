# Script para desplegar DeployTest directamente desde GitHub en Windows
# Uso: .\deploy-from-github.ps1

Write-Host "🚀 Iniciando despliegue de DeployTest desde GitHub..." -ForegroundColor Green

# Crear directorio temporal si no existe
$TempDir = ".\deploytest-temp"
if (Test-Path $TempDir) {
    Write-Host "📁 Limpiando directorio temporal existente..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $TempDir
}

# Clonar repositorio
Write-Host "📥 Clonando repositorio desde GitHub..." -ForegroundColor Cyan
try {
    git clone https://github.com/ragarse-es/DeployTest.git $TempDir
    Write-Host "✅ Repositorio clonado exitosamente" -ForegroundColor Green
}
catch {
    Write-Host "❌ Error al clonar el repositorio" -ForegroundColor Red
    exit 1
}

# Cambiar al directorio del proyecto
Set-Location $TempDir

# Construir y desplegar con Docker Compose
Write-Host "🔨 Construyendo y desplegando con Docker..." -ForegroundColor Cyan
try {
    docker-compose up -d --build
    Write-Host "✅ Despliegue completado exitosamente!" -ForegroundColor Green
    Write-Host "🌐 La aplicación está disponible en: http://localhost:3100" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "📋 Comandos útiles:" -ForegroundColor Yellow
    Write-Host "   Ver logs:        cd $TempDir; docker-compose logs -f" -ForegroundColor White
    Write-Host "   Parar app:       cd $TempDir; docker-compose down" -ForegroundColor White
    Write-Host "   Ver estado:      docker ps" -ForegroundColor White
    Write-Host "   Ver imágenes:    docker images | findstr deploytest" -ForegroundColor White
}
catch {
    Write-Host "❌ Error durante el despliegue" -ForegroundColor Red
    exit 1
}

# Volver al directorio original
Set-Location ..

Write-Host "🎉 ¡Despliegue desde GitHub completado!" -ForegroundColor Green