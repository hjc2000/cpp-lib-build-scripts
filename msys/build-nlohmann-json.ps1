$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

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
