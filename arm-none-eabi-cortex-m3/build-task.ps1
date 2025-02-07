$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/task"
$install_path = "$libs_path/task"
$build_path = "$source_path/jc_build"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	& "$build_script_path/build-bsp-interface.ps1"
	& "$build_script_path/build-freertos.ps1"

	git-get-repo.ps1 -git_url "https://github.com/hjc2000/task.git"

	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		--preset "arm-none-eabi-cortex-m3-release" `
		-DCMAKE_INSTALL_PREFIX="$install_path"

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}

	ninja -j12 -v
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
