$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libtool/libtool-2.4.7"
$install_path = "$libs_path/libtool"
Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.gz" `
		-out_dir_name "libtool"

	run-bash-cmd.ps1 -cmd @"
	set -e
	cd $source_path

	./configure -h
	exit

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf

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
