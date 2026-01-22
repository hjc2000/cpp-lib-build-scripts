$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/json/"
$install_path = "$libs_path/nlohmann-json"

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url https://github.com/nlohmann/json.git

	New-Item -Path "$install_path/include/nlohmann" -ItemType Directory -Force
	Copy-Item -Path "$source_path/single_include/nlohmann/json.hpp" `
		-Destination "$install_path/include/nlohmann" `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{

}
