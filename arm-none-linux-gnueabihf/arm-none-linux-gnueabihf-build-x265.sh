source_root_path=$(pwd)
install_path="${source_root_path}/install"

cd x265-master/source &&
mkdir build
cd build && rm -rf *

touch toolchain.cmake &&
echo "set(CROSS_COMPILE_ARM 1)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv4)

set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)" > toolchain.cmake &&

cmake -G "Unix Makefiles" \
-DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake \
-DCMAKE_INSTALL_PREFIX="${install_path}" \
-DENABLE_SHARED=on \
-DENABLE_PIC=on \
-DENABLE_ASSEMBLY=off \
.. &&

make clean
make -j12 &&
make install

