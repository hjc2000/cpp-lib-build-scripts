param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

# 编译依赖项
& $cpp_lib_build_scripts_path/linux/build-x264.ps1
& $cpp_lib_build_scripts_path/linux/build-x265.ps1
& $cpp_lib_build_scripts_path/linux/build-sdl2.ps1
& $cpp_lib_build_scripts_path/linux/build-openssl.ps1

$env:PKG_CONFIG_PATH = 
"$libs_path/x264/lib/pkgconfig:" +
"$libs_path/x265/lib/pkgconfig:" +
"$libs_path/openssl/lib64/pkgconfig:" +
"$libs_path/SDL2/lib/pkgconfig:"
Write-Host $env:PKG_CONFIG_PATH

Push-Location $repos_path
get-git-repo.ps1 -git_url "https://gitee.com/programmingwindows/FFmpeg.git" `
	-branch_name release/6.1
$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"

$cmd = @"
set -e
cd $source_path

./configure \
--prefix="$install_path" \
--enable-libx264 \
--enable-libx265 \
--enable-openssl \
--enable-pic \
--enable-gpl \
--enable-shared \
--disable-static

make clean
make -j12
make install
"@

$cmd | bash -norc
Pop-Location