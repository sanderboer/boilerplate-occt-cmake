#!/bin/bash

# Set the build directory name
BUILD_DIR="build"

# Check if the build directory exists
if [ -d "$BUILD_DIR" ]; then
  echo "Build directory '$BUILD_DIR' already exists."
else
  # Create the build directory
  echo "Creating build directory '$BUILD_DIR'."
  mkdir "$BUILD_DIR"
fi

# Change to the build directory
pushd "$BUILD_DIR"

# Run CMake
echo "Running CMake..."
cmake ..

# Build the project
echo "Building the project..."
cmake --build .

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo "Build successful."
else
  echo "Build failed."
fi

popd
