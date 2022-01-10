cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
project(super)

set(CMAKE_POLICY_DEFAULT_CMP0120 OLD)
set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)

include(CMakeDependentOption)

# ccache
find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    message(STATUS "Found CCache")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

# set global cxx standard
set(CMAKE_CXX_STANDARD 17)
# always generate position independent code, no matter static or shared library
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# disable cpp extensions
set(CMAKE_CXX_EXTENSIONS OFF)
# # link time optimization
# set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

# set global cxx flags for different build types
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g -DNDEBUG")
set(CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG")

set(THIRDPARTY_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/3rdparty")
set(THIRDPARTY_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/deps")

# options
option(OPTION_A "..." ON)

add_subdirectory(core)

add_subdirectory(utils)
