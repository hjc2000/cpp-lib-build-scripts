$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	pull-sh.ps1

	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/cb"
	try-remove-items --paths "$libs_path/xhif"
	try-remove-items --paths "$libs_path/pn"
	try-remove-items --paths "$libs_path/DevKit51"
	try-remove-items --paths "$libs_path/ertec200p-3-flash-tool"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-cb.ps1"
	& "$build_script_path/build-xhif.ps1"
	& "$build_script_path/build-pn.ps1"
	& "$build_script_path/build-DevKit51.ps1"
	& "$build_script_path/build-ertec200p-3-flash-tool.ps1"
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

}
