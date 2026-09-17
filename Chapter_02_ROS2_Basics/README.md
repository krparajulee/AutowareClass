# Chapter 02: ROS 2 Basics

Working C++ and Python examples for core ROS 2 client primitives: Topics, Services, Actions, and Parameters.

## Structure

```
Chapter_02_ROS2_Basics/
├── CMakeLists.txt
├── package.xml
├── src/
│   ├── publisher_member_function.cpp
│   ├── subscriber_member_function.cpp
│   ├── service_server.cpp
│   ├── service_client.cpp
│   ├── action_server.cpp
│   └── action_client.cpp
└── scripts/
    ├── py_publisher.py
    └── py_subscriber.py
```

## Build and Run

Copy folder into a ROS 2 workspace `src` directory:
```bash
mkdir -p ~/ros2_ws/src
cp -r Chapter_02_ROS2_Basics ~/ros2_ws/src/ros2_basics_demo
cd ~/ros2_ws
source /opt/ros/foxy/setup.bash
colcon build --symlink-install
source install/setup.bash
```

### Publisher & Subscriber
```bash
ros2 run ros2_basics_demo publisher_node
ros2 run ros2_basics_demo subscriber_node
```

### Service Server & Client
```bash
ros2 run ros2_basics_demo service_server
ros2 run ros2_basics_demo service_client 5 7
```

### Action Server & Client
```bash
ros2 run ros2_basics_demo action_server
ros2 run ros2_basics_demo action_client
```
