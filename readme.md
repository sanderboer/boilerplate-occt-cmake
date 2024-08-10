# OpenCascade CMake Boilerplate

This project is a boilerplate setup for using the OpenCascade Technology (OCCT) library in a CMake-based project. It demonstrates how to fetch, build, and link against the OpenCascade library using modern CMake practices.

## Features

- **CMake Integration**: Uses `ExternalProject_Add` to fetch and build the OpenCascade library from the official GitHub repository.
- **Multi-threaded Build**: Supports multi-threaded building of the OpenCascade library for faster compilation.
- **Customizable**: Easily customizable to add more libraries or adjust build settings.

## Prerequisites

- **CMake** (version 3.10 or higher)
- **Git** (to clone the OpenCascade repository)
- **C++ Compiler** (supporting C++14 or higher)

## Project Structure

```plaintext
OpenCascadeProject/
├── CMakeLists.txt          # Main CMake build script
├── src/
│   └── main.cpp            # Example source file using OpenCascade
└── build/                  # Build directory (generated during the build process)
