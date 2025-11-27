# 🎯 Dual Deployment Access

## ✅ Both Deployments Running!

You now have **TWO separate deployments** of your portfolio running simultaneously:

---

## 📦 **Docker Deployment**

**Access URLs:**
- **Frontend:** http://localhost:8080
- **Backend:** http://localhost:8070/api/portfolio/health

**Containers:**
- `portfolio-frontend` (port 8080)
- `portfolio-backend` (port 8070)
- `portfolio-mysql` (internal)

**Management:**
```powershell
.\manage-portfolio.ps1 status
.\manage-portfolio.ps1 health
.\manage-portfolio.ps1 logs
```

---

## ☸️ **Kubernetes Deployment**

**Access URLs:**
- **Frontend:** http://localhost:9090
- **Backend:** Proxied through frontend at `/api`

**Pods:**
- `backend-deployment-*` 
- `frontend-deployment-*`
- `mysql-deployment-*`

**Management:**
```powershell
kubectl get pods -n portfolio
kubectl logs -n portfolio <pod-name>
.\check-status.ps1
```

**Port-Forward Control:**
```powershell
# Stop port-forward
Get-Process | Where-Object {$_.ProcessName -eq 'kubectl'} | Stop-Process

# Restart port-forward
kubectl port-forward -n portfolio service/frontend-service 9090:80
```

---

## 🎯 **Quick Comparison**

| Feature | Docker (8080) | Kubernetes (9090) |
|---------|---------------|-------------------|
| **Environment** | Local containers | Kind cluster |
| **Access** | Direct ports | Port-forward |
| **Persistence** | Docker volumes | K8s PVC |
| **Management** | Docker commands | kubectl commands |
| **Auto-restart** | Yes (--restart) | Yes (K8s) |

---

## 🚀 **Quick Access**

**Open Docker version:**
```powershell
Start-Process "http://localhost:8080"
```

**Open Kubernetes version:**
```powershell
Start-Process "http://localhost:9090"
```

**View status of both:**
```powershell
.\dual-deployment-status.ps1
```

---

## 🛠️ **Managing Both Deployments**

### Docker Management
```powershell
# Start/Stop
.\manage-portfolio.ps1 start
.\manage-portfolio.ps1 stop

# Health check
.\manage-portfolio.ps1 health

# Logs
.\manage-portfolio.ps1 logs
```

### Kubernetes Management
```powershell
# Check status
kubectl get all -n portfolio

# Check logs
kubectl logs -n portfolio deployment/backend-deployment

# Restart deployment
kubectl rollout restart deployment/backend-deployment -n portfolio
```

---

## 💡 **Why Two Deployments?**

- **Docker (8080):** Fast, simple, local development
- **Kubernetes (9090):** Production-like, orchestration, scaling

Both use the same Docker images but different orchestration!

---

## 🔍 **Verification**

Run this to check both:
```powershell
# Docker
Invoke-WebRequest http://localhost:8080
Invoke-RestMethod http://localhost:8070/api/portfolio/health

# Kubernetes  
Invoke-WebRequest http://localhost:9090
```

---

## ⚠️ **Important Notes**

1. **Different Databases:** Each deployment has its own MySQL instance
2. **Port-forward Required:** Kubernetes needs active port-forward for access
3. **Resource Usage:** Running both uses 2x resources
4. **Independent:** Changes to one don't affect the other

---

## 🎊 **Summary**

✅ **Docker Deployment:** http://localhost:8080 (ports 8070, 8080)  
✅ **Kubernetes Deployment:** http://localhost:9090 (port-forward)  
✅ **Both Healthy:** All services responding  
✅ **Easy Management:** Scripts available for both

**Check status anytime:**
```powershell
.\dual-deployment-status.ps1
```

---

**Both deployments are running and accessible on different ports!** 🌟
