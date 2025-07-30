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
	try-remove-items --paths "$libs_path/ffmpeg-wrapper"
	try-remove-items --paths "$libs_path/sdl2-wrapper"
	try-remove-items --paths "$libs_path/point24"
	try-remove-items --paths "$libs_path/check-avstream"
	try-remove-items --paths "$libs_path/cb"
	try-remove-items --paths "$libs_path/tsduck"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-widget.ps1"
	& "$build_script_path/build-can-diagnosis.ps1"
	& "$build_script_path/build-ffmpeg-wrapper.ps1"
	& "$build_script_path/build-sdl2-wrapper.ps1"
	& "$build_script_path/build-point24.ps1"
	& "$build_script_path/build-check-avstream.ps1"
	& "$build_script_path/build-cb.ps1"
	& "$build_script_path/build-tsduck.ps1"
}
finally
{
	Pop-Location
}
