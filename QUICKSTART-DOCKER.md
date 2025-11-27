# Quick Start - Portfolio Application

## 🚀 Start Portfolio (All Services)

```powershell
# Start all containers in correct order
docker start portfolio-mysql
Start-Sleep -Seconds 10
docker start portfolio-backend
Start-Sleep -Seconds 5
docker start portfolio-frontend

# Open in browser
Start-Process "http://localhost:8080"
```

## 🛑 Stop Portfolio

```powershell
docker stop portfolio-frontend portfolio-backend portfolio-mysql
```

## 🔄 Restart Portfolio

```powershell
docker restart portfolio-mysql
Start-Sleep -Seconds 10
docker restart portfolio-backend
Start-Sleep -Seconds 5
docker restart portfolio-frontend
```

## 📊 Check Status

```powershell
docker ps --filter "name=portfolio-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

## 🏥 Health Check

```powershell
# Backend
Invoke-RestMethod -Uri "http://localhost:8070/api/portfolio/health"

# Frontend
Invoke-WebRequest -Uri "http://localhost:8080" | Select-Object StatusCode
```

## 📝 View Logs

```powershell
# All logs
docker logs portfolio-backend --tail 50

# Follow logs (live)
docker logs -f portfolio-backend
```

## 🌐 Access URLs

- **Frontend:** http://localhost:8080
- **Backend:** http://localhost:8070/api/portfolio/health
- **API Docs:** http://localhost:8070/api/portfolio/*

---

**See DOCKER-DEPLOYMENT-SUCCESS.md for complete documentation**
