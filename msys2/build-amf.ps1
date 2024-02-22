param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"


Set-Location ${repos_path}
get-git-repo.ps1 https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git

$amf_include_install_path = "${libs_path}/amf/include/AMF/"
New-Item -Path ${amf_include_install_path} -ItemType Directory -Force
Copy-Item -Path "${repos_path}/AMF/amf/public/include/*" `
	-Destination ${amf_include_install_path} `
	-Force -Recurse