# 🎉 Portfolio Deployment Successful!

## ✅ Deployment Complete

Your portfolio application has been successfully deployed using **Docker** on your local machine!

---

## 🌐 Access Your Portfolio

**Frontend:** http://localhost:8080  
**Backend API:** http://localhost:8070/api/portfolio/health

---

## 📊 Running Containers

| Container | Image | Port | Status |
|-----------|-------|------|--------|
| **portfolio-frontend** | pratyushpandey/portfoliofrontend:latest | 8080→80 | ✅ Running |
| **portfolio-backend** | pratyushpandey/portfoliobackend:latest | 8070→8070 | ✅ Running |
| **portfolio-mysql** | mysql:8.0 | 3306 (internal) | ✅ Running |

All containers are connected via **portfolio-network** Docker network.

---

## 🎯 What Was Deployed

```
┌─────────────────────────────────────────┐
│        Docker Deployment (Local)        │
├─────────────────────────────────────────┤
│                                         │
│  🌐 Frontend (Port 8080)                │
│     → React + Vite + Nginx              │
│     → Proxies /api → Backend            │
│                                         │
│  ⚙️  Backend (Port 8070)                │
│     → Spring Boot 3.2.0 + Java 21       │
│     → REST API at /api/portfolio        │
│                                         │
│  🗄️  MySQL (Port 3306 internal)        │
│     → Database: portfolio_db            │
│     → Persistent volume storage         │
│                                         │
│  🔗 Network: portfolio-network          │
│                                         │
└─────────────────────────────────────────┘
```

---

## 🛠️ Management Commands

### View Container Status
```powershell
docker ps --filter "name=portfolio-"
```

### View Logs
```powershell
# Frontend logs
docker logs portfolio-frontend

# Backend logs
docker logs portfolio-backend

# MySQL logs
docker logs portfolio-mysql

# Follow logs in real-time
docker logs -f portfolio-backend
```

### Stop All Services
```powershell
docker stop portfolio-frontend portfolio-backend portfolio-mysql
```

### Start All Services
```powershell
docker start portfolio-mysql portfolio-backend portfolio-frontend
```

### Restart All Services
```powershell
docker restart portfolio-mysql portfolio-backend portfolio-frontend
```

### Remove All Containers
```powershell
docker rm -f portfolio-frontend portfolio-backend portfolio-mysql
```

### Remove All (Including Network & Volume)
```powershell
docker rm -f portfolio-frontend portfolio-backend portfolio-mysql
docker network rm portfolio-network
docker volume rm portfolio-mysql-data
```

---

## 🔍 Health Checks

### Backend Health
```powershell
Invoke-RestMethod -Uri "http://localhost:8070/api/portfolio/health"
```

**Expected Response:**
```json
{
  "message": "Portfolio Backend API is running",
  "status": "OK"
}
```

### Frontend Health
```powershell
Invoke-WebRequest -Uri "http://localhost:8080"
```

**Expected:** HTTP 200 response

### Database Connection
```powershell
docker exec -it portfolio-mysql mysql -uroot -p@Pratyush123 -e "SHOW DATABASES;"
```

---

## 🐛 Troubleshooting

### Container Won't Start

**Check logs:**
```powershell
docker logs portfolio-backend --tail 50
```

**Check if port is in use:**
```powershell
Get-NetTCPConnection -LocalPort 8070
```

### Frontend Can't Reach Backend

**Verify network connectivity:**
```powershell
docker exec portfolio-frontend ping -c 3 portfolio-backend
```

**Check nginx config:**
```powershell
docker exec portfolio-frontend cat /etc/nginx/conf.d/default.conf
```

### Database Connection Issues

**Check MySQL is running:**
```powershell
docker ps --filter "name=portfolio-mysql"
```

**Check backend environment variables:**
```powershell
docker inspect portfolio-backend | Select-String "SPRING_DATASOURCE"
```

### Port Already in Use

If ports 8070 or 8080 are in use, redeploy with different ports:

```powershell
# Stop frontend
docker rm -f portfolio-frontend

# Use different port (e.g., 3000)
docker run -d `
  --name portfolio-frontend `
  --network portfolio-network `
  -p 3000:80 `
  --restart unless-stopped `
  pratyushpandey/portfoliofrontend:latest
```

Then access at `http://localhost:3000`

---

## 🔄 Redeploy After Code Changes

### 1. Rebuild Images

**Frontend:**
```powershell
cd frontend
docker build -t pratyushpandey/portfoliofrontend:latest .
```

**Backend:**
```powershell
cd backend
docker build -t pratyushpandey/portfoliobackend:latest .
```

### 2. Restart Containers

```powershell
# Stop and remove old containers
docker rm -f portfolio-frontend portfolio-backend

# Redeploy backend
docker run -d `
  --name portfolio-backend `
  --network portfolio-network `
  -e SPRING_DATASOURCE_URL="jdbc:mysql://portfolio-mysql:3306/portfolio_db?useSSL=false&allowPublicKeyRetrieval=true" `
  -e SPRING_DATASOURCE_USERNAME=root `
  -e SPRING_DATASOURCE_PASSWORD='@Pratyush123' `
  -p 8070:8070 `
  --restart unless-stopped `
  pratyushpandey/portfoliobackend:latest

# Redeploy frontend
docker run -d `
  --name portfolio-frontend `
  --network portfolio-network `
  -p 8080:80 `
  --restart unless-stopped `
  pratyushpandey/portfoliofrontend:latest
```

---

## 📦 Database Backup & Restore

### Backup Database
```powershell
docker exec portfolio-mysql mysqldump -uroot -p@Pratyush123 portfolio_db > backup.sql
```

### Restore Database
```powershell
Get-Content backup.sql | docker exec -i portfolio-mysql mysql -uroot -p@Pratyush123 portfolio_db
```

---

## 🔐 Security Notes

**⚠️ For Production:**

1. **Change default password:**
   ```powershell
   # Update MySQL password
   docker exec -it portfolio-mysql mysql -uroot -p@Pratyush123 -e "ALTER USER 'root'@'%' IDENTIFIED BY 'NewSecurePassword';"
   ```

2. **Use environment variable files:**
   Create `.env` file and use `--env-file` flag

3. **Enable SSL/TLS:**
   Configure nginx with SSL certificates

4. **Use Docker secrets:**
   For sensitive credentials

---

## 🚀 Next Steps

### Deploy to Remote Server

Use the Ansible playbooks in the `ansible/` directory:

```bash
cd ansible
ansible-playbook playbooks/deploy-portfolio.yml
```

### Push Images to Docker Hub

```powershell
# Login to Docker Hub
docker login

# Push images
docker push pratyushpandey/portfoliofrontend:latest
docker push pratyushpandey/portfoliobackend:latest
```

### Set Up CI/CD

Automate deployments using GitHub Actions or Jenkins

---

## 📚 Additional Resources

- **Kubernetes Deployment:** See `k8s/` directory
- **Ansible Deployment:** See `ansible/` directory  
- **Frontend README:** `frontend/README.md`
- **Backend README:** `backend/README.md`

---

## ✨ Summary

✅ **3 Containers Running** (Frontend, Backend, MySQL)  
✅ **Docker Network** (portfolio-network)  
✅ **Persistent Storage** (MySQL data volume)  
✅ **Health Checks** Passing  
✅ **Accessible** at http://localhost:8080

**Deployment Method:** Docker (Windows-compatible alternative to Ansible)

**Total Deployment Time:** ~3 minutes

---

**🎊 Your portfolio is now live and running!**

Open http://localhost:8080 in your browser to see it in action! 🌟
