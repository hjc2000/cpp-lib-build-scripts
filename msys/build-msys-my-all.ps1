$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/widget"
	try-remove-items --paths "$libs_path/can-diagnosis"
	try-remove-items --paths "$libs_path/c-bsp-interface"
	try-remove-items --paths "$libs_path/libusb-wrapper"
	try-remove-items --paths "$libs_path/ffmpeg-wrapper"
	try-remove-items --paths "$libs_path/pinvoke"
	try-remove-items --paths "$libs_path/pcappp"
	try-remove-items --paths "$libs_path/tsduck"
	try-remove-items --paths "$libs_path/sync-time"
	try-remove-items --paths "$libs_path/sdl2-wrapper"
	try-remove-items --paths "$libs_path/avmixer"
	try-remove-items --paths "$libs_path/check-avstream"
	try-remove-items --paths "$libs_path/cpp-test"
	try-remove-items --paths "$libs_path/FatFs"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-can-diagnosis.ps1"
	& "$build_script_path/build-widget.ps1"
	& "$build_script_path/build-c-bsp-interface.ps1"
	& "$build_script_path/build-libusb-wrapper.ps1"
	& "$build_script_path/build-ffmpeg-wrapper.ps1"
	& "$build_script_path/build-pinvoke.ps1"
	& "$build_script_path/build-pcappp.ps1"
	& "$build_script_path/build-tsduck.ps1"
	& "$build_script_path/build-sync-time.ps1"
	& "$build_script_path/build-sdl2-wrapper.ps1"
	& "$build_script_path/build-avmixer.ps1"
	& "$build_script_path/build-check-avstream.ps1"
	& "$build_script_path/build-cpp-test.ps1"
	& "$build_script_path/build-FatFs.ps1"
}
finally
{
	Pop-Location
}
