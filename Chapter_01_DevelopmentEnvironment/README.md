# Chapter 01: Development Environment & Object Detection Demo

Updates to Lecture 1 setup and the LiDAR object detection pipeline.

## Fixes for ROS 2 Foxy / Humble
In Dashing, node remappings and parameters were passed like this:
```bash
ros2 run pkg node __ns:=/lidar_front __params:=params.yaml
```
In Foxy and newer ROS 2 releases, this syntax fails. It requires `--ros-args`:
```bash
ros2 run pkg node --ros-args -r __ns:=/lidar_front --params-file params.yaml
```

## Files
- `run_demo.sh`: Script that starts Velodyne driver, filter transform, ground classifier, euclidean clusterer, vehicle state publisher, and RViz2.
- `velodyne_node.param.yaml`: Sensor parameter file for VLP-16.
- `aw_class2020.rviz`: Display configuration for RViz2.

## Running the Demo
```bash
source /opt/ros/foxy/setup.bash
source /opt/AutowareAuto/setup.bash
./run_demo.sh
```
