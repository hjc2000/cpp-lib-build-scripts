param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location ${repos_path}
get-git-repo.ps1 https://github.com/libsdl-org/SDL.git release-2.30.x

New-Item -ItemType Directory -Path "${repos_path}/SDL/build/" -Force
Set-Location "${repos_path}/SDL/build/"

# 创建文件 toolchain.cmake
New-Item -ItemType File -Path "${repos_path}/SDL/build/toolchain.cmake" -Force
# 向 toolchain.cmake 写入内容
$Content = @"
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x64)
set(CMAKE_RC_COMPILER llvm-rc)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
"@
# 使用 Out-File cmdlet 写入文件
$Content | Out-File -FilePath toolchain.cmake -Encoding UTF8

$install_path = "$libs_path/SDL2"
cmake -G "Ninja" .. `
	-DCMAKE_TOOLCHAIN_FILE="${repos_path}/SDL/build/toolchain.cmake" `
	-DCMAKE_BUILD_TYPE=Release `
	-DCMAKE_INSTALL_PREFIX="$install_path"

ninja -j12
ninja install

# 修复 .pc 文件内的路径
update-pc-prefix.ps1 "${install_path}/lib/pkgconfig/sdl2.pc"