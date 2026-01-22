Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/prepare.ps1

	pull-sh.ps1

	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/msys-base-filesystem"
	try-remove-items --paths "$libs_path/widget"
	try-remove-items --paths "$libs_path/can-diagnosis"
	try-remove-items --paths "$libs_path/ffmpeg-wrapper"
	try-remove-items --paths "$libs_path/sdl2-wrapper"
	try-remove-items --paths "$libs_path/point24"
	try-remove-items --paths "$libs_path/check-avstream"
	try-remove-items --paths "$libs_path/cb"
	try-remove-items --paths "$libs_path/tsduck"
	try-remove-items --paths "$libs_path/pinvoke"
	try-remove-items --paths "$libs_path/libusb-wrapper"
	try-remove-items --paths "$libs_path/gsdml"
	try-remove-items --paths "$libs_path/avmixer"
	try-remove-items --paths "$libs_path/rename-with-numbering"
	try-remove-items --paths "$libs_path/copy-truthfully"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-msys-base-filesystem.ps1"
	& "$build_script_path/build-widget.ps1"
	& "$build_script_path/build-can-diagnosis.ps1"
	& "$build_script_path/build-ffmpeg-wrapper.ps1"
	& "$build_script_path/build-sdl2-wrapper.ps1"
	& "$build_script_path/build-point24.ps1"
	& "$build_script_path/build-check-avstream.ps1"
	& "$build_script_path/build-cb.ps1"
	& "$build_script_path/build-tsduck.ps1"
	& "$build_script_path/build-pinvoke.ps1"
	& "$build_script_path/build-libusb-wrapper.ps1"
	& "$build_script_path/build-gsdml.ps1"
	& "$build_script_path/build-avmixer.ps1"
	& "$build_script_path/build-rename-with-numbering.ps1"
	& "$build_script_path/build-copy-truthfully.ps1"
}
catch
{
	throw "
		$(get-script-position.ps1)
		$(${PSItem}.Exception.Message)
	"
}
finally
{
	Pop-Location
}
