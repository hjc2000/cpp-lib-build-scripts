$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/json"
$install_path = "$libs_path/nlohmann-json"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url "https://github.com/nlohmann/json.git"

	New-Item -Path $install_path/include/nlohmann -ItemType Directory -Force

	Copy-Item -Path "$source_path/single_include/nlohmann/json.hpp" `
		-Destination "$install_path/include/nlohmann/json.hpp" `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
