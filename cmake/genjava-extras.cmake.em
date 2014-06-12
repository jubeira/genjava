@[if DEVELSPACE]@
# location of scripts in develspace
set(GENJAVA_BIN_DIR "@(CMAKE_CURRENT_SOURCE_DIR)/scripts")
@[else]@
# location of scripts in installspace
set(GENJAVA_BIN_DIR "${GENJAVA_DIR}/../../../@(CATKIN_PACKAGE_BIN_DESTINATION)")
@[end if]@

set(GENMSG_JAVA_BIN ${GENJAVA_BIN_DIR}/genmsg_java.py)
set(GENSRV_JAVA_BIN ${GENJAVA_BIN_DIR}/gensrv_java.py)

# Generate .msg->.h for py
# The generated .h files should be added ALL_GEN_OUTPUT_FILES_py
macro(_generate_msg_java ARG_PKG ARG_MSG ARG_IFLAGS ARG_MSG_DEPS ARG_GEN_OUTPUT_DIR)

  message(STATUS "GEN_MSG_JAVA..........._generate_msg_java")
  message(STATUS "  ARG_PKG..............${ARG_PKG}")
  message(STATUS "  ARG_MSG..............${ARG_MSG}")
  message(STATUS "  ARG_IFLAGS...........${ARG_IFLAGS}")
  message(STATUS "  ARG_MSG_DEPS.........${ARG_MSG_DEPS}")
  message(STATUS "  ARG_GEN_OUTPUT_DIR...${ARG_GEN_OUTPUT_DIR}")

  #Append msg to output dir
#  set(GEN_OUTPUT_DIR "${ARG_GEN_OUTPUT_DIR}/msg")
#  file(MAKE_DIRECTORY ${GEN_OUTPUT_DIR})
  #Create input and output filenames
#  get_filename_component(MSG_SHORT_NAME ${ARG_MSG} NAME_WE)
#
#  set(MSG_GENERATED_NAME _${MSG_SHORT_NAME}.py)
#  set(GEN_OUTPUT_FILE ${GEN_OUTPUT_DIR}/${MSG_GENERATED_NAME})
#
#  add_custom_command(OUTPUT ${GEN_OUTPUT_FILE}
#    DEPENDS ${GENMSG_PY_BIN} ${ARG_MSG} ${ARG_MSG_DEPS}
#    COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_PY_BIN} ${ARG_MSG}
#    ${ARG_IFLAGS}
#    -p ${ARG_PKG}
#    -o ${GEN_OUTPUT_DIR}
#    COMMENT "Generating Python from MSG ${ARG_PKG}/${MSG_SHORT_NAME}"
#    )
#
#  list(APPEND ALL_GEN_OUTPUT_FILES_py ${GEN_OUTPUT_FILE})

endmacro()

#todo, these macros are practically equal. Check for input file extension instead
macro(_generate_srv_java ARG_PKG ARG_SRV ARG_IFLAGS ARG_MSG_DEPS ARG_GEN_OUTPUT_DIR)

  message(STATUS "GEN_SRV_JAVA..........._generate_srv_java")
  #Append msg to output dir
#  set(GEN_OUTPUT_DIR "${ARG_GEN_OUTPUT_DIR}/srv")
#  file(MAKE_DIRECTORY ${GEN_OUTPUT_DIR})
#
  #Create input and output filenames
#  get_filename_component(SRV_SHORT_NAME ${ARG_SRV} NAME_WE)
#
#  set(SRV_GENERATED_NAME _${SRV_SHORT_NAME}.py)
#  set(GEN_OUTPUT_FILE ${GEN_OUTPUT_DIR}/${SRV_GENERATED_NAME})
#
#  add_custom_command(OUTPUT ${GEN_OUTPUT_FILE}
#    DEPENDS ${GENSRV_PY_BIN} ${ARG_SRV} ${ARG_MSG_DEPS}
#    COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENSRV_PY_BIN} ${ARG_SRV}
#    ${ARG_IFLAGS}
#    -p ${ARG_PKG}
#    -o ${GEN_OUTPUT_DIR}
#    COMMENT "Generating Python code from SRV ${ARG_PKG}/${SRV_SHORT_NAME}"
#    )
#
#  list(APPEND ALL_GEN_OUTPUT_FILES_py ${GEN_OUTPUT_FILE})

endmacro()

macro(_generate_module_java ARG_PKG ARG_GEN_OUTPUT_DIR ARG_GENERATED_FILES)

  message(STATUS "GEN_MODULE_PY..........._generate_module_py")
  # generate empty __init__ to make parent folder of msg/srv a python module
  if(NOT EXISTS ${ARG_GEN_OUTPUT_DIR}/__init__.py)
    file(WRITE ${ARG_GEN_OUTPUT_DIR}/__init__.py "")
  endif()

  #Append msg to output dir
  foreach(type "msg" "srv")
    set(GEN_OUTPUT_DIR "${ARG_GEN_OUTPUT_DIR}/${type}")
    set(GEN_OUTPUT_FILE ${GEN_OUTPUT_DIR}/__init__.py)

    if(IS_DIRECTORY ${GEN_OUTPUT_DIR})
      add_custom_command(OUTPUT ${GEN_OUTPUT_FILE}
        DEPENDS ${GENMSG_PY_BIN} ${ARG_GENERATED_FILES}
        COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_PY_BIN}
        -o ${GEN_OUTPUT_DIR}
        --initpy
        COMMENT "Generating Python ${type} __init__.py for ${ARG_PKG}")
      list(APPEND ALL_GEN_OUTPUT_FILES_py ${GEN_OUTPUT_FILE})
    endif()

  endforeach()

endmacro()

if(NOT EXISTS @(PROJECT_NAME)_SOURCE_DIR)
  set(GENJAVA_INSTALL_DIR ${PYTHON_INSTALL_DIR})
endif()