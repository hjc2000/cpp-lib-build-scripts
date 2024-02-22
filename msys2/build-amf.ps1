param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"


Set-Location ${repos_path}
wget-repo.ps1 -workspace_dir $(Get-Location) `
	-repo_url https://github.com/GPUOpen-LibrariesAndSDKs/AMF/archive/refs/tags/v1.4.33.tar.gz `
	-out_dir_name AMF
$source_path = "${repos_path}/AMF"
Set-Location $source_path

# 准备好安装目录
$amf_include_install_path = "${libs_path}/amf/include/AMF/"
New-Item -Path ${amf_include_install_path} -ItemType Directory -Force

# 将头文件复制到安装目录
Copy-Item -Path "${source_path}/AMF-1.4.33/amf/public/include/*" `
	-Destination ${amf_include_install_path} `
	-Force -Recurse