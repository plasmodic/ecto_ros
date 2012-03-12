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

set_ecto_install_package_name(ecto_ros)

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

add_subdirectory(cmake)
add_subdirectory(include/ecto_ros)
add_subdirectory(src)

# Make sure the ecto modules are part of a Python module
set(python_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PYTHON_PACKAGES_PATH}/ecto_ros)

configure_file(python/__init__.py.in
               ${python_LIBRARY_OUTPUT_DIRECTORY}/__init__.py
               @ONLY
)

install(FILES ${python_LIBRARY_OUTPUT_DIRECTORY}/__init__.py
        DESTINATION ${ecto_module_PYTHON_INSTALL} COMPONENT main
)

# Deal with the tests
option(BUILD_TEST "Build tests" ON)
if(BUILD_TEST)
  enable_testing()
  add_subdirectory(test)
endif()

catkin_add_env_hooks(10.ecto_ros SHELLS all)

