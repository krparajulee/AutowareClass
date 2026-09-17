# Chapter 01: Development Environment & Object Detection Demo

This chapter modernizes the development environment setup and canonical LiDAR object detection pipeline from Lecture 1.

## Side-by-Side Comparison
- **Original Lecture Material**: See [`ORIGINAL_devenv.md`](./ORIGINAL_devenv.md) and [`ORIGINAL_devenv2.md`](./ORIGINAL_devenv2.md) for the original Dashing-based instructions.
- **Updated Material**: The commands below and [`run_demo.sh`](./run_demo.sh) update the broken Dashing CLI remappings to ROS 2 Foxy / Humble standards.

---

## What Changed: Dashing vs Foxy CLI Flags
In Dashing, node remappings and parameters were passed using `__ns:=` and `__params:=` directly:
```bash
ros2 run velodyne_nodes velodyne_cloud_node_exe __ns:=/lidar_front __params:=path/to/params.yaml
```
In Foxy and newer ROS 2 releases, passing double-underscore arguments directly causes launch errors. Modern ROS 2 requires `--ros-args`:
```bash
ros2 run velodyne_nodes velodyne_cloud_node_exe --ros-args -r __ns:=/lidar_front --params-file path/to/params.yaml
```

---

## Option A: Step-by-Step Terminal Commands (Original Course Sequence, Modernized)

Open separate terminal windows inside ADE (`krp@ade:~$`) for each step:

### Terminal 1: LiDAR PCAP Replay
```bash
python3 /home/krp/pcap_player.py --speed 0.1
# Or: udpreplay ~/data/route_small_loop_rw-127.0.0.1.pcap
```

### Terminal 2: Velodyne Driver Node
```bash
source /opt/ros/foxy/setup.bash
source /opt/AutowareAuto/setup.bash
ros2 run velodyne_nodes velodyne_cloud_node_exe \
    --ros-args -r __ns:=/lidar_front \
    --params-file ./velodyne_node.param.yaml
```

### Terminal 3: PointCloud Filter Transform Node
```bash
source /opt/ros/foxy/setup.bash
source /opt/AutowareAuto/setup.bash
ros2 run point_cloud_filter_transform_nodes point_cloud_filter_transform_node_exe \
    --ros-args -r __ns:=/lidar_front \
    -r __node:=filter_transform_vlp16_front \
    -r points_filtered:=/perception/points_in \
    --params-file /opt/AutowareAuto/share/point_cloud_filter_transform_nodes/param/vlp16_sim_lexus_filter_transform.param.yaml
```

### Terminal 4: Ray Ground Classifier Node
```bash
source /opt/ros/foxy/setup.bash
source /opt/AutowareAuto/setup.bash
ros2 run ray_ground_classifier_nodes ray_ground_classifier_cloud_node_exe \
    --ros-args -r __ns:=/perception \
    --params-file /opt/AutowareAuto/share/autoware_auto_avp_demo/param/ray_ground_classifier.param.yaml
```

### Terminal 5: Euclidean Cluster Node
```bash
source /opt/ros/foxy/setup.bash
source /opt/AutowareAuto/setup.bash
ros2 run euclidean_cluster_nodes euclidean_cluster_exe \
    --ros-args -r __ns:=/perception \
    --params-file /opt/AutowareAuto/share/autoware_auto_avp_demo/param/euclidean_cluster.param.yaml
```

### Terminal 6: Robot State Publisher (3D Lexus Model)
```bash
source /opt/ros/foxy/setup.bash
source /opt/AutowareAuto/setup.bash
ros2 run robot_state_publisher robot_state_publisher \
    /opt/AutowareAuto/share/lexus_rx_450h_description/urdf/lexus_rx_450h.urdf
```

### Terminal 7: RViz 2 Visualizer
```bash
source /opt/ros/foxy/setup.bash
rviz2 -d ./aw_class2020.rviz
```

---

## Option B: All-in-One Runner Script
Instead of opening 7 terminals manually, run:
```bash
./run_demo.sh
```

---

## Files Included
- [`ORIGINAL_devenv.md`](./ORIGINAL_devenv.md): Unmodified original course setup file.
- [`ORIGINAL_devenv2.md`](./ORIGINAL_devenv2.md): Unmodified original course instructions file.
- [`run_demo.sh`](./run_demo.sh): Automated pipeline runner script.
- [`velodyne_node.param.yaml`](./velodyne_node.param.yaml): Sensor configuration file.
- [`aw_class2020.rviz`](./aw_class2020.rviz): RViz2 visualizer layout.
