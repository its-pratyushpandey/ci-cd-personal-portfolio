# Portfolio Application - Management Script
# Convenient commands to manage your Docker deployment

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('start', 'stop', 'restart', 'status', 'logs', 'health', 'deploy', 'cleanup', 'help')]
    [string]$Action = 'help'
)

$FRONTEND_CONTAINER = "portfolio-frontend"
$BACKEND_CONTAINER = "portfolio-backend"
$MYSQL_CONTAINER = "portfolio-mysql"

function Show-Help {
    Write-Host ""
    Write-Host "Portfolio Application - Management Script" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\manage-portfolio.ps1 <action>" -ForegroundColor White
    Write-Host ""
    Write-Host "Available Actions:" -ForegroundColor Yellow
    Write-Host "  start      - Start all containers" -ForegroundColor White
    Write-Host "  stop       - Stop all containers" -ForegroundColor White
    Write-Host "  restart    - Restart all containers" -ForegroundColor White
    Write-Host "  status     - Show container status" -ForegroundColor White
    Write-Host "  logs       - View container logs" -ForegroundColor White
    Write-Host "  health     - Run health checks" -ForegroundColor White
    Write-Host "  deploy     - Full deployment (with rebuild)" -ForegroundColor White
    Write-Host "  cleanup    - Remove all containers" -ForegroundColor White
    Write-Host "  help       - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\manage-portfolio.ps1 start" -ForegroundColor Gray
    Write-Host "  .\manage-portfolio.ps1 health" -ForegroundColor Gray
    Write-Host "  .\manage-portfolio.ps1 logs" -ForegroundColor Gray
    Write-Host ""
}

function Start-Portfolio {
    Write-Host ""
    Write-Host "🚀 Starting Portfolio Application..." -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Starting MySQL..." -ForegroundColor Yellow
    docker start $MYSQL_CONTAINER
    Start-Sleep -Seconds 10
    
    Write-Host "Starting Backend..." -ForegroundColor Yellow
    docker start $BACKEND_CONTAINER
    Start-Sleep -Seconds 5
    
    Write-Host "Starting Frontend..." -ForegroundColor Yellow
    docker start $FRONTEND_CONTAINER
    Start-Sleep -Seconds 3
    
    Write-Host ""
    Write-Host "✅ Portfolio started!" -ForegroundColor Green
    Write-Host "🌐 Access at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
}

function Stop-Portfolio {
    Write-Host ""
    Write-Host "🛑 Stopping Portfolio Application..." -ForegroundColor Yellow
    Write-Host ""
    
    docker stop $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER
    
    Write-Host ""
    Write-Host "✅ Portfolio stopped!" -ForegroundColor Green
    Write-Host ""
}

function Restart-Portfolio {
    Write-Host ""
    Write-Host "🔄 Restarting Portfolio Application..." -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Restarting MySQL..." -ForegroundColor Yellow
    docker restart $MYSQL_CONTAINER
    Start-Sleep -Seconds 10
    
    Write-Host "Restarting Backend..." -ForegroundColor Yellow
    docker restart $BACKEND_CONTAINER
    Start-Sleep -Seconds 5
    
    Write-Host "Restarting Frontend..." -ForegroundColor Yellow
    docker restart $FRONTEND_CONTAINER
    Start-Sleep -Seconds 3
    
    Write-Host ""
    Write-Host "✅ Portfolio restarted!" -ForegroundColor Green
    Write-Host "🌐 Access at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Status {
    Write-Host ""
    Write-Host "📊 Portfolio Container Status" -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host ""
    
    docker ps --filter "name=portfolio-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    Write-Host ""
}

