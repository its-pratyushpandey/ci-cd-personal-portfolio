# Port Forward to Access Portfolio
Start-Process powershell -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n portfolio service/frontend-service 8080:80"

Write-Host "=====================================" -ForegroundColor Green
Write-Host "Portfolio Frontend Port Forward Started" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Access your portfolio at:" -ForegroundColor Yellow
Write-Host "  http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "A new PowerShell window has opened to maintain the port forward." -ForegroundColor Yellow
Write-Host "Keep that window open while using the application." -ForegroundColor Yellow
Write-Host ""
Write-Host "To stop port forwarding, close the port-forward PowerShell window." -ForegroundColor Gray
Write-Host ""

# Wait a moment for port-forward to start
Start-Sleep -Seconds 3

# Try to open in default browser
Write-Host "Opening browser..." -ForegroundColor Green
Start-Process "http://localhost:8080"
