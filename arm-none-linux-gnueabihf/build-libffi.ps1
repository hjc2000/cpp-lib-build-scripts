$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libffi/"
$install_path = "$libs_path/libffi/"
$build_path = "$source_path/build/"
Push-Location $repos_path

try
{
	& $build_script_path/build-libtool.ps1

	Set-Location $repos_path
	get-git-repo.ps1 -git_url https://github.com/libffi/libffi.git

	run-bash-cmd.ps1 @"
	export LIBTOOL="$libs_path/libtool"
	export LT_PATH_LD=$(which ld)

	cd $source_path
	autoreconf -i
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