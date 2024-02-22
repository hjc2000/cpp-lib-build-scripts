param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location ${repos_path}
get-git-repo.ps1 https://gitee.com/programmingwindows/FFmpeg.git release/6.1

# 编译依赖项
& ${cpp_lib_build_scripts_path}/msys2/build-x264.ps1
& ${cpp_lib_build_scripts_path}/msys2/build-x265.ps1
& ${cpp_lib_build_scripts_path}/msys2/build-sdl2.ps1
& ${cpp_lib_build_scripts_path}/msys2/build-amf.ps1

$configure_cmd = @"
./configure \
--prefix="${install_path}" \
--extra-cflags="-I${libs_path}/amf/include -DAMF_CORE_STATICTIC" \
--enable-libx264 \
--enable-libx265 \
--enable-amf \
--enable-pic \
--enable-gpl \
--enable-shared
"@
configure.ps1 $configure_cmd

make -j12
make install

# 将 msys2 中的 dll 复制到安装目录
# 可以用 ldd ffmpeg.exe | grep ucrt64 命令来查看有哪些依赖是来自 ucrt64 的
Copy-Item -Path /ucrt64/bin/libgcc_s_seh-1.dll `
	-Destination ${install_path}/bin/ `
	-Force
Copy-Item -Path /ucrt64/bin/libbz2-1.dll `
	-Destination ${install_path}/bin/ `
	-Force
Copy-Item -Path /ucrt64/bin/libiconv-2.dll `
	-Destination ${install_path}/bin/ `
	-Force
Copy-Item -Path /ucrt64/bin/liblzma-5.dll `
	-Destination ${install_path}/bin/ `
	-Force
Copy-Item -Path /ucrt64/bin/libstdc++-6.dll `
	-Destination ${install_path}/bin/ `
	-Force
Copy-Item -Path /ucrt64/bin/libwinpthread-1.dll `
	-Destination ${install_path}/bin/ `
	-Force
Copy-Item -Path /ucrt64/bin/zlib1.dll `
	-Destination ${install_path}/bin/ `
	-Force