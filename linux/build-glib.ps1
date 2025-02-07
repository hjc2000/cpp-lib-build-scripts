$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/glib/"
$install_path = "$libs_path/glib/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path

try
{
	Set-Location $repos_path
	git-get-repo.ps1 -git_url "https://github.com/GNOME/glib.git"

	New-Empty-Dir $build_path
	Set-Location $source_path
	meson setup jc_build/ `
		--prefix="$install_path"

	Set-Location $build_path
	ninja -j12 -v
	ninja install

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
