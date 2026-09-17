/**
 * @file planner_component.cpp
 * @brief ROS 2 Composable Motion Planner Component Node
 * Modernized for ROS 2 Foxy / Humble (rclcpp_components)
 */

#include <memory>
#include "rclcpp/rclcpp.hpp"
#include "rclcpp_components/register_node_macro.hpp"
#include "std_msgs/msg/string.hpp"

namespace autoware_architecture
{

class PlannerComponent : public rclcpp::Node
{
public:
  explicit PlannerComponent(const rclcpp::NodeOptions & options)
  : Node("planner_component", options)
  {
    sub_objects_ = this->create_subscription<std_msgs::msg::String>(
      "perception/objects", 10,
      std::bind(&PlannerComponent::on_objects_received, this, std::placeholders::_1));

    pub_trajectory_ = this->create_publisher<std_msgs::msg::String>("planning/trajectory", 10);

    RCLCPP_INFO(this->get_logger(), "Planner Composable Component Loaded");
  }

private:
  void on_objects_received(const std_msgs::msg::String::SharedPtr msg)
  {
    RCLCPP_INFO(this->get_logger(), "Planner received: '%s'", msg->data.c_str());

    auto trajectory_msg = std_msgs::msg::String();
    trajectory_msg.data = "Generated Trajectory: Slow Down and Yield";
    pub_trajectory_->publish(trajectory_msg);
  }

  rclcpp::Subscription<std_msgs::msg::String>::SharedPtr sub_objects_;
  rclcpp::Publisher<std_msgs::msg::String>::SharedPtr pub_trajectory_;
};

}  // namespace autoware_architecture

RCLCPP_COMPONENTS_REGISTER_NODE(autoware_architecture::PlannerComponent)
