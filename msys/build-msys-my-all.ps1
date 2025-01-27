$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	Try-Remove-Item.exe --path "$libs_path/base"
	Try-Remove-Item.exe --path "$libs_path/FatFs"
	Try-Remove-Item.exe --path "$libs_path/c-bsp-interface"
	Try-Remove-Item.exe --path "$libs_path/libusb-wrapper"
	Try-Remove-Item.exe --path "$libs_path/ffmpeg-wrapper"
	Try-Remove-Item.exe --path "$libs_path/pinvoke"
	Try-Remove-Item.exe --path "$libs_path/pcappp"
	Try-Remove-Item.exe --path "$libs_path/tsduck"

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-FatFs.ps1"
	& "$build_script_path/build-c-bsp-interface.ps1"
	& "$build_script_path/build-libusb-wrapper.ps1"
	& "$build_script_path/build-ffmpeg-wrapper.ps1"
	& "$build_script_path/build-pinvoke.ps1"
	& "$build_script_path/build-pcappp.ps1"
	& "$build_script_path/build-tsduck.ps1"
}
finally
{
	Pop-Location
}
