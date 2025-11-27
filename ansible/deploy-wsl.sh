#!/bin/bash
# Ansible-style deployment using Docker in WSL
# This deploys the portfolio on different ports than Docker/K8s deployments

echo ""
echo "=========================================================="
echo "  ANSIBLE DEPLOYMENT (Running in WSL)"
echo "=========================================================="
echo ""

# Configuration
NETWORK_NAME="ansible-portfolio-network"
MYSQL_CONTAINER="ansible-portfolio-mysql"
BACKEND_CONTAINER="ansible-portfolio-backend"
FRONTEND_CONTAINER="ansible-portfolio-frontend"

FRONTEND_IMAGE="pratyushpandey/portfoliofrontend:latest"
BACKEND_IMAGE="pratyushpandey/portfoliobackend:latest"
MYSQL_IMAGE="mysql:8.0"

MYSQL_PASSWORD="@Pratyush123"
MYSQL_DATABASE="portfolio_db"

# Ports (different from Docker and K8s deployments)
FRONTEND_PORT=3000
BACKEND_PORT=3070
MYSQL_PORT=3307

echo "Step 1/6: Creating Docker network..."
if docker network inspect $NETWORK_NAME >/dev/null 2>&1; then
    echo "  Network already exists"
else
    docker network create $NETWORK_NAME
    echo "  Network created"
fi
echo ""

echo "Step 2/6: Cleaning up old containers..."
docker stop $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER 2>/dev/null
docker rm $FRONTEND_CONTAINER $BACKEND_CONTAINER $MYSQL_CONTAINER 2>/dev/null
echo "  Cleanup complete"
echo ""

echo "Step 3/6: Deploying MySQL..."
docker run -d \
    --name $MYSQL_CONTAINER \
    --network $NETWORK_NAME \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE \
    -v ansible-portfolio-mysql-data:/var/lib/mysql \
    -p $MYSQL_PORT:3306 \
    --restart unless-stopped \
    $MYSQL_IMAGE

if [ $? -eq 0 ]; then
    echo "  MySQL container started"
    echo "  Waiting for MySQL to initialize..."
    sleep 15
else
    echo "  ERROR: Failed to start MySQL"
    exit 1
fi
echo ""

echo "Step 4/6: Deploying Backend..."
docker run -d \
    --name $BACKEND_CONTAINER \
    --network $NETWORK_NAME \
    -e SPRING_DATASOURCE_URL="jdbc:mysql://${MYSQL_CONTAINER}:3306/${MYSQL_DATABASE}?useSSL=false&allowPublicKeyRetrieval=true" \
    -e SPRING_DATASOURCE_USERNAME=root \
    -e SPRING_DATASOURCE_PASSWORD=$MYSQL_PASSWORD \
    -p $BACKEND_PORT:8070 \
    --restart unless-stopped \
    $BACKEND_IMAGE

if [ $? -eq 0 ]; then
    echo "  Backend container started"
    echo "  Waiting for backend to initialize..."
    sleep 10
else
    echo "  ERROR: Failed to start Backend"
    exit 1
fi
echo ""

echo "Step 5/6: Deploying Frontend..."
docker run -d \
    --name $FRONTEND_CONTAINER \
    --network $NETWORK_NAME \
    -p $FRONTEND_PORT:80 \
    --restart unless-stopped \
    $FRONTEND_IMAGE

if [ $? -eq 0 ]; then
    echo "  Frontend container started"
    sleep 5
else
    echo "  ERROR: Failed to start Frontend"
    exit 1
fi
echo ""

echo "Step 6/6: Verifying deployment..."
echo ""
docker ps --filter "name=ansible-portfolio-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "=========================================================="
echo "  DEPLOYMENT COMPLETE!"
echo "=========================================================="
echo ""
echo "Access your portfolio:"
echo "  Frontend: http://localhost:$FRONTEND_PORT"
echo "  Backend:  http://localhost:$BACKEND_PORT/api/portfolio/health"
echo ""
echo "From Windows, access via WSL IP:"
WSL_IP=$(hostname -I | awk '{print $1}')
echo "  Frontend: http://$WSL_IP:$FRONTEND_PORT"
echo "  Backend:  http://$WSL_IP:$BACKEND_PORT/api/portfolio/health"
echo ""
echo "=========================================================="
echo ""
