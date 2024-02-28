param (
	[string]$repos_path = $env:repos_path
)
$ErrorActionPreference = "Stop"
$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../ps-fun/import-fun.ps1
$libs_path = "$build_script_path/.libs"

Push-Location $repos_path
try
{
	# 文件URL
	$url = "https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0_rc1.tar.gz"
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url $url `
		-out_dir_name boost

	Copy-Item -Path $repos_path/boost/boost_1_84_0/boost/ `
		-Destination $libs_path/boost/include/boost/ `
		-Force `
		-Recurse
}
catch
{
	<#Do this if a terminating exception happens#>
}
finally
{
	Pop-Location
}
