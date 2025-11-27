# Portfolio Application - Local Docker Deployment
# This script deploys the portfolio app using Docker (Ansible alternative for Windows)

Write-Host "🚀 Starting Portfolio Application Deployment..." -ForegroundColor Cyan
Write-Host ""

# Configuration
$NETWORK_NAME = "portfolio-network"
$MYSQL_CONTAINER = "portfolio-mysql"
$BACKEND_CONTAINER = "portfolio-backend"
$FRONTEND_CONTAINER = "portfolio-frontend"

$MYSQL_IMAGE = "mysql:8.0"
$BACKEND_IMAGE = "pratyushpandey/portfoliobackend:latest"
$FRONTEND_IMAGE = "pratyushpandey/portfoliofrontend:latest"

$MYSQL_ROOT_PASSWORD = "@Pratyush123"
$MYSQL_DATABASE = "portfolio_db"

# Step 1: Create Docker Network
Write-Host "📡 Step 1/6: Creating Docker network..." -ForegroundColor Yellow
$networkExists = docker network ls --filter name=$NETWORK_NAME -q
if ($networkExists) {
    Write-Host "✅ Network '$NETWORK_NAME' already exists" -ForegroundColor Green
} else {
    docker network create $NETWORK_NAME
    Write-Host "✅ Network '$NETWORK_NAME' created" -ForegroundColor Green
}
Write-Host ""

# Step 2: Stop and remove existing containers
Write-Host "🧹 Step 2/6: Cleaning up existing containers..." -ForegroundColor Yellow
docker stop $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER 2>&1 | Out-Null
docker rm $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER 2>&1 | Out-Null
Write-Host "✅ Cleanup complete" -ForegroundColor Green
Write-Host ""

# Step 3: Deploy MySQL
Write-Host "🗄️  Step 3/6: Deploying MySQL database..." -ForegroundColor Yellow
docker run -d `
    --name $MYSQL_CONTAINER `
    --network $NETWORK_NAME `
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD `
    -e MYSQL_DATABASE=$MYSQL_DATABASE `
    -v portfolio-mysql-data:/var/lib/mysql `
    --restart unless-stopped `
    $MYSQL_IMAGE

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ MySQL container started" -ForegroundColor Green
    Write-Host "⏳ Waiting for MySQL to be ready..." -ForegroundColor Cyan
    Start-Sleep -Seconds 15
} else {
    Write-Host "❌ Failed to start MySQL" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 4: Deploy Backend
Write-Host "⚙️  Step 4/6: Deploying Backend (Spring Boot)..." -ForegroundColor Yellow
docker run -d `
    --name $BACKEND_CONTAINER `
    --network $NETWORK_NAME `
    -e SPRING_DATASOURCE_URL="jdbc:mysql://${MYSQL_CONTAINER}:3306/${MYSQL_DATABASE}?useSSL=false&allowPublicKeyRetrieval=true" `
    -e SPRING_DATASOURCE_USERNAME=root `
    -e SPRING_DATASOURCE_PASSWORD=$MYSQL_ROOT_PASSWORD `
    -p 8070:8070 `
    --restart unless-stopped `
    $BACKEND_IMAGE

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backend container started" -ForegroundColor Green
    Write-Host "⏳ Waiting for backend to be ready..." -ForegroundColor Cyan
    Start-Sleep -Seconds 10
} else {
    Write-Host "❌ Failed to start Backend" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 5: Deploy Frontend
Write-Host "🌐 Step 5/6: Deploying Frontend (React + Nginx)..." -ForegroundColor Yellow
docker run -d `
    --name $FRONTEND_CONTAINER `
    --network $NETWORK_NAME `
    -p 80:80 `
    --restart unless-stopped `
    $FRONTEND_IMAGE

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Frontend container started" -ForegroundColor Green
    Start-Sleep -Seconds 5
} else {
    Write-Host "❌ Failed to start Frontend" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 6: Verify Deployment
Write-Host "🔍 Step 6/6: Verifying deployment..." -ForegroundColor Yellow
Write-Host ""

$runningContainers = docker ps --filter "name=portfolio-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
Write-Host $runningContainers
Write-Host ""

# Health Check
Write-Host "🏥 Health Check:" -ForegroundColor Cyan
Start-Sleep -Seconds 2

try {
    $backendHealth = Invoke-RestMethod -Uri "http://localhost:8070/api/portfolio/health" -TimeoutSec 5
    Write-Host "✅ Backend Health: $($backendHealth.status) - $($backendHealth.message)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Backend health check pending (might need more time)" -ForegroundColor Yellow
}

try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost" -TimeoutSec 5
    Write-Host "✅ Frontend Status: HTTP $($frontendResponse.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Frontend check pending" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✨ Deployment Complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Access your portfolio at:" -ForegroundColor White
Write-Host "   Frontend:  http://localhost" -ForegroundColor Cyan
Write-Host "   Backend:   http://localhost:8070/api/portfolio/health" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Container Management:" -ForegroundColor White
Write-Host "   View logs:    docker logs $FRONTEND_CONTAINER" -ForegroundColor Gray
Write-Host "   Stop all:     docker stop $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER" -ForegroundColor Gray
Write-Host "   Start all:    docker start $MYSQL_CONTAINER $BACKEND_CONTAINER $FRONTEND_CONTAINER" -ForegroundColor Gray
Write-Host "   Remove all:   docker rm -f $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER" -ForegroundColor Gray
Write-Host ""
Write-Host "🎉 Happy coding!" -ForegroundColor Magenta
