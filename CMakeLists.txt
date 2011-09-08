cmake_minimum_required(VERSION 2.8)
project(ecto_ros)

add_definitions(-Wno-strict-aliasing)

find_package(ecto REQUIRED) #brings in rosbuild_lite

set(ECTO_ROS_VERSION 0.1.0)
set(ECTO_ROS_PREFIX ${PROJECT_NAME}-${ECTO_ROS_VERSION} CACHE INTERNAL "Mangled prefixer" FORCE)
set(ECTO_ROS_INCLUDE_PREFIX include/${ECTO_ROS_PREFIX} CACHE INTERNAL "Where ecto_ros include will live" FORCE)
set(ECTO_ROS_SHARE_PREFIX share/${ECTO_ROS_PREFIX} CACHE INTERNAL "Where ecto_ros share will live" FORCE)

option(BUILD_ECTO_ROS "should I build ecto_ros" ON)
if (NOT BUILD_ECTO_ROS)
  message("Skipping build of ecto_ros because BUILD_ECTO_ROS is OFF")
  return()
endif()

rosbuild_lite_init() # found in rosbuild_lite

if (NOT ROS_FOUND) #rosbuild_lite_init sets this
  message("*** unable to find ROS... is your environment set correctly?")
  set (BUILD_ECTO_ROS OFF CACHE "" FORCE)
  return()
else()
  if(ROS_CONFIGURE_VERBOSE)
    message(STATUS "+ ROSPACK_EXE: ${ROSPACK_EXE}")
  endif()
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
