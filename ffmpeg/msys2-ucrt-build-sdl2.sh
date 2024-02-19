source_root_path=$(pwd)
install_path=${source_root_path}/msys2-ucrt-build-install/

get-repo.sh https://gitee.com/mycn027b/SDL.git SDL2 &&
cd SDL &&

if [ ! -d ./build/ ]; then
	mkdir build
fi &&
cd build && rm -rf *

touch toolchain.cmake &&
echo "set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x64)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)" > toolchain.cmake &&

cmake -G "Unix Makefiles" .. \
-DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake \
-DCMAKE_INSTALL_PREFIX=${install_path} &&

make -j12 && make install
