# Chapter 04: Platform, DDS Middleware & Real-Time Programming

Notes and configuration profiles for DDS middleware tuning and real-time C++ execution in ROS 2.

## Files
- `dds_profiles/cyclonedds.xml`: CycloneDDS configuration for high-bandwidth point clouds.
- `dds_profiles/fastdds.xml`: FastDDS configuration enabling Shared Memory (SHM) transport.
- `src/realtime_node_template.cpp`: C++ node template showing `mlockall` memory locking, `SCHED_FIFO` real-time thread priority, and zero-copy message loaning.

## Setting DDS Providers

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
