#NON INSTALL cmake configuration
set(ECTO_ROS_INCLUDE_DIRS ${ecto_ros_SOURCE_DIR}/include)
configure_file(ecto_rosConfig.cmake.in ${CMAKE_BINARY_DIR}/ecto_rosConfig.cmake @ONLY)
configure_file(ecto_rosConfig-version.cmake.in ${CMAKE_BINARY_DIR}/ecto_rosConfig-version.cmake @ONLY)

#INSTALL cmake configuration
set(ECTO_ROS_INCLUDE_DIRS ${CMAKE_INSTALL_PREFIX}/${ECTO_ROS_INCLUDE_PREFIX})
configure_file(ecto_rosConfig.cmake.in ${CMAKE_BINARY_DIR}/unix_install/ecto_rosConfig.cmake @ONLY)
configure_file(ecto_rosConfig-version.cmake.in ${CMAKE_BINARY_DIR}/unix_install/ecto_rosConfig-version.cmake @ONLY)

INSTALL(FILES
  ${CMAKE_BINARY_DIR}/unix_install/ecto_rosConfig-version.cmake
  ${CMAKE_BINARY_DIR}/unix_install/ecto_rosConfig.cmake
  DESTINATION ${ECTO_ROS_SHARE_PREFIX}
  COMPONENT main
  )
