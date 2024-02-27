param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path,

	[bool]$cross_compile = $false,
	[string]$cross_compiler_prefix = "arm-none-linux-gnueabihf"
)
$ErrorActionPreference = "Stop"

Push-Location $repos_path
get-git-repo.ps1 -git_url "https://gitee.com/Qianshunan/x264.git"
$source_path = "$repos_path/x264/"
$install_path = "$libs_path/x264"
Set-Location $source_path

# 设置配置命令的内容
$configure = @"
./configure \
--prefix="$(Fix-Path.ps1 -path_to_fix $install_path)" \
--enable-shared \
--disable-opencl \
--enable-pic
"@
if ($cross_compile)
{
	$configure += " \"
	$configure += @"
--host=$cross_compiler_prefix \
--cross-prefix=$cross_compiler_prefix-
"@
}

# 执行命令进行构建
run-bash-cmd.ps1 @"
set -e
cd $(Fix-Path.ps1 -path_to_fix $source_path)
$configure
make clean
make -j12
make install
"@

Write-Host "`n`n`n========================================"
Write-Host "pc 文件的内容："
Get-Content "$install_path/lib/pkgconfig/x264.pc"
Pop-Location