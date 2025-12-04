#!/bin/bash
# Quick update script for EC2 backend
# Run: ssh -i key.pem ec2-user@3.129.138.4 < update_backend.sh

set -e

echo "=== Updating Beautiful Hair Backend ==="

# Navigate to backend
cd /home/ubuntu/backend

# Pull latest changes
echo "Pulling latest code..."
git pull origin main

# Install any new dependencies
echo "Installing dependencies..."
source .venv/bin/activate
pip install -q -r requirements.txt

# Restart the service
echo "Restarting backend service..."
sudo systemctl restart backend

# Wait a moment for service to restart
sleep 2

# Check if service is running
if sudo systemctl is-active --quiet backend; then
    echo "✓ Backend service restarted successfully"
else
    echo "✗ Backend service failed to start"
    sudo systemctl status backend
    exit 1
fi

echo "=== Update complete ==="
