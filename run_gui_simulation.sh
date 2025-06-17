#!/bin/bash

echo "🖥️ Starting Crazyflie Simulation with GUI..."
echo "==========================================="

# Default values  
X_POS=${1:-0.0}
Y_POS=${2:-0.0}
Z_POS=${3:-0.5}

echo "🚁 Spawning Crazyflie at position: ($X_POS, $Y_POS, $Z_POS)"
echo ""
echo "🌐 Starting VNC server and web interface..."
echo "   - VNC will be available on port 5901"
echo "   - Web GUI will be available at: http://localhost:6080"
echo "   - VNC password: crazyflie"
echo ""

# Start the container with VNC
docker-compose up -d

echo "⏳ Waiting for VNC server to start..."
sleep 10

# Launch the simulation
echo "🚀 Launching Gazebo simulation..."
docker-compose exec cf_sim bash -c "
    export DISPLAY=:1 &&
    source /opt/ros/humble/setup.bash && 
    source install/setup.bash && 
    ros2 launch crazyflie_sim spawn_cf.launch.py x:=$X_POS y:=$Y_POS z:=$Z_POS headless:=false &
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