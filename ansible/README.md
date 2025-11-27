# Portfolio Application - Ansible Deployment

## 📋 Overview

This Ansible deployment automates the deployment of your portfolio application stack:
- **Frontend**: React + Nginx (pratyushpandey/portfoliofrontend)
- **Backend**: Spring Boot (pratyushpandey/portfoliobackend)
- **Database**: MySQL 8.0

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│   Target Host(s)                    │
├─────────────────────────────────────┤
│  Frontend Container (port 80)       │
│  ↓ (nginx proxy /api → backend)     │
│  Backend Container (port 8070)      │
│  ↓                                  │
│  MySQL Container (port 3306)        │
│  + Volume (mysql_data)              │
└─────────────────────────────────────┘
```

## 📁 Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── inventory/
│   ├── hosts.yml           # Target servers inventory
│   └── group_vars/
│       └── all.yml         # Global variables
├── playbooks/
│   ├── deploy-portfolio.yml        # Main deployment playbook
│   ├── stop-portfolio.yml          # Stop all services
│   └── cleanup-portfolio.yml       # Remove all containers & volumes
├── roles/
│   ├── docker/             # Install Docker on hosts
│   ├── mysql/              # Deploy MySQL container
│   ├── backend/            # Deploy backend container
│   └── frontend/           # Deploy frontend container
└── templates/
    └── nginx.conf.j2       # Nginx configuration template
```

## 🚀 Quick Start

### 1. Prerequisites

- **Control Machine** (where you run Ansible):
  - Python 3.8+
  - Ansible 2.9+
  
- **Target Host(s)**:
  - Ubuntu 20.04+ / CentOS 7+ / RHEL 8+
  - SSH access with sudo privileges
  - Python 3 installed

### 2. Install Ansible

**On Windows (using WSL or Git Bash):**
```bash
pip install ansible
```

**On Linux/Mac:**
```bash
pip3 install ansible
```

### 3. Configure Inventory

Edit `ansible/inventory/hosts.yml` with your target server(s):

```yaml
all:
  hosts:
    portfolio-server:
      ansible_host: YOUR_SERVER_IP
      ansible_user: YOUR_SSH_USER
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

### 4. Deploy

```bash
cd ansible
ansible-playbook playbooks/deploy-portfolio.yml
```

## 📖 Detailed Usage

### Deploy Portfolio Application

```bash
ansible-playbook playbooks/deploy-portfolio.yml
```

**What it does:**
1. Installs Docker on target host(s)
2. Creates Docker network: `portfolio-network`
3. Deploys MySQL container with persistent volume
4. Deploys Backend (Spring Boot) container
5. Deploys Frontend (React + Nginx) container
6. Configures networking between containers

### Stop All Services

```bash
ansible-playbook playbooks/stop-portfolio.yml
```

Stops all portfolio containers without removing data.

### Complete Cleanup

```bash
ansible-playbook playbooks/cleanup-portfolio.yml
```

**Warning:** This removes all containers, networks, and volumes (including database data).

### Check Status

```bash
ansible all -m shell -a "docker ps --filter 'name=portfolio'"
```

## 🔧 Configuration

### Environment Variables

Edit `ansible/inventory/group_vars/all.yml`:

```yaml
# Docker images
frontend_image: "pratyushpandey/portfoliofrontend:latest"
backend_image: "pratyushpandey/portfoliobackend:latest"
mysql_image: "mysql:8.0"

# Database configuration
mysql_root_password: "@Pratyush123"
mysql_database: "portfolio_db"

# Application ports
frontend_port: 80
backend_port: 8070
mysql_port: 3306

# Network
docker_network: "portfolio-network"
```

### Custom Ports

To expose on different ports, edit `group_vars/all.yml`:

```yaml
frontend_port: 8080  # Access via http://server:8080
backend_port: 8070
```

## 🎯 Deployment Scenarios

### Single Server Deployment

Deploy all components on one server:

```yaml
# inventory/hosts.yml
all:
  hosts:
    portfolio-server:
      ansible_host: 192.168.1.100
```

### Multi-Server Deployment

Deploy components on separate servers:

```yaml
# inventory/hosts.yml
all:
  children:
    database:
      hosts:
        db-server:
          ansible_host: 192.168.1.101
    application:
      hosts:
        app-server:
          ansible_host: 192.168.1.102
```

Then modify playbook to target specific groups.

## 🔍 Verification

After deployment, verify:

1. **Check containers:**
   ```bash
   ansible all -m shell -a "docker ps"
   ```

2. **Check backend health:**
   ```bash
   curl http://YOUR_SERVER_IP:8070/api/portfolio/health
   ```

3. **Access frontend:**
   ```
   http://YOUR_SERVER_IP
   ```

## 🛠️ Troubleshooting

### View Container Logs

```bash
# Backend logs
ansible all -m shell -a "docker logs portfolio-backend"

# Frontend logs
ansible all -m shell -a "docker logs portfolio-frontend"

# MySQL logs
ansible all -m shell -a "docker logs portfolio-mysql"
```

### Restart a Service

```bash
ansible all -m shell -a "docker restart portfolio-backend"
```

### Check Container Network

```bash
ansible all -m shell -a "docker network inspect portfolio-network"
```

## 🔄 Updates

### Update Frontend/Backend

```bash
# Pull latest images and restart
ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend,backend"
```

### Database Backup

```bash
ansible all -m shell -a "docker exec portfolio-mysql mysqldump -uroot -p@Pratyush123 portfolio_db > /tmp/backup.sql"
```

## 📊 Monitoring

Add monitoring with:

```bash
ansible-playbook playbooks/deploy-portfolio.yml --tags "monitoring"
```

This will deploy:
- Prometheus (metrics)
- Grafana (dashboards)

## 🔐 Security Notes

1. **Change default passwords** in `group_vars/all.yml`
2. **Use Ansible Vault** for sensitive data:
   ```bash
   ansible-vault encrypt inventory/group_vars/all.yml
   ```
3. **Configure firewall** on target hosts
4. **Use SSL/TLS** for production (add nginx SSL config)

## 📝 Next Steps

1. Configure your inventory file
2. Test SSH connectivity: `ansible all -m ping`
3. Run deployment: `ansible-playbook playbooks/deploy-portfolio.yml`
4. Access your portfolio at `http://YOUR_SERVER_IP`

---

**Made with ❤️ for automated deployment**
