$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

sync-sh.ps1

try
{
	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/task"
	try-remove-items --paths "$libs_path/profidrive"
	try-remove-items --paths "$libs_path/bsp-interface"
	try-remove-items --paths "$libs_path/stm32h743iit6-hal"
	try-remove-items --paths "$libs_path/stm32h743iit6-peripherals"
	try-remove-items --paths "$libs_path/stm32h743iit6-p-net"
	try-remove-items --paths "$libs_path/stm32h743-project"
	try-remove-items --paths "$libs_path/stm32h723zgt6-hal"
	try-remove-items --paths "$libs_path/stm32h723zgt6-peripherals"
	try-remove-items --paths "$libs_path/stm32h723-project"
	try-remove-items --paths "$libs_path/cb"
	try-remove-items --paths "$libs_path/xhif"
	try-remove-items --paths "$libs_path/pn"

	# try-remove-items --paths "$libs_path/lwip"
	# try-remove-items --paths "$libs_path/lwip-wrapper"
	# try-remove-items --paths "$libs_path/freertos-osal"
	# try-remove-items --paths "$libs_path/freertos-gcc-cm7"
	# try-remove-items --paths "$libs_path/FatFs"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-bsp-interface.ps1"
	& "$build_script_path/build-task.ps1"
	& "$build_script_path/build-lwip.ps1"
	& "$build_script_path/build-lwip-wrapper.ps1"
	& "$build_script_path/build-xhif.ps1"
	& "$build_script_path/build-pn.ps1"
	& "$build_script_path/build-freertos-osal.ps1"
	& "$build_script_path/build-freertos-gcc-cm7.ps1"
	& "$build_script_path/build-FatFs.ps1"
	& "$build_script_path/build-profidrive.ps1"

	& "$build_script_path/build-stm32h743iit6-p-net.ps1"
	& "$build_script_path/build-stm32h743iit6-hal.ps1"
	& "$build_script_path/build-stm32h743iit6-peripherals.ps1"
	& "$build_script_path/build-stm32h743-project.ps1"

	& "$build_script_path/build-stm32h723zgt6-hal.ps1"
	& "$build_script_path/build-stm32h723zgt6-peripherals.ps1"
	& "$build_script_path/build-stm32h723-project.ps1"
}
finally
{
	Pop-Location
}
