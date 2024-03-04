$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/alsa-lib/"
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

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--cross-prefix=arm-none-linux-gnueabihf- \
	--with-softfloat

	make clean
	make -j12
	make install
"@
}
catch
{
	throw
}
finally
{
	Pop-Location
}
