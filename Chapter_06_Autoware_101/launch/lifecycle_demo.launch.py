"""
lifecycle_demo.launch.py
ROS 2 Python Launch File for Lifecycle Managed Node State Transitions
Modernized for ROS 2 Foxy / Humble
"""

from launch import LaunchDescription
from launch_ros.actions import LifecycleNode
import launch_ros.events.lifecycle
import launch.actions
import launch.events


def generate_launch_description():
    """Generate launch description for managed lifecycle node."""
    
    lifecycle_node = LifecycleNode(
        package='autoware_lifecycle_demo',
        executable='lifecycle_node_demo',
        name='autoware_managed_sensor',
        namespace='',
        output='screen'
    )

    # Automatically transition from Unconfigured -> Inactive (configure)
    emit_configure_event = launch.actions.EmitEvent(
        event=launch_ros.events.lifecycle.ChangeState(
            lifecycle_node_matcher=launch.events.matches_action(lifecycle_node),
            transition_id=lifecycle_msgs.msg.Transition.TRANSITION_CONFIGURE,
        )
    ) if hasattr(launch_ros.events.lifecycle, 'Transition') else None

    return LaunchDescription([
        lifecycle_node
    ])
