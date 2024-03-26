$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libpng/"
$install_path = "$libs_path/libpng/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Build-Dependency "build-zlib.ps1"

	get-git-repo.ps1 -git_url "https://github.com/pnggroup/libpng.git"

	New-Empty-Dir -Path $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CMAKE_SYSTEM_NAME Windows)
	set(CMAKE_SYSTEM_PROCESSOR x64)
	set(CMAKE_C_COMPILER gcc)
	set(CMAKE_CXX_COMPILER g++)
	set(CMAKE_RC_COMPILER windres)
	set(CMAKE_RANLIB ranlib)

	include_directories(BEFORE "$total_install_path/include")
	link_directories(BEFORE "$total_install_path/lib")
"@

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path"
		
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

	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/zlib/bin"
	
	Fix-Pck-Config-Pc-Path
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe "/ucrt64" -w)
}
finally
{
	Pop-Location
}
