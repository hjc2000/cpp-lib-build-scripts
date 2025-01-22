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

	Build-Dependency "build-base"
	Build-Dependency "build-bsp-interface"
	Build-Dependency "build-lwip-wrapper"
	Build-Dependency "build-stm32h743iit6-sdram"
	Build-Dependency "build-stm32h743iit6-ethternet"
	Build-Dependency "build-stm32h743iit6-isr"
	Build-Dependency "build-system-call"
	Build-Dependency "build-stm32h743iit6-hal"
	Build-Dependency "build-lwip"
	Build-Dependency "build-stm32h743iit6-p-net"
	Build-Dependency "build-freertos-osal"
	Build-Dependency "build-freertos"
	Build-Dependency "build-FatFs"
	Build-Dependency "build-littlefs"
	Build-Dependency "build-task"
	Build-Dependency "build-stm32h743iit6-gpio"
	Build-Dependency "build-stm32h743iit6-flash"
	Build-Dependency "build-stm32h743iit6-interrupt"
	Build-Dependency "build-stm32h743iit6-timer"
	Build-Dependency "build-stm32h743iit6-dma"
	Build-Dependency "build-stm32h743iit6-serial"
	Build-Dependency "build-stm32h743iit6-clock"
}
finally
{
	Pop-Location
}
