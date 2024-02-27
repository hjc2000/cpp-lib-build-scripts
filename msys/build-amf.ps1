param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"
. $cpp_lib_build_scripts_path/ps-fun/import-fun.ps1
$source_path = "$repos_path/AMF_1/"
$install_path = "$libs_path/amf/"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url https://gitee.com/mirrors_GPUOpen-LibrariesAndSDKs/AMF_1.git

	# 准备好安装目录
	$amf_include_install_path = "$install_path/include/AMF/"
	New-Item -Path $amf_include_install_path -ItemType Directory -Force
	
	# 将头文件复制到安装目录
	Copy-Item -Path "$source_path/amf/public/include/*" `
		-Destination $amf_include_install_path `
		-Force -Recurse
}
catch
{
	<#Do this if a terminating exception happens#>
}
finally
{
	Pop-Location
}
