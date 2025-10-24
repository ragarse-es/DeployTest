# 🚀 Automatic Deployment - X20Edge Deploy Test

## 📋 Deployment Instructions from Any Device

### Prerequisites

#### For Local Deployment:
- ✅ **Docker Desktop** installed and running
- ✅ **Git** installed
- ✅ Internet Connection

#### For Remote Deployment:
- ✅ **SSH Client** (included in Windows 10+)
- ✅ **Linux Server** with Docker and Git installed
- ✅ **SSH Access** to remote server

### 🎯 Option 1: Complete Automatic Script (Recommended)

**Download and execute directly:**
```cmd
curl -o deploy-auto.bat https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-auto.bat && deploy-auto.bat
```

Or manually:
1. Download: https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-auto.bat
2. Execute the `deploy-auto.bat` file

### 🎯 Option 2: Simple Script
```cmd
curl -o deploy-simple.bat https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-simple.bat && deploy-simple.bat
```

### 🎯 Option 3: Local Manual Commands
```cmd
cd %TEMP%
git clone https://github.com/ragarse-es/DeployTest.git DeployTest-deploy
cd DeployTest-deploy
docker-compose up -d --build
```

## 🖥️ Remote Deployment (SSH to Linux Server)

### 🎯 Option 1: Remote Automatic Script (Recommended)
```cmd
curl -o remote-deploy-auto.bat https://raw.githubusercontent.com/ragarse-es/DeployTest/main/remote-deploy-auto.bat && remote-deploy-auto.bat
```

**Features:**
- ✅ SSH connection from Windows to Linux
- ✅ Complete verifications on remote server
- ✅ Automatic deployment on Linux server
- ✅ Default IP: `10.10.10.207`
- ✅ Default user: `admin`

### 🎯 Option 2: Simple Remote Script
```cmd
curl -o remote-deploy-simple.bat https://raw.githubusercontent.com/ragarse-es/DeployTest/main/remote-deploy-simple.bat && remote-deploy-simple.bat
```

### 🎯 Option 3: Manual Remote Command
```cmd
ssh admin@10.10.10.207 "rm -rf /tmp/deploy-tmp && git clone https://github.com/ragarse-es/DeployTest.git /tmp/deploy-tmp && cd /tmp/deploy-tmp && docker-compose up -d --build"
```

---

## 🎉 Expected Result

### Local Deployment:
- ✅ **Application running** at: http://localhost:3100
- ✅ **Docker image created**: `deploytest:latest`
- ✅ **Container running**: `x20edge-deploytest-app`

### Remote Deployment:
- ✅ **Application running** at: http://[SERVER_IP]:3100
- ✅ **Docker image created** on server: `deploytest:latest`
- ✅ **Container running** on server: `x20edge-deploytest-app`

---

## 🔧 Useful Follow-up Commands

```cmd
# View container status
docker ps

# View application logs
docker logs x20edge-deploytest-app

# Stop the application
docker stop x20edge-deploytest-app

# View Docker images
docker images | findstr deploytest

# Remove everything (container and image)
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