#!/bin/bash

# Deploy script for GP backend
# This script is run by the CI/CD pipeline to deploy the latest changes

set -e  # Exit on any error

echo "Starting deployment..."

# Navigate to backend directory and pull latest changes
echo "Pulling latest changes from repository..."
cd /home/ubuntu/backend
git pull origin main

echo "Restarting backend service..."
sudo systemctl restart backend

echo "Restarting nginx..."
sudo systemctl restart nginx

echo "Deployment completed successfully!"
