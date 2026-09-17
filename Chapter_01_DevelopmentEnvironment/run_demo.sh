#!/usr/bin/env bash
# AutowareClass2020 Lecture 1 LiDAR Demo Script
# Updated for ROS 2 Foxy/Humble remapping syntax (--ros-args)

set -e

if [ -f /opt/ros/foxy/setup.bash ]; then
    source /opt/ros/foxy/setup.bash
fi

if [ -f /opt/AutowareAuto/setup.bash ]; then
    source /opt/AutowareAuto/setup.bash
elif [ -f ~/AutowareAuto/install/setup.bash ]; then
    source ~/AutowareAuto/install/setup.bash
fi

PARAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PCAP_DATA="/home/krp/data/route_small_loop_rw-127.0.0.1.pcap"

killall -9 velodyne_cloud_node_exe robot_state_publisher point_cloud_filter_transform_node_exe ray_ground_classifier_cloud_node_exe euclidean_cluster_node_exe pcap_player.py rviz2 2>/dev/null || true
sleep 1

if [ -f /home/krp/pcap_player.py ]; then
    python3 /home/krp/pcap_player.py --speed 0.1 &
elif command -v udpreplay &> /dev/null; then
    udpreplay "$PCAP_DATA" &
fi
sleep 1

ros2 run velodyne_nodes velodyne_cloud_node_exe \
    --ros-args -r __ns:=/lidar_front \
    --params-file "$PARAM_DIR/velodyne_node.param.yaml" &
sleep 1

ros2 run point_cloud_filter_transform_nodes point_cloud_filter_transform_node_exe \
    --ros-args -r __ns:=/lidar_front \
    -r __node:=filter_transform_vlp16_front \
    -r points_filtered:=/perception/points_in \
    --params-file /opt/AutowareAuto/share/point_cloud_filter_transform_nodes/param/vlp16_sim_lexus_filter_transform.param.yaml &
sleep 1

ros2 run ray_ground_classifier_nodes ray_ground_classifier_cloud_node_exe \
    --ros-args -r __ns:=/perception \
    --params-file /opt/AutowareAuto/share/autoware_auto_avp_demo/param/ray_ground_classifier.param.yaml &
sleep 1

ros2 run euclidean_cluster_nodes euclidean_cluster_exe \
    --ros-args -r __ns:=/perception \
    --params-file /opt/AutowareAuto/share/autoware_auto_avp_demo/param/euclidean_cluster.param.yaml &
sleep 1

ros2 run robot_state_publisher robot_state_publisher \
    /opt/AutowareAuto/share/lexus_rx_450h_description/urdf/lexus_rx_450h.urdf &
sleep 1

rviz2 -d "$PARAM_DIR/aw_class2020.rviz"
