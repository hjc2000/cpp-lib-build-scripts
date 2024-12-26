$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	Try-Remove-Item -Path "$libs_path/base"
	Try-Remove-Item -Path "$libs_path/FatFs"
	Try-Remove-Item -Path "$libs_path/c-bsp-interface"
	Try-Remove-Item -Path "$libs_path/libusb-wrapper"
	Try-Remove-Item -Path "$libs_path/ffmpeg-wrapper"
	Try-Remove-Item -Path "$libs_path/pinvoke"
	Try-Remove-Item -Path "$libs_path/pcappp"
	Try-Remove-Item -Path "$libs_path/tsduck"

	Build-Dependency "build-base"
	Build-Dependency "build-FatFs"
	Build-Dependency "build-c-bsp-interface"
	Build-Dependency "build-libusb-wrapper"
	Build-Dependency "build-ffmpeg-wrapper"
	Build-Dependency "build-pinvoke"
	Build-Dependency "build-pcappp"
	Build-Dependency "build-tsduck"
}
finally
{
	Pop-Location
}
