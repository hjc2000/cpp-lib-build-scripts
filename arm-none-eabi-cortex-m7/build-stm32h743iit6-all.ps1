$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	# Try-Remove-Item -Path "$libs_path/freertos"
	Try-Remove-Item -Path "$libs_path/task"
	Try-Remove-Item -Path "$libs_path/base"
	Try-Remove-Item -Path "$libs_path/bsp-interface"
	Try-Remove-Item -Path "$libs_path/c-bsp-interface"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-gpio"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-flash"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-interrupt"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-timer"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-dma"
	Try-Remove-Item -Path "$libs_path/stm32h743iit6-serial"

	Build-Dependency "build-freertos"
	Build-Dependency "build-task"
	Build-Dependency "build-base"
	Build-Dependency "build-bsp-interface"
	Build-Dependency "build-c-bsp-interface"
	Build-Dependency "build-stm32h743iit6-gpio"
	Build-Dependency "build-stm32h743iit6-flash"
	Build-Dependency "build-stm32h743iit6-interrupt"
	Build-Dependency "build-stm32h743iit6-timer"
	Build-Dependency "build-stm32h743iit6-dma"
	Build-Dependency "build-stm32h743iit6-serial"
}
finally
{
	Pop-Location
}
