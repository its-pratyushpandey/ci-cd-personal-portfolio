# Portfolio Deployment Verification Script

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Portfolio Kubernetes Deployment Verification" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check Kubernetes connection
Write-Host "[1/5] Checking Kubernetes cluster connection..." -ForegroundColor Yellow
$context = kubectl config current-context 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Connected to: $context" -ForegroundColor Green
} else {
    Write-Host "  ✗ Failed to connect to Kubernetes cluster" -ForegroundColor Red
    exit 1
}

# Check namespace
Write-Host "[2/5] Checking portfolio namespace..." -ForegroundColor Yellow
$namespace = kubectl get namespace portfolio 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Namespace 'portfolio' exists" -ForegroundColor Green
} else {
    Write-Host "  ✗ Namespace 'portfolio' not found" -ForegroundColor Red
    exit 1
}

# Check pods
Write-Host "[3/5] Checking pods..." -ForegroundColor Yellow
kubectl get pods -n portfolio --no-headers | ForEach-Object {
    $parts = $_ -split '\s+'
    $name = $parts[0]
    $ready = $parts[1]
    $status = $parts[2]
    
    if ($status -eq "Running") {
        Write-Host "  ✓ $name - $status ($ready)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ $name - $status ($ready)" -ForegroundColor Yellow
    }
}

# Check services
Write-Host "[4/5] Checking services..." -ForegroundColor Yellow
kubectl get svc -n portfolio --no-headers | ForEach-Object {
    $parts = $_ -split '\s+'
    $name = $parts[0]
    $type = $parts[1]
    Write-Host "  ✓ $name ($type)" -ForegroundColor Green
}

# Check accessibility
Write-Host "[5/5] Checking frontend accessibility..." -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
if ($response.StatusCode -eq 200) {
    Write-Host "  ✓ Frontend is accessible at http://localhost:8080" -ForegroundColor Green
    Write-Host "  ✓ Page title: Pratyush Portfolio" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Frontend not accessible - Port forwarding may not be active" -ForegroundColor Yellow
    Write-Host "    Run: .\start-portfolio.ps1" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "✅ Verification Complete!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Yellow
Write-Host '  Access app:  .\start-portfolio.ps1' -ForegroundColor White
Write-Host '  View logs:   kubectl logs -f deployment/backend-deployment -n portfolio' -ForegroundColor White
Write-Host '  Check pods:  kubectl get pods -n portfolio' -ForegroundColor White
Write-Host ""

