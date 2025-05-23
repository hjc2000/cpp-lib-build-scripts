$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

sync-sh.ps1

try
{
	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/c-bsp-interface"
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/prd"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-c-bsp-interface.ps1"
	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-prd.ps1"
}
finally
{
	Pop-Location
}
