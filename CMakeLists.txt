cmake_minimum_required(VERSION 3.14)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
project(modern-cmake LANGUAGES C CXX VERSION 0.0.1.0)

include(CMakeDependentOption)

find_program(CCACHE ccache)
if(CCACHE)
    message(STATUS "ccache found")
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
else()
    message(STATUS "ccache not found")
endif()

# Set the output directory for libraries and executables
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)

# set global cxx standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# always generate position independent code, no matter static or shared library
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# disable cpp extensions
set(CMAKE_CXX_EXTENSIONS OFF)
# # link time optimization
# set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)


set(THIRDPARTY_SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/3rdparty)

# options
option(OPTION_A "..." ON)

# core library
configure_file(cmake/version.h.in include/core/version.h)

add_library(core)
target_sources(core
    PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}/include/core/version.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/core/core.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/core/core.h
)
target_include_directories(core
    PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# utils
add_executable(use_core)
target_sources(use_core
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/utils/use_core.cpp
)
target_link_libraries(use_core
    PRIVATE
        core
)
