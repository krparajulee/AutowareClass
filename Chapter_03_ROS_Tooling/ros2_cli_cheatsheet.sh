#!/usr/bin/env bash
# ==============================================================================
# AutowareClass2020 - Chapter 03: ROS 2 CLI Cheatsheet
# Modernized for ROS 2 Foxy / Humble
# ==============================================================================

set -e

if [ -f /opt/ros/foxy/setup.bash ]; then
    source /opt/ros/foxy/setup.bash
fi

echo "======================================================================"
echo " 1. ROS 2 Node Operations"
echo "======================================================================"
echo "Listing active nodes:"
ros2 node list || true

echo -e "\nDetailed node info for /turtlesim (if running):"
ros2 node info /turtlesim 2>/dev/null || echo "turtlesim_node not running."

echo -e "\n======================================================================"
echo " 2. ROS 2 Topic Operations"
echo "======================================================================"
echo "Listing active topics with message types:"
ros2 topic list -t

echo -e "\nEchoing 1 message from /parameter_events:"
timeout 2 ros2 topic echo /parameter_events --once 2>/dev/null || true

echo -e "\n======================================================================"
echo " 3. ROS 2 Service Operations"
echo "======================================================================"
echo "Listing active services with types:"
ros2 service list -t

echo -e "\nFinding service type for /turtlesim/spawn (if active):"
ros2 service type /turtlesim/spawn 2>/dev/null || echo "Service not found"

echo -e "\n======================================================================"
echo " 4. ROS 2 Action Operations"
echo "======================================================================"
echo "Listing active actions:"
ros2 action list -t

echo -e "\nShowing RotateAbsolute action definition:"
ros2 action show turtlesim/action/RotateAbsolute 2>/dev/null || true

echo -e "\n======================================================================"
echo " 5. ROS 2 Parameter Operations"
echo "======================================================================"
echo "Listing parameters for running nodes:"
ros2 param list

echo -e "\n======================================================================"
echo " 6. ROS 2 System Health & Environment Check"
echo "======================================================================"
ros2 doctor

echo -e "\n[INFO] ROS 2 CLI Cheatsheet execution completed."
