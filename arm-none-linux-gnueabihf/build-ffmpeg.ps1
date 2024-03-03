$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"
Push-Location $repos_path
try
{
	# 构建依赖项
	# & "${build_script_path}/build-x264.ps1"
	# & "${build_script_path}/build-x265.ps1"
	# & "${build_script_path}/build-openssl.ps1"
	# & "${build_script_path}/build-pulseaudio.ps1"
	# & "${build_script_path}/build-sdl2.ps1"
	# 设置依赖项的 pkg-config
	Clear-PkgConfig-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/x264"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/x265"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/openssl"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/pulseaudio"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/sdl2"
	Write-Host "PKG_CONFIG_PATH 的值：$env:PKG_CONFIG_PATH"



	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"


	$env:PATH = "$libs_path/sdl2/bin/:$env:PATH"
	Copy-Item -Path "$libs_path/sdl2/bin/sdl2-config" `
		-Destination "$libs_path/sdl2/bin/arm-none-linux-gnueabihf-sdl2-config"



	@"
test_cpp_condition SDL.h "(SDL_MAJOR_VERSION<<16 | SDL_MINOR_VERSION<<8 | SDL_PATCHLEVEL) >= 0x020001" $sdl2_cflags &&
test_cpp_condition SDL.h "(SDL_MAJOR_VERSION<<16 | SDL_MINOR_VERSION<<8 | SDL_PATCHLEVEL) < 0x030000" $sdl2_cflags &&
check_func_headers SDL_events.h SDL_PollEvent $sdl2_extralibs $sdl2_cflags &&
"@

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--enable-libx264 \
	--enable-libx265 \
	--enable-openssl \
	--enable-libpulse \
	--enable-sdl \
	--enable-gpl \
	--enable-version3 \
	--enable-pic \
	--enable-shared \
	--disable-static \
	--enable-cross-compile \
	--cross-prefix="arm-none-linux-gnueabihf-" \
	--arch="arm" \
	--target-os="linux" \
	--pkg-config="pkg-config"

	make clean
	make -j12
	make install
"@
}
catch
{
	throw
}
finally
{
	Pop-Location
}
