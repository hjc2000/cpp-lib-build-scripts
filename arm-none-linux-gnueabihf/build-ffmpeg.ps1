$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"
Push-Location $repos_path
try
{
	Import-Lib -LibName "x264"
	Import-Lib -LibName "x265"
	Import-Lib -LibName "sdl2"
	Import-Lib -LibName "amf"
	Import-Lib -LibName "openssl"
	Write-Host $env:PKG_CONFIG_PATH
	Total-Install

	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://gitee.com/programmingwindows/FFmpeg.git" `
		-branch_name release/6.1

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
	--cpu="armv7-a" \
	--target-os="linux" \
	--pkg-config="$(which pkg-config)" \
	--sysroot="$total_install_path"

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
