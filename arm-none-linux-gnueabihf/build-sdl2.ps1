$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/SDL/"
$install_path = "$libs_path/sdl2/"
$build_path = "$source_path/build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	# 构建依赖项
	Build-Dependency "build-alsa-lib.ps1"
	Build-Dependency "build-pulseaudio.ps1"
	Build-Dependency "build-wayland.ps1"
	Build-Dependency "build-libxkbcommon.ps1"

	# 开始构建本体
	get-git-repo.ps1 -git_url "https://github.com/libsdl-org/SDL.git" `
		-branch_name SDL2

	New-Item -Path $build_path -ItemType Directory -Force | Out-Null
	Remove-Item "$build_path/*" -Recurse -Force
	
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)

	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)

	$(Get-Cmake-Set-Find-Lib-Path-String)
"@
	

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DSDL_SHARED=ON `
		-DSDL_STATIC=OFF `
		-DSDL_WAYLAND=ON `
		-DSDL_WAYLAND_LIBDECOR=OFF `
		-DSDL_IBUS=OFF `
		-DSDL_KMSDRM=OFF `
		-DSDL_SNDIO=OFF `
		-DSDL_ALSA=ON `
		-DSDL_PULSEAUDIO=ON

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}
	
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
