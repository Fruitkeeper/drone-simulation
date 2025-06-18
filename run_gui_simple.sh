#!/bin/bash

echo "🖥️ Starting Crazyflie Simulation with GUI..."
echo "==========================================="

# Start the container
echo "🐳 Starting Docker container..."
docker-compose up -d

# Wait for container to be ready
echo "⏳ Waiting for container to start..."
sleep 5

# Start VNC server manually
echo "🖥️ Starting VNC server..."
docker-compose exec -d cf_sim vncserver :1 -geometry 1280x800 -depth 24

# Wait for VNC to start
sleep 3

# Start noVNC web interface
echo "🌐 Starting web interface..."
docker-compose exec -d cf_sim /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080

# Wait for services to be ready
sleep 5

# Launch the simulation
echo "🚀 Launching Gazebo simulation..."
docker-compose exec -d cf_sim bash -c "
    export DISPLAY=:1 &&
    source /opt/ros/humble/setup.bash && 
    source install/setup.bash && 
    ros2 launch crazyflie_sim spawn_cf.launch.py headless:=false
"

echo ""
echo "✅ Setup complete!"
echo "🌐 Open your web browser and go to:"
echo "   http://localhost:6080"
echo ""
echo "🔑 VNC password: crazyflie"
echo ""
echo "🛑 To stop the simulation, run:"
echo "   docker-compose down" 