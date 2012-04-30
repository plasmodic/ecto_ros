# TODO remove the following after electric
if (ROS_ELECTRIC_FOUND)
    find_ros_package(roscpp)
    find_ros_package(rosbag)
else()
    find_package(ROS REQUIRED gencpp genmsg roscpp rosbag)
endif()

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

# Macro that builds default ecto cells for publishing/subscribing for a given
# ROS package. If extra arguments are given, they must be the message names
macro(pubsub_gen_wrap ROS_PACKAGE)
  find_program(ECTO_ROS_GEN_MSG_WRAPPERS
    gen_msg_wrappers.py
    PATHS ${ecto_ros_SOURCE_DIR}/cmake ${ecto_ros_DIR}
    NO_DEFAULT_PATH)
  mark_as_advanced(ECTO_ROS_GEN_MSG_WRAPPERS)
  set(ARGN_CLEAN ${ROS_PACKAGE})
  if (${ARGC} GREATER 1)
    foreach(msg ${ARGN})
      list(APPEND ARGN_CLEAN "${ROS_PACKAGE}/${msg}")
    endforeach()
  endif()
  if(NOT ${ROS_PACKAGE}_srcs)
    _set_ros_env()
    execute_process(COMMAND ${ECTO_ROS_GEN_MSG_WRAPPERS} ${ARGN_CLEAN}
      OUTPUT_VARIABLE ${ROS_PACKAGE}_srcs
      ERROR_VARIABLE ${ROS_PACKAGE}_err
      RESULT_VARIABLE ${ROS_PACKAGE}_res
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (${ROS_PACKAGE}_res)
      message(STATUS "pubsub_gen_wrap returned: " ${${ROS_PACKAGE}_res})
    endif()
    _unset_ros_env()
    separate_arguments(${ROS_PACKAGE}_srcs UNIX_COMMAND ${${ROS_PACKAGE}_srcs})
    set(_SRCS)
    foreach(_SRC ${${ROS_PACKAGE}_srcs})
      list(APPEND _SRCS ${CMAKE_CURRENT_BINARY_DIR}/${_SRC})
    endforeach()
    set(${ROS_PACKAGE}_srcs ${_SRCS} CACHE INTERNAL "The generated srcs for ${ROS_PACKAGE}")
  endif()
  find_package(${ROS_PACKAGE} QUIET)

  include_directories(${ecto_ros_INCLUDE_DIRS})

  list(LENGTH ${ROS_PACKAGE}_srcs len)
  if(ROS_CONFIGURE_VERBOSE)
    message(STATUS "+ ${ROS_PACKAGE}: ${len} message types")
  endif()

  if (ROS_ELECTRIC_FOUND)
    find_ros_package(roscpp)
  else()
    find_package(roscpp REQUIRED)
  endif()
  include_directories(SYSTEM
                      ${roscpp_INCLUDE_DIRS}
                      ${CMAKE_BINARY_DIR}/gen/cpp/${ROS_PACKAGE}
  )
  ectomodule(ecto_${ROS_PACKAGE}
    ${${ROS_PACKAGE}_srcs}
    )
  link_ecto(ecto_${ROS_PACKAGE}
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
  add_dependencies(ecto_${ROS_PACKAGE}_ectomodule ${ROS_PACKAGE}_gencpp)
endmacro()
