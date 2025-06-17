from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription
from launch.conditions import IfCondition, UnlessCondition
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration, PathJoinSubstitution
from launch_ros.actions import Node
from launch_ros.substitutions import FindPackageShare
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    # Get the package directory
    pkg_share = FindPackageShare(package='crazyflie_sim').find('crazyflie_sim')
    
    # Define launch arguments
    x_pos = LaunchConfiguration('x', default='0.0')
    y_pos = LaunchConfiguration('y', default='0.0')
    z_pos = LaunchConfiguration('z', default='0.5')
    headless = LaunchConfiguration('headless', default='false')
    gui = LaunchConfiguration('gui', default='true')
    
    # Path to URDF file
    urdf_file = os.path.join(pkg_share, 'urdf', 'crazyflie.urdf')
    
    # Declare launch arguments
    declare_x_cmd = DeclareLaunchArgument(
        'x',
        default_value='0.0',
        description='X position of the Crazyflie'
    )
    
    declare_y_cmd = DeclareLaunchArgument(
        'y',
        default_value='0.0',
        description='Y position of the Crazyflie'
    )
    
    declare_z_cmd = DeclareLaunchArgument(
        'z',
        default_value='0.5',
        description='Z position of the Crazyflie'
    )
    
    declare_headless_cmd = DeclareLaunchArgument(
        'headless',
        default_value='false',
        description='Run Gazebo in headless mode (server only)'
    )
    
    declare_gui_cmd = DeclareLaunchArgument(
        'gui',
        default_value='true',
        description='Launch Gazebo GUI'
    )
    
    # Start Gazebo with GUI
    start_gazebo_gui_cmd = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([
                FindPackageShare('ros_gz_sim'),
                'launch',
                'gz_sim.launch.py'
            ])
        ]),
        launch_arguments={
            'gz_args': ['-r empty.sdf'],
            'gui': gui
        }.items(),
        condition=UnlessCondition(headless)
    )
    
    # Start Gazebo headless (server only)
    start_gazebo_headless_cmd = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([
                FindPackageShare('ros_gz_sim'),
                'launch',
                'gz_sim.launch.py'
            ])
        ]),
        launch_arguments={
            'gz_args': ['-r -s empty.sdf'],
            'gui': 'false'
        }.items(),
        condition=IfCondition(headless)
    )
    
    # Spawn Crazyflie
    spawn_crazyflie_cmd = Node(
        package='ros_gz_sim',
        executable='create',
        arguments=[
            '-file', urdf_file,
            '-name', 'crazyflie',
            '-x', x_pos,
            '-y', y_pos,
            '-z', z_pos
        ],
        output='screen'
    )
    
    # Create the launch description and populate
    ld = LaunchDescription()
    
    # Add launch arguments
    ld.add_action(declare_x_cmd)
    ld.add_action(declare_y_cmd)
    ld.add_action(declare_z_cmd)
    ld.add_action(declare_headless_cmd)
    ld.add_action(declare_gui_cmd)
    
    # Add the actions to launch Gazebo and spawn the drone
    ld.add_action(start_gazebo_gui_cmd)
    ld.add_action(start_gazebo_headless_cmd)
    ld.add_action(spawn_crazyflie_cmd)
    
    return ld 