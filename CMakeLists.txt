cmake_minimum_required(VERSION 3.2)

project(occt-webgl-sample)

set(APP_VERSION_MAJOR 1)
set(APP_VERSION_MINOR 0)
set(APP_TARGET occt-webgl-sample)

# set(CMAKE_C_COMPILER   "/Projects/Github/emsdk/upstream/emscripten/emcc")
# set(CMAKE_CXX_COMPILER "/Projects/Github/emsdk/upstream/emscripten/em++")
# set(CMAKE_CXX_LINK_EXECUTABLE "/Projects/Github/emsdk/upstream/bin/wasm-ld")
#

# Include ExternalProject module
include(ExternalProject)

# Step 1: Download and install emsdk
ExternalProject_Add(emsdk
    GIT_REPOSITORY    https://github.com/emscripten-core/emsdk.git
    GIT_TAG           main
    UPDATE_COMMAND    ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ./emsdk install latest && ./emsdk activate latest
    INSTALL_COMMAND   ""
    LOG_DOWNLOAD      ON
    LOG_UPDATE        ON
    LOG_CONFIGURE     ON
    LOG_BUILD         ON
    LOG_INSTALL       ON
)

# Step 2: Set up the Emscripten toolchain after emsdk is installed
ExternalProject_Get_Property(emsdk SOURCE_DIR)
ExternalProject_Get_Property(emsdk BINARY_DIR)

# The path to the emsdk environment script
set(EMSDK_ENV_SCRIPT "${BINARY_DIR}/emsdk_env.sh")

# Load the emsdk environment (for Unix-like systems)
add_custom_target(activate_emsdk
    COMMAND source ${EMSDK_ENV_SCRIPT} && ${CMAKE_COMMAND} -E env
    COMMENT "Activating emsdk"
)

# Step 3: Set the Emscripten toolchain for the project
set(CMAKE_TOOLCHAIN_FILE "${BINARY_DIR}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")

# Ensure that the emsdk is installed before any targets are built
add_dependencies(activate_emsdk emsdk)

# Add an external project for OpenCascade
ExternalProject_Add(
  FREETYPE
    GIT_REPOSITORY https://gitlab.freedesktop.org/freetype/freetype.git 
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/freetype-install
        -DBUILD_LIBRARY_TYPE=Static
    BUILD_IN_SOURCE 1
    UPDATE_DISCONNECTED 1
    BUILD_COMMAND ${CMAKE_COMMAND} --build . -- -j${NUM_BUILD_THREADS}
)
add_dependencies(FREETYPE activate_emsdk)

include_directories(${CMAKE_BINARY_DIR}/freetype-install/include/)
link_directories(${CMAKE_BINARY_DIR}/freetype-install/lib)

# Add OpenCascade libraries
ExternalProject_Get_Property(FREETYPE binary_dir)
link_directories(${binary_dir}/lib)








# Add an external project for OpenCascade
ExternalProject_Add(
    OCCT
    GIT_REPOSITORY https://github.com/Open-Cascade-SAS/OCCT.git
    GIT_TAG V7_8_1
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -Dfreetype_DIR=${CMAKE_BINARY_DIR}/freetype-install
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/occt-install
        -DBUILD_LIBRARY_TYPE=Static
        -DBUILD_MODULE_ApplicationFramework=ON
        -DBUILD_MODULE_DETools=OFF #static build fails on ExpToCasExe
        -DBUILD_MODULE_DataExchange=ON
        -DBUILD_MODULE_Draw=OFF
        -DBUILD_MODULE_FoundationClasses=ON
        -DBUILD_MODULE_ModelingAlgorithms=ON
        -DBUILD_MODULE_ModelingData=ON
        -DBUILD_MODULE_Visualization=ON
        -DBUILD_DOC_Overview=OFF
        -DBUILD_SAMPLES_QT=OFF
    BUILD_IN_SOURCE 1
    UPDATE_DISCONNECTED 1
    BUILD_COMMAND ${CMAKE_COMMAND} --build . -- -j${NUM_BUILD_THREADS}
)
add_dependencies(OCCT activate_emsdk freetype)

