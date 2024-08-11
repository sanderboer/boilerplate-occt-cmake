cmake_minimum_required(VERSION 3.10)

# Project name
project(OpenCascadeProject)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Define the number of threads (default to the number of available processors)
if(NOT DEFINED NUM_BUILD_THREADS)
  set(NUM_BUILD_THREADS 4)
endif()

# Set default build type to Debug if not specified
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

# Include ExternalProject module
include(ExternalProject)

# Add an external project for OpenCascade
ExternalProject_Add(
    OCCT
    GIT_REPOSITORY https://github.com/Open-Cascade-SAS/OCCT.git
    GIT_TAG V7_8_1
    CMAKE_ARGS
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
include_directories(${CMAKE_BINARY_DIR}/occt-install/include/opencascade)
link_directories(${CMAKE_BINARY_DIR}/occt-install/lib)

# Add an external project for raylib
ExternalProject_Add(
    raylib
    GIT_REPOSITORY https://github.com/raysan5/raylib.git
    GIT_TAG 5.0
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/raylib-install
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_EXAMPLES=OFF
        -DENABLE_ASAN=OFF
        -DENABLE_UBSAN=OFF
        -DMACOS_FATLIB=OFF
        -DUSE_AUDIO=OFF

    BUILD_IN_SOURCE 1
    UPDATE_DISCONNECTED 1
    BUILD_COMMAND ${CMAKE_COMMAND} --build . -- -j${NUM_BUILD_THREADS}
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install
)
include_directories(${CMAKE_BINARY_DIR}/raylib-install/include)
link_directories(${CMAKE_BINARY_DIR}/raylib-install/lib64)

# Fetch raygui (header-only library, no build required)
ExternalProject_Add(
    raygui
    GIT_REPOSITORY https://github.com/raysan5/raygui.git
    GIT_TAG 4.0
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    SOURCE_SUBDIR src
)
# Include raygui header directory
ExternalProject_Get_Property(raygui source_dir)
include_directories(${source_dir}/src)

# Set the output directory for the executable based on build type
set(CUSTOM_BIN_DIR ${CMAKE_BINARY_DIR}/bin/$<CONFIG>)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CUSTOM_BIN_DIR})


# Set the output directories for the executable based on build type
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin/Debug)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin/Release)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_BINARY_DIR}/bin/RelWithDebInfo)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL ${CMAKE_BINARY_DIR}/bin/MinSizeRel)

# Set RPATH to ensure the executable finds the libraries
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH "$ORIGIN")

# Add source files
file(GLOB_RECURSE SOURCES src/*.cpp)

# Add the executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Link against OpenCascade libraries after they've been built
add_dependencies(${PROJECT_NAME} OCCT raylib raygui)

# # Link against OpenCascade and raylib static libraries
# target_link_libraries(${PROJECT_NAME} 
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKBO.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKernel.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKMath.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKG2d.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKG3d.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKBRep.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKGeomBase.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKGeomAlgo.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKTopAlgo.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKPrim.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKBO.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKShHealing.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKXMesh.a
#     # ${CMAKE_BINARY_DIR}/occt-install/lib/libTKXSBase.a
#     # ${CMAKE_BINARY_DIR}/raylib-install/lib64/libraylib.a
#     TKPrim.a
#     raylib.a
#     m
#     pthread
# )

target_link_libraries(${PROJECT_NAME} 
   raylib.a
    m
    pthread

  -Wl,--whole-archive   
      TKernel.a 
      TKBO.a
      TKBRep.a
      TKBin.a
      TKBinL.a
      TKBinTObj.a
      TKBinXCAF.a
      TKBool.a
     # TKCAF.a
     # TKCDF.a
      TKDE.a
      TKDECascade.a
     # TKDEGLTF.a
     # TKDEIGES.a
     # TKDEOBJ.a
     # TKDEPLY.a
     # TKDESTEP.a
     # TKDESTL.a
     # TKDEVRML.a
      TKFeat.a
      TKFillet.a
      TKG2d.a
      TKG3d.a
      TKGeomAlgo.a
      TKGeomBase.a
     # TKHLR.a
     # TKLCAF.a
      TKMath.a
      TKMesh.a
      TKMeshVS.a
      TKOffset.a
      TKOpenGl.a
      TKPrim.a
      TKRWMesh.a
      TKService.a
      TKShHealing.a
      TKStd.a
      TKStdL.a
     # TKTObj.a
      TKTopAlgo.a
     # TKV3d.a
     # TKVCAF.a
     # TKXCAF.a
     # TKXMesh.a
     # TKXSBase.a
     # TKXml.a
     # TKXmlL.a
     # TKXmlTObj.a
     # TKXmlXCAF.a
)
#
# Post-build step to copy necessary libraries to the bin directory based on build type
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
       $<TARGET_FILE_DIR:${PROJECT_NAME}>
)


