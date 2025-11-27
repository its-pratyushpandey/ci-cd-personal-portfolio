# Portfolio Application - Ansible Deployment Quick Start

## ⚡ Quick Deploy (5 Minutes)

### Step 1: Install Ansible

**Windows (PowerShell):**
```powershell
pip install ansible
```

**Linux/Mac:**
```bash
pip3 install ansible
```

### Step 2: Configure Target Server

Edit `ansible/inventory/hosts.yml`:

```yaml
all:
  hosts:
    portfolio-server:
      ansible_host: 192.168.1.100  # ← Change this to your server IP
      ansible_user: ubuntu          # ← Your SSH username
      ansible_ssh_private_key_file: ~/.ssh/id_rsa  # ← Your SSH key
```

### Step 3: Test Connection

```bash
cd ansible
ansible all -m ping
```

Expected output:
```
portfolio-server | SUCCESS => {
    "ping": "pong"
}
```

### Step 4: Deploy!

**Option A: Use deployment script (recommended)**

Linux/Mac:
```bash
chmod +x deploy.sh
./deploy.sh
```

Windows:
```powershell
.\deploy.ps1
```

**Option B: Direct command**

```bash
ansible-playbook playbooks/deploy-portfolio.yml
```

### Step 5: Access Your Portfolio

```
http://YOUR_SERVER_IP
```

**That's it!** 🎉

---

## 📋 What Gets Deployed

```
Target Server
├── MySQL Container (port 3306)
│   └── Volume: portfolio-mysql-data
├── Backend Container (port 8070)
│   └── Spring Boot + Java 21
└── Frontend Container (port 80)
    └── React + Nginx
```

---

## 🔧 Common Tasks

### Check Status

```bash
ansible-playbook playbooks/check-status.yml
```

### View Logs

```bash
ansible-playbook playbooks/view-logs.yml
```

### Update Application

```bash
# Pull latest images and redeploy
ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend,backend"
```

### Stop Everything

```bash
ansible-playbook playbooks/stop-portfolio.yml
```

### Complete Cleanup

```bash
ansible-playbook playbooks/cleanup-portfolio.yml
```

---

## 🆘 Troubleshooting

### SSH Connection Failed

```bash
# Test SSH manually
ssh ubuntu@YOUR_SERVER_IP

# Check SSH key permissions
chmod 600 ~/.ssh/id_rsa
```

### Container Not Starting

```bash
# Check logs
ansible all -m shell -a "docker logs portfolio-backend"

# Check if port is in use
ansible all -m shell -a "netstat -tuln | grep 8070"
```

### Backend Can't Connect to Database

```bash
# Verify MySQL is running
ansible all -m shell -a "docker ps | grep mysql"

# Check network
ansible all -m shell -a "docker network inspect portfolio-network"
```

---

## 📖 Full Documentation

See [README.md](README.md) for complete documentation.

---

## ⚙️ Environment Variables

Edit `ansible/inventory/group_vars/all.yml` to customize:

```yaml
# Change ports
frontend_port: 8080
backend_port: 8070

# Change database password
mysql_root_password: "YourSecurePassword"

# Use different images
frontend_image: "pratyushpandey/portfoliofrontend:v2"
backend_image: "pratyushpandey/portfoliobackend:v2"
```

Then redeploy:
```bash
ansible-playbook playbooks/deploy-portfolio.yml
```

---

**Need help?** Check the logs or open an issue! 🚀
