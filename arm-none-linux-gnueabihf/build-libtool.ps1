$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libtool/libtool-2.4.7"
$install_path = "$libs_path/libtool/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Apt-Ensure-Packets @(
		"help2man",
		"texinfo",
		"autoconf",
		"automake"
	)

	Set-Location $repos_path
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.gz `
		-out_dir_name libtool
	Set-Location $source_path

	if (Test-Path -Path $source_path/configure)
	{
		Write-Host "已经有 configure 了，不需要 bootstrap。"
	}
	else
	{
		run-bash-cmd.ps1 "$source_path/bootstrap"
	}

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix=$install_path \
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