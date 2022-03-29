#!/bin/bash -e
cd "$(dirname "$0")"
if [ -f "build-android.conf" ]; then
    source build-android.conf
else
    echo "Modify 'build-android.conf' before continue."
    cp build-android.conf.defaults build-android.conf
    exit 1
fi

ANDROID_TOOLCHAIN="clang"
ANDROID_MIN_API_LEVEL="android-27"
ANDROID_STL="c++_static"

if [ -f "build/android/${ANDROID_ABI}/CMakeCache.txt" ]; then
    rm build/android/${ANDROID_ABI}/CMakeCache.txt
fi

CMAKE_BUILD_TYPE="RelWithDebInfo"

cmake \
    -S . \
    -B build/android/${ANDROID_ABI} \
    -G Ninja \
    -D CMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -D CMAKE_EXPORT_COMPILE_COMMANDS=1 \
    -D ANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
    -D CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
    -D ANDROID_NDK=${ANDROID_NDK} \
    -D ANDROID_ABI=${ANDROID_ABI} \
    -D ANDROID_PLATFORM=${ANDROID_MIN_API_LEVEL} \
    -D ANDROID_STL=${ANDROID_STL}

cp build/android/${ANDROID_ABI}/compile_commands.json build/

cmake --build build/android/${ANDROID_ABI} --config ${CMAKE_BUILD_TYPE}
