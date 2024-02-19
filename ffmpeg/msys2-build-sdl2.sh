# 需要环境变量 PATH
# 需要 vs 安装 clang
# C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\x64\bin
# C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja
source_root_path=$(pwd)
install_path=${source_root_path}/msys2-build-install/

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

cmake -G "Ninja" .. \
-DCMAKE_TOOLCHAIN_FILE=$(pwd)/toolchain.cmake \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=${install_path} &&

ninja -j12 && ninja install &&

cd ${install_path}/include/SDL2 &&
mv * ${install_path}/include/ &&
cd ${install_path}/include/ &&
rm -rf SDL2/