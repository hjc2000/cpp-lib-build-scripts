$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

sync-sh.ps1

try
{
	# pacman-ensure-packages.ps1 -packages @(
	# 	"mingw-w64-ucrt-x86_64-libarchive"
	# )

	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/widget"
	try-remove-items --paths "$libs_path/can-diagnosis"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-widget.ps1"
	& "$build_script_path/build-can-diagnosis.ps1"
}
finally
{
	Pop-Location
}
