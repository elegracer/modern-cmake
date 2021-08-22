cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
project(utils LANGUAGES CXX)

add_executable(use_core)
target_sources(use_core PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_core.cpp)
target_link_libraries(use_core PRIVATE core)
