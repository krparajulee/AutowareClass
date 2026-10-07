# Chapter 05: Autonomous Driving Stack Architectures

Modular node composition (`rclcpp_components`) and ROS 2 Python launch files running natively.

## Files
- `src/perception_component.cpp`: Perception component publishing obstacle detections.
- `src/planner_component.cpp`: Motion planner component subscribing to obstacles and generating commands.
- `launch/autoware_architecture.launch.py`: Launch file loading both components into a single container process.
- `CMakeLists.txt` & `package.xml`: Native build manifests for `autoware_architecture_demo`.

---

## Build and Run

```bash
mkdir -p ~/ros2_ws/src
cp -r Chapter_05_Architectures ~/ros2_ws/src/autoware_architecture_demo
cd ~/ros2_ws
source /opt/ros/foxy/setup.bash
colcon build --packages-select autoware_architecture_demo
source install/setup.bash

# Launch composable container natively
ros2 launch autoware_architecture_demo autoware_architecture.launch.py
```
