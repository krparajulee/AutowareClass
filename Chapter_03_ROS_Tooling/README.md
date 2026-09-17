# Chapter 03: ROS 2 Tooling & Command Line Interface

Scripts and reference notes for CLI tools, introspection, RQT, Byobu, and rosbag2.

## Included Scripts
- `ros2_cli_cheatsheet.sh`: Runs basic node, topic, service, action, and parameter introspection commands.
- `rosbag_demo.sh`: Launches turtlesim, records pose data to a sqlite3 bag file, and replays it.

## Usage
```bash
source /opt/ros/foxy/setup.bash
./ros2_cli_cheatsheet.sh
./rosbag_demo.sh
```

## Useful Commands
- List topics with types: `ros2 topic list -t`
- Echo topic once: `ros2 topic echo /topic_name --once`
- Show node info: `ros2 node info /node_name`
- Inspect bag file: `ros2 bag info <bag_directory>`
