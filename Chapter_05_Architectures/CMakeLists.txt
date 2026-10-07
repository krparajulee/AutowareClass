cmake_minimum_required(VERSION 3.8)
project(autoware_architecture_demo)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_components REQUIRED)
find_package(std_msgs REQUIRED)

# Perception Component Library
add_library(perception_component SHARED src/perception_component.cpp)
ament_target_dependencies(perception_component rclcpp rclcpp_components std_msgs)
rclcpp_components_register_nodes(perception_component "autoware_architecture::PerceptionComponent")

# Planner Component Library
add_library(planner_component SHARED src/planner_component.cpp)
ament_target_dependencies(planner_component rclcpp rclcpp_components std_msgs)
rclcpp_components_register_nodes(planner_component "autoware_architecture::PlannerComponent")

# Install Component Libraries
install(TARGETS
  perception_component
  planner_component
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

# Install Launch Directory
install(DIRECTORY
  launch
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
