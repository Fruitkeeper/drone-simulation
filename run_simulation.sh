#!/bin/bash

# Crazyflie Simulation Runner
echo "🚁 Starting Crazyflie Simulation..."

# Default values  
X_POS=${1:-0.0}
Y_POS=${2:-0.0}
Z_POS=${3:-0.5}
HEADLESS=${4:-false}

if [ "$HEADLESS" = "true" ]; then
    echo "Running in headless mode (no GUI)"
    HEADLESS_ARG="headless:=true"
else
    echo "Running with GUI - make sure XQuartz is configured!"
    echo "Run './setup_display.sh' first if you haven't already."
    HEADLESS_ARG="headless:=false"
fi

echo "Spawning Crazyflie at position: ($X_POS, $Y_POS, $Z_POS)"

# Run the simulation
docker-compose run --rm cf_sim bash -c "
    source /opt/ros/humble/setup.bash && 
    source install/setup.bash && 
    ros2 launch crazyflie_sim spawn_cf.launch.py x:=$X_POS y:=$Y_POS z:=$Z_POS $HEADLESS_ARG
" 