$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

sync-sh.ps1

try
{
	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/c-bsp-interface"
	try-remove-items --paths "$libs_path/prd"
	try-remove-items --paths "$libs_path/DevKit51"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-c-bsp-interface.ps1"
	& "$build_script_path/build-prd.ps1"
	& "$build_script_path/build-DevKit51.ps1"
}
finally
{
	Pop-Location
}
