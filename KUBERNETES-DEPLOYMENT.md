# Portfolio Application - Kubernetes Deployment Summary

## ✅ Deployment Status: COMPLETE

Your portfolio application has been successfully deployed to Kubernetes!

## 📦 Deployed Components

### 1. **MySQL Database**
   - **Pod**: `mysql-deployment-7dbb8bddf-4drk2`
   - **Service**: `mysql` (ClusterIP on port 3306)
   - **Storage**: 1Gi PersistentVolumeClaim
   - **Status**: ✅ Running

### 2. **Backend (Spring Boot)**
   - **Pod**: `backend-deployment-785489df9d-bmv5c`
   - **Service**: `backend-service` (ClusterIP on port 8070)
   - **Image**: `pratyushpandey/portfoliobackend:latest`
   - **Context Path**: `/api`
   - **Status**: ✅ Running (healthy, connected to MySQL)

### 3. **Frontend (React + Nginx)**
   - **Pod**: `frontend-deployment-ccdbbb5fd-hsdnc`
   - **Service**: `frontend-service` (LoadBalancer on port 80, NodePort 32525)
   - **Image**: `pratyushpandey/portfoliofrontend:latest`
   - **Status**: ✅ Running

## 🌐 Access Your Application

### **Quick Access (Recommended):**

Run the port forward script:
```powershell
.\start-portfolio.ps1
```

Then open: **http://localhost:8080**

### Manual Port Forward:
```powershell
kubectl port-forward -n portfolio service/frontend-service 8080:80
```

> **Note:** Your Kind cluster requires port forwarding to access services from the host.  
> See `ACCESS-GUIDE.md` for detailed instructions and alternatives.

### Alternative Access (if using Minikube):
```powershell
minikube service frontend-service -n portfolio
```

## 🔍 Useful Commands

### Check Pod Status
```powershell
kubectl get pods -n portfolio
```

### Check Services
```powershell
kubectl get svc -n portfolio
```

### View Backend Logs
```powershell
kubectl logs -f deployment/backend-deployment -n portfolio
```

### View Frontend Logs
```powershell
kubectl logs -f deployment/frontend-deployment -n portfolio
```

### View MySQL Logs
```powershell
kubectl logs -f deployment/mysql-deployment -n portfolio
```

### Restart a Deployment
```powershell
# Backend
kubectl rollout restart deployment backend-deployment -n portfolio

# Frontend
kubectl rollout restart deployment frontend-deployment -n portfolio
```

### Delete Everything
```powershell
kubectl delete namespace portfolio
```

## 📝 Configuration Details

### Backend Environment Variables
- `SPRING_DATASOURCE_URL`: jdbc:mysql://mysql:3306/portfolio_db
- `SPRING_DATASOURCE_USERNAME`: root
- `SPRING_DATASOURCE_PASSWORD`: @Pratyush123
- `SERVER_PORT`: 8070
- `SERVER_SERVLET_CONTEXT_PATH`: /api

### Frontend API Configuration
- **API Base URL**: `http://backend-service.portfolio.svc.cluster.local:8070/api/portfolio`
- The frontend communicates with the backend using Kubernetes internal DNS

### Database
- **Type**: MySQL 8.0
- **Database Name**: portfolio_db
- **Auto-create**: Enabled
- **Persistence**: Yes (1Gi PVC)

## 🐳 Docker Images

### Published Images on Docker Hub
- **Backend**: `pratyushpandey/portfoliobackend:latest`
- **Frontend**: `pratyushpandey/portfoliofrontend:latest`

### Rebuild and Redeploy

If you make code changes:

#### Backend
```powershell
cd "c:\Users\praty\OneDrive\Desktop\ci cd portfolio\backend"
docker build -t pratyushpandey/portfoliobackend:latest .
docker push pratyushpandey/portfoliobackend:latest
kubectl rollout restart deployment backend-deployment -n portfolio
```

#### Frontend
```powershell
cd "c:\Users\praty\OneDrive\Desktop\ci cd portfolio\frontend"
docker build -t pratyushpandey/portfoliofrontend:latest .
docker push pratyushpandey/portfoliofrontend:latest
kubectl rollout restart deployment frontend-deployment -n portfolio
```

## 📂 Kubernetes Manifests

All Kubernetes configuration files are in the `k8s/` directory:

- `k8s/namespace.yaml` - Portfolio namespace
- `k8s/mysql-deployment.yaml` - MySQL database deployment & service
- `k8s/backend-deployment.yaml` - Backend deployment & service
- `k8s/frontend-deployment.yaml` - Frontend deployment & service

## 🔧 Troubleshooting

### If pods are crashing:
```powershell
kubectl describe pod <pod-name> -n portfolio
kubectl logs <pod-name> -n portfolio
```

### If you can't access the frontend:
1. Check service: `kubectl get svc -n portfolio`
2. Verify NodePort: Look for `80:XXXXX/TCP` in frontend-service
3. Access via `http://localhost:<NodePort>`

### If backend can't connect to database:
1. Check MySQL is running: `kubectl get pods -n portfolio`
2. Verify backend env vars: `kubectl describe deployment backend-deployment -n portfolio`
3. Check backend logs: `kubectl logs deployment/backend-deployment -n portfolio`

## 🎉 Next Steps

1. **Populate Database**: Use your portfolio controller endpoints to add:
   - Projects
   - Services
   - Technologies
   - Experiences
   - Certificates
   - Testimonials

2. **Monitor Health**: Check backend health at:
   ```
   http://localhost:32525 (opens frontend)
   ```
   Backend health endpoint (internal): `http://backend-service:8070/api/portfolio/health`

3. **Scale Up** (if needed):
   ```powershell
   kubectl scale deployment backend-deployment --replicas=3 -n portfolio
   kubectl scale deployment frontend-deployment --replicas=3 -n portfolio
   ```

4. **Set up Ingress** (for production):
   - Configure Ingress controller
   - Add TLS/SSL certificates
   - Use custom domain

## ✨ Architecture

```
┌─────────────────┐
│   Browser       │
│  :32525         │
└────────┬────────┘
         │
         ▼
┌─────────────────────┐
│  Frontend Service   │
│  (LoadBalancer)     │
│  Port: 80           │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐      ┌──────────────────┐
│  Frontend Pod       │──────▶│  Backend Service │
│  (Nginx + React)    │      │  (ClusterIP)     │
│  Port: 80           │      │  Port: 8070      │
└─────────────────────┘      └────────┬─────────┘
                                      │
                                      ▼
                             ┌──────────────────┐      ┌────────────────┐
                             │  Backend Pod     │──────▶│ MySQL Service  │
                             │  (Spring Boot)   │      │ (ClusterIP)    │
                             │  Port: 8070      │      │ Port: 3306     │
                             └──────────────────┘      └───────┬────────┘
                                                               │
                                                               ▼
                                                        ┌────────────────┐
                                                        │  MySQL Pod     │
                                                        │  + PVC (1Gi)   │
                                                        └────────────────┘
```

---

**Deployment completed successfully! 🚀**

All services are running and healthy in the `portfolio` namespace.
