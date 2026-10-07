# Chapter 06: Autoware 101 & Lifecycle Nodes

Implementation of ROS 2 Managed Lifecycle Nodes (`rclcpp_lifecycle`) for Autoware state management, running natively on your system.

## Files
- `src/lifecycle_node_demo.cpp`: Node implementing `on_configure`, `on_activate`, `on_deactivate`, and `on_cleanup` state transitions.
- `launch/lifecycle_demo.launch.py`: Launch script for managing lifecycle nodes.
- `CMakeLists.txt` & `package.xml`: Native build manifests for `autoware_lifecycle_demo`.

---

## Build and Run

```bash
mkdir -p ~/ros2_ws/src
cp -r Chapter_06_Autoware_101 ~/ros2_ws/src/autoware_lifecycle_demo
cd ~/ros2_ws
source /opt/ros/foxy/setup.bash
colcon build --packages-select autoware_lifecycle_demo
source install/setup.bash

# 1. Launch the Lifecycle Node
ros2 launch autoware_lifecycle_demo lifecycle_demo.launch.py
```

### 2. Control Lifecycle State via CLI
In a second terminal:

```bash
# Check current state (starts Unconfigured)
ros2 lifecycle get /autoware_managed_sensor

# Transition to Inactive (allocates publishers and memory)
ros2 lifecycle set /autoware_managed_sensor configure

# Transition to Active (begins publishing sensor data)
ros2 lifecycle set /autoware_managed_sensor activate

# Transition to Inactive (pauses publication)
ros2 lifecycle set /autoware_managed_sensor deactivate

# Clean up back to Unconfigured
ros2 lifecycle set /autoware_managed_sensor cleanup
```