include_directories(${CMAKE_BINARY_DIR}/occt-install/include/opencascade)
link_directories(${CMAKE_BINARY_DIR}/occt-install/lib)

# Add OpenCascade libraries
ExternalProject_Get_Property(OCCT binary_dir)
link_directories(${binary_dir}/lib)



add_dependencies(${PROJECT_NAME} activate_emsdk freetype OCCT)

set(CMAKE_INSTALL_PREFIX "/opt/occt-webgl")
set(OpenCASCADE_DIR "/opt/emsdk-occt/lib/cmake/opencascade")
set(freetype_DIR "/opt/emsdk-freetype/lib/cmake/freetype")
  

# option to enable or disable use of precompiled headers
if (NOT DEFINED SOURCE_MAP_BASE)
  set (SOURCE_MAP_BASE "" CACHE STRING "Path to source map server for debugging C++ code; e.g. http://localhost:9090/")
endif()

# customize build
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --bind")
if (NOT "${SOURCE_MAP_BASE}" STREQUAL "")
  set(CMAKE_CXX_FLAGS_DEBUG "-g4 --source-map-base ${SOURCE_MAP_BASE}")
endif()

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s WASM=1")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s MAX_WEBGL_VERSION=2")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s MODULARIZE=1")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s EXPORT_NAME='createOccViewerModule'")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -sERROR_ON_UNDEFINED_SYMBOLS=0 ")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s ALLOW_MEMORY_GROWTH=1")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --initial_memory=16MB")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s TABLE_BASE=1")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s TOTAL_MEMORY=16MB")
#
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --preload-file myFile")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --extern-post-js ${CMAKE_CURRENT_SOURCE_DIR}/occt-webgl-viewer.js")

INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})
file(GLOB SOURCES
  *.h
  *.cpp
)
source_group ("Headers" FILES
  WasmOcctView.h)
source_group ("Sources" FILES
  WasmOcctView.cpp
  main.cpp)

# FreeType
find_package(freetype REQUIRED NO_DEFAULT_PATH)
if(freetype_FOUND)
  message (STATUS "Using FreeType from \"${freetype_DIR}\"" )
else()
  message(WARNING "Could not find FreeType, please set freetype_DIR variable." )
endif()

# Open CASCADE Technology
find_package(OpenCASCADE REQUIRED NO_DEFAULT_PATH)
if(OpenCASCADE_FOUND)
  message (STATUS "Using OpenCASCADE from \"${OpenCASCADE_DIR}\"" )
  INCLUDE_DIRECTORIES(${OpenCASCADE_INCLUDE_DIR})
  LINK_DIRECTORIES(${OpenCASCADE_LIBRARY_DIR})
else()
  message(WARNING "Could not find OpenCASCADE, please set OpenCASCADE_DIR variable." )
  set(OCCT_LIBRARY_DIR)
  set(OCCT_BIN_DIR)
endif()

set(OpenCASCADE_LIBS TKRWMesh TKDEGLTF TKDEOBJ TKDEPLY TKBinXCAF TKBin TKBinL TKOpenGles TKXCAF TKVCAF TKCAF TKV3d TKHLR TKMesh TKService TKShHealing TKPrim TKTopAlgo TKGeomAlgo TKBRep TKGeomBase TKG3d TKG2d TKMath TKLCAF TKCDF TKernel)

add_executable(${APP_TARGET} ${SOURCES})
target_link_libraries(
  ${APP_TARGET}
  ${OpenCASCADE_LIBS}
  freetype
)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}" LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.wasm DESTINATION ${CMAKE_INSTALL_PREFIX})
if (NOT "${SOURCE_MAP_BASE}" STREQUAL "")
  if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.wasm.map DESTINATION ${CMAKE_INSTALL_PREFIX})
  endif()
endif()
install(FILES occt-webgl-sample.html DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES ${OpenCASCADE_RESOURCE_DIR}/DrawResources/OCC_logo.png  DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES ${OpenCASCADE_RESOURCE_DIR}/DrawResources/lamp.ico      DESTINATION ${CMAKE_INSTALL_PREFIX})
if (CMAKE_CXX_FLAGS MATCHES "-pthread")
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.worker.js DESTINATION ${CMAKE_INSTALL_PREFIX})
endif()
