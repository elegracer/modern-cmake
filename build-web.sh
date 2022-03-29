#!/bin/bash -e

PROJ_DIR=$(
    cd "$(dirname "$0")"
    pwd
)
echo $PROJ_DIR

if [ -f "build/web/CMakeCache.txt" ]; then
    rm build/web/CMakeCache.txt
fi

CMAKE_BUILD_TYPE="Release"

echo "Build lvo for web"
emcmake cmake \
    -S . \
    -B build/web \
    -D CMAKE_EXPORT_COMPILE_COMMANDS=1 \
    -D CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

cp build/web/compile_commands.json build/

cmake --build build/web --config ${CMAKE_BUILD_TYPE}
