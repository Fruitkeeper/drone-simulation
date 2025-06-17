FROM ros:humble

ENV DEBIAN_FRONTEND=noninteractive

# Install Gazebo Garden and ROS 2 tools
RUN apt update && apt install -y \
    gazebo \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-xacro \
    python3-colcon-common-extensions \
    build-essential \
    x11-apps \
    && apt clean

# Set up ROS 2 workspace
RUN mkdir -p /root/ros2_ws/src
WORKDIR /root/ros2_ws

COPY ./src ./src
RUN . /opt/ros/humble/setup.sh && colcon build

ENV DISPLAY=:0
CMD ["bash"]
