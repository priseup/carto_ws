#!/bin/bash -e
set -e
set -x

# any problem, read src/cartographer_ros/docs/source/compilation.rst

sudo apt update
sudo apt install -y python3-wstool python3-rosdep ninja-build stow

##### install abseil #############
cd ~/carto_ws/abseil-cpp
mkdir build 
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl .. > /dev/null
ninja > /dev/null
sudo ninja install > /dev/null
cd /usr/local/stow
sudo stow absl > /dev/null

##### install protobuf #############
#sudo apt-get install -y autoconf automake libtool curl make g++ unzip
#cd ~/carto_ws/protobuf
#./configure
#make
#make check
#sudo make install
#sudo ldconfig

##### compile cartographer && cartographer_ros
sudo apt install -y python3-pip
sudo pip install rosdepc

# if rosdep[c] init && rosdep[c] update failed
# . fishros instead
sudo rosdepc init
rosdepc update

cd ~/carto_ws
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
catkin_make_isolated --install --use-ninja -j3

echo "~/carto_ws/install_isolated/setup.bash" >> ~/.bashrc
