$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/dbus/"
$install_path = "$libs_path/dbus/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Set-Location $repos_path
	get-git-repo.ps1 -git_url https://gitlab.freedesktop.org/dbus/dbus.git `
		-branch_name dbus-1.14

	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_INSTALL_PREFIX="${install_path}"

	ninja -j12
	ninja install

	Append-Pkg-Config-Path -Path "$libs_path/dbus/lib/pkgconfig"
}
catch
{
	throw
}
finally
{
	Pop-Location
}
