cmake_minimum_required(VERSION 3.8)
project(autoware_lifecycle_demo)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_lifecycle REQUIRED)
find_package(std_msgs REQUIRED)

add_executable(lifecycle_node_demo src/lifecycle_node_demo.cpp)
ament_target_dependencies(lifecycle_node_demo
  rclcpp
  rclcpp_lifecycle
  std_msgs
)

install(TARGETS
  lifecycle_node_demo
  DESTINATION lib/${PROJECT_NAME}
)

install(DIRECTORY
  launch
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
