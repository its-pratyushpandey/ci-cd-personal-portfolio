Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Portfolio Kubernetes Deployment Verification" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/4] Checking cluster connection..." -ForegroundColor Yellow
$context = kubectl config current-context 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK - Connected to: $context" -ForegroundColor Green
} else {
    Write-Host "  FAIL - Not connected" -ForegroundColor Red
    exit 1
}

Write-Host "[2/4] Checking namespace..." -ForegroundColor Yellow
kubectl get namespace portfolio 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK - Namespace exists" -ForegroundColor Green
} else {
    Write-Host "  FAIL - Namespace not found" -ForegroundColor Red
    exit 1
}

Write-Host "[3/4] Checking pods..." -ForegroundColor Yellow
kubectl get pods -n portfolio

Write-Host "[4/4] Checking frontend..." -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
if ($response.StatusCode -eq 200) {
    Write-Host "  OK - Frontend accessible at http://localhost:8080" -ForegroundColor Green
} else {
    Write-Host "  WARNING - Port forward not active" -ForegroundColor Yellow
    Write-Host "  Run: .\start-portfolio.ps1" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Verification Complete!" -ForegroundColor Green
Write-Host ""
