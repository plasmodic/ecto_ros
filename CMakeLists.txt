cmake_minimum_required(VERSION 2.8)
project(ecto_ros)
find_package(catkin REQUIRED)
catkin_stack(ecto_ros)

add_definitions(-Wno-strict-aliasing)

find_package(ecto REQUIRED)

catkin_project(ecto_ros
    VERSION 0.1.0
    INCLUDE_DIRS include
)

rosbuild_lite_init()

set_ecto_install_package_name(ecto_ros)

set(ECTO_ROS_VERSION 0.1.0)
set(ECTO_ROS_PREFIX ${PROJECT_NAME}-${ECTO_ROS_VERSION} CACHE INTERNAL "Mangled prefixer" FORCE)
set(ECTO_ROS_INCLUDE_PREFIX include/${ECTO_ROS_PREFIX} CACHE INTERNAL "Where ecto_ros include will live" FORCE)
set(ECTO_ROS_SHARE_PREFIX share/${ECTO_ROS_PREFIX} CACHE INTERNAL "Where ecto_ros share will live" FORCE)

option(BUILD_ECTO_ROS "should I build ecto_ros" ON)
if (NOT BUILD_ECTO_ROS)
  message("Skipping build of ecto_ros because BUILD_ECTO_ROS is OFF")
  return()
endif()

set(CMAKE_MODULE_PATH ${ecto_ros_SOURCE_DIR}/cmake)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)

include_directories(${ecto_ros_SOURCE_DIR}/include)

add_subdirectory(include/ecto_ros)
add_subdirectory(src)
add_subdirectory(cmake)

option(BUILD_TEST "Build tests" ON)
if(BUILD_TEST)
  enable_testing()
  add_subdirectory(test)
endif()
