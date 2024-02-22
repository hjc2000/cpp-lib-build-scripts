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

