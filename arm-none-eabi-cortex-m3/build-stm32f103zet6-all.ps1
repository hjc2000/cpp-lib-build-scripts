$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	try-remove-items --paths "$libs_path/system-call"
	try-remove-items --paths "$libs_path/freertos"
	try-remove-items --paths "$libs_path/FatFs"
	try-remove-items --paths "$libs_path/task"
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/bsp-interface"
	try-remove-items --paths "$libs_path/stm32f103zet6-gpio"
	try-remove-items --paths "$libs_path/stm32f103zet6-interrupt"
	try-remove-items --paths "$libs_path/stm32f103zet6-timer"
	try-remove-items --paths "$libs_path/stm32f103zet6-dma"
	try-remove-items --paths "$libs_path/stm32f103zet6-serial"

	& "$build_script_path/build-system-call.ps1"
	& "$build_script_path/build-freertos.ps1"
	& "$build_script_path/build-FatFs.ps1"
	& "$build_script_path/build-task.ps1"
	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-bsp-interface.ps1"
	& "$build_script_path/build-stm32f103zet6-gpio.ps1"
	& "$build_script_path/build-stm32f103zet6-interrupt.ps1"
	& "$build_script_path/build-stm32f103zet6-timer.ps1"
	& "$build_script_path/build-stm32f103zet6-dma.ps1"
	& "$build_script_path/build-stm32f103zet6-serial.ps1"
}
finally
{
	Pop-Location
}
