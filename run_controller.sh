#!/bin/bash

echo "🎮 Starting Crazyflie Controller..."
echo "Make sure the simulation is running first!"
echo "=================================="

# Run the controller
docker-compose run --rm cf_sim bash -c "
    source /opt/ros/humble/setup.bash && 
    source install/setup.bash && 
    ros2 run crazyflie_sim control_crazyflie.py
" 