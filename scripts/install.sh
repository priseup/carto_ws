#!/bin/bash -e
set -o errexit

sudo apt update
sudo apt install -y python3-wstool python3-rosdep ninja-build stow

##### install abseil #############
cd ~/carto_ws/abseil-cpp
mkdir build
cd build
cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl \
  ..
ninja
sudo ninja install
cd /usr/local/stow
sudo stow absl

##### install protobuf #############
sudo apt-get install -y autoconf automake libtool curl make g++ unzip
cd ~/carto_ws/protobuf
./configure
make
make check
sudo make install
sudo ldconfig

##### compile cartographer && cartographer_ros
sudo rosdep init
rosdep update
cd ~/carto_ws
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
catkin_make_isolated --install --use-ninja -j3
