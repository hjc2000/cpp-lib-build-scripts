$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	$PSNativeCommandUseErrorActionPreference = $true
	try-remove-items --paths "$libs_path/base"
	try-remove-items --paths "$libs_path/bsp-interface"
	try-remove-items --paths "$libs_path/stm32h743iit6-sdram"
	try-remove-items --paths "$libs_path/lwip-wrapper"
	try-remove-items --paths "$libs_path/stm32h743iit6-ethternet"
	try-remove-items --paths "$libs_path/stm32h743iit6-isr"
	try-remove-items --paths "$libs_path/stm32h743iit6-p-net"
	try-remove-items --paths "$libs_path/stm32h743iit6-gpio"
	try-remove-items --paths "$libs_path/stm32h743iit6-flash"
	try-remove-items --paths "$libs_path/stm32h743iit6-interrupt"
	try-remove-items --paths "$libs_path/stm32h743iit6-timer"
	try-remove-items --paths "$libs_path/stm32h743iit6-dma"
	try-remove-items --paths "$libs_path/stm32h743iit6-serial"
	try-remove-items --paths "$libs_path/stm32h743iit6-clock"
	try-remove-items --paths "$libs_path/system-call"
	try-remove-items --paths "$libs_path/stm32h743iit6-hal"
	try-remove-items --paths "$libs_path/lwip"
	try-remove-items --paths "$libs_path/freertos-osal"
	try-remove-items --paths "$libs_path/freertos"
	try-remove-items --paths "$libs_path/FatFs"
	try-remove-items --paths "$libs_path/littlefs"
	try-remove-items --paths "$libs_path/task"
	$PSNativeCommandUseErrorActionPreference = $false

	& "$build_script_path/build-base.ps1"
	& "$build_script_path/build-bsp-interface.ps1"
	& "$build_script_path/build-lwip-wrapper.ps1"
	& "$build_script_path/build-stm32h743iit6-sdram.ps1"
	& "$build_script_path/build-stm32h743iit6-ethternet.ps1"
	& "$build_script_path/build-stm32h743iit6-isr.ps1"
	& "$build_script_path/build-system-call.ps1"
	& "$build_script_path/build-stm32h743iit6-hal.ps1"
	& "$build_script_path/build-lwip.ps1"
	& "$build_script_path/build-stm32h743iit6-p-net.ps1"
	& "$build_script_path/build-freertos-osal.ps1"
	& "$build_script_path/build-freertos.ps1"
	& "$build_script_path/build-FatFs.ps1"
	& "$build_script_path/build-littlefs.ps1"
	& "$build_script_path/build-task.ps1"
	& "$build_script_path/build-stm32h743iit6-gpio.ps1"
	& "$build_script_path/build-stm32h743iit6-flash.ps1"
	& "$build_script_path/build-stm32h743iit6-interrupt.ps1"
	& "$build_script_path/build-stm32h743iit6-timer.ps1"
	& "$build_script_path/build-stm32h743iit6-dma.ps1"
	& "$build_script_path/build-stm32h743iit6-serial.ps1"
	& "$build_script_path/build-stm32h743iit6-clock.ps1"
}
finally
{
	Pop-Location
}
