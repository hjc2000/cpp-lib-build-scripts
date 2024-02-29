$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/libtool/"
$install_path = "$libs_path/libtool/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "git://git.savannah.gnu.org/libtool.git"
}
catch
{
	throw
}
finally
{
	Pop-Location
}