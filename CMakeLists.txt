cmake_minimum_required(VERSION 2.8)
project(ecto_ros)

find_package(catkin)
if (${catkin_VERSION} VERSION_GREATER "0.5.28")
find_package(catkin REQUIRED geometry_msgs nav_msgs rosbag roscpp sensor_msgs std_msgs)
catkin_package(CFG_EXTRAS ecto_ros-extras.cmake
               INCLUDE_DIRS include
)
else()
find_package(ROS QUIET COMPONENTS geometry_msgs nav_msgs rosbag roscpp sensor_msgs std_msgs)
catkin_stack()
catkin_project(ecto_ros
               INCLUDE_DIRS include
               CFG_EXTRAS ecto_ros-extras.cmake
)
endif()

find_package(ecto REQUIRED)

add_definitions(-Wno-strict-aliasing)

include_directories(include)

add_subdirectory(cmake)
add_subdirectory(src)

# configure and install Python
catkin_python_setup()

# Deal with the tests
option(BUILD_TEST "Build tests" ON)
if(BUILD_TEST)
  enable_testing()
  add_subdirectory(test)
endif()

ecto_sphinx(${CMAKE_CURRENT_SOURCE_DIR}/doc/source doc)
