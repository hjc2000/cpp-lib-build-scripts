$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url https://gitlab.freedesktop.org/dbus/dbus.git `
		-branch_name dbus-1.14
}
catch
{
	throw
}
finally
{
	Pop-Location
}
