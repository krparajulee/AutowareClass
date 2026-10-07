cmake_minimum_required(VERSION 3.8)
project(autoware_platform_demo)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

add_executable(realtime_control_node src/realtime_node_template.cpp)
ament_target_dependencies(realtime_control_node rclcpp std_msgs)

install(TARGETS
  realtime_control_node
  DESTINATION lib/${PROJECT_NAME}
)

install(DIRECTORY
  dds_profiles
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
