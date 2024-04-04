$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-msys.ps1

$source_path = "$repos_path/icu/icu4c/source/"
$install_path = "$libs_path/icu"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path

try
{
	git-get-repo.ps1 -git_url "https://github.com/unicode-org/icu.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)

	./configure \
	--prefix="$(cygpath.exe $install_path)"

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Msys-Dlls @(
		"/ucrt64/bin/libwinpthread-1.dll"
		"/ucrt64/bin/libgcc_s_seh-1.dll"
		"/ucrt64/bin/libstdc++-6.dll"
	)
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
	Auto-Ldd $install_path/bin
}
finally
{
	Pop-Location
}
