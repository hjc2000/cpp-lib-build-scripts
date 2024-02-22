param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location ${repos_path}
get-git-repo.ps1 https://gitee.com/programmingwindows/FFmpeg.git release/6.1

# 编译依赖项
# & ${cpp_lib_build_scripts_path}/msys2/build-x264.ps1
# & ${cpp_lib_build_scripts_path}/msys2/build-x265.ps1
# & ${cpp_lib_build_scripts_path}/msys2/build-sdl2.ps1
# & ${cpp_lib_build_scripts_path}/msys2/build-amf.ps1

Set-Location -Path "${repos_path}/FFmpeg/"
$configure_cmd = @"
set -e

cd ${repos_path}/FFmpeg/
echo 666666666666666666666666
echo `$(pwd)

./configure \
--prefix="$(cygpath.exe ${repos_path}/FFmpeg/)" \
--extra-cflags="-I$(cygpath.exe ${libs_path})/amf/include -DAMF_CORE_STATICTIC" \
--enable-libx264 \
--enable-libx265 \
--enable-amf \
--enable-pic \
--enable-gpl \
--enable-shared

make clean
make -j12
make install
"@
run-bash-cmd.ps1 $configure_cmd

# 将 msys2 中的 dll 复制到安装目录
# 可以用 ldd ffmpeg.exe | grep ucrt64 命令来查看有哪些依赖是来自 ucrt64 的
$msys_dlls = @(
	"/ucrt64/bin/libgcc_s_seh-1.dll",
	"/ucrt64/bin/libbz2-1.dll",
	"/ucrt64/bin/libiconv-2.dll",
	"/ucrt64/bin/liblzma-5.dll",
	"/ucrt64/bin/libstdc++-6.dll",
	"/ucrt64/bin/libwinpthread-1.dll",
	"/ucrt64/bin/zlib1.dll"
)
foreach ($msys_dll in $msys_dlls)
{
	Copy-Item -Path $(cygpath.exe -w ${msys_dll}) `
		-Destination "${install_path}/bin/" `
		-Force
}