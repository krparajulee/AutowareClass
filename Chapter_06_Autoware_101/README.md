# Chapter 06: Autoware 101 & Lifecycle Nodes

Implementation of ROS 2 Managed Lifecycle Nodes (`rclcpp_lifecycle`) for Autoware state management.

## Files
- `src/lifecycle_node_demo.cpp`: Node implementing `on_configure`, `on_activate`, `on_deactivate`, and `on_cleanup` state transitions.
- `launch/lifecycle_demo.launch.py`: Launch script for managing lifecycle nodes.

## Usage

### 1. Launch Node
```bash
ros2 launch lifecycle_demo.launch.py
```

### 2. Control Lifecycle via CLI
In another terminal:
```bash
ros2 lifecycle get /autoware_managed_sensor
ros2 lifecycle set /autoware_managed_sensor configure
ros2 lifecycle set /autoware_managed_sensor activate
ros2 lifecycle set /autoware_managed_sensor deactivate
```
