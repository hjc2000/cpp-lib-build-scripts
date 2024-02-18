export source_root_path=$(pwd)
export install_path=${source_root_path}/msys2-ucrt-build-install/

get-repo.sh https://gitee.com/mycn027b/SDL.git SDL2 &&
cd SDL &&
if [ ! -d "./build/" ]; then
	mkdir build
fi &&
cd build &&
rm -rf *
export build_path=$(pwd)
touch toolchain.cmake &&
echo "set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER cl.exe)
set(CMAKE_CXX_COMPILER cl.exe)" > toolchain.cmake &&

cmd
cmd.exe /k "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -startdir=none -arch=x64 -host_arch=x64
cmake -G "Ninja" .. ^
-DCMAKE_TOOLCHAIN_FILE=%build_path%/toolchain.cmake ^
-DCMAKE_INSTALL_PREFIX=%install_path%

"C:\msys64\usr\bin\bash"
# "/c/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja/ninja.exe" -h
