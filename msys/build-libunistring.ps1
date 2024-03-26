$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libunistring/libunistring-1.2"
$install_path = "$libs_path/libunistring"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.2.tar.gz" `
		-out_dir_name "libunistring"

	run-bash-cmd.ps1 -cmd @"
	cd $(cygpath.exe $source_path)

	./configure -h

	./configure \
	--prefix=$(cygpath.exe $install_path) \
	--enable-static=no

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Fix-Pck-Config-Pc-Path
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}