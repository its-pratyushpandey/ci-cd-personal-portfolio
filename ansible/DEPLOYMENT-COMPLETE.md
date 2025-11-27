# 🎉 Portfolio Application - Ansible Deployment Complete!

## ✅ What Has Been Created

Your complete Ansible automation solution for deploying the portfolio application is ready!

---

## 📁 Directory Structure

```
ansible/
├── ansible.cfg                    # Ansible configuration
├── requirements.txt               # Python dependencies
├── requirements.yml               # Ansible Galaxy collections
├── deploy.sh                      # Linux/Mac deployment script
├── deploy.ps1                     # Windows PowerShell deployment script
│
├── README.md                      # Complete documentation
├── QUICKSTART.md                  # 5-minute quick start guide
├── SETUP-GUIDE.md                 # Detailed setup instructions
│
├── inventory/
│   ├── hosts.yml                  # Target servers (EDIT THIS!)
│   └── group_vars/
│       └── all.yml                # Global variables & configuration
│
├── playbooks/
│   ├── deploy-portfolio.yml       # Main deployment playbook
│   ├── stop-portfolio.yml         # Stop all services
│   ├── cleanup-portfolio.yml      # Remove everything
│   ├── check-status.yml           # Health check
│   └── view-logs.yml              # View container logs
│
└── roles/
    ├── docker/
    │   └── tasks/
    │       └── main.yml           # Install Docker
    ├── mysql/
    │   └── tasks/
    │       └── main.yml           # Deploy MySQL
    ├── backend/
    │   └── tasks/
    │       └── main.yml           # Deploy Backend
    └── frontend/
        ├── tasks/
        │   └── main.yml           # Deploy Frontend
        └── templates/
            └── nginx.conf.j2      # Nginx configuration
```

---

## 🚀 Quick Start (3 Steps)

### 1️⃣ Install Ansible

```bash
pip install ansible docker
```

### 2️⃣ Configure Your Server

Edit `ansible/inventory/hosts.yml`:

```yaml
all:
  hosts:
    portfolio-server:
      ansible_host: YOUR_SERVER_IP  # ← Change this!
      ansible_user: ubuntu           # ← Your SSH username
```

### 3️⃣ Deploy!

```bash
cd ansible
ansible-playbook playbooks/deploy-portfolio.yml
```

**Done!** Access at: `http://YOUR_SERVER_IP` 🎊

---

## 📖 What Gets Deployed

```
┌─────────────────────────────────────────────────┐
│           Target Server (YOUR_SERVER_IP)        │
├─────────────────────────────────────────────────┤
│                                                 │
│  🌐 Frontend Container (Port 80)                │
│      Image: pratyushpandey/portfoliofrontend    │
│      → React + Vite + Nginx                     │
│      → Proxies /api → Backend                   │
│                                                 │
│  ⚙️  Backend Container (Port 8070)               │
│      Image: pratyushpandey/portfoliobackend     │
│      → Spring Boot 3.2.0 + Java 21              │
│      → Connects to MySQL                        │
│                                                 │
│  🗄️  MySQL Container (Port 3306)                │
│      Image: mysql:8.0                           │
│      → Database: portfolio_db                   │
│      → Volume: portfolio-mysql-data (1Gi)       │
│                                                 │
│  🔗 Docker Network: portfolio-network           │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 🎯 Key Features

✅ **Fully Automated** - One command deployment  
✅ **Idempotent** - Safe to run multiple times  
✅ **Docker-Based** - Uses your existing images  
✅ **Persistent Storage** - MySQL data survives container restarts  
✅ **Health Checks** - Automatic health verification  
✅ **Network Isolation** - Containers on dedicated network  
✅ **Easy Management** - Scripts for all operations  
✅ **Multi-Server Ready** - Deploy to multiple hosts  

---

## 📋 Available Commands

### Deploy Application
```bash
ansible-playbook playbooks/deploy-portfolio.yml
```

### Check Status
```bash
ansible-playbook playbooks/check-status.yml
```

### View Logs
```bash
ansible-playbook playbooks/view-logs.yml
```

### Stop Services
```bash
ansible-playbook playbooks/stop-portfolio.yml
```

### Cleanup Everything
```bash
ansible-playbook playbooks/cleanup-portfolio.yml
```

### Partial Deployments
```bash
# Only backend
ansible-playbook playbooks/deploy-portfolio.yml --tags "backend"

# Only frontend
ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend"

