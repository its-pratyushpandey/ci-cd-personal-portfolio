# Portfolio Ansible - Complete Setup Guide

## 📦 What You Need

### On Your Computer (Control Machine)
- Python 3.8+
- Ansible 2.9+
- SSH client

### On Target Server(s)
- Ubuntu 20.04+ / CentOS 7+ / RHEL 8+
- SSH access with sudo privileges
- Internet connection (to pull Docker images)

---

## 🚀 Complete Installation Steps

### 1. Install Python & Pip

**Windows:**
```powershell
# Download from python.org or use winget
winget install Python.Python.3.11
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install python3 python3-pip -y
```

**Mac:**
```bash
brew install python3
```

### 2. Install Ansible

```bash
pip install -r requirements.txt
```

Or manually:
```bash
pip install ansible docker docker-compose
```

Verify installation:
```bash
ansible --version
```

### 3. Install Ansible Collections

```bash
ansible-galaxy collection install -r requirements.yml
```

### 4. Setup SSH Access

**Generate SSH key (if you don't have one):**
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

**Copy SSH key to target server:**
```bash
ssh-copy-id ubuntu@YOUR_SERVER_IP
```

**Test SSH connection:**
```bash
ssh ubuntu@YOUR_SERVER_IP
```

### 5. Configure Inventory

Edit `inventory/hosts.yml`:

```yaml
all:
  hosts:
    portfolio-server:
      ansible_host: YOUR_SERVER_IP     # Server IP or hostname
      ansible_user: ubuntu             # SSH username
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
      ansible_python_interpreter: /usr/bin/python3
```

**For multiple servers:**
```yaml
all:
  hosts:
    server1:
      ansible_host: 192.168.1.10
      ansible_user: ubuntu
    server2:
      ansible_host: 192.168.1.11
      ansible_user: centos
```

### 6. Configure Variables (Optional)

Edit `inventory/group_vars/all.yml` to customize:

```yaml
# Ports
frontend_port: 80        # Change if 80 is in use
backend_port: 8070
mysql_port: 3306

# Database
mysql_root_password: "ChangeThisPassword!"  # Use strong password
mysql_database: "portfolio_db"

# Docker images
frontend_image: "pratyushpandey/portfoliofrontend:latest"
backend_image: "pratyushpandey/portfoliobackend:latest"
```

### 7. Test Connection

```bash
cd ansible
ansible all -m ping
```

Expected output:
```
portfolio-server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 8. Deploy!

**Using the deployment script:**

Linux/Mac:
```bash
chmod +x deploy.sh
./deploy.sh
```

Windows PowerShell:
```powershell
.\deploy.ps1
```

**Or directly:**
```bash
ansible-playbook playbooks/deploy-portfolio.yml
```

### 9. Verify Deployment

```bash
# Check status
ansible-playbook playbooks/check-status.yml

# Or manually
ansible all -m shell -a "docker ps"
```

### 10. Access Your Application

```
http://YOUR_SERVER_IP
```

---

## 🎯 Deployment Modes

### Full Deployment (All Components)
```bash
ansible-playbook playbooks/deploy-portfolio.yml
```

### Deploy Only Specific Components
```bash
# Only MySQL
ansible-playbook playbooks/deploy-portfolio.yml --tags "mysql"

# Only Backend
ansible-playbook playbooks/deploy-portfolio.yml --tags "backend"

# Only Frontend
ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend"

# Backend + Frontend (skip MySQL)
ansible-playbook playbooks/deploy-portfolio.yml --tags "backend,frontend"
```

### Deploy to Specific Hosts
```bash
# Single host
ansible-playbook playbooks/deploy-portfolio.yml --limit server1

# Multiple hosts
ansible-playbook playbooks/deploy-portfolio.yml --limit server1,server2
```

---

## 🔧 Management Playbooks

### Check Application Status
```bash
ansible-playbook playbooks/check-status.yml
```

Shows:
- Running containers
- Health check status
- Network configuration

### View Logs
```bash
ansible-playbook playbooks/view-logs.yml
```

Interactive prompt to select which container's logs to view.

### Stop All Services
```bash
ansible-playbook playbooks/stop-portfolio.yml
```

Stops containers but preserves data.

### Complete Cleanup
```bash
ansible-playbook playbooks/cleanup-portfolio.yml
```

⚠️ **Warning:** Removes all containers, networks, and volumes (including database data).

---

## 🔒 Security Best Practices

### 1. Use Ansible Vault for Secrets

Encrypt sensitive variables:
```bash
ansible-vault encrypt inventory/group_vars/all.yml
```

Deploy with vault password:
```bash
ansible-playbook playbooks/deploy-portfolio.yml --ask-vault-pass
```

### 2. Change Default Passwords

Edit `inventory/group_vars/all.yml`:
```yaml
mysql_root_password: "UseAStrongPassword123!"
```

### 3. Configure Firewall on Target Server

```bash
ansible all -m shell -a "ufw allow 22/tcp"   # SSH
ansible all -m shell -a "ufw allow 80/tcp"   # Frontend
ansible all -m shell -a "ufw allow 8070/tcp" # Backend (optional)
ansible all -m shell -a "ufw enable"
```

### 4. Use Non-Root User

The playbooks use `become: true` to run with sudo. Ensure your SSH user has sudo privileges:

```bash
# On target server
usermod -aG sudo ubuntu
```

---

## 📊 Monitoring & Maintenance

### View Container Stats
```bash
ansible all -m shell -a "docker stats --no-stream"
```

### Check Disk Usage
```bash
ansible all -m shell -a "docker system df"
```

### Backup Database
```bash
ansible all -m shell -a "docker exec portfolio-mysql mysqldump -uroot -p@Pratyush123 portfolio_db > /tmp/backup.sql"
```

### Restore Database
```bash
ansible all -m shell -a "docker exec -i portfolio-mysql mysql -uroot -p@Pratyush123 portfolio_db < /tmp/backup.sql"
```

### Update Images
```bash
# Pull latest images and redeploy
ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend,backend"
```

---

## 🆘 Troubleshooting

### SSH Connection Issues

**Problem:** "Permission denied (publickey)"
```bash
# Solution: Copy SSH key
ssh-copy-id ubuntu@YOUR_SERVER_IP

# Or add password authentication temporarily
ansible_ssh_pass: "your_password"
```

**Problem:** "Host key verification failed"
```bash
# Solution: Add to known_hosts
ssh-keyscan YOUR_SERVER_IP >> ~/.ssh/known_hosts
```

### Docker Installation Issues

**Problem:** "docker: command not found"
```bash
# Solution: Run docker role manually
ansible-playbook playbooks/deploy-portfolio.yml --tags "docker"
```

### Container Startup Issues

**View logs:**
```bash
ansible all -m shell -a "docker logs portfolio-backend --tail 100"
```

**Check if port is in use:**
```bash
ansible all -m shell -a "netstat -tuln | grep 8070"
```

**Restart container:**
```bash
ansible all -m shell -a "docker restart portfolio-backend"
```

### Database Connection Issues

**Check MySQL is running:**
```bash
ansible all -m shell -a "docker ps | grep mysql"
```

**Test connection:**
```bash
ansible all -m shell -a "docker exec portfolio-mysql mysql -uroot -p@Pratyush123 -e 'SHOW DATABASES;'"
```

**Check network:**
```bash
ansible all -m shell -a "docker network inspect portfolio-network"
```

### Frontend Not Loading

**Check nginx config:**
```bash
ansible all -m shell -a "docker exec portfolio-frontend cat /etc/nginx/conf.d/default.conf"
```

**Test from server:**
```bash
ansible all -m shell -a "curl -I http://localhost:80"
```

---

## 🌐 Advanced Configurations

### SSL/TLS with Let's Encrypt

1. Install Certbot on target server
2. Obtain certificate
3. Update nginx configuration
4. Redeploy frontend with new config

### Custom Domain

Update nginx config template in `roles/frontend/templates/nginx.conf.j2`:
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    # ... rest of config
}
```

### Load Balancer Setup

For multiple backend instances, configure nginx upstream:
```nginx
upstream backend {
    server backend1:8070;
    server backend2:8070;
    server backend3:8070;
}
```

---

## 📚 Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [React Documentation](https://react.dev/)

---

**Questions or Issues?**

Check the troubleshooting section or review the playbook logs for detailed error messages.

Happy Deploying! 🚀
