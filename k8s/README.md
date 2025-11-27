# Kubernetes Manifests

This directory contains all Kubernetes deployment configurations for the Portfolio application.

## Files

- **namespace.yaml** - Creates the `portfolio` namespace
- **mysql-deployment.yaml** - MySQL database deployment, service, and persistent storage
- **backend-deployment.yaml** - Spring Boot backend deployment and ClusterIP service
- **frontend-deployment.yaml** - React frontend deployment and LoadBalancer service

## Quick Deploy

```powershell
# Apply in order
kubectl apply -f namespace.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

# Check status
kubectl get all -n portfolio
```

## Clean Up

```powershell
kubectl delete namespace portfolio
```

This will remove all resources including the MySQL persistent volume.
