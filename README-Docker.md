# X20Edge Deploy Test - Docker

Este proyecto puede ser desplegado directamente desde GitHub usando Docker.

## 🚀 Despliegue Directo desde GitHub

### Opción 1: Script Automatizado (Recomendado)

**Para Windows PowerShell:**
```powershell
# Descargar y ejecutar el script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-from-github.ps1" -OutFile "deploy-from-github.ps1"
.\deploy-from-github.ps1
```

**Para Linux/Mac:**
```bash
# Descargar y ejecutar el script
curl -o deploy-from-github.sh https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-from-github.sh
chmod +x deploy-from-github.sh
./deploy-from-github.sh
```

### Opción 2: Clonando el repositorio manualmente

```bash
# Clonar el repositorio
git clone https://github.com/ragarse-es/DeployTest.git

# Navegar al directorio
cd DeployTest

# Construir y desplegar (con tag personalizado deploytest:latest)
docker-compose up -d --build
```

### Opción 3: Build directo con Docker

```bash
# Construir desde GitHub directamente
docker build -t deploytest:latest https://github.com/ragarse-es/DeployTest.git

# Ejecutar el contenedor
docker run -d -p 3100:3100 --name x20edge-app deploytest:latest
```

## Comandos útiles

```bash
# Ver logs de la aplicación
docker-compose logs -f

# Parar la aplicación
docker-compose down

# Reconstruir la imagen
docker-compose up --build -d

# Ver estado de los contenedores
docker-compose ps
```

## Acceso a la aplicación

Una vez desplegada, la aplicación estará disponible en:
- http://localhost:3100

## Características del despliegue

- **Puerto**: 3100
- **Health Check**: Verificación automática cada 30 segundos
- **Restart Policy**: Se reinicia automáticamente si falla
- **Usuario no-root**: Ejecuta con usuario nodejs para seguridad
- **Imagen optimizada**: Basada en Node.js 18 Alpine (ligera)