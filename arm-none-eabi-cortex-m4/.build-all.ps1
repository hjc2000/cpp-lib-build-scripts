$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

sync-sh.ps1

try
{
	$PSNativeCommandUseErrorActionPreference = $true
	# try-remove-items --paths "$libs_path/base"
	# try-remove-items --paths "$libs_path/freertos-gcc-cm4"
	# try-remove-items --paths "$libs_path/task"
	# try-remove-items --paths "$libs_path/stm32f407zet6-hal"
	# try-remove-items --paths "$libs_path/stm32f407zet6-peripheral"
	# try-remove-items --paths "$libs_path/cb"
	# try-remove-items --paths "$libs_path/prd"
	# try-remove-items --paths "$libs_path/stm32f407zet6-project"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-freertos-gcc-cm4.ps1"
	& "$build_script_path/build-task.ps1"
	& "$build_script_path/build-stm32f407zet6-hal.ps1"
	& "$build_script_path/build-stm32f407zet6-peripheral.ps1"
	& "$build_script_path/build-cb.ps1"
	& "$build_script_path/build-prd.ps1"
	& "$build_script_path/build-stm32f407zet6-project.ps1"
}
finally
{
	Pop-Location
}
