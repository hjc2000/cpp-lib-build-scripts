$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/../.base-script/prepare-for-cross-building.ps1

	$source_path = "$repos_path/SDL/"
	$install_path = "$libs_path/sdl2/"
	$build_path = "$source_path/jc_build/"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	# 构建依赖项
	& "$build_script_path/build-alsa-lib.ps1"
	& "$build_script_path/build-pulseaudio.ps1"
	& "$build_script_path/build-wayland.ps1"
	& "$build_script_path/build-libxkbcommon.ps1"

	# 开始构建本体
	git-get-repo.ps1 -git_url "https://github.com/libsdl-org/SDL.git" `
		-branch_name SDL2

	New-Empty-Dir -Path $build_path

	New-Text-File -Path "$build_path/toolchain.cmake" `
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
catch
{
	throw "
		$(get-script-position.ps1)
		$(${PSItem}.Exception.Message)
	"
}
finally
{
	Pop-Location
}
