# Chapter 04: Platform, DDS Middleware & Real-Time Programming

Notes, configuration profiles, and compilable code for DDS middleware tuning and deterministic real-time C++ execution in ROS 2.

## Files
- `dds_profiles/cyclonedds.xml`: CycloneDDS configuration for high-bandwidth point clouds.
- `dds_profiles/fastdds.xml`: FastDDS configuration enabling Shared Memory (SHM) transport.
- `src/realtime_node_template.cpp`: C++ node template showing `mlockall` memory locking, `SCHED_FIFO` real-time thread priority, and zero-copy message loaning.
- `CMakeLists.txt` & `package.xml`: Native build manifests for `autoware_platform_demo`.

---

## Build and Run

```bash
mkdir -p ~/ros2_ws/src
cp -r Chapter_04_Platform ~/ros2_ws/src/autoware_platform_demo
cd ~/ros2_ws
source /opt/ros/foxy/setup.bash
colcon build --packages-select autoware_platform_demo
source install/setup.bash

# Run real-time node natively
ros2 run autoware_platform_demo realtime_control_node
```

---

## Setting DDS Middleware Providers

### CycloneDDS
```bash
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file://$(pwd)/dds_profiles/cyclonedds.xml
```

### FastDDS
```bash
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export FASTRTPS_DEFAULT_PROFILES_FILE=$(pwd)/dds_profiles/fastdds.xml
```
