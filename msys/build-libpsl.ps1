$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libpsl"
$install_path = "$libs_path/libpsl"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Build-Dependency "build-icu.ps1"

	get-git-repo.ps1 -git_url "https://github.com/rockdaboot/libpsl.git"

	New-Empty-Dir -Path $build_path
	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = 'gcc'
	cpp = 'g++'
	strip = 'strip'
	pkg-config = 'pkg-config'
"@

	Set-Location $source_path
	# meson设置库的默认查找路径
	meson setup jc_build/ `
		--cross-file="$build_path/cross_file.ini" `
		--prefix="$install_path" `
		--libdir="$total_install_path/lib" `
		--includedir="$total_install_path/include"
		
	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}
	
	Set-Location $build_path
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install

	Install-Msys-Dlls @(
		"/ucrt64/bin/libgcc_s_seh-1.dll"
		"/ucrt64/bin/libwinpthread-1.dll"
		"/ucrt64/bin/libstdc++-6.dll"
	)
	Install-Dependent-Dlls-From-Dir $libs_path/icu/bin
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
	Auto-Ldd $install_path/bin
}
finally
{
	Pop-Location
}
