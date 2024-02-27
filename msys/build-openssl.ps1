param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"
if ($IsWindows)
{
	# 编译后安装阶段依赖 Perl 中的 pod2man，但是它比较不同寻常，
	# 可执行文件不是在 bin 里面，而是在 bin 里面又创建了一个目录
	$env:Path = "C:\msys64\usr\bin\core_perl;" + $env:Path
}

Push-Location $repos_path
get-git-repo.ps1 -git_url "https://gitee.com/hughpenn23/openssl.git"
$source_path = "$repos_path/openssl"
$install_path = "$libs_path/openssl"

run-bash-cmd.ps1 @"
set -e
cd $(Fix-Path.ps1 -path_to_fix $source_path)

./Configure shared \
--prefix="$(Fix-Path.ps1 -path_to_fix $install_path)"

make -j12
make install
"@

Pop-Location