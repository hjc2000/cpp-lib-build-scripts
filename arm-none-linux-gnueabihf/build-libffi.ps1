$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libffi/"
$install_path = "$libs_path/libffi/"
$build_path = "$source_path/build/"
Push-Location $repos_path

try
{
	Apt-Ensure-Packets @(
		"autoconf",
		"automake",
		"libtool"
	)

	Set-Location $repos_path
	get-git-repo.ps1 -git_url https://github.com/libffi/libffi.git

	run-bash-cmd.ps1 @"
	cd $source_path
	aclocal
	autoconf
	autoreconf -i

	./configure \
	--prefix=$install_path \
	--host=arm-none-linux-gnueabihf
	--target=arm-none-linux-gnueabihf

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