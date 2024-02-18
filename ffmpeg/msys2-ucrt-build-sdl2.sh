source_root_path=$(pwd)
install_path=${source_root_path}/msys2-ucrt-build-install/

get-repo.sh https://gitee.com/mycn027b/SDL.git SDL2 &&
cd SDL &&
if [ ! -d "./build/" ]; then
	mkdir build
fi &&
cd build &&
rm -rf * &&
cmake -G "Visual Studio 17 2022" .. \
-DCMAKE_INSTALL_PREFIX=${install_path}

# 如果使用 makefile 进行构建，SDL 会检测一些头文件，结果就绑死了 mysy2 了，
# 编译出来的库在 vs 中无法使用。
# 所以需要手动打开 vs 进行编译。本脚本只能做到这了。
