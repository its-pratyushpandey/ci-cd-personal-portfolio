"# Personal Portfolio - Full Stack Application

A modern, containerized portfolio application deployed on Kubernetes.

## 🚀 Quick Start

### Access Your Deployed Portfolio

```powershell
.\start-portfolio.ps1
```

Then open: **http://localhost:8080**

## 📦 Tech Stack

### Frontend
- **React** - UI framework
- **Vite** - Build tool
- **TailwindCSS** - Styling
- **Three.js** - 3D graphics
- **Nginx** - Production server

### Backend
- **Spring Boot 3.2.0** - Java framework
- **Java 21** - Runtime
- **MySQL 8.0** - Database
- **JPA/Hibernate** - ORM

### DevOps
- **Docker** - Containerization
- **Kubernetes (Kind)** - Orchestration
- **kubectl** - K8s management

## 🏗️ Architecture

```
Browser → Frontend (React+Nginx) → Backend (Spring Boot) → MySQL
          Port 80                   Port 8070              Port 3306
```

## 📁 Project Structure

```
├── backend/                # Spring Boot application
│   ├── src/               # Java source code
│   ├── pom.xml           # Maven dependencies
│   └── Dockerfile        # Backend container image
├── frontend/              # React application
│   ├── src/              # React components
│   ├── package.json      # npm dependencies
│   ├── Dockerfile        # Frontend container image
│   └── nginx.conf        # Nginx configuration
└── k8s/                   # Kubernetes manifests
    ├── namespace.yaml    # Portfolio namespace
    ├── mysql-deployment.yaml
    ├── backend-deployment.yaml
    └── frontend-deployment.yaml
```

## 🐳 Docker Images

- **Frontend:** `pratyushpandey/portfoliofrontend:latest`
- **Backend:** `pratyushpandey/portfoliobackend:latest`

## 📚 Documentation

- **[ACCESS-GUIDE.md](ACCESS-GUIDE.md)** - How to access the application
- **[DEPLOYMENT-SUCCESS.md](DEPLOYMENT-SUCCESS.md)** - Quick deployment summary
- **[KUBERNETES-DEPLOYMENT.md](KUBERNETES-DEPLOYMENT.md)** - Detailed K8s guide

## 🛠️ Local Development

### Backend
```powershell
cd backend
.\start-backend.bat
```

### Frontend
```powershell
cd frontend
npm install
npm run dev
```

## ☸️ Kubernetes Deployment

### Deploy Everything
```powershell
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
```

### Check Status
```powershell
kubectl get all -n portfolio
```

### Access Application
```powershell
.\start-portfolio.ps1
```

## 🔧 Useful Commands

### View Logs
```powershell
kubectl logs -f deployment/backend-deployment -n portfolio
kubectl logs -f deployment/frontend-deployment -n portfolio
```

### Restart Services
```powershell
kubectl rollout restart deployment/backend-deployment -n portfolio
kubectl rollout restart deployment/frontend-deployment -n portfolio
```

### Clean Up
```powershell
kubectl delete namespace portfolio
```

## 🎯 Features

- ✅ Fully containerized with Docker
- ✅ Orchestrated with Kubernetes
- ✅ Persistent database storage
- ✅ Internal service networking
- ✅ Health checks and probes
- ✅ Production-ready configuration

## 📝 License

MIT License - feel free to use this project as a template!

---

**Made with ❤️ by Pratyush Pandey**
" 