function Show-Logs {
    Write-Host ""
    Write-Host "📝 Container Logs" -ForegroundColor Cyan
    Write-Host "=================" -ForegroundColor Cyan
    Write-Host ""
    
    $container = Read-Host "Which container? (frontend/backend/mysql/all)"
    
    switch ($container.ToLower()) {
        "frontend" {
            Write-Host ""
            Write-Host "Frontend Logs:" -ForegroundColor Yellow
            docker logs $FRONTEND_CONTAINER --tail 50
        }
        "backend" {
            Write-Host ""
            Write-Host "Backend Logs:" -ForegroundColor Yellow
            docker logs $BACKEND_CONTAINER --tail 50
        }
        "mysql" {
            Write-Host ""
            Write-Host "MySQL Logs:" -ForegroundColor Yellow
            docker logs $MYSQL_CONTAINER --tail 50
        }
        "all" {
            Write-Host ""
            Write-Host "Frontend Logs:" -ForegroundColor Yellow
            docker logs $FRONTEND_CONTAINER --tail 20
            Write-Host ""
            Write-Host "Backend Logs:" -ForegroundColor Yellow
            docker logs $BACKEND_CONTAINER --tail 20
            Write-Host ""
            Write-Host "MySQL Logs:" -ForegroundColor Yellow
            docker logs $MYSQL_CONTAINER --tail 20
        }
        default {
            Write-Host "Invalid choice. Use: frontend, backend, mysql, or all" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

function Test-Health {
    Write-Host ""
    Write-Host "🏥 Health Check" -ForegroundColor Cyan
    Write-Host "===============" -ForegroundColor Cyan
    Write-Host ""
    
    # Backend Health
    try {
        $backendHealth = Invoke-RestMethod -Uri "http://localhost:8070/api/portfolio/health" -TimeoutSec 5
        Write-Host "✅ Backend: $($backendHealth.status) - $($backendHealth.message)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Backend: Not responding" -ForegroundColor Red
    }
    
    # Frontend Health
    try {
        $frontendResponse = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5
        Write-Host "✅ Frontend: HTTP $($frontendResponse.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Frontend: Not responding" -ForegroundColor Red
    }
    
    # MySQL Health
    $mysqlStatus = docker exec $MYSQL_CONTAINER mysqladmin -uroot -p@Pratyush123 ping 2>&1
    if ($mysqlStatus -like "*mysqld is alive*") {
        Write-Host "✅ MySQL: Database is alive" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL: Database issue" -ForegroundColor Red
    }
    
    Write-Host ""
}

function Deploy-Full {
    Write-Host ""
    Write-Host "🚀 Full Deployment (with rebuild)" -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    
    $confirm = Read-Host "This will rebuild images and redeploy. Continue? (y/n)"
    if ($confirm.ToLower() -ne 'y') {
        Write-Host "Deployment cancelled." -ForegroundColor Yellow
        return
    }
    
    # Rebuild Frontend
    Write-Host ""
    Write-Host "📦 Building Frontend Image..." -ForegroundColor Yellow
    Set-Location frontend
    docker build -t pratyushpandey/portfoliofrontend:latest .
    Set-Location ..
    
    # Rebuild Backend
    Write-Host ""
    Write-Host "📦 Building Backend Image..." -ForegroundColor Yellow
    Set-Location backend
    docker build -t pratyushpandey/portfoliobackend:latest .
    Set-Location ..
    
    # Stop and remove containers
    Write-Host ""
    Write-Host "🧹 Cleaning up old containers..." -ForegroundColor Yellow
    docker stop $FRONTEND_CONTAINER $BACKEND_CONTAINER 2>&1 | Out-Null
    docker rm $FRONTEND_CONTAINER $BACKEND_CONTAINER 2>&1 | Out-Null
    
    # Redeploy Backend
    Write-Host ""
    Write-Host "⚙️  Deploying Backend..." -ForegroundColor Yellow
    docker run -d `
        --name $BACKEND_CONTAINER `
        --network portfolio-network `
        -e SPRING_DATASOURCE_URL="jdbc:mysql://${MYSQL_CONTAINER}:3306/portfolio_db?useSSL=false&allowPublicKeyRetrieval=true" `
        -e SPRING_DATASOURCE_USERNAME=root `
        -e SPRING_DATASOURCE_PASSWORD='@Pratyush123' `
        -p 8070:8070 `
        --restart unless-stopped `
        pratyushpandey/portfoliobackend:latest
    
    Start-Sleep -Seconds 10
    
    # Redeploy Frontend
    Write-Host ""
    Write-Host "🌐 Deploying Frontend..." -ForegroundColor Yellow
    docker run -d `
        --name $FRONTEND_CONTAINER `
        --network portfolio-network `
        -p 8080:80 `
        --restart unless-stopped `
        pratyushpandey/portfoliofrontend:latest
    
    Start-Sleep -Seconds 5
    
    Write-Host ""
    Write-Host "✅ Deployment complete!" -ForegroundColor Green
    Write-Host "🌐 Access at: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
}

function Remove-Portfolio {
    Write-Host ""
    Write-Host "🗑️  Cleanup Portfolio" -ForegroundColor Red
    Write-Host "====================" -ForegroundColor Red
    Write-Host ""
    
    $confirm = Read-Host "This will remove ALL containers, network, and data. Continue? (y/n)"
    if ($confirm.ToLower() -ne 'y') {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
        return
    }
    
    Write-Host ""
    Write-Host "Removing containers..." -ForegroundColor Yellow
    docker rm -f $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER 2>&1 | Out-Null
    
    Write-Host "Removing network..." -ForegroundColor Yellow
    docker network rm portfolio-network 2>&1 | Out-Null
    
    $removeVolume = Read-Host "Also remove database volume (data will be lost)? (y/n)"
    if ($removeVolume.ToLower() -eq 'y') {
        Write-Host "Removing volume..." -ForegroundColor Yellow
        docker volume rm portfolio-mysql-data 2>&1 | Out-Null
        Write-Host "✅ Everything removed (including data)" -ForegroundColor Green
    } else {
        Write-Host "✅ Containers removed (data preserved)" -ForegroundColor Green
    }
    
    Write-Host ""
}

# Main execution
switch ($Action) {
    'start'   { Start-Portfolio }
    'stop'    { Stop-Portfolio }
    'restart' { Restart-Portfolio }
    'status'  { Show-Status }
    'logs'    { Show-Logs }
    'health'  { Test-Health }
    'deploy'  { Deploy-Full }
    'cleanup' { Remove-Portfolio }
    'help'    { Show-Help }
    default   { Show-Help }
}
