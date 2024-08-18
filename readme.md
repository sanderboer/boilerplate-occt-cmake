# OpenCascade CMake Boilerplate, Emscripten Edition

This project is a boilerplate setup for using the OpenCascade Technology (OCCT) library in a CMake-based project. It demonstrates how to fetch, build, and link against the OpenCascade library using modern CMake practices.

## Features

- **bootstrap Emscripten with freetype**: Downloads and activates Emscripten to bootstrap Emscripten with freetype support.
- **Bash scripts**: Uses a number of seperate bash scripts to download and install emsdk and download and build OpenCascade using Emscripten. 

The scripts are split by the different stages of the build process, these are used to set up a build environment for the main project. Its dependencies are installed in the 'deps' folder.
## Prerequisites

- **Python** (version 3.10 or higher), necessary for Emscripten's freetype port initialization
- **CMake** (version 3.10 or higher)
- **Git** (to clone the OpenCascade repository)

## Project Structure

```plaintext
OpenCascadeProject/
├── CMakeLists.txt          # Main CMake build script
├── src/
│   └── main.cpp            # Example source file using OpenCascade
├─── deps/                  # Project dependencies directory (generated during the setup process)
└─── build/                 # Build directory (generated during the build process)

## Alternative Setup
Once emsdk has been bootstrapped with freetype support, OpenCascade can also be initialized using the ExternalProject_Add mechanism.
A number of different setups have been tried (and failed), embarassing proof has been left in the archive folder for future reference.
It turns out that bootstrapping emsk with freetype is not really something cmake can accommodate and my efforts where also marred by a local python version that could not accommodate emscripten's port system.
As awesome as cmake is, it it also quite byzantine and bootstrapping external dependencies are not always possible. That is why for now I switched to a script based setup.
