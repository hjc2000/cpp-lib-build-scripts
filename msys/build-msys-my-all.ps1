$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	try-remove-items --paths "$libs_path/base" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/c-bsp-interface" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/libusb-wrapper" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/ffmpeg-wrapper" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/pinvoke" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/pcappp" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/tsduck" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/sync-time" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"
	try-remove-items --paths "$libs_path/widget"
	try-remove-items --paths "$libs_path/can-diagnosis" || throw "try-remove-items 失败，退出代码: $LASTEXITCODE"

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-c-bsp-interface.ps1"
	& "$build_script_path/build-libusb-wrapper.ps1"
	& "$build_script_path/build-ffmpeg-wrapper.ps1"
	& "$build_script_path/build-pinvoke.ps1"
	& "$build_script_path/build-pcappp.ps1"
	& "$build_script_path/build-tsduck.ps1"
	& "$build_script_path/build-sync-time.ps1"
	& "$build_script_path/build-widget.ps1"
	& "$build_script_path/build-can-diagnosis.ps1"
}
finally
{
	Pop-Location
}
