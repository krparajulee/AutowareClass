"""
autoware_architecture.launch.py
ROS 2 Python Launch File for Composable Node Container Architecture
Modernized for ROS 2 Foxy / Humble
"""

from launch import LaunchDescription
from launch_ros.actions import ComposableNodeContainer
from launch_ros.descriptions import ComposableNode


def generate_launch_description():
    """Generate launch description with composable perception and planning components."""
    
    container = ComposableNodeContainer(
        name='autoware_container',
        namespace='',
        package='rclcpp_components',
        executable='component_container',
        composable_node_descriptions=[
            ComposableNode(
                package='autoware_architecture_demo',
                plugin='autoware_architecture::PerceptionComponent',
                name='perception_node',
                extra_arguments=[{'use_intra_process_comms': True}]
            ),
            ComposableNode(
                package='autoware_architecture_demo',
                plugin='autoware_architecture::PlannerComponent',
                name='planner_node',
                extra_arguments=[{'use_intra_process_comms': True}]
            ),
        ],
        output='screen',
    )

    return LaunchDescription([container])
