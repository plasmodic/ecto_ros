find_package(OpenCV REQUIRED)

    if (ROS_FUERTE_FOUND)
    find_package(ROS QUIET COMPONENTS geometry_msgs nav_msgs sensor_msgs std_msgs)
    find_package(ROS QUIET COMPONENTS rosbag roscpp)
    else()
find_package(catkin REQUIRED geometry_msgs nav_msgs sensor_msgs std_msgs)
find_package(catkin REQUIRED rosbag roscpp)
    endif()

find_package(Eigen REQUIRED)

include_directories(SYSTEM
                    ${Eigen_INCLUDE_DIRS}
                    ${ROS_INCLUDE_DIRS}
)

ectomodule(ecto_ros_main DESTINATION ecto_ros INSTALL
  ecto_ros.cpp
  cv_bridge.cpp
  cv_pose.cpp
  cv_camera_info.cpp
  Synchronizer.cpp
  BagReader.cpp
  BagWriter.cpp
  camera_sync_printer.cpp
)

link_ecto(ecto_ros_main
  ${OpenCV_LIBS}
  ${roscpp_LIBRARIES}
  ${rosbag_LIBRARIES}
  ${geometry_msgs_LIBRARIES}
  ${sensor_msgs_LIBRARIES}
  )

pubsub_gen_wrap(std_msgs DESTINATION ecto_ros INSTALL)
pubsub_gen_wrap(sensor_msgs DESTINATION ecto_ros INSTALL)
pubsub_gen_wrap(geometry_msgs DESTINATION ecto_ros INSTALL)
pubsub_gen_wrap(nav_msgs DESTINATION ecto_ros INSTALL)

set_target_properties(ecto_ros_main_ectomodule
  PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE
  )
