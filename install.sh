# Create build dir.
rm -r ./build
mkdir -p build && cd build

# CMake configure.
CMAKE_ARGS=\
\ -DCMAKE_BUILD_TYPE="Release"\
\ -DBUILD_TESTING=ON

if [ $# -eq 0 ]
then
    cmake $CMAKE_ARGS ..
    cmake --build . -- VERBOSE=1 -j16 all test
else
    cmake $CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=$1 ..  
    cmake --build . -- VERBOSE=1 -j16 all test install
fi
