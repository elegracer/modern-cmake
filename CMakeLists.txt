cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")
project(super)

set(CMAKE_POLICY_DEFAULT_CMP0120 OLD)
set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)

include(FetchContent)
set(FETCHCONTENT_QUIET OFF)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
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

## 3rdparty libraries

# spdlog
FetchContent_Declare(
    spdlog
    URL https://github.com/gabime/spdlog/archive/refs/tags/v1.10.0.tar.gz
    URL_HASH MD5=effea813cd81cfb5588806c5754e14f1
    DOWNLOAD_NAME spdlog-1.10.0.tar.gz
    DOWNLOAD_DIR ${THIRDPARTY_SOURCE_DIR}
    # SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}/spdlog-src
)
FetchContent_GetProperties(spdlog)
if(NOT spdlog_POPULATED)
    FetchContent_Populate(spdlog)
endif()
add_subdirectory(${spdlog_SOURCE_DIR} ${spdlog_BINARY_DIR})
add_library(depends::spdlog INTERFACE IMPORTED GLOBAL)
target_link_libraries(depends::spdlog INTERFACE spdlog::spdlog_header_only)
set(spdlog-source-dir ${spdlog_SOURCE_DIR} CACHE INTERNAL "" FORCE)
set(spdlog-binary-dir ${spdlog_BINARY_DIR} CACHE INTERNAL "" FORCE)
mark_as_advanced(spdlog-source-dir)
mark_as_advanced(spdlog-binary-dir)

# boost
FetchContent_Declare(
    boost
    URL https://boostorg.jfrog.io/artifactory/main/beta/1.79.0.beta1/source/boost_1_79_0_b1.tar.gz
    URL_HASH MD5=b2a240d67680ef965a5167e974c1c0e8
    DOWNLOAD_NAME boost-1.79.0-b1.tar.gz
    DOWNLOAD_DIR ${THIRDPARTY_SOURCE_DIR}
    # SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}/boost-src
)
FetchContent_GetProperties(boost)
if(NOT boost_POPULATED)
    FetchContent_Populate(boost)
endif()
add_library(depends::boost INTERFACE IMPORTED GLOBAL)
target_include_directories(depends::boost INTERFACE ${boost_SOURCE_DIR})
set(boost-source-dir ${boost_SOURCE_DIR} CACHE INTERNAL "" FORCE)
set(boost-binary-dir ${boost_BINARY_DIR} CACHE INTERNAL "" FORCE)
mark_as_advanced(boost-source-dir)
mark_as_advanced(boost-binary-dir)

# eigen
FetchContent_Declare(
    eigen
    URL https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz
    URL_HASH MD5=4c527a9171d71a72a9d4186e65bea559
    DOWNLOAD_NAME eigen-3.4.0.tar.gz
    DOWNLOAD_DIR ${THIRDPARTY_SOURCE_DIR}
    # SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}/eigen-src
)
FetchContent_GetProperties(eigen)
if(NOT eigen_POPULATED)
    FetchContent_Populate(eigen)
endif()
file(READ "${eigen_SOURCE_DIR}/Eigen/src/Core/util/Macros.h" _eigen_version_header)
string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen_world_version_match "${_eigen_version_header}")
set(EIGEN_WORLD_VERSION "${CMAKE_MATCH_1}")
string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen_major_version_match "${_eigen_version_header}")
set(EIGEN_MAJOR_VERSION "${CMAKE_MATCH_1}")
string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen_minor_version_match "${_eigen_version_header}")
set(EIGEN_MINOR_VERSION "${CMAKE_MATCH_1}")
set(EIGEN_VERSION_NUMBER ${EIGEN_WORLD_VERSION}.${EIGEN_MAJOR_VERSION}.${EIGEN_MINOR_VERSION})

