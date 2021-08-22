cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
project(core VERSION 1.0.0.0 LANGUAGES CXX)

# dependencies
# find_package(Eigen3 REQUIRED)
# add_library(depends::eigen INTERFACE IMPORTED GLOBAL)
# target_link_libraries(
#     depends::eigen INTERFACE options::modern-cpp Eigen3::Eigen
# )

# core library
configure_file(cmake/version.h.in include/core/version.h)

add_library(core)
target_sources(
    core
    PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include/core/version.h
            ${CMAKE_CURRENT_SOURCE_DIR}/src/core/core.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/core/core.h
)
target_compile_options(
    core PUBLIC -O3 -g PRIVATE -Qunused-arguments -mllvm -inline-threshold=5000
)
target_include_directories(
    core PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include
                ${CMAKE_CURRENT_SOURCE_DIR}/src
)
# target_link_libraries(core PUBLIC depends::eigen)
