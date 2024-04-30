$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/libstm32f103-hal"
$install_path = "$libs_path/libstm32f103-hal"
$build_path = "$source_path/jc_build"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url "https://github.com/hjc2000/libstm32f103-hal.git"
	
	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-Dcpp_lib_build_scripts_path="$project_root_path" `
		-Dplatform="arm-none-eabi-cortex-m3" `
		-DCMAKE_SYSTEM_PROCESSOR="arm" `
		-DCMAKE_SYSTEM_ARCH="armv7-m" `
		-DCMAKE_SYSTEM_NAME="Generic" `
		-DCMAKE_C_COMPILER="arm-none-eabi-gcc" `
		-DCMAKE_CXX_COMPILER="arm-none-eabi-g++" `
		-DCMAKE_ASM_COMPILER="arm-none-eabi-gcc" `
		-DCMAKE_AR="arm-none-eabi-ar" `
		-DCMAKE_LINKER="arm-none-eabi-ld" `
		-DCMAKE_OBJCOPY="arm-none-eabi-objcopy" `
		-DCMAKE_RANLIB="arm-none-eabi-ranlib" `
		-DCMAKE_SIZE="arm-none-eabi-size" `
		-DCMAKE_STRIP="arm-none-eabi-ld" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DCMAKE_C_FLAGS="$c_cxx_flags" `
		-DCMAKE_CXX_FLAGS="$c_cxx_flags" `
		-DCMAKE_ASM_FLAGS="$asm_flags" `
		-DCMAKE_EXECUTABLE_SUFFIX=".elf" `
		-DCMAKE_STATIC_LIBRARY_SUFFIX=".a"
		
	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}
	
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
