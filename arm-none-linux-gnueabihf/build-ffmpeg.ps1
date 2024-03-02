$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"
Push-Location $repos_path
try
{
	Import-Lib -LibName "x264" -NotBuild
	Import-Lib -LibName "x265" -NotBuild
	Import-Lib -LibName "sdl2" -NotBuild
	Import-Lib -LibName "amf" -NotBuild
	Import-Lib -LibName "openssl" -NotBuild
	Write-Host $env:PKG_CONFIG_PATH
	Total-Install

	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--extra-cflags="-I$libs_path/amf/include/" \
	--enable-sdl \
	--enable-libx264 \
	--enable-libx265 \
	--enable-openssl \
	--enable-version3 \
	--enable-amf \
	--enable-pic \
	--enable-gpl \
	--enable-shared \
	--disable-static \
	--enable-cross-compile \
	--cross-prefix="arm-none-linux-gnueabihf-" \
	--arch="arm" \
	--target-os="linux" \
	--pkg-config="$(which pkg-config)"

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
