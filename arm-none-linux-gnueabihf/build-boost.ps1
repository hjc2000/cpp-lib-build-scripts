$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

Push-Location $repos_path
try
{
	# 文件URL
	$url = "https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.bz2"
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url $url `
		-out_dir_name boost

	Copy-Item -Path $repos_path/boost/boost_1_84_0/boost/ `
		-Destination $libs_path/boost/include/boost/ `
		-Force -Recurse

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
