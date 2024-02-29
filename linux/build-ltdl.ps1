$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/libtool/"
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
	get-git-repo.ps1 -git_url "git://git.savannah.gnu.org/libtool.git"
	Set-Location $source_path
	run-bash-cmd.ps1 "$source_path/bootstrap"
}
catch
{
	throw
}
finally
{
	Pop-Location
}