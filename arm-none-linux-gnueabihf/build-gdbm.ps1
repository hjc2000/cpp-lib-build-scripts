$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/gdbm/gdbm-1.23"
$install_path = "$libs_path/gdbm"
Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.23.tar.gz" `
		-out_dir_name "gdbm"

	run-bash-cmd.ps1 -cmd @"
	set -e
	cd $source_path

	./configure -h
	exit

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--enable-ltdl-install

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
