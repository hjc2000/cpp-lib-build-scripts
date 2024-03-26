$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/xz/"
$install_path = "$libs_path/xz/"
$build_path = "$source_path/build"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://github.com/tukaani-project/xz.git" `
		-branch_name "v5.6"

	New-Empty-Dir $build_path
	# 突发情况：
	# windows 更新了还是怎么着，fopen 函数被弃用了，然后就导致编译失败。
	# 必须使用 gcc 编译器，使用 msys 提供的 SDK 才能编译通过。
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CMAKE_SYSTEM_NAME Windows)
	set(CMAKE_SYSTEM_PROCESSOR x64)
	set(CMAKE_C_COMPILER gcc)
	set(CMAKE_CXX_COMPILER g++)
	set(CMAKE_RC_COMPILER windres)
	set(CMAKE_RANLIB ranlib)
"@

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DBUILD_SHARED_LIBS=ON

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

	Fix-Pck-Config-Pc-Path
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
