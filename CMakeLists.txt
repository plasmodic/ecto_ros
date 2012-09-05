cmake_minimum_required(VERSION 2.8)
project(ecto_ros)
find_package(catkin REQUIRED)

add_definitions(-Wno-strict-aliasing)

find_package(ecto REQUIRED)

catkin_stack()
catkin_project(ecto_ros
               INCLUDE_DIRS include
               CFG_EXTRAS ecto_ros-extras.cmake
)

rosbuild_lite_init()

set(CMAKE_MODULE_PATH ${ecto_ros_SOURCE_DIR}/cmake)
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)

include_directories(${ecto_ros_SOURCE_DIR}/include)

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
