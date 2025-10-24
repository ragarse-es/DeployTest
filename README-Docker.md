# X20Edge Deploy Test - Docker

This project can be deployed directly from GitHub using Docker.

## 🚀 Direct Deployment from GitHub

### Option 1: Automated Script (Recommended)

**For Windows PowerShell:**
```powershell
# Download and execute the script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-from-github.ps1" -OutFile "deploy-from-github.ps1"
.\deploy-from-github.ps1
```

**For Linux/Mac:**
```bash
# Download and execute the script
curl -o deploy-from-github.sh https://raw.githubusercontent.com/ragarse-es/DeployTest/main/deploy-from-github.sh
chmod +x deploy-from-github.sh
./deploy-from-github.sh
```

### Option 2: Manual repository cloning

```bash
# Clone the repository
git clone https://github.com/ragarse-es/DeployTest.git

# Navigate to directory
cd DeployTest

# Build and deploy (with custom tag deploytest:latest)
docker-compose up -d --build
```

### Option 3: Direct Docker build

```bash
# Build directly from GitHub
docker build -t deploytest:latest https://github.com/ragarse-es/DeployTest.git

# Run the container
docker run -d -p 3100:3100 --name x20edge-app deploytest:latest
```

## Useful Commands

```bash
# View application logs
docker-compose logs -f

# Stop the application
docker-compose down

# Rebuild the image
docker-compose up --build -d

# View container status
docker-compose ps
```

## Application Access

Once deployed, the application will be available at:
- http://localhost:3100

## Deployment Features

- **Port**: 3100
- **Health Check**: Automatic verification every 30 seconds
- **Restart Policy**: Automatically restarts if it fails
- **Non-root User**: Runs with nodejs user for security
- **Optimized Image**: Based on Node.js 18 Alpine (lightweight)