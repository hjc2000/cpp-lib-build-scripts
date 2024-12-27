$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

try
{
	Try-Remove-Item -Path "$libs_path/system-call"
	Try-Remove-Item -Path "$libs_path/freertos"
	Try-Remove-Item -Path "$libs_path/FatFs"
	Try-Remove-Item -Path "$libs_path/littlefs"
	Try-Remove-Item -Path "$libs_path/task"
	Try-Remove-Item -Path "$libs_path/base"
	Try-Remove-Item -Path "$libs_path/bsp-interface"
	Try-Remove-Item -Path "$libs_path/stm32f103zet6-gpio"
	Try-Remove-Item -Path "$libs_path/stm32f103zet6-interrupt"
	Try-Remove-Item -Path "$libs_path/stm32f103zet6-timer"
	Try-Remove-Item -Path "$libs_path/stm32f103zet6-dma"
	Try-Remove-Item -Path "$libs_path/stm32f103zet6-serial"

	Build-Dependency "build-system-call"
	Build-Dependency "build-freertos"
	Build-Dependency "build-FatFs"
	Build-Dependency "build-littlefs"
	Build-Dependency "build-task"
	Build-Dependency "build-base"
	Build-Dependency "build-bsp-interface"
	Build-Dependency "build-stm32f103zet6-gpio"
	Build-Dependency "build-stm32f103zet6-interrupt"
	Build-Dependency "build-stm32f103zet6-timer"
	Build-Dependency "build-stm32f103zet6-dma"
	Build-Dependency "build-stm32f103zet6-serial"
}
finally
{
	Pop-Location
}
