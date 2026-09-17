cmake_minimum_required(VERSION 3.8)
project(ros2_basics_demo)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Find ROS 2 dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(std_msgs REQUIRED)
find_package(example_interfaces REQUIRED)

# ==============================================================================
# 1. Topic Publisher Node
# ==============================================================================
add_executable(publisher_node src/publisher_member_function.cpp)
ament_target_dependencies(publisher_node rclcpp std_msgs)

# ==============================================================================
# 2. Topic Subscriber Node
# ==============================================================================
add_executable(subscriber_node src/subscriber_member_function.cpp)
ament_target_dependencies(subscriber_node rclcpp std_msgs)

# ==============================================================================
# 3. Service Server Node
# ==============================================================================
add_executable(service_server src/service_server.cpp)
ament_target_dependencies(service_server rclcpp example_interfaces)

# ==============================================================================
# 4. Service Client Node
# ==============================================================================
add_executable(service_client src/service_client.cpp)
ament_target_dependencies(service_client rclcpp example_interfaces)

# ==============================================================================
# 5. Action Server Node
# ==============================================================================
add_executable(action_server src/action_server.cpp)
ament_target_dependencies(action_server rclcpp rclcpp_action example_interfaces)

# ==============================================================================
# 6. Action Client Node
# ==============================================================================
add_executable(action_client src/action_client.cpp)
ament_target_dependencies(action_client rclcpp rclcpp_action example_interfaces)

# Install C++ Executables
install(TARGETS
  publisher_node
  subscriber_node
  service_server
  service_client
  action_server
  action_client
  DESTINATION lib/${PROJECT_NAME}
)

# Install Python Scripts
install(PROGRAMS
  scripts/py_publisher.py
  scripts/py_subscriber.py
  DESTINATION lib/${PROJECT_NAME}
)

ament_package()
