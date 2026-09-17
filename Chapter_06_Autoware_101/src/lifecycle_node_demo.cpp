/**
 * @file lifecycle_node_demo.cpp
 * @brief Managed Lifecycle Node Implementation for Autoware
 * Modernized for ROS 2 Foxy / Humble (rclcpp_lifecycle)
 */

#include <chrono>
#include <memory>
#include <string>
#include <utility>

#include "rclcpp/rclcpp.hpp"
#include "rclcpp_lifecycle/lifecycle_node.hpp"
#include "rclcpp_lifecycle/lifecycle_publisher.hpp"
#include "std_msgs/msg/string.hpp"

using namespace std::chrono_literals;

class AutowareManagedSensor : public rclcpp_lifecycle::LifecycleNode
{
public:
  explicit AutowareManagedSensor(const std::string & node_name, bool __node=false)
  : rclcpp_lifecycle::LifecycleNode(node_name)
  {
    RCLCPP_INFO(this->get_logger(), "Lifecycle Node Instantiated [Unconfigured State]");
  }

  // 1. Transition: Unconfigured -> Inactive
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
  on_configure(const rclcpp_lifecycle::State & state) override
  {
    (void)state;
    RCLCPP_INFO(this->get_logger(), "on_configure() called -> Initializing parameters and publishers");
    
    // Lifecycle publishers are inactive by default until the node enters Active state
    pub_sensor_ = this->create_publisher<std_msgs::msg::String>("sensor/data", 10);
    timer_ = this->create_wall_timer(500ms, std::bind(&AutowareManagedSensor::publish_sensor_data, this));

    return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
  }

  // 2. Transition: Inactive -> Active
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
  on_activate(const rclcpp_lifecycle::State & state) override
  {
    (void)state;
    RCLCPP_INFO(this->get_logger(), "on_activate() called -> Enabling sensor stream to vehicle");
    
    // Explicitly activate publisher lifecycle
    pub_sensor_->on_activate();

    return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
  }

  // 3. Transition: Active -> Inactive
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
  on_deactivate(const rclcpp_lifecycle::State & state) override
  {
    (void)state;
    RCLCPP_INFO(this->get_logger(), "on_deactivate() called -> Disabling sensor stream");
    
    pub_sensor_->on_deactivate();

    return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
  }

  // 4. Transition: Inactive -> Unconfigured
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
  on_cleanup(const rclcpp_lifecycle::State & state) override
  {
    (void)state;
    RCLCPP_INFO(this->get_logger(), "on_cleanup() called -> Releasing hardware handles");
    
    pub_sensor_.reset();
    timer_.reset();

    return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
  }

  // 5. Shutdown state
  rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
  on_shutdown(const rclcpp_lifecycle::State & state) override
  {
    (void)state;
    RCLCPP_INFO(this->get_logger(), "on_shutdown() called");
    return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
  }

private:
  void publish_sensor_data()
  {
    if (pub_sensor_ && pub_sensor_->is_activated()) {
      auto msg = std::make_unique<std_msgs::msg::String>();
      msg->data = "Active Sensor Frame Data: OK";
      RCLCPP_INFO(this->get_logger(), "Publishing: '%s'", msg->data.c_str());
      pub_sensor_->publish(std::move(msg));
    }
  }

  std::shared_ptr<rclcpp_lifecycle::LifecyclePublisher<std_msgs::msg::String>> pub_sensor_;
  rclcpp::TimerBase::SharedPtr timer_;
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  auto lc_node = std::make_shared<AutowareManagedSensor>("autoware_managed_sensor");
  rclcpp::spin(lc_node->get_node_base_interface());
  rclcpp::shutdown();
  return 0;
}
