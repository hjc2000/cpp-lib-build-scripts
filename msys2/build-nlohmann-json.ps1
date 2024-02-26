param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

$install_path = "$libs_path/nlohmann-json/include/nlohmann"
New-Item -Path $install_path -ItemType Directory -Force


Invoke-WebRequest -Uri https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp `
	-OutFile "$install_path/json.hpp"
