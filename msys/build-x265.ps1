$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-msys.ps1

$source_path = "$repos_path/x265_git/source"
$install_path = "$libs_path/x265/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	# x265 必须完全克隆。因为这逼在 cmake 配置时会从 git log 中获取标签，然后作为
	# 版本号，注入 x265.rc 中，然后再编译 x265.rc
	get-git-repo.ps1 -git_url "https://bitbucket.org/multicoreware/x265_git.git" `
		-full_clone
	
	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Unix Makefiles" $source_path `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DCMAKE_C_COMPILER="gcc" `
		-DCMAKE_CXX_COMPILER="g++" `
		-DCMAKE_BUILD_TYPE=Release `
		-DENABLE_SHARED=ON `
		-DENABLE_PIC=ON `
		-DENABLE_ASSEMBLY=OFF
		
	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}
	
	make -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	make install

	Install-Msys-Dlls @(
		"/ucrt64/bin/libstdc++-6.dll"
		"/ucrt64/bin/libgcc_s_seh-1.dll"
		"/ucrt64/bin/libwinpthread-1.dll"
	)
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
	Auto-Ldd $install_path/bin
}
finally
{
	Pop-Location
}
