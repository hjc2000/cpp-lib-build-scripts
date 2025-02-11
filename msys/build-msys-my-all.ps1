$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/c-bsp-interface"
	try-remove-items --paths "$libs_path/libusb-wrapper"
	try-remove-items --paths "$libs_path/ffmpeg-wrapper"
	try-remove-items --paths "$libs_path/pinvoke"
	try-remove-items --paths "$libs_path/pcappp"
	try-remove-items --paths "$libs_path/tsduck"
	try-remove-items --paths "$libs_path/sync-time"
	try-remove-items --paths "$libs_path/widget"

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-c-bsp-interface.ps1"
	& "$build_script_path/build-libusb-wrapper.ps1"
	& "$build_script_path/build-ffmpeg-wrapper.ps1"
	& "$build_script_path/build-pinvoke.ps1"
	& "$build_script_path/build-pcappp.ps1"
	& "$build_script_path/build-tsduck.ps1"
	& "$build_script_path/build-sync-time.ps1"
	& "$build_script_path/build-widget.ps1"
}
finally
{
	Pop-Location
}
