find_package(OpenCV REQUIRED)

find_package(ROS REQUIRED gencpp geometry_msgs message_filters roscpp rosbag sensor_msgs)
find_package(Eigen REQUIRED)

include_directories(SYSTEM
    ${Eigen_INCLUDE_DIRS}
    ${ROS_INCLUDE_DIRS}
)

#attempts to set ENV variables so that ROS commands will work.
#This appears to work well on linux, but may be questionable on
#other platforms.
macro (_set_ros_env)
  set(ORIG_ROS_ROOT $ENV{ROS_ROOT})
  set(ORIG_ROS_PACKAGE_PATH $ENV{ROS_PACKAGE_PATH})
  set(ORIG_PATH $ENV{PATH})
  set(ORIG_PYTHONPATH $ENV{PYTHONPATH})
  set(ENV{ROS_ROOT} $ENV{ROS_ROOT})
  set(ENV{ROS_PACKAGE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}:$ENV{ROS_PACKAGE_PATH}")
  set(ENV{PATH} "${ROS_ROOT}/bin:$ENV{PATH}")
  set(ENV{PYTHONPATH} "${ROS_ROOT}/core/roslib/src:$ENV{PYTHONPATH}")
endmacro()

#unset environment
macro (_unset_ros_env)
  set(ENV{ROS_ROOT} ${ORIG_ROS_ROOT})
  set(ENV{ROS_PACKAGE_PATH} ${ORIG_ROS_PACKAGE_PATH})
  set(ENV{PATH} "${ORIG_PATH}")
  set(ENV{PYTHONPATH} "${ORIG_PYTHONPATH}")
endmacro()

macro(pubsub_gen_wrap ROS_PACKAGE)
  find_program(ECTO_ROS_GEN_MSG_WRAPPERS
    gen_msg_wrappers.py
    PATHS ${ecto_ros_SOURCE_DIR}/cmake
    NO_DEFAULT_PATH)
  mark_as_advanced(ECTO_ROS_GEN_MSG_WRAPPERS)
  if(NOT ${ROS_PACKAGE}_srcs)
    _set_ros_env()
    execute_process(COMMAND ${ECTO_ROS_GEN_MSG_WRAPPERS} ${ROS_PACKAGE}
      OUTPUT_VARIABLE ${ROS_PACKAGE}_srcs
      ERROR_VARIABLE ${ROS_PACKAGE}_srcs
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    _unset_ros_env()
    separate_arguments(${ROS_PACKAGE}_srcs UNIX_COMMAND ${${ROS_PACKAGE}_srcs})
    set(_SRCS)
    foreach(_SRC ${${ROS_PACKAGE}_srcs})
      list(APPEND _SRCS ${CMAKE_CURRENT_BINARY_DIR}/${_SRC})
    endforeach()
    set(${ROS_PACKAGE}_srcs ${_SRCS} CACHE INTERNAL "The generated srcs for ${ROS_PACKAGE}")
  endif()
  find_package(${ROS_PACKAGE} QUIET)

  include_directories(${ecto_ros_SOURCE_DIR}/include)

  list(LENGTH ${ROS_PACKAGE}_srcs len)
  if(ROS_CONFIGURE_VERBOSE)
    message(STATUS "+ ${ROS_PACKAGE}: ${len} message types")
  endif() 
  ectomodule(ecto_${ROS_PACKAGE}
    ${${ROS_PACKAGE}_srcs}
    )
  link_ecto(ecto_${ROS_PACKAGE}
    ecto_ros_ectomodule
    ${roscpp_LIBRARIES}
    ${rosbag_LIBRARIES}
    ${${ROS_PACKAGE}_LIBRARIES}
    )
  install_ecto_module(ecto_${ROS_PACKAGE})
  set_target_properties(ecto_${ROS_PACKAGE}_ectomodule
    PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE
    )
  set_source_files_properties(${${ROS_PACKAGE}_srcs}
    PROPERTIES
    OBJECT_DEPENDS ${ECTO_ROS_GEN_MSG_WRAPPERS}
    )

endmacro()

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
