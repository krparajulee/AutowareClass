#!/usr/bin/env bash
# ==============================================================================
# AutowareClass2020 - Chapter 03: ROS 2 Bag Recording & Playback Demo
# Modernized for ROS 2 Foxy / Humble
# ==============================================================================

set -e

if [ -f /opt/ros/foxy/setup.bash ]; then
    source /opt/ros/foxy/setup.bash
fi

BAG_NAME="turtle_pose_demo_bag"

echo "[INFO] Cleaning old bag directory if present..."
rm -rf "$BAG_NAME"

echo "[INFO] Starting background Turtlesim node..."
ros2 run turtlesim turtlesim_node &
TURTLE_PID=$!

sleep 2

echo "[INFO] Starting background turtle motion publisher (draw_square)..."
ros2 run turtlesim draw_square &
SQUARE_PID=$!

sleep 1

echo "[INFO] Recording /turtle1/pose topic for 5 seconds into $BAG_NAME..."
timeout 5 ros2 bag record /turtle1/pose -o "$BAG_NAME" || true

echo "[INFO] Stopping background motion and turtlesim..."
kill -9 $SQUARE_PID $TURTLE_PID 2>/dev/null || true

sleep 1

echo "======================================================================"
echo " Introspecting Recorded ROS 2 Bag Metadata"
echo "======================================================================"
ros2 bag info "$BAG_NAME"

echo "======================================================================"
echo " Replaying ROS 2 Bag Data"
echo "======================================================================"
echo "[INFO] Replaying $BAG_NAME at 1.0x speed..."
timeout 3 ros2 bag play "$BAG_NAME" || true

echo "[INFO] ROS 2 Bag demonstration completed successfully."
