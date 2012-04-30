foreach(file pubsub_gen_wrap.cmake gen_msg_wrappers.py)
    file(COPY ${PROJECT_SOURCE_DIR}/cmake/${file}
         DESTINATION ${CMAKE_BINARY_DIR}/cmake/ecto_ros
         USE_SOURCE_PERMISSIONS
    )
endforeach()

#install the extra CMake files
install(DIRECTORY ${CMAKE_BINARY_DIR}/cmake/ecto_ros/
        DESTINATION share/ecto_ros/cmake
        COMPONENT main
)

include(pubsub_gen_wrap.cmake)
