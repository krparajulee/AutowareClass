# AutowareClass2020 (Modernized for ROS 2)

Updated code and notes for Lectures 1 through 6 of AutowareClass2020. The original course material was built on ROS 2 Dashing (now EOL). The code here has been updated and tested for ROS 2 Foxy / Humble.

---

## Environment Setup

### System Requirements
- Ubuntu 18.04 / 20.04 (Native or WSL 2 on Windows)
- Docker
- ADE (Awesome Development Environment)

### 1. WSL 2 Setup (Windows users)
If on Windows 10/11, install Ubuntu in PowerShell (Admin):
```powershell
wsl --install -d Ubuntu-18.04
```

### 2. Docker Installation
In Ubuntu/WSL:
```bash
sudo apt update && sudo apt install -y curl git wget build-essential
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
```

### 3. ADE Setup
```bash
cd ${HOME}
mkdir -p adehome && cd adehome

wget https://gitlab.com/ApexAI/ade-cli/uploads/85a5af81339fe55555ee412f9a3a734b/ade+x86_64
mv ade+x86_64 ade
chmod +x ade
mkdir -p ~/.local/bin && mv ade ~/.local/bin/

echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc

touch .adehome
git clone --recurse-submodules https://gitlab.com/autowarefoundation/autoware.auto/AutowareAuto.git
cd AutowareAuto/
ade start
ade enter
```

### 4. ROS Key Update & Package Install
Inside ADE (`krp@ade:~$`):
```bash
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -
sudo apt update
source /opt/ros/foxy/setup.bash
sudo apt install -y ros-foxy-turtlesim ros-foxy-rqt* byobu
```

### 5. Verification Test
Terminal 1:
```bash
source /opt/ros/foxy/setup.bash
ros2 run demo_nodes_cpp talker
```
Terminal 2:
```bash
source /opt/ros/foxy/setup.bash
ros2 run demo_nodes_cpp listener
```

---

## Repository Structure

- [`Chapter_01_DevelopmentEnvironment`](./Chapter_01_DevelopmentEnvironment): Fixed launch syntax (`--ros-args -r __ns:=...`) and LiDAR object detection demo.
- [`Chapter_02_ROS2_Basics`](./Chapter_02_ROS2_Basics): ROS 2 primitives (Topics, Services, Actions) in C++ and Python with working CMake setup.
- [`Chapter_03_ROS_Tooling`](./Chapter_03_ROS_Tooling): Command line tools, RQT, Byobu, and rosbag2 scripts.
- [`Chapter_04_Platform`](./Chapter_04_Platform): CycloneDDS and FastDDS profiles, plus real-time C++ node example (`mlockall`, `SCHED_FIFO`).
- [`Chapter_05_Architectures`](./Chapter_05_Architectures): Modular AD architecture using composable nodes (`rclcpp_components`) and Python launch files.
- [`Chapter_06_Autoware_101`](./Chapter_06_Autoware_101): Lifecycle managed node (`rclcpp_lifecycle`) implementation and transition launch script.
