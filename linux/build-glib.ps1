$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/glib/"
$install_path = "$libs_path/glib/"
$build_path = "$source_path/build/"
Push-Location $repos_path

try
{
	Set-Location $repos_path
	get-git-repo.ps1 -git_url https://github.com/GNOME/glib.git

	New-Empty-Dir $build_path
	Set-Location $source_path
	meson setup build/ `
		--prefix="$install_path"

	Set-Location $build_path
	ninja -j12
	ninja install
}
catch
{
	throw
}
finally
{
	Pop-Location
}
