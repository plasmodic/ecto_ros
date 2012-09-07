macro(pytest pyfile)
  string(REPLACE ";" " " args "${ARGN}")
if (ROS_GROOVY_FOUND)
  add_test(ros_${pyfile}
    ${CMAKE_CURRENT_SOURCE_DIR}/run_test.sh  ${CATKIN_BUILD_PREFIX}/setup.sh ${CMAKE_CURRENT_SOURCE_DIR}/${pyfile}.py ${args}
    )
else()
  add_test(ros_${pyfile}
    ${CMAKE_CURRENT_SOURCE_DIR}/run_test.sh  ${CMAKE_BINARY_DIR}/setup.sh ${CMAKE_CURRENT_SOURCE_DIR}/${pyfile}.py ${args}
    )
endif()
endmacro()

macro(data_download PATH_VAR DATA_FILE)
  set(data_base_url http://vault.willowgarage.com/wgdata1/vol1/ecto_data)
  set(${PATH_VAR} ${PROJECT_BINARY_DIR}/data/${DATA_FILE})
  if(NOT EXISTS ${${PATH_VAR}})
    message(STATUS "Data fetch.\n** Downloading:\n** ${data_base_url}/${DATA_FILE}\n** to:\n** ${${PATH_VAR}}")
    file(DOWNLOAD ${data_base_url}/${DATA_FILE} ${${PATH_VAR}})
  endif()
endmacro()

data_download(T01 t01.bag)
pytest(test_bag ${T01} )
#pytest(test_sync_sub ${T01} ) 
#pytest(test_image_sub ${T01} )
#pytest(test_image_sub_threadpool ${T01} )
#pytest(test_reinit ${T01} )
#pytest(test_reinit_threadpool ${T01} )
