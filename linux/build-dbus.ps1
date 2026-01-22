$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1

	$source_path = "$repos_path/dbus/"
	$install_path = "$libs_path/dbus/"
	$build_path = "$source_path/jc_build/"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	Set-Location $repos_path

	git-get-repo.ps1 -git_url https://gitlab.freedesktop.org/dbus/dbus.git `
		-branch_name dbus-1.14

	New-Empty-Dir $build_path
	Set-Location $build_path

	cmake -G "Ninja" $source_path `
		-DCMAKE_INSTALL_PREFIX="${install_path}"

	ninja -j12
	ninja install

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw "
		$(get-script-position.ps1)
		$(${PSItem}.Exception.Message)
	"
}
finally
{
	Pop-Location
}
