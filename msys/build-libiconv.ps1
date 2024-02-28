$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$install_path = "$libs_path/libiconv"
Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz `
		-out_dir_name libiconv

	run-bash-cmd.ps1 -cmd @"
set -e
cd $(cygpath.exe $repos_path)/libiconv/libiconv-1.17/

./configure \
--prefix=$(cygpath.exe $install_path)

make -j12
make install
"@
}
catch
{
	throw
}
finally
{
	Pop-Location
}
