source_root_path=$(pwd)
install_path="${source_root_path}/install"

cd SDL2/ &&
if [ ! -d ./build/ ]; then
	mkdir build
fi &&
cd build && rm -rf *

touch toolchain.cmake &&
echo "set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_x64)
set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
# 确保查找库和头文件时仅在交叉编译环境中查找
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"> toolchain.cmake &&

cmake -G "Unix Makefiles" .. \
-DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake \
-DCMAKE_INSTALL_PREFIX="${install_path}" &&

make clean
make -j12 &&
make install

