ecto_python_env_gen(${LIBRARY_OUTPUT_PATH})

find_package(OpenCV 2.3.1 EXACT REQUIRED)

find_ros_package(roscpp)
find_ros_package(rosbag)
find_ros_package(eigen)
find_ros_package(geometry_msgs)
find_ros_package(sensor_msgs)
find_ros_package(message_filters)

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

  list(LENGTH ${ROS_PACKAGE}_srcs len)
  if(ROS_CONFIGURE_VERBOSE)
    message(STATUS "+ ${ROS_PACKAGE}: ${len} message types")
  endif() 
  find_ros_package(${ROS_PACKAGE})
  ectomodule(ecto_${ROS_PACKAGE}
    ${${ROS_PACKAGE}_srcs}
    )
  link_ecto(ecto_${ROS_PACKAGE}
    ecto_ros_ectomodule
    ${roscpp_LIBRARIES}
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
