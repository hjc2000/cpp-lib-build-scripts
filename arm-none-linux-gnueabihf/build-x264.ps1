$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/x264/"
$install_path = "$libs_path/x264"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://gitee.com/Qianshunan/x264.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--enable-shared \
	--disable-opencl \
	--enable-pic \
	--host=arm-none-linux-gnueabihf \
	--cross-prefix=arm-none-linux-gnueabihf- > /dev/null

	make clean
	make -j12 > /dev/null
	make install > /dev/null
"@
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw
}
finally
{
	Pop-Location
}
