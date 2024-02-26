param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Push-Location $repos_path
get-git-repo.ps1 -git_url "https://github.com/openssl/openssl.git"
$source_path = "$repos_path/openssl"
$install_path = "$libs_path/openssl"

$cmd = @"
set -e
cd $(cygpath.exe $source_path)

./Configure shared \
--prefix="$(cygpath.exe $install_path)"

make -j12
make install
"@

run-bash-cmd.ps1 $cmd
Pop-Location