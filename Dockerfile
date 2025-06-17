FROM ros:humble

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and setup repositories
RUN apt update && apt install -y \
    lsb-release \
    wget \
    gnupg \
    software-properties-common \
    && apt clean

# Add Gazebo Garden repository (recommended for ROS 2 Humble)
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

# Install VNC and desktop environment
RUN apt update && apt install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    supervisor \
    && apt clean

# Update packages and install Gazebo Garden and ROS 2 packages
RUN apt update && apt install -y \
    gz-garden \
    ros-humble-ros-gz-sim \
    ros-humble-ros-gz-bridge \
    ros-humble-xacro \
    python3-colcon-common-extensions \
    build-essential \
    && apt clean

# Set up VNC
RUN mkdir /root/.vnc
RUN echo "crazyflie" | vncpasswd -f > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd

# Create xstartup file for VNC
RUN echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

# Set up supervisor configuration
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set up ROS 2 workspace
RUN mkdir -p /root/ros2_ws/src
WORKDIR /root/ros2_ws

COPY ./src ./src
RUN . /opt/ros/humble/setup.sh && colcon build

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Set display
ENV DISPLAY=:1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
