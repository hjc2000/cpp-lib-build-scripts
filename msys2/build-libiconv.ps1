param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Push-Location $repos_path
wget-repo.ps1 -workspace_dir $repos_path `
	-repo_url https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz `
	-out_dir_name libiconv

$install_path = "$libs_path/libiconv"

run-bash-cmd.ps1 -cmd @"
set -e
cd $(cygpath.exe $repos_path)/libiconv/libiconv-1.17/

./configure \
--prefix=$(cygpath.exe $install_path)

make -j12
make install
"@

Pop-Location