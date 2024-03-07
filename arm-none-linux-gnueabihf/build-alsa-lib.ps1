$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/alsa-lib/alsa-lib-1.2.7.2"
$install_path = "$libs_path/alsa-lib/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 开始构建本体
	Set-Location $repos_path
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.7.2.tar.bz2" `
		-out_dir_name "alsa-lib"

	run-bash-cmd.ps1 @"
	cd $source_path

	export CC=arm-none-linux-gnueabihf-gcc

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--with-softfloat > /dev/null

	make clean > /dev/null
	make -j12 > /dev/null
	make install > /dev/null
"@

	if ($LASTEXITCODE)
	{
		throw "编译失败"
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
