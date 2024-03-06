$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libxml2/"
$install_path = "$libs_path/libxml2/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& "${build_script_path}/build-libiconv.ps1"
	& "${build_script_path}/build-xz.ps1"
	& "${build_script_path}/build-zlib.ps1"


	get-git-repo.ps1 -git_url "https://gitlab.gnome.org/GNOME/libxml2.git" `
		-branch_name "2.12"

	New-Item -Path $build_path -ItemType Directory -Force
	# Remove-Item "$build_path/*" -Recurse -Force

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

	include_directories(BEFORE "$total_install_path/include")
	link_directories(BEFORE "$total_install_path/lib")
	link_libraries(
		"$total_install_path/lib/libz.so.1"
		"$total_install_path/lib/liblzma.so.5"
		"$total_install_path/lib/libiconv.so.2"
	)
"@
	

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DLIBXML2_WITH_PYTHON=OFF `
		-DLIBXML2_WITH_TESTS=OFF `
		-DLIBXML2_WITH_LZMA=ON `
		-DLIBXML2_WITH_ZLIB=ON

	ninja -j12
	ninja install

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw
}
finally
{
	Pop-Location
}
