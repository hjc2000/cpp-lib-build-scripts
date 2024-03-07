$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libpng/"
$install_path = "$libs_path/libpng/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	& "${build_script_path}/build-zlib.ps1"

	get-git-repo.ps1 -git_url "https://github.com/pnggroup/libpng.git"

	New-Item -Path $build_path -ItemType Directory -Force | Out-Null
	# Remove-Item "$build_path/*" -Recurse -Force

	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)

	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)

	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath-link,$total_install_path/lib" CACHE STRING "Linker flags for executables" FORCE)
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-rpath-link,$total_install_path/lib" CACHE STRING "Linker flags for shared libraries" FORCE)

	# 指定查找程序、库、头文件时的根路径，防止在默认系统路径中查找
	set(CMAKE_FIND_ROOT_PATH "$total_install_path")
	# 设置查找路径的模式，确保仅在指定的根路径中查找
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE FORCE)
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE FORCE)
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE FORCE)
	set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY CACHE FORCE)

	include_directories("$total_install_path/include")
	link_directories("$total_install_path/lib")
	link_libraries(m)
"@
	

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path"
	if ($LASTEXITCODE)
	{
		throw "配置失败"
	}
	
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "编译失败"
	}

	ninja install | Out-Null

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
