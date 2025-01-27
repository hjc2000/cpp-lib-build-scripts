$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	Try-Remove-Item.exe --path "$libs_path/system-call"
	Try-Remove-Item.exe --path "$libs_path/freertos"
	Try-Remove-Item.exe --path "$libs_path/FatFs"
	Try-Remove-Item.exe --path "$libs_path/littlefs"
	Try-Remove-Item.exe --path "$libs_path/task"
	Try-Remove-Item.exe --path "$libs_path/base"
	Try-Remove-Item.exe --path "$libs_path/bsp-interface"
	Try-Remove-Item.exe --path "$libs_path/stm32f103zet6-gpio"
	Try-Remove-Item.exe --path "$libs_path/stm32f103zet6-interrupt"
	Try-Remove-Item.exe --path "$libs_path/stm32f103zet6-timer"
	Try-Remove-Item.exe --path "$libs_path/stm32f103zet6-dma"
	Try-Remove-Item.exe --path "$libs_path/stm32f103zet6-serial"

	& "$build_script_path/build-system-call.ps1"
	& "$build_script_path/build-freertos.ps1"
	& "$build_script_path/build-FatFs.ps1"
	& "$build_script_path/build-littlefs.ps1"
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
