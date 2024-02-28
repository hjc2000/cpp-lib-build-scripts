param (
	[string]$repos_path = $env:repos_path
)
$ErrorActionPreference = "Stop"
$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../ps-fun/import-fun.ps1
$libs_path = "$build_script_path/.libs"

$source_path = "$repos_path/x264/"
$install_path = "$libs_path/x264"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://gitee.com/Qianshunan/x264.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
set -e
cd $(cygpath.exe $source_path)

./configure \
--prefix="$(cygpath.exe $install_path)" \
--enable-shared \
--disable-opencl \
--enable-pic

make clean
make -j12
make install
"@

}
catch
{
	<#Do this if a terminating exception happens#>
}
finally
{
	Pop-Location
}
