$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libusb/"
$install_path = "$libs_path/libusb"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://github.com/libusb/libusb.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)
	autoreconf -fi

	./configure \
	--prefix="$(cygpath.exe $install_path)" \
	--enable-udev=no

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}