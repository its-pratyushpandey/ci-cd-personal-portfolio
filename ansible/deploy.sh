#!/bin/bash

# Portfolio Ansible Deployment Script
# This script helps you deploy the portfolio application using Ansible

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Portfolio Application - Ansible Deployment"
echo "=========================================="
echo ""

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible is not installed!"
    echo ""
    echo "Install Ansible with:"
    echo "  pip install ansible"
    echo "  or"
    echo "  pip3 install ansible"
    exit 1
fi

echo "✅ Ansible version: $(ansible --version | head -n1)"
echo ""

# Check if inventory is configured
if grep -q "YOUR_SERVER_IP_HERE" inventory/hosts.yml; then
    echo "⚠️  Warning: Inventory not configured!"
    echo ""
    echo "Please edit: ansible/inventory/hosts.yml"
    echo "Replace 'YOUR_SERVER_IP_HERE' with your actual server IP/hostname"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Test connectivity
echo "Testing SSH connectivity..."
if ansible all -m ping > /dev/null 2>&1; then
    echo "✅ SSH connectivity successful"
else
    echo "❌ SSH connectivity failed!"
    echo ""
    echo "Please verify:"
    echo "  1. Server IP/hostname in inventory/hosts.yml"
    echo "  2. SSH key is configured correctly"
    echo "  3. Server is reachable"
    echo ""
    echo "Test manually with: ansible all -m ping"
    exit 1
fi

echo ""
echo "=========================================="
echo "Deployment Options:"
echo "=========================================="
echo "1) Deploy full application"
echo "2) Deploy only backend"
echo "3) Deploy only frontend"
echo "4) Check deployment status"
echo "5) View logs"
echo "6) Stop all containers"
echo "7) Cleanup (remove all)"
echo "0) Exit"
echo ""
read -p "Select option: " option

case $option in
    1)
        echo ""
        echo "🚀 Deploying full portfolio application..."
        ansible-playbook playbooks/deploy-portfolio.yml
        ;;
    2)
        echo ""
        echo "🚀 Deploying backend only..."
        ansible-playbook playbooks/deploy-portfolio.yml --tags "backend"
        ;;
    3)
        echo ""
        echo "🚀 Deploying frontend only..."
        ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend"
        ;;
    4)
        echo ""
        ansible-playbook playbooks/check-status.yml
        ;;
    5)
        echo ""
        ansible-playbook playbooks/view-logs.yml
        ;;
    6)
        echo ""
        read -p "Stop all portfolio containers? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ansible-playbook playbooks/stop-portfolio.yml
        fi
        ;;
    7)
        echo ""
        echo "⚠️  WARNING: This will remove all containers, networks, and data!"
        read -p "Are you sure? (yes/no) " confirm
        if [[ $confirm == "yes" ]]; then
            ansible-playbook playbooks/cleanup-portfolio.yml
        else
            echo "Cleanup cancelled"
        fi
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "✅ Operation complete!"
echo "=========================================="
