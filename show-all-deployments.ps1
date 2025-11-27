# Triple Deployment Status Check
# Shows all three deployments: Docker, Kubernetes, and Ansible (WSL)

$WSL_IP = (wsl bash -c "hostname -I" 2>$null).Split()[0]

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "     PORTFOLIO - TRIPLE DEPLOYMENT STATUS" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Docker Deployment
Write-Host "1. DOCKER DEPLOYMENT (Windows - Local Containers)" -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "   Frontend:  http://localhost:8080" -ForegroundColor Green
Write-Host "   Backend:   http://localhost:8070/api/portfolio/health" -ForegroundColor Green
Write-Host ""
Write-Host "   Containers:" -ForegroundColor White
docker ps --format "   - {{.Names}} ({{.Status}})" | Where-Object { $_ -like "*portfolio-*" -and $_ -notlike "*ansible*" }
Write-Host ""

# Kubernetes Deployment
Write-Host "2. KUBERNETES DEPLOYMENT (Kind Cluster)" -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
Write-Host "   Frontend:  http://localhost:9090" -ForegroundColor Green
Write-Host "   (Requires port-forward to be running)" -ForegroundColor Gray
Write-Host ""
Write-Host "   Pods:" -ForegroundColor White
kubectl get pods -n portfolio --no-headers 2>$null | ForEach-Object {
    $parts = $_ -split '\s+'
    Write-Host "   - $($parts[0]) ($($parts[2]))" -ForegroundColor White
}
Write-Host ""

# Ansible Deployment (WSL)
Write-Host "3. ANSIBLE DEPLOYMENT (WSL - Ubuntu)" -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor DarkGray
if ($WSL_IP) {
    Write-Host "   Frontend:  http://${WSL_IP}:3000" -ForegroundColor Green
    Write-Host "   Backend:   http://${WSL_IP}:3070/api/portfolio/health" -ForegroundColor Green
} else {
    Write-Host "   WSL not running or not accessible" -ForegroundColor Red
}
Write-Host ""
Write-Host "   Containers (in WSL):" -ForegroundColor White
wsl bash -c "docker ps --filter 'name=ansible-portfolio-' --format '   - {{.Names}} ({{.Status}})'" 2>$null
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
if ($WSL_IP) {
    Write-Host "Open Ansible Deployment:" -ForegroundColor White
    Write-Host "  Start-Process 'http://${WSL_IP}:3000'" -ForegroundColor Gray
    Write-Host ""
}
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# Health Check
Write-Host "HEALTH CHECK:" -ForegroundColor Cyan
Write-Host ""

# Docker
try {
    $dockerFrontend = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 3
    Write-Host "   [OK] Docker Frontend: HTTP $($dockerFrontend.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Docker Frontend" -ForegroundColor Red
}

try {
    $dockerBackend = Invoke-RestMethod -Uri "http://localhost:8070/api/portfolio/health" -TimeoutSec 3
    Write-Host "   [OK] Docker Backend: $($dockerBackend.status)" -ForegroundColor Green
} catch {
    Write-Host "   [FAIL] Docker Backend" -ForegroundColor Red
}

# Kubernetes
try {
    $k8sFrontend = Invoke-WebRequest -Uri "http://localhost:9090" -TimeoutSec 3
    Write-Host "   [OK] Kubernetes Frontend: HTTP $($k8sFrontend.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "   [WARN] Kubernetes: Port-forward not running" -ForegroundColor Yellow
}

# Ansible (WSL)
if ($WSL_IP) {
    try {
        $ansibleFrontend = Invoke-WebRequest -Uri "http://${WSL_IP}:3000" -TimeoutSec 3
        Write-Host "   [OK] Ansible Frontend: HTTP $($ansibleFrontend.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "   [FAIL] Ansible Frontend" -ForegroundColor Red
    }
    
    try {
        $ansibleBackend = Invoke-RestMethod -Uri "http://${WSL_IP}:3070/api/portfolio/health" -TimeoutSec 3
        Write-Host "   [OK] Ansible Backend: $($ansibleBackend.status)" -ForegroundColor Green
    } catch {
        Write-Host "   [FAIL] Ansible Backend" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
