#!/bin/bash

echo "🔍 Monitoring Crazyflie Simulation..."
echo "=================================="

# Check if simulation is running
docker ps --filter "name=crazyflie_sim" --format "table {{.Names}}\t{{.Status}}" | head -2

echo ""
echo "Available ROS 2 topics:"
echo "======================"

# Run monitoring commands in Docker
docker-compose run --rm cf_sim bash -c "
    source /opt/ros/humble/setup.bash && 
    source install/setup.bash && 
    echo 'ROS 2 Topics:' &&
    ros2 topic list &&
    echo '' &&
    echo 'Node information:' &&
    ros2 node list &&
    echo '' &&
    echo 'Transform tree:' &&
    ros2 run tf2_tools view_frames.py --wait-for-transform-timeout 2.0 2>/dev/null || echo 'No transforms available yet' &&
    echo '' &&
    echo 'To monitor pose continuously, run:' &&
    echo 'ros2 topic echo /model/crazyflie/pose'
" 