set(INCLUDE_INSTALL_DIR "${CMAKE_INSTALL_INCLUDEDIR}/eigen3" CACHE PATH "The directory relative to CMAKE_INSTALL_PREFIX where Eigen header files are installed")
set(CMAKEPACKAGE_INSTALL_DIR "${CMAKE_INSTALL_DATADIR}/eigen3/cmake" CACHE PATH "The directory relative to CMAKE_INSTALL_PREFIX where Eigen3Config.cmake is installed")
# message(STATUS "${CMAKE_INSTALL_INCLUDEDIR} ${CMAKE_INSTALL_DATADIR}")
# message(STATUS "${INCLUDE_INSTALL_DIR} ${CMAKEPACKAGE_INSTALL_DIR}")

set(EIGEN_VERSION_STRING ${EIGEN_VERSION_NUMBER})
set(EIGEN_VERSION_MAJOR  ${EIGEN_WORLD_VERSION})
set(EIGEN_VERSION_MINOR  ${EIGEN_MAJOR_VERSION})
set(EIGEN_VERSION_PATCH  ${EIGEN_MINOR_VERSION})
set(EIGEN_DEFINITIONS "")
set(EIGEN_INCLUDE_DIR "${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}")
set(EIGEN_ROOT_DIR ${CMAKE_INSTALL_PREFIX})

add_library(eigen INTERFACE)
add_library(Eigen3::Eigen ALIAS eigen)
target_include_directories(eigen INTERFACE
    $<BUILD_INTERFACE:${eigen_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}>
)
# Export as title case Eigen
set_target_properties (eigen PROPERTIES EXPORT_NAME Eigen)
install(TARGETS eigen EXPORT Eigen3Targets)
configure_package_config_file (
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Eigen3Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/Eigen3Config.cmake
    PATH_VARS EIGEN_INCLUDE_DIR EIGEN_ROOT_DIR
    INSTALL_DESTINATION ${CMAKEPACKAGE_INSTALL_DIR}
    NO_CHECK_REQUIRED_COMPONENTS_MACRO # Eigen does not provide components
)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/Eigen3ConfigVersion.cmake
    VERSION ${EIGEN_VERSION_NUMBER}
    COMPATIBILITY SameMajorVersion
)
export(TARGETS eigen NAMESPACE Eigen3:: FILE Eigen3Targets.cmake)
export(PACKAGE Eigen3)
install(
    EXPORT Eigen3Targets
    NAMESPACE Eigen3::
    DESTINATION ${CMAKEPACKAGE_INSTALL_DIR}
)
install(
    FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/UseEigen3.cmake
          ${CMAKE_CURRENT_BINARY_DIR}/Eigen3Config.cmake
          ${CMAKE_CURRENT_BINARY_DIR}/Eigen3ConfigVersion.cmake
    DESTINATION ${CMAKEPACKAGE_INSTALL_DIR}
)

add_library(depends::eigen INTERFACE IMPORTED GLOBAL)
target_link_libraries(depends::eigen INTERFACE Eigen3::Eigen)
set(eigen-source-dir ${eigen_SOURCE_DIR} CACHE INTERNAL "" FORCE)
set(eigen-binary-dir ${eigen_BINARY_DIR} CACHE INTERNAL "" FORCE)
mark_as_advanced(eigen-source-dir)
mark_as_advanced(eigen-binary-dir)

