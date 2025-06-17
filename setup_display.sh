#!/bin/bash

echo "🖥️  Setting up X11 Display for Gazebo GUI..."

# Get local IP address
LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')
echo "Local IP: $LOCAL_IP"

# Start XQuartz if not running
if ! pgrep -x "Xquartz" > /dev/null; then
    echo "Starting XQuartz..."
    open -a XQuartz
    sleep 5
    
    # Wait for XQuartz to be ready
    echo "Waiting for XQuartz to start..."
    while ! pgrep -x "Xquartz" > /dev/null; do
        sleep 1
    done
fi

# Configure XQuartz settings
echo "Configuring X11 permissions..."
xhost +localhost
xhost +$LOCAL_IP

# Export DISPLAY for local use
export DISPLAY=:0

# Create environment file for Docker
echo "DISPLAY=$LOCAL_IP:0" > .env
echo "LOCAL_IP=$LOCAL_IP" >> .env

echo "✅ Display setup complete!"
echo "Local IP: $LOCAL_IP"
echo "DISPLAY set to: $LOCAL_IP:0"
echo ""
echo "Now you can run the simulation with GUI:"
echo "./run_simulation.sh"
echo ""
echo "Or with custom position:"
echo "./run_simulation.sh 1.0 2.0 0.5" 