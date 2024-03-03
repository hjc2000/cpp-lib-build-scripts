$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/SDL/"
$install_path = "$libs_path/sdl2/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& "${build_script_path}/build-pulseaudio.ps1"
	# 设置依赖项的 pkg-config
	Clear-PkgConfig-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/pulseaudio"



	get-git-repo.ps1 -git_url "https://github.com/libsdl-org/SDL.git" `
		-branch_name "release-2.30.x"

	New-Empty-Dir $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)

	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)

	# 指定查找程序、库、头文件时的根路径，防止在默认系统路径中查找
	set(CMAKE_FIND_ROOT_PATH "$total_install_path")
	# 设置查找路径的模式，确保仅在指定的根路径中查找
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
	set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
"@
	
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DSDL_SHARED=ON `
		-DSDL_STATIC=OFF `
		-DSDL_WAYLAND=OFF `
		-DSDL_IBUS=OFF `
		-DSDL_KMSDRM=OFF `
		-DSDL_SNDIO=OFF `
		-DSDL_ALSA=OFF
		

	ninja -j12
	ninja install

	# 将头文件移出来，不然它是处于 include/SDL2/ 内
	Move-Item -Path "$install_path/include/SDL2/*" `
		-Destination "$install_path/include/" `
		-Force
	Remove-Item "$install_path/include/SDL2/"
}
catch
{
	throw
}
finally
{
	Pop-Location
}
