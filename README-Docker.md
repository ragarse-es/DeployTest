# X20Edge Deploy Test - Docker

Este proyecto puede ser desplegado directamente desde GitHub usando Docker.

## Despliegue Directo desde GitHub

### Opción 1: Usando solo el docker-compose.yml

Puedes desplegar la aplicación directamente desde GitHub con un solo comando:

```bash
# Descargar solo el archivo docker-compose.yml
curl -o docker-compose.yml https://raw.githubusercontent.com/ragarse-es/DeployTest/main/docker-compose.yml

# Desplegar la aplicación
docker-compose up -d
```

### Opción 2: Clonando el repositorio completo

```bash
# Clonar el repositorio
git clone https://github.com/ragarse-es/DeployTest.git

# Navegar al directorio
cd DeployTest

# Construir y desplegar
docker-compose up -d
```

### Opción 3: Build directo sin docker-compose

```bash
# Construir desde GitHub directamente
docker build -t x20edge-deploytest https://github.com/ragarse-es/DeployTest.git

# Ejecutar el contenedor
docker run -d -p 3100:3100 --name x20edge-app x20edge-deploytest
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