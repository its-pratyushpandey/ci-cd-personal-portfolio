# Portfolio Kubernetes Deployment - Access Guide

## 🚨 Important: Kind Cluster Port Access

Your Kind (Kubernetes in Docker) cluster requires **port forwarding** to access services from your host machine.

---

## ✅ Quick Start - Access Your Portfolio Now

### **Option 1: Using Port Forward Script (Recommended)**

Simply run this script:

```powershell
.\start-portfolio.ps1
```

This will:
- Start port forwarding from `localhost:8080` to the frontend service
- Open your browser automatically to `http://localhost:8080`

**To stop:**
```powershell
.\stop-portfolio.ps1
```

---

### **Option 2: Manual Port Forward**

Open a **separate PowerShell terminal** and run:

```powershell
kubectl port-forward -n portfolio service/frontend-service 8080:80
```

Keep this terminal open, then access: **http://localhost:8080**

---

### **Option 3: Recreate Cluster with Port Mapping (Advanced)**

For permanent access on standard ports (80/443), recreate your Kind cluster:

1. **Delete current cluster:**
   ```powershell
   kind delete cluster --name frontend-cluster
   ```

2. **Create new cluster with port mapping:**
   ```powershell
   kind create cluster --config kind-cluster-config.yaml
   ```

3. **Redeploy everything:**
   ```powershell
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/mysql-deployment.yaml
   kubectl apply -f k8s/backend-deployment.yaml
   
   # Update frontend service to use NodePort 30080
   # Edit k8s/frontend-deployment.yaml and change service type
   ```

4. **Update frontend service** in `k8s/frontend-deployment.yaml`:
   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: frontend-service
     namespace: portfolio
   spec:
     type: NodePort
     selector:
       app: portfolio-frontend
     ports:
       - port: 80
         targetPort: 80
         nodePort: 30080  # Add this line
         protocol: TCP
   ```

5. **Access at:** `http://localhost:80`

---

## 🔍 Verify Deployment

### Check all pods are running:
```powershell
kubectl get pods -n portfolio
```

Expected output:
```
NAME                                  READY   STATUS    RESTARTS   AGE
backend-deployment-xxxxx              1/1     Running   0          Xm
frontend-deployment-xxxxx             1/1     Running   0          Xm
mysql-deployment-xxxxx                1/1     Running   0          Xm
```

### Test backend health:
```powershell
kubectl exec -n portfolio deployment/backend-deployment -- curl http://localhost:8070/api/portfolio/health
```

Expected: `{"message":"Portfolio Backend API is running","status":"OK"}`

### Test frontend HTML:
```powershell
kubectl exec -n portfolio deployment/frontend-deployment -- curl -s http://localhost:80
```

Expected: HTML content with `<!DOCTYPE html>`

---

## 📊 Current Architecture

```
┌─────────────────────────────┐
│   Your Browser              │
│   http://localhost:8080     │
└──────────┬──────────────────┘
           │ kubectl port-forward
           ↓
┌─────────────────────────────┐
│   Kind Docker Container     │
│  ┌─────────────────────────┐│
│  │ Frontend Service :80    ││
│  │   ↓                     ││
│  │ Frontend Pod (Nginx)    ││
│  │   → calls backend via   ││
│  │   Kubernetes DNS        ││
│  └─────────────────────────┘│
│  ┌─────────────────────────┐│
│  │ Backend Service :8070   ││
│  │   ↓                     ││
│  │ Backend Pod (Spring)    ││
│  └─────────────────────────┘│
│  ┌─────────────────────────┐│
│  │ MySQL Service :3306     ││
│  │   ↓                     ││
│  │ MySQL Pod + Storage     ││
│  └─────────────────────────┘│
└─────────────────────────────┘
```

---

## 🎯 Why Port Forward is Needed

**Kind (Kubernetes in Docker)** runs your cluster inside a Docker container:
- Services with type `LoadBalancer` stay in `<pending>` state
- `NodePort` services are only accessible within the Docker network
- **Solution:** Use `kubectl port-forward` to tunnel traffic from your host to the cluster

---

## 🔧 Troubleshooting

### "Connection refused" or "Unable to connect"
- Ensure port-forward is running: `.\start-portfolio.ps1`
- Check pods are healthy: `kubectl get pods -n portfolio`
- Verify services: `kubectl get svc -n portfolio`

### Frontend loads but can't reach backend
- Frontend calls backend at: `http://backend-service.portfolio.svc.cluster.local:8070/api/portfolio`
- This works **inside the cluster** via Kubernetes DNS
- Check backend logs: `kubectl logs -f deployment/backend-deployment -n portfolio`

### Backend can't connect to MySQL
- Check MySQL pod: `kubectl get pod -n portfolio | Select-String mysql`
- Check backend logs for connection errors
- Verify env vars: `kubectl describe deployment backend-deployment -n portfolio`

---

## ✨ Access Your Portfolio

**Run this command:**
```powershell
.\start-portfolio.ps1
```

**Or manually:**
```powershell
kubectl port-forward -n portfolio service/frontend-service 8080:80
```

Then open: **http://localhost:8080**

---

**Your portfolio is fully deployed and ready!** 🚀
