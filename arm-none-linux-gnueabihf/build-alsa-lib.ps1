$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/alsa-lib/alsa-lib-1.2.7.2"
$install_path = "$libs_path/alsa-lib/"
$build_path = "$source_path/build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path

try
{
	# 开始构建本体
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.7.2.tar.bz2" `
		-out_dir_name "alsa-lib"

	run-bash-cmd.ps1 @"
	cd $source_path
	export CC=arm-none-linux-gnueabihf-gcc

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--with-softfloat

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
catch
{
	throw
}
finally
{
	Pop-Location
}
