#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage: ./save_cartographer_map.sh map_name"
fi

if [ ! -d "${HOME}/data" ]; then
  echo "data directory not exist, create it"
  mkdir ~/data
fi

#cartographer创建的地图格式与gmapping、hector_slam等生成的地图格式不同，不能使用map_saver节点保存地图。需要使用以下命令保存地图
#cartographer建图完成后
name=$1

# 1. 请求/finish_trajectory服务，完成轨迹，不再接收数据：
rosservice call /finish_trajectory 0

# 2. 请求/write_state服务，保存当前状态，其中路径可以根据需要自行更改：
rosservice call /write_state "{filename: '${HOME}/data/${name}.pbstream'}"

# 3. 运行cartographer_pbstream_to_ros_map节点，将保存的.pbstream文件转为.pgm和.yaml文件：
rosrun cartographer_ros cartographer_pbstream_to_ros_map -map_filestem=${HOME}/data/${name} -pbstream_filename=${HOME}/data/${name}.pbstream -resolution=0.02
