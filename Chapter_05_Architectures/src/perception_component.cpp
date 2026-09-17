/**
 * @file perception_component.cpp
 * @brief ROS 2 Composable Perception Component Node
 * Modernized for ROS 2 Foxy / Humble (rclcpp_components)
 */

#include <chrono>
#include <memory>
#include <utility>

#include "rclcpp/rclcpp.hpp"
#include "rclcpp_components/register_node_macro.hpp"
#include "std_msgs/msg/string.hpp"

using namespace std::chrono_literals;

namespace autoware_architecture
{

class PerceptionComponent : public rclcpp::Node
{
public:
  explicit PerceptionComponent(const rclcpp::NodeOptions & options)
  : Node("perception_component", options)
  {
    pub_objects_ = this->create_publisher<std_msgs::msg::String>("perception/objects", 10);
    timer_ = this->create_wall_timer(100ms, std::bind(&PerceptionComponent::process_sensors, this));

    RCLCPP_INFO(this->get_logger(), "Perception Composable Component Loaded");
  }

private:
  void process_sensors()
  {
    auto msg = std::make_unique<std_msgs::msg::String>();
    msg->data = "Detected Obstacle at (x=12.5m, y=0.2m)";
    
    // Intra-process zero-copy publication when loaded in container
    pub_objects_->publish(std::move(msg));
  }

  rclcpp::Publisher<std_msgs::msg::String>::SharedPtr pub_objects_;
  rclcpp::TimerBase::SharedPtr timer_;
};

}  // namespace autoware_architecture

// Register node with rclcpp_components
RCLCPP_COMPONENTS_REGISTER_NODE(autoware_architecture::PerceptionComponent)
