param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"
. $cpp_lib_build_scripts_path/ps-fun/import-fun.ps1
$install_path = "$libs_path/nlohmann-json/include/nlohmann"
Push-Location $repos_path
try
{
	Write-Host $install_path
	New-Item -Path $install_path -ItemType Directory -Force
	if (Test-Path -Path "$install_path/json.hpp")
	{
		Remove-Item -Path "$install_path/json.hpp" -Force
	}
	
	
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp" `
		-OutFile "$install_path/json.hpp"
}
catch
{
	<#Do this if a terminating exception happens#>
}
finally
{
	Pop-Location
}