# ceres-solver
FetchContent_Declare(
    ceres-solver
    URL https://github.com/ceres-solver/ceres-solver/archive/refs/tags/2.1.0.tar.gz
    URL_HASH MD5=4ab48f439d63a09a075d4fcdcddc7667
    DOWNLOAD_NAME ceres-solver-2.1.0.tar.gz
    DOWNLOAD_DIR ${THIRDPARTY_SOURCE_DIR}
    # SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}/ceres-solver-src
)
set(Eigen3_DIR ${CMAKE_CURRENT_BINARY_DIR} CACHE PATH "" FORCE)
set(MINIGLOG ON CACHE BOOL "" FORCE)
set(GFLAGS OFF CACHE BOOL "" FORCE)
set(SUITESPARSE OFF CACHE BOOL "" FORCE)
set(CXSPARSE OFF CACHE BOOL "" FORCE)
set(CUDA OFF CACHE BOOL "" FORCE)
set(LAPACK OFF CACHE BOOL "" FORCE)
set(SCHUR_SPECIALIZATIONS OFF CACHE BOOL "" FORCE)
set(CUSTOM_BLAS OFF CACHE BOOL "" FORCE)
set(EIGENSPARSE ON CACHE BOOL "" FORCE)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE BOOL "" FORCE)
set(PROVIDE_UNINSTALL_TARGET OFF CACHE BOOL "" FORCE)
FetchContent_GetProperties(ceres-solver)
if(NOT ceres-solver_POPULATED)
    FetchContent_Populate(ceres-solver)
endif()
add_subdirectory(${ceres-solver_SOURCE_DIR} ${ceres-solver_BINARY_DIR})
add_library(depends::ceres-solver INTERFACE IMPORTED GLOBAL)
target_link_libraries(depends::ceres-solver INTERFACE ceres)
set(ceres-solver-source-dir ${ceres-solver_SOURCE_DIR} CACHE INTERNAL "" FORCE)
set(ceres-solver-binary-dir ${ceres-solver_BINARY_DIR} CACHE INTERNAL "" FORCE)
mark_as_advanced(ceres-solver-source-dir)
mark_as_advanced(ceres-solver-binary-dir)

# lyra
FetchContent_Declare(
    lyra
    URL https://github.com/bfgroup/Lyra/archive/refs/tags/1.6.tar.gz
    URL_HASH MD5=08b7b28aacb0bf07f28dbd5d0858c6ea
    DOWNLOAD_NAME lyra-1.6.tar.gz
    DOWNLOAD_DIR ${THIRDPARTY_SOURCE_DIR}
    # SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}/lyra-src
)
FetchContent_GetProperties(lyra)
if(NOT lyra_POPULATED)
    FetchContent_Populate(lyra)
endif()
add_subdirectory(${lyra_SOURCE_DIR} ${lyra_BINARY_DIR})
add_library(depends::lyra INTERFACE IMPORTED GLOBAL)
target_link_libraries(depends::lyra INTERFACE bfg::lyra)
set(lyra-source-dir ${lyra_SOURCE_DIR} CACHE INTERNAL "" FORCE)
set(lyra-binary-dir ${lyra_BINARY_DIR} CACHE INTERNAL "" FORCE)
mark_as_advanced(lyra-source-dir)
mark_as_advanced(lyra-binary-dir)

# range-v3
FetchContent_Declare(
    range-v3
    URL https://github.com/ericniebler/range-v3/archive/d800a032132512a54c291ce55a2a43e0460591c7.zip
    URL_HASH MD5=0319befb31e9ffbeddd1b332227f8fbe
    DOWNLOAD_NAME range-v3-d800a03.zip
    DOWNLOAD_DIR ${THIRDPARTY_SOURCE_DIR}
    # SOURCE_DIR ${THIRDPARTY_SOURCE_DIR}/range-v3-src
)
FetchContent_GetProperties(range-v3)
if(NOT range-v3_POPULATED)
    FetchContent_Populate(range-v3)
endif()
add_library(depends::range-v3 INTERFACE IMPORTED GLOBAL)
target_include_directories(depends::range-v3 INTERFACE "${range-v3_SOURCE_DIR}/include")
set(range-v3-source-dir ${range-v3_SOURCE_DIR} CACHE INTERNAL "" FORCE)
set(range-v3-binary-dir ${range-v3_BINARY_DIR} CACHE INTERNAL "" FORCE)
mark_as_advanced(range-v3-source-dir)
mark_as_advanced(range-v3-binary-dir)

# options
option(OPTION_A "..." ON)

add_subdirectory(core)

add_subdirectory(utils)
