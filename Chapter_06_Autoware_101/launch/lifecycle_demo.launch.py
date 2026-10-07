"""
lifecycle_demo.launch.py
ROS 2 Python Launch File for Lifecycle Managed Node State Transitions
Modernized for ROS 2 Foxy / Humble
"""

from launch import LaunchDescription
from launch_ros.actions import LifecycleNode


def generate_launch_description():
    """Generate launch description for managed lifecycle node."""
    
    lifecycle_node = LifecycleNode(
        package='autoware_lifecycle_demo',
        executable='lifecycle_node_demo',
        name='autoware_managed_sensor',
        namespace='',
        output='screen'
    )

    return LaunchDescription([
        lifecycle_node
    ])
