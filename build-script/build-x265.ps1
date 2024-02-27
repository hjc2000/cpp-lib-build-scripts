param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path,
	[switch]$cross_compile
)
$ErrorActionPreference = "Stop"

Push-Location $repos_path
get-git-repo.ps1 -git_url https://gitee.com/Qianshunan/x265_git.git
$source_path = "$repos_path/x265_git/source"
$build_path = "$source_path/build/"
$install_path = "$libs_path/x265/"

New-Item -Path $build_path -ItemType Directory -Force
Remove-Item "$build_path/*" -Recurse -Force

# 创建文件 toolchain.cmake
$toolchain_file_content = ""
if ($cross_compile)
{
	$toolchain_file_content = @"
set(CROSS_COMPILE_ARM 1)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv4)

set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)
"@
}

New-Item -ItemType File -Path "$build_path/toolchain.cmake" -Force
$toolchain_file_content | Out-File -FilePath "$build_path/toolchain.cmake" -Encoding UTF8

# 切换到 build 目录开始构建
Set-Location $build_path
cmake -G "Unix Makefiles" $source_path `
	-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
	-DCMAKE_INSTALL_PREFIX="${install_path}" `
	-DENABLE_SHARED=on `
	-DENABLE_PIC=on `
	-DENABLE_ASSEMBLY=off

make -j12
make install

if ($IsWindows)
{
	# 修复 .pc 文件内的路径
	update-pc-prefix.ps1 "$install_path/lib/pkgconfig/x265.pc"
}

Pop-Location