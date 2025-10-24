#!/bin/bash

# Script para desplegar DeployTest directamente desde GitHub
# Uso: ./deploy-from-github.sh

echo "🚀 Iniciando despliegue de DeployTest desde GitHub..."

# Crear directorio temporal si no existe
TEMP_DIR="./deploytest-temp"
if [ -d "$TEMP_DIR" ]; then
    echo "📁 Limpiando directorio temporal existente..."
    rm -rf "$TEMP_DIR"
fi

# Clonar repositorio
echo "📥 Clonando repositorio desde GitHub..."
git clone https://github.com/ragarse-es/DeployTest.git "$TEMP_DIR"

if [ $? -eq 0 ]; then
    echo "✅ Repositorio clonado exitosamente"
else
    echo "❌ Error al clonar el repositorio"
    exit 1
fi

# Cambiar al directorio del proyecto
cd "$TEMP_DIR"

# Construir y desplegar con Docker Compose
echo "🔨 Construyendo y desplegando con Docker..."
docker-compose up -d --build

if [ $? -eq 0 ]; then
    echo "✅ Despliegue completado exitosamente!"
    echo "🌐 La aplicación está disponible en: http://localhost:3100"
    echo ""
    echo "📋 Comandos útiles:"
    echo "   Ver logs:        cd $TEMP_DIR && docker-compose logs -f"
    echo "   Parar app:       cd $TEMP_DIR && docker-compose down"
    echo "   Ver estado:      docker ps"
    echo "   Ver imágenes:    docker images | grep deploytest"
else
    echo "❌ Error durante el despliegue"
    exit 1
fi

# Volver al directorio original
cd ..

echo "🎉 ¡Despliegue desde GitHub completado!"