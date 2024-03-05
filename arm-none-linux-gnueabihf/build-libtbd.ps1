$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/tdb/tdb-1.4.10"
$install_path = "$libs_path/tdb"
Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://www.samba.org/ftp/tdb/tdb-1.4.10.tar.gz" `
		-out_dir_name "tdb"

	run-bash-cmd.ps1 -cmd @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--cross-compile=arm-none-linux-gnueabihf-gcc \
	--disable-python

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
