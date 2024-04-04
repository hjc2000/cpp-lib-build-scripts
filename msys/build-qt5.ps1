$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-msys.ps1

$source_path = "$repos_path/qt5/"
$install_path = "$libs_path/qt5/"
$build_path = "$source_path/jc_build"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Build-Dependency "build-zlib.ps1"

	git-get-repo.ps1 -git_url "https://github.com/qt/qt5.git" `
		-branch_name "6.7.0"

	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_C_COMPILER="gcc" `
		-DCMAKE_CXX_COMPILER="g++" `
		-DCMAKE_C_STANDARD=17 `
		-DCMAKE_CXX_STANDARD=20 `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DQT_NO_PACKAGE_VERSION_CHECK=TRUE

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}
	
	# qt 需要编译很久。这里使用 11 线程，避免电脑长时间卡顿。
	ninja -j11
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install

	Install-Msys-Dlls @(
		"/ucrt64/bin/libgcc_s_seh-1.dll",
		"/ucrt64/bin/libstdc++-6.dll",
		"/ucrt64/bin/libwinpthread-1.dll"
		"/ucrt64/bin/libzstd.dll"
	)
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/zlib/bin"
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
	Auto-Ldd $install_path/bin
}
finally
{
	Pop-Location
}
