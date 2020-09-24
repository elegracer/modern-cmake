cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
project(super)

include(CMakeDependentOption)

set(THIRDPARTY_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/3rdparty")
set(THIRDPARTY_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/deps")

# always generate PIC code, no matter static or shared library
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# options
option(OPTION_A "..." ON)

add_subdirectory(library)

add_subdirectory(pc)
