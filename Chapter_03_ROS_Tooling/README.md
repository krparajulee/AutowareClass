# Chapter 03: ROS 2 Tooling & Command Line Interface

Scripts and notes for ROS 2 CLI tools, introspection, RQT, Byobu, and rosbag2.

## Side-by-Side Comparison
- **Original Lecture Material**: See [`ORIGINAL_Lesson3CLI.rst`](./ORIGINAL_Lesson3CLI.rst) for the original Dashing CLI tutorial text.
- **Updated Material**: `ros2_cli_cheatsheet.sh` and `rosbag_demo.sh` update all command line flags and bag storage options for ROS 2 Foxy / Humble.

---

## What Changed: Dashing vs Foxy CLI

1. **ROS Bag Storage Options**:
   - Dashing used `-s sqlite3` by default.
   - Foxy/Humble default to `-s sqlite3` or `mcap`. Replaying bags requires specifying the directory: `ros2 bag play <bag_folder>`.

2. **Action Commands**:
   - `ros2 action send_goal` syntax: `ros2 action send_goal -f /turtle1/rotate_absolute turtlesim/action/RotateAbsolute "{theta: 1.7}"`

---

## Included Scripts
- [`ros2_cli_cheatsheet.sh`](./ros2_cli_cheatsheet.sh): Runs node, topic, service, action, parameter, and doctor introspection.
- [`rosbag_demo.sh`](./rosbag_demo.sh): Launches turtlesim, records `/turtle1/pose` to sqlite3 bag, and replays it.

---

## How to Run
```bash
source /opt/ros/foxy/setup.bash
./ros2_cli_cheatsheet.sh
./rosbag_demo.sh
```
