# 🚀 Despliegue Automático - X20Edge Deploy Test

## 📋 Instrucciones para Despliegue desde Cualquier Dispositivo

### Requisitos Previos
- ✅ **Docker Desktop** instalado y ejecutándose
- ✅ **Git** instalado
- ✅ Conexión a Internet

### 🎯 Opción 1: Script Automático Completo (Recomendado)

**Descarga y ejecuta directamente:**
```cmd
curl -o deploy-auto.bat https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-auto.bat && deploy-auto.bat
```

O manualmente:
1. Descargar: https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-auto.bat
2. Ejecutar el archivo `deploy-auto.bat`

### 🎯 Opción 2: Script Simple
```cmd
curl -o deploy-simple.bat https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-simple.bat && deploy-simple.bat
```

### 🎯 Opción 3: Comandos Manuales
```cmd
cd %TEMP%
git clone https://github.com/ragarse-es/DeployTest.git DeployTest-deploy
cd DeployTest-deploy
docker-compose up -d --build
```

---

## 🎉 Resultado Esperado

Después de ejecutar cualquiera de las opciones:

- ✅ **Aplicación funcionando** en: http://localhost:3100
- ✅ **Imagen Docker creada**: `deploytest:latest`
- ✅ **Contenedor ejecutándose**: `x20edge-deploytest-app`

---

## 🔧 Comandos Útiles Posteriores

```cmd
# Ver estado de contenedores
docker ps

# Ver logs de la aplicación
docker logs x20edge-deploytest-app

# Parar la aplicación
docker stop x20edge-deploytest-app

# Ver imágenes Docker
docker images | findstr deploytest

# Eliminar todo (contenedor e imagen)
docker rm -f x20edge-deploytest-app
docker rmi deploytest:latest
```

---

## ⚡ Despliegue Ultra-Rápido (Una línea)

Para dispositivos con Git y Docker ya configurados:

```cmd
git clone https://github.com/ragarse-es/DeployTest.git %TEMP%\deploy-tmp && cd %TEMP%\deploy-tmp && docker-compose up -d --build && echo Aplicación disponible en: http://localhost:3100 && start http://localhost:3100
```

---

## 🆘 Solución de Problemas

### Docker no encontrado
```cmd
# Verificar instalación
docker --version
# Si falla, descargar de: https://www.docker.com/products/docker-desktop
```

### Git no encontrado
```cmd
# Verificar instalación
git --version
# Si falla, descargar de: https://git-scm.com/downloads
```

### Puerto 3100 ocupado
```cmd
# Ver qué está usando el puerto
netstat -an | findstr :3100
# Cambiar puerto en docker-compose.yml: "3101:3100"
```

---

## 📱 Compatibilidad

- ✅ **Windows 10/11**
- ✅ **Windows Server 2019/2022**
- ⚠️ **Requiere PowerShell o CMD**
- ⚠️ **Requiere permisos de administrador** (para Docker)