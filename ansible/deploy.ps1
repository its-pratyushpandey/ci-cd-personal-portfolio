# Portfolio Ansible Deployment Script for Windows
# Run this from PowerShell

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Portfolio Application - Ansible Deployment" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Ansible is installed
try {
    $ansibleVersion = ansible --version 2>$null | Select-Object -First 1
    Write-Host "OK Ansible installed: $ansibleVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Ansible is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install Ansible with:" -ForegroundColor Yellow
    Write-Host "  pip install ansible" -ForegroundColor White
    Write-Host "  or use WSL (Windows Subsystem for Linux)" -ForegroundColor White
    exit 1
}

Write-Host ""

# Check inventory configuration
$inventoryContent = Get-Content "inventory/hosts.yml" -Raw
if ($inventoryContent -match "YOUR_SERVER_IP_HERE") {
    Write-Host "WARNING: Inventory not configured!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please edit: ansible/inventory/hosts.yml" -ForegroundColor Yellow
    Write-Host "Replace 'YOUR_SERVER_IP_HERE' with your actual server IP/hostname" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

# Test connectivity
Write-Host "Testing SSH connectivity..." -ForegroundColor Yellow
try {
    ansible all -m ping | Out-Null
    Write-Host "OK SSH connectivity successful" -ForegroundColor Green
} catch {
    Write-Host "ERROR: SSH connectivity failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please verify:" -ForegroundColor Yellow
    Write-Host "  1. Server IP/hostname in inventory/hosts.yml"
    Write-Host "  2. SSH key is configured correctly"
    Write-Host "  3. Server is reachable"
    Write-Host ""
    Write-Host "Test manually with: ansible all -m ping" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Deployment Options:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "1) Deploy full application"
Write-Host "2) Deploy only backend"
Write-Host "3) Deploy only frontend"
Write-Host "4) Check deployment status"
Write-Host "5) View logs"
Write-Host "6) Stop all containers"
Write-Host "7) Cleanup (remove all)"
Write-Host "0) Exit"
Write-Host ""

$option = Read-Host "Select option"

switch ($option) {
    "1" {
        Write-Host ""
        Write-Host "Deploying full portfolio application..." -ForegroundColor Green
        ansible-playbook playbooks/deploy-portfolio.yml
    }
    "2" {
        Write-Host ""
        Write-Host "Deploying backend only..." -ForegroundColor Green
        ansible-playbook playbooks/deploy-portfolio.yml --tags "backend"
    }
    "3" {
        Write-Host ""
        Write-Host "Deploying frontend only..." -ForegroundColor Green
        ansible-playbook playbooks/deploy-portfolio.yml --tags "frontend"
    }
    "4" {
        Write-Host ""
        ansible-playbook playbooks/check-status.yml
    }
    "5" {
        Write-Host ""
        ansible-playbook playbooks/view-logs.yml
    }
    "6" {
        Write-Host ""
        $confirm = Read-Host "Stop all portfolio containers? (y/n)"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            ansible-playbook playbooks/stop-portfolio.yml
        }
    }
    "7" {
        Write-Host ""
        Write-Host "WARNING: This will remove all containers, networks, and data!" -ForegroundColor Red
        $confirm = Read-Host "Are you sure? (yes/no)"
        if ($confirm -eq "yes") {
            ansible-playbook playbooks/cleanup-portfolio.yml
        } else {
            Write-Host "Cleanup cancelled" -ForegroundColor Yellow
        }
    }
    "0" {
        Write-Host "Exiting..." -ForegroundColor Gray
        exit 0
    }
    default {
        Write-Host "Invalid option" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Operation complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