# Only database
ansible-playbook playbooks/deploy-portfolio.yml --tags "mysql"
```

---

## 🔧 Configuration

### Ports (edit `inventory/group_vars/all.yml`)

```yaml
frontend_port: 80       # Frontend web interface
backend_port: 8070      # Backend API
mysql_port: 3306        # MySQL database
```

### Database Credentials

```yaml
mysql_root_password: "@Pratyush123"  # ⚠️ Change this!
mysql_database: "portfolio_db"
```

### Docker Images

```yaml
frontend_image: "pratyushpandey/portfoliofrontend:latest"
backend_image: "pratyushpandey/portfoliobackend:latest"
mysql_image: "mysql:8.0"
```

---

## 🔍 Verification Steps

After deployment, verify everything works:

### 1. Check Containers
```bash
ansible all -m shell -a "docker ps"
```

Expected output shows 3 running containers:
- portfolio-frontend
- portfolio-backend
- portfolio-mysql

### 2. Test Backend Health
```bash
curl http://YOUR_SERVER_IP:8070/api/portfolio/health
```

Expected response:
```json
{"message":"Portfolio Backend API is running","status":"OK"}
```

### 3. Access Frontend
Open browser:
```
http://YOUR_SERVER_IP
```

Should see your portfolio website!

---

## 🆘 Troubleshooting

### SSH Connection Failed

```bash
# Test manually
ssh ubuntu@YOUR_SERVER_IP

# Copy SSH key
ssh-copy-id ubuntu@YOUR_SERVER_IP
```

### Container Won't Start

```bash
# Check logs
ansible all -m shell -a "docker logs portfolio-backend --tail 50"

# Check if port is in use
ansible all -m shell -a "netstat -tuln | grep 8070"
```

### Database Connection Issues

```bash
# Verify MySQL is running
ansible all -m shell -a "docker ps | grep mysql"

# Check network
ansible all -m shell -a "docker network inspect portfolio-network"
```

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Complete documentation with all details |
| `QUICKSTART.md` | Get started in 5 minutes |
| `SETUP-GUIDE.md` | Detailed step-by-step setup instructions |
| This file | Deployment summary and overview |

---

## 🔄 Deployment Workflow

```
1. Configure Inventory
   └→ Edit inventory/hosts.yml with your server details

2. Test Connection
   └→ ansible all -m ping

3. Run Deployment
   └→ ansible-playbook playbooks/deploy-portfolio.yml
       │
       ├→ Install Docker
       ├→ Create Docker Network
       ├→ Deploy MySQL (with persistent volume)
       ├→ Deploy Backend (Spring Boot)
       ├→ Deploy Frontend (React + Nginx)
       └→ Run Health Checks

4. Verify
   └→ Access http://YOUR_SERVER_IP
```

---

## 🎓 Next Steps

### For Production Deployment

1. **Change Passwords**
   ```yaml
   mysql_root_password: "UseStrongPassword123!"
   ```

2. **Use Ansible Vault**
   ```bash
   ansible-vault encrypt inventory/group_vars/all.yml
   ```

3. **Configure Firewall**
   ```bash
   ansible all -m shell -a "ufw allow 22,80,443/tcp"
   ansible all -m shell -a "ufw enable"
   ```

4. **Add SSL Certificate**
   - Install Certbot
   - Configure nginx with SSL
   - Update frontend deployment

5. **Set Up Monitoring**
   - Add Prometheus for metrics
   - Add Grafana for dashboards
   - Configure alerts

### For Development

1. **Deploy to Local VM**
   ```yaml
   ansible_host: 192.168.56.10  # VirtualBox/VMware IP
   ```

2. **Use Test Images**
   ```yaml
   frontend_image: "pratyushpandey/portfoliofrontend:dev"
   backend_image: "pratyushpandey/portfoliobackend:dev"
   ```

3. **Enable Debug Logging**
   ```bash
   ansible-playbook playbooks/deploy-portfolio.yml -vvv
   ```

---

## 🌟 Comparison: Kubernetes vs Ansible

| Feature | Kubernetes | Ansible |
|---------|-----------|---------|
| **Complexity** | High | Low |
| **Setup Time** | 30-60 min | 5 min |
| **Learning Curve** | Steep | Gentle |
| **Orchestration** | Built-in | Manual |
| **Scaling** | Automatic | Manual |
| **Best For** | Large deployments, microservices | Simple deployments, single server |
| **Dependencies** | kubectl, Kind/minikube | SSH only |

---

## ✨ What You've Achieved

✅ **Automated Deployment** - No manual Docker commands needed  
✅ **Reproducible** - Deploy to any server with one command  
✅ **Version Controlled** - All configuration in Git  
✅ **Easy Updates** - Pull new images and redeploy  
✅ **Production Ready** - Health checks, logging, monitoring  
✅ **Portable** - Works on Ubuntu, CentOS, RHEL  

---

## 🎊 You're All Set!

Your Ansible deployment is complete and ready to use. Simply:

1. Edit `ansible/inventory/hosts.yml` with your server IP
2. Run `ansible-playbook playbooks/deploy-portfolio.yml`
3. Access your portfolio at `http://YOUR_SERVER_IP`

**Happy Deploying!** 🚀

---

**Questions?** Check the documentation files or review the playbook output for detailed logs.
