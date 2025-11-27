# Stop all port-forward processes for portfolio
Write-Host "Stopping portfolio port forwards..." -ForegroundColor Yellow

# Find and kill kubectl port-forward processes
Get-Process | Where-Object {$_.CommandLine -like "*kubectl*port-forward*portfolio*"} | Stop-Process -Force

Write-Host "Port forwards stopped." -ForegroundColor Green
