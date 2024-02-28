$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"
Push-Location $repos_path
try
{
	# 编译依赖项
	& $build_script_path/build-x264.ps1
	& $build_script_path/build-x265.ps1
	& $build_script_path/build-sdl2.ps1
	& $build_script_path/build-amf.ps1
	& $build_script_path/build-openssl.ps1

	$env:PKG_CONFIG_PATH = 
	"$libs_path/x264/lib/pkgconfig:" +
	"$libs_path/x265/lib/pkgconfig:" +
	"$libs_path/openssl/lib64/pkgconfig:" +
	"$libs_path/SDL2/lib/pkgconfig:"
	Write-Host $env:PKG_CONFIG_PATH

	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://gitee.com/programmingwindows/FFmpeg.git" `
		-branch_name release/6.1

	run-bash-cmd.ps1 @"
set -e
cd $source_path

./configure \
--prefix="$install_path" \
--extra-cflags="-I$libs_path/amf/include/ -DAMF_CORE_STATICTIC" \
--enable-libx264 \
--enable-libx265 \
--enable-openssl \
--enable-version3 \
--enable-amf \
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
