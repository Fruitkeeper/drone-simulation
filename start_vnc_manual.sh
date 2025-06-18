#!/bin/bash

echo "🖥️ Manual VNC Setup for Crazyflie Simulation"
echo "============================================"

# Start container in background
echo "🐳 Starting container..."
docker-compose run -d --name cf_gui --service-ports cf_sim bash -c "sleep infinity"

# Wait for container to be ready
sleep 5

# Start VNC server
echo "🖥️ Starting VNC server..."
docker exec cf_gui vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None

# Start noVNC web interface
echo "🌐 Starting noVNC web interface..."
docker exec -d cf_gui bash -c "cd /usr/share/novnc && python3 -m novnc --listen 6080 --vnc localhost:5901"

# Wait for services to start
sleep 5

# Launch ROS environment and Gazebo
echo "🚀 Starting Gazebo with GUI..."
docker exec -d cf_gui bash -c "
    export DISPLAY=:1 &&
    source /opt/ros/humble/setup.bash && 
    source /root/ros2_ws/install/setup.bash && 
    ros2 launch crazyflie_sim spawn_cf.launch.py headless:=false
"

echo ""
echo "✅ Setup complete!"
echo "🌐 Open your web browser and go to:"
echo "   http://localhost:6080"
echo ""
echo "🔑 Click 'Connect' (no password needed)"
echo ""
echo "🛑 To stop everything:"
echo "   docker stop cf_gui && docker rm cf_gui" 