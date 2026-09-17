#include <sys/mman.h>
#include <sched.h>
#include <cstring>
#include <chrono>
#include <memory>
#include <iostream>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/float64.hpp"

using namespace std::chrono_literals;

class RealtimeControlNode : public rclcpp::Node
{
public:
  explicit RealtimeControlNode(const rclcpp::NodeOptions & options = rclcpp::NodeOptions())
  : Node("realtime_control_node", options)
  {
    publisher_ = this->create_publisher<std_msgs::msg::Float64>("control_cmd", 10);
    timer_ = this->create_wall_timer(
      10ms, std::bind(&RealtimeControlNode::control_loop_callback, this));
  }

private:
  void control_loop_callback()
  {
    if (publisher_->can_loan_messages()) {
      auto loaned_msg = publisher_->borrow_loaned_message();
      loaned_msg.get().data = 42.0;
      publisher_->publish(std::move(loaned_msg));
    } else {
      auto msg = std_msgs::msg::Float64();
      msg.data = 42.0;
      publisher_->publish(msg);
    }
  }

  rclcpp::Publisher<std_msgs::msg::Float64>::SharedPtr publisher_;
  rclcpp::TimerBase::SharedPtr timer_;
};

void lock_memory()
{
  if (mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
    std::cerr << "Memory locking failed. Check user limits or run with elevated permissions." << std::endl;
  }
}

void set_realtime_priority(int priority = 80)
{
  struct sched_param param;
  param.sched_priority = priority;
  if (sched_setscheduler(0, SCHED_FIFO, &param) != 0) {
    std::cerr << "Setting SCHED_FIFO priority failed." << std::endl;
  }
}

int main(int argc, char * argv[])
{
  lock_memory();
  set_realtime_priority(80);

  rclcpp::init(argc, argv);
  auto node = std::make_shared<RealtimeControlNode>();
  rclcpp::spin(node);
  rclcpp::shutdown();
  return 0;
}
