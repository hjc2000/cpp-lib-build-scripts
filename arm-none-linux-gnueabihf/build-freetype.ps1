$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/freetype/"
$install_path = "$libs_path/freetype/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	& "${build_script_path}/build-zlib.ps1"
	& "${build_script_path}/build-libpng.ps1"


	get-git-repo.ps1 -git_url "https://github.com/freetype/freetype.git"

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf

	make -j12
	make install > /dev/null
"@
	
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
