param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Push-Location $repos_path

# 文件URL
$url = "https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0_rc1.tar.gz"
wget-repo.ps1 -workspace_dir $repos_path `
	-repo_url $url `
	-out_dir_name boost

Copy-Item -Path $repos_path/boost_1_84_0_rc1/boost_1_84_0/boost/ `
	-Destination $libs_path/boost/ `
	-Force `
	-Recurse

Pop-Location