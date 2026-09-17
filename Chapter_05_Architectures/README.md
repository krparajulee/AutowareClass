# Chapter 05: Autonomous Driving Stack Architectures

Example showing modular node composition (`rclcpp_components`) and ROS 2 Python launch files.

## Files
- `src/perception_component.cpp`: Perception component publishing obstacle detections.
- `src/planner_component.cpp`: Motion planner component subscribing to obstacles and generating commands.
- `launch/autoware_architecture.launch.py`: Launch file that loads both components into a single container process.

## Running
```bash
ros2 launch autoware_architecture.launch.py
```
