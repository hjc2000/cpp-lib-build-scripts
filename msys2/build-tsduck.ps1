param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

$install_path = "${libs_path}/tsduck/"
New-Item -Path $install_path -ItemType Directory -Force
Copy-Item -Path "${cpp_lib_build_scripts_path}/.prebuild/tsduck/*" `
	-Destination $install_path `
	-Force -Recurse