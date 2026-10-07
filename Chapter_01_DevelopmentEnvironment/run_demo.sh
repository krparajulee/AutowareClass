#!/usr/bin/env bash
# ==============================================================================
# AutowareClass2020 - Chapter 01: LiDAR Object Detection Pipeline Demo Script
# Modernized for Native Host Execution (No Docker) on ROS 2 Foxy / Humble
# ==============================================================================

set -e

# 1. Source ROS 2 base installation
if [ -f /opt/ros/foxy/setup.bash ]; then
    source /opt/ros/foxy/setup.bash
elif [ -f /opt/ros/humble/setup.bash ]; then
    source /opt/ros/humble/setup.bash
fi

# 2. Source Autoware workspace if available
if [ -f "$HOME/autoware_ws/install/setup.bash" ]; then
    source "$HOME/autoware_ws/install/setup.bash"
elif [ -f "$HOME/AutowareAuto/install/setup.bash" ]; then
    source "$HOME/AutowareAuto/install/setup.bash"
elif [ -f "$HOME/adehome/AutowareAuto/install/setup.bash" ]; then
    source "$HOME/adehome/AutowareAuto/install/setup.bash"
elif [ -f /opt/AutowareAuto/setup.bash ]; then
    source /opt/AutowareAuto/setup.bash
fi

PARAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve PCAP file location
if [ -f "$HOME/data/route_small_loop_rw-127.0.0.1.pcap" ]; then
    PCAP_DATA="$HOME/data/route_small_loop_rw-127.0.0.1.pcap"
elif [ -f "$PARAM_DIR/route_small_loop_rw-127.0.0.1.pcap" ]; then
    PCAP_DATA="$PARAM_DIR/route_small_loop_rw-127.0.0.1.pcap"
else
    PCAP_DATA="$HOME/data/route_small_loop_rw-127.0.0.1.pcap"
fi

# Clean up any previously running demo nodes
killall -9 velodyne_cloud_node_exe robot_state_publisher point_cloud_filter_transform_node_exe ray_ground_classifier_cloud_node_exe euclidean_cluster_node_exe pcap_player.py rviz2 2>/dev/null || true
sleep 1

# Start PCAP streamer
if [ -f "$PARAM_DIR/pcap_player.py" ]; then
    python3 "$PARAM_DIR/pcap_player.py" --speed 0.1 &
elif [ -f "$HOME/pcap_player.py" ]; then
    python3 "$HOME/pcap_player.py" --speed 0.1 &
elif command -v udpreplay &> /dev/null; then
    udpreplay "$PCAP_DATA" &
fi
sleep 1

# Launch Velodyne Driver Node
ros2 run velodyne_nodes velodyne_cloud_node_exe \
    --ros-args -r __ns:=/lidar_front \
    --params-file "$PARAM_DIR/velodyne_node.param.yaml" &
sleep 1

# Locate package share directories dynamically
FILTER_PARAM=$(ros2 pkg prefix point_cloud_filter_transform_nodes 2>/dev/null)/share/point_cloud_filter_transform_nodes/param/vlp16_sim_lexus_filter_transform.param.yaml
AVP_SHARE=$(ros2 pkg prefix autoware_auto_avp_demo 2>/dev/null)/share/autoware_auto_avp_demo/param
LEXUS_URDF=$(ros2 pkg prefix lexus_rx_450h_description 2>/dev/null)/share/lexus_rx_450h_description/urdf/lexus_rx_450h.urdf

# Fallbacks if packages are located in /opt/AutowareAuto
if [ ! -f "$FILTER_PARAM" ]; then
    FILTER_PARAM="/opt/AutowareAuto/share/point_cloud_filter_transform_nodes/param/vlp16_sim_lexus_filter_transform.param.yaml"
fi
if [ ! -d "$AVP_SHARE" ]; then
    AVP_SHARE="/opt/AutowareAuto/share/autoware_auto_avp_demo/param"
fi
if [ ! -f "$LEXUS_URDF" ]; then
    LEXUS_URDF="/opt/AutowareAuto/share/lexus_rx_450h_description/urdf/lexus_rx_450h.urdf"
fi

# Launch Point Cloud Filter Transform Node
ros2 run point_cloud_filter_transform_nodes point_cloud_filter_transform_node_exe \
    --ros-args -r __ns:=/lidar_front \
    -r __node:=filter_transform_vlp16_front \
    -r points_filtered:=/perception/points_in \
    --params-file "$FILTER_PARAM" &
sleep 1

# Launch Ray Ground Classifier Node
ros2 run ray_ground_classifier_nodes ray_ground_classifier_cloud_node_exe \
    --ros-args -r __ns:=/perception \
    --params-file "$AVP_SHARE/ray_ground_classifier.param.yaml" &
sleep 1

# Launch Euclidean Cluster Node
ros2 run euclidean_cluster_nodes euclidean_cluster_exe \
    --ros-args -r __ns:=/perception \
    --params-file "$AVP_SHARE/euclidean_cluster.param.yaml" &
sleep 1

# Launch Robot State Publisher
if [ -f "$LEXUS_URDF" ]; then
    ros2 run robot_state_publisher robot_state_publisher "$LEXUS_URDF" &
    sleep 1
fi

# Launch RViz 2 Visualizer
rviz2 -d "$PARAM_DIR/aw_class2020.rviz"
