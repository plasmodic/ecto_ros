find_package(OpenCV REQUIRED)

# TODO remove the following after electric
if (ROS_ELECTRIC_FOUND)
#    find_library(geometry_msgs_LIBRARIES geometry_msgs /opt/ros/elet/lib/)
    find_ros_package(roscpp)
    find_ros_package(rosbag)
    find_ros_package(eigen)
    find_ros_package(geometry_msgs)
    find_ros_package(nav_msgs)
    find_ros_package(sensor_msgs)
    find_ros_package(message_filters)
else()
    find_package(ROS QUIET COMPONENTS gencpp geometry_msgs message_filters roscpp rosbag sensor_msgs)
endif()

find_package(Eigen REQUIRED)

include_directories(SYSTEM
    ${Eigen_INCLUDE_DIRS}
    ${ROS_INCLUDE_DIRS}
)

ectomodule(ecto_ros
  ecto_ros.cpp
  cv_bridge.cpp
  cv_pose.cpp
  cv_camera_info.cpp
  Synchronizer.cpp
  BagReader.cpp
  BagWriter.cpp
  camera_sync_printer.cpp
)

link_ecto(ecto_ros
  ${OpenCV_LIBS}
  ${roscpp_LIBRARIES}
  ${rosbag_LIBRARIES}
  ${geometry_msgs_LIBRARIES}
  ${sensor_msgs_LIBRARIES}
  )

pubsub_gen_wrap(std_msgs)
pubsub_gen_wrap(sensor_msgs)
pubsub_gen_wrap(geometry_msgs)
pubsub_gen_wrap(nav_msgs)

install_ecto_module(ecto_ros)

set_target_properties(ecto_ros_ectomodule
  PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE
  )
