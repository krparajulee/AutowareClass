# Chapter 02: ROS 2 Basics

This chapter provides working C++ and Python ROS 2 node implementations for Topics, Services, Actions, and Parameters.

## Side-by-Side Comparison
- **Original Lecture Material**: See [`ORIGINAL_Lesson2Basics.rst`](./ORIGINAL_Lesson2Basics.rst) for the original course code snippets written for ROS 2 Dashing.
- **Updated Material**: The standalone files in `src/` and `scripts/` convert those snippets into buildable, production-ready node files for ROS 2 Foxy / Humble.

---

## Detailed Code Mapping (Original vs Updated)

| Topic / Primitive | Original Course File (`Lesson2Basics.rst`) | Updated Working File |
| :--- | :--- | :--- |
| **Topic Publisher** | Embedded snippet | [`src/publisher_member_function.cpp`](./src/publisher_member_function.cpp) |
| **Topic Subscriber** | Embedded snippet | [`src/subscriber_member_function.cpp`](./src/subscriber_member_function.cpp) |
| **Service Server** | `add_two_ints_server.cpp` snippet | [`src/service_server.cpp`](./src/service_server.cpp) |
| **Service Client** | `add_two_ints_client.cpp` snippet | [`src/service_client.cpp`](./src/service_client.cpp) |
| **Action Server** | `fibonacci_action_server.cpp` snippet | [`src/action_server.cpp`](./src/action_server.cpp) |
| **Action Client** | `member_functions.cpp` snippet | [`src/action_client.cpp`](./src/action_client.cpp) |
| **Python Publisher** | Embedded snippet | [`scripts/py_publisher.py`](./scripts/py_publisher.py) |
| **Python Subscriber**| Embedded snippet | [`scripts/py_subscriber.py`](./scripts/py_subscriber.py) |

---

## Key API Changes from Dashing to Foxy/Humble

1. **Action Client Interface**:
   - In Dashing, action clients required manually retrieving sub-interfaces: `create_client<Fibonacci>(get_node_base_interface(), ...)`
   - In Foxy+, simplified constructor is used: `create_client<Fibonacci>(this, "fibonacci")`

2. **Action Feedback Type**:
   - Feedback callback parameter updated to `const std::shared_ptr<const Fibonacci::Feedback>`.

3. **Build System**:
   - Added complete [`CMakeLists.txt`](./CMakeLists.txt) and [`package.xml`](./package.xml) configured for `colcon build`.

---

## Build and Run Instructions

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
