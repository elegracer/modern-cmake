cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
project(utils LANGUAGES CXX)

add_executable(use_boost)
target_sources(use_boost PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_boost.cpp)
target_link_libraries(use_boost PRIVATE core)

add_executable(use_core)
target_sources(use_core PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_core.cpp)
target_link_libraries(use_core PRIVATE core)

add_executable(use_eigen)
target_sources(use_eigen PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_eigen.cpp)
target_link_libraries(use_eigen PRIVATE core)

add_executable(use_lyra)
target_sources(use_lyra PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_lyra.cpp)
target_link_libraries(use_lyra PRIVATE core)

add_executable(use_range)
target_sources(use_range PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_range.cpp)
target_link_libraries(use_range PRIVATE core)

add_executable(use_spdlog)
target_sources(use_spdlog PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/use_spdlog.cpp)
target_link_libraries(use_spdlog PRIVATE core)
