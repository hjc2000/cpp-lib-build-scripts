$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& "${build_script_path}/build-x264.ps1"
	& "${build_script_path}/build-x265.ps1"
	& "${build_script_path}/build-openssl.ps1"
	& "${build_script_path}/build-sdl2.ps1"
	# 设置依赖项的 pkg-config
	Clear-PkgConfig-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/x264"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/x265"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/openssl"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/sdl2"
	Write-Host "PKG_CONFIG_PATH 的值：$env:PKG_CONFIG_PATH"


	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--enable-sdl \
	--enable-libx264 \
	--enable-libx265 \
	--enable-openssl \
	--enable-version3 \
	--enable-pic \
	--enable-gpl \
	--enable-shared \
	--disable-static

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
