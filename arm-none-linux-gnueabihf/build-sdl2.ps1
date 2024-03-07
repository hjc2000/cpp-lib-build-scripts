$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/SDL/"
$install_path = "$libs_path/sdl2/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& "${build_script_path}/build-alsa-lib.ps1"
	& "${build_script_path}/build-pulseaudio.ps1"
	& "${build_script_path}/build-wayland.ps1"
	& "${build_script_path}/build-libxkbcommon.ps1"
	# 设置依赖项的 pkg-config
	$env:PKG_CONFIG_PATH = "$total_install_path/lib"
	Total-Install




	get-git-repo.ps1 -git_url "https://github.com/libsdl-org/SDL.git" `
		-branch_name SDL2

	New-Empty-Dir $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)

	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)

	$(Get-Cmake-Set-Find-Lib-Path-String)

	# link_libraries("$total_install_path/lib/liblzma.so.5")
	# link_libraries("$total_install_path/lib/libiconv.so.2")
	# link_libraries("$total_install_path/lib/libz.so.1")
"@
	

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DSDL_SHARED=ON `
		-DSDL_STATIC=OFF `
		-DSDL_WAYLAND=ON `
		-DSDL_IBUS=OFF `
		-DSDL_KMSDRM=OFF `
		-DSDL_SNDIO=OFF `
		-DSDL_ALSA=ON `
		-DSDL_PULSEAUDIO=ON
	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}
	
	ninja clean
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

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
