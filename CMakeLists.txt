
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

# Include ExternalProject module
include(ExternalProject)

# Add an external project for OpenCascade
ExternalProject_Add(
    OCCT
    GIT_REPOSITORY https://github.com/Open-Cascade-SAS/OCCT.git
    GIT_TAG V7_8_1
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/occt-install
        -DBUILD_DOC_Overview=OFF
        -DBUILD_SAMPLES_QT=OFF
    BUILD_IN_SOURCE 1
    UPDATE_DISCONNECTED 1
    BUILD_COMMAND ${CMAKE_COMMAND} --build . -- -j${NUM_BUILD_THREADS}
)

# Add OpenCascade include directories
ExternalProject_Get_Property(OCCT source_dir)
include_directories(${source_dir}/include/opencascade)

# Add OpenCascade libraries
ExternalProject_Get_Property(OCCT binary_dir)
link_directories(${binary_dir}/lib)

# Add OpenCascade include directories from the installation path
#include_directories(${CMAKE_BINARY_DIR}/occt-install/include/opencascade)
#include_directories(${binary_dir}/include/opencascade)

# Add OpenCascade libraries from the installation path
#link_directories(${CMAKE_BINARY_DIR}/occt-install/lib)

# Add source files
file(GLOB_RECURSE SOURCES src/*.cpp)

# Add the executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Link against OpenCascade libraries after they've been built
add_dependencies(${PROJECT_NAME} OCCT)
target_link_libraries(${PROJECT_NAME} 
    TKernel
    TKMath
    TKG2d
    TKG3d
    TKBRep
    TKGeomBase
    TKGeomAlgo
    TKTopAlgo
    TKPrim
    TKBO
    TKShHealing
    TKXMesh
)
