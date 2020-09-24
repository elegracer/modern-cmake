cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
project(library VERSION 1.1.0 LANGUAGES CXX)

# ccache
find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
    message(STATUS "Found CCache")
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

# cxx standard
add_library(options::modern-cpp INTERFACE IMPORTED GLOBAL)
target_compile_features(options::modern-cpp INTERFACE cxx_std_17)

# always generate PIC code, no matter static or shared library
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# dependencies
find_package(Eigen3 REQUIRED)
add_library(depends::eigen INTERFACE IMPORTED GLOBAL)
target_link_libraries(
    depends::eigen INTERFACE options::modern-cpp Eigen3::Eigen
)

# core library
configure_file(cmake/version.h.in include/core/version.h)

set(CORE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(CORE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(CORE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(CORE_BINARY_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)

set(CORE_PUBLIC_HEADERS ${CORE_BINARY_INCLUDE_DIR}/core/version.h
                        ${CORE_INCLUDE_DIR}/core/core.h
)
set(CORE_PUBLIC_SOURCES)
set(CORE_PRIVATE_HEADERS)
set(CORE_PRIVATE_SOURCES ${CORE_SOURCE_DIR}/core/core.cpp)

add_library(core)
set_target_properties(core PROPERTIES CXX_EXTENSIONS OFF
)# -std=c++** instead of -std=g++**
target_sources(
    core PRIVATE ${CORE_PUBLIC_HEADERS} ${CORE_PUBLIC_SOURCES}
                 ${CORE_PRIVATE_HEADERS} ${CORE_PRIVATE_SOURCES}
)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(
        core PUBLIC $<$<AND:$<CONFIG:Release>,$<NOT:$<BOOL:${WEB}>>>:-O3 -g>
                    $<$<CONFIG:Debug>:-O0 -g> PRIVATE -Qunused-arguments -mllvm
                                                      -inline-threshold=5000
    )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    target_compile_options(
        core PUBLIC $<$<AND:$<CONFIG:Release>,$<NOT:$<BOOL:${WEB}>>>:-O3 -g>
                    $<$<CONFIG:Debug>:-O0 -g> PRIVATE -march=native
    )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    target_compile_definitions(core PRIVATE _CRT_SECURE_NO_WARNINGS)
endif()
target_include_directories(
    core PUBLIC ${CORE_INCLUDE_DIR} ${CORE_BINARY_INCLUDE_DIR}
    PRIVATE ${CORE_SOURCE_DIR}
)
target_compile_features(core PUBLIC cxx_std_17)
target_link_libraries(core PUBLIC depends::eigen)
