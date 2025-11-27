# Dual Deployment Status Check
# Shows status of both Docker and Kubernetes deployments

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "       PORTFOLIO - DUAL DEPLOYMENT STATUS" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Docker Deployment
Write-Host "DOCKER DEPLOYMENT (Local Containers)" -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "   Frontend:  http://localhost:8080" -ForegroundColor Green
Write-Host "   Backend:   http://localhost:8070/api/portfolio/health" -ForegroundColor Green
Write-Host ""
Write-Host "   Containers:" -ForegroundColor White
docker ps --format "   - {{.Names}} ({{.Status}})" --filter "name=portfolio-"
Write-Host ""

# Kubernetes Deployment
Write-Host "KUBERNETES DEPLOYMENT (Kind Cluster)" -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "   Frontend:  http://localhost:9090" -ForegroundColor Green
Write-Host "   (Backend proxied through frontend at /api)" -ForegroundColor Gray
Write-Host ""
Write-Host "   Pods:" -ForegroundColor White
kubectl get pods -n portfolio --no-headers | ForEach-Object {
    $parts = $_ -split '\s+'
    Write-Host "   - $($parts[0]) ($($parts[2]))" -ForegroundColor White
}
Write-Host ""

# Quick Actions
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "QUICK ACTIONS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Open Docker Deployment:" -ForegroundColor White
Write-Host "  Start-Process 'http://localhost:8080'" -ForegroundColor Gray
Write-Host ""
Write-Host "Open Kubernetes Deployment:" -ForegroundColor White
Write-Host "  Start-Process 'http://localhost:9090'" -ForegroundColor Gray
Write-Host ""
Write-Host "Manage Docker:" -ForegroundColor White
Write-Host "  .\manage-portfolio.ps1 status" -ForegroundColor Gray
Write-Host ""
Write-Host "Check Kubernetes:" -ForegroundColor White
Write-Host "  kubectl get all -n portfolio" -ForegroundColor Gray
Write-Host ""
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# Health Check
Write-Host "HEALTH CHECK:" -ForegroundColor Cyan
Write-Host ""

try {
    $dockerFrontend = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 3
    Write-Host "   [OK] Docker Frontend: HTTP $($dockerFrontend.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Docker Frontend: Not responding" -ForegroundColor Red
}

try {
    $dockerBackend = Invoke-RestMethod -Uri "http://localhost:8070/api/portfolio/health" -TimeoutSec 3
    Write-Host "   [OK] Docker Backend: $($dockerBackend.status)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Docker Backend: Not responding" -ForegroundColor Red
}

try {
    $k8sFrontend = Invoke-WebRequest -Uri "http://localhost:9090" -TimeoutSec 3
    Write-Host "   [OK] Kubernetes Frontend: HTTP $($k8sFrontend.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   [WARN] Kubernetes Frontend: Port-forward may not be running" -ForegroundColor Yellow
    Write-Host "          Run: kubectl port-forward -n portfolio service/frontend-service 9090:80" -ForegroundColor Gray
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
