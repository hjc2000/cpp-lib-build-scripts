$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	Try-Remove-Item -Path "$libs_path/base"
	Try-Remove-Item -Path "$libs_path/bsp-interface"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-sdram"
	Try-Remove-Item -Path "$libs_path/lwip-wrapper"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-ethternet"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-isr"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-p-net"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-gpio"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-flash"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-interrupt"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-timer"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-dma"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-serial"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-clock"
	Try-Remove-Item -Path "$libs_path/system-call"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-hal"
	Try-Remove-Item -Path "$libs_path/lwip"
	Try-Remove-Item -Path "$libs_path/freertos-osal"
	Try-Remove-Item -Path "$libs_path/freertos"
	Try-Remove-Item -Path "$libs_path/FatFs"
	Try-Remove-Item -Path "$libs_path/littlefs"
	Try-Remove-Item -Path "$libs_path/task"

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
