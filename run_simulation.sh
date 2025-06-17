#!/bin/bash

# Crazyflie Simulation Runner
echo "🚁 Starting Crazyflie Simulation..."

# Default values  
X_POS=${1:-0.0}
Y_POS=${2:-0.0}
Z_POS=${3:-0.5}

echo "Spawning Crazyflie at position: ($X_POS, $Y_POS, $Z_POS)"

# Run the simulation
docker-compose run --rm cf_sim bash -c "
    source /opt/ros/humble/setup.bash && 
    source install/setup.bash && 
    ros2 launch crazyflie_sim spawn_cf.launch.py x:=$X_POS y:=$Y_POS z:=$Z_POS
" 