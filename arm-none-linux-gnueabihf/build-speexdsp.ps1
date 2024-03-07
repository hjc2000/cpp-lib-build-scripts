$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/speexdsp/"
$install_path = "$libs_path/speexdsp"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://gitlab.xiph.org/xiph/speexdsp.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./configure -h
	exit

	./configure \
	--prefix="$install_path"

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
