#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import time

class CrazyflieController(Node):
    def __init__(self):
        super().__init__('crazyflie_controller')
        
        # Create publisher for velocity commands
        self.cmd_vel_pub = self.create_publisher(
            Twist, 
            '/model/crazyflie/cmd_vel', 
            10
        )
        
        self.get_logger().info('Crazyflie Controller initialized!')
        self.get_logger().info('Publishing velocity commands...')
        
        # Create timer for periodic commands
        self.timer = self.create_timer(0.1, self.publish_commands)
        self.start_time = time.time()
        
    def publish_commands(self):
        msg = Twist()
        current_time = time.time() - self.start_time
        
        # Simple flight pattern: hover and rotate
        if current_time < 5.0:
            # Takeoff
            msg.linear.z = 0.5
            self.get_logger().info('Taking off...')
        elif current_time < 10.0:
            # Hover
            msg.linear.z = 0.0
            self.get_logger().info('Hovering...')
        elif current_time < 15.0:
            # Rotate
            msg.angular.z = 0.5
            self.get_logger().info('Rotating...')
        else:
            # Land
            msg.linear.z = -0.2
            self.get_logger().info('Landing...')
            
        self.cmd_vel_pub.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    
    controller = CrazyflieController()
    
    try:
        rclpy.spin(controller)
    except KeyboardInterrupt:
        pass
    
    controller.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main() 