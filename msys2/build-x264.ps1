param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location $repos_path
get-git-repo.ps1 https://gitee.com/Qianshunan/x264.git
Set-Location $repos_path/x264

$install_path = "$libs_path/x264"

$configure_cmd = @"
./configure \
--prefix=${install_path} \
--enable-shared \
--disable-opencl \
--enable-pic
"@
configure.ps1 $configure_cmd

make -j12
make install

Write-Host "pc 文件的内容："
Get-Content $install_path/lib/pkgconfig/x264.pc