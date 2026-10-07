# AutowareClass2020 (Modernized Native ROS 2 Edition)

Updated code and notes for Lectures 1 through 6 of AutowareClass2020. All examples have been updated from the obsolete ROS 2 Dashing release to modern ROS 2 standards (Foxy / Humble) and configured to run **100% natively on Linux / WSL without Docker or ADE**.

---

## Native Environment Setup (No Docker Required)

This repository runs directly on your host operating system using standard ROS 2 packages and `colcon`.

### Supported Systems
- **Ubuntu Linux** (20.04 LTS for Foxy, 22.04 LTS for Humble)
- **Windows 10/11 with WSL 2** (Ubuntu distribution)

---

### 1. Windows WSL 2 Setup (Windows Users Only)

If you are using Windows, open PowerShell as Administrator and install Ubuntu:

```powershell
wsl --install -d Ubuntu-20.04
```

After rebooting, launch Ubuntu from your Start menu and complete user setup.

---

### 2. Native ROS 2 Installation (Ubuntu / WSL)

Run the following in your Ubuntu terminal to install ROS 2:

```bash
# Set locale
sudo apt update && sudo apt install -y locales curl gnupg2 lsb-release build-essential
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Add ROS 2 repository
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 and developer build tools
sudo apt update
# For Ubuntu 20.04:
sudo apt install -y ros-foxy-desktop python3-colcon-common-extensions python3-rosdep ros-foxy-turtlesim ros-foxy-rqt*
# (Or on Ubuntu 22.04: replace foxy with humble)

# Automatically source ROS 2 in every terminal session
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

---

### 3. Verify Native ROS 2 Installation

Open two terminal windows:

**Terminal 1:**
```bash
ros2 run demo_nodes_cpp talker
```

**Terminal 2:**
```bash
ros2 run demo_nodes_cpp listener
```

If you see `Publishing: 'Hello World'` in Terminal 1 and `I heard: [Hello World]` in Terminal 2, your native ROS 2 environment is working.

---

## Repository Structure

Every chapter is a self-contained, native ROS 2 package ready for `colcon build`:

| Chapter | Topic | What's Included |
| :--- | :--- | :--- |
| [**Chapter 01**](./Chapter_01_DevelopmentEnvironment/) | **Environment & LiDAR Demo** | Updated `--ros-args` CLI remappings, LiDAR pipeline script, sensor parameters, and RViz config. |
| [**Chapter 02**](./Chapter_02_ROS2_Basics/) | **ROS 2 Basics (C++ & Python)** | Standalone nodes for Topics, Services, Actions, and parameters with CMake build files. |
| [**Chapter 03**](./Chapter_03_ROS_Tooling/) | **ROS 2 CLI & Tooling** | Command-line introspection scripts, RQT, and native sqlite3 rosbag recording/replay. |
| [**Chapter 04**](./Chapter_04_Platform/) | **Platform, DDS & Real-Time** | CycloneDDS and FastDDS profiles, plus a compilable real-time C++ node (`mlockall`, `SCHED_FIFO`). |
| [**Chapter 05**](./Chapter_05_Architectures/) | **Modular AD Stack Architecture** | Composable intra-process component nodes (`rclcpp_components`) and container launch file. |
| [**Chapter 06**](./Chapter_06_Autoware_101/) | **Autoware 101 & Lifecycle Nodes** | Managed Lifecycle Node (`rclcpp_lifecycle`) and state transition launch file. |

---

## How to Build and Run Any Chapter

1. Clone this repository into your workspace:
```bash
mkdir -p ~/autoware_ws/src
cd ~/autoware_ws/src
git clone https://github.com/krparajulee/AutowareClass.git
```

2. Build all chapters simultaneously with `colcon`:
```bash
cd ~/autoware_ws
colcon build --symlink-install
source install/setup.bash
```

3. Run individual nodes or launch files directly:
```bash
# Example: Run Chapter 2 Action Server
ros2 run ros2_basics_demo action_server

# Example: Run Chapter 5 Architecture Container
ros2 launch autoware_architecture_demo autoware_architecture.launch.py

# Example: Run Chapter 6 Lifecycle Node
ros2 launch autoware_lifecycle_demo lifecycle_demo.launch.py
```
