$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/freetype/freetype-2.7"
$install_path = "$libs_path/freetype/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	& "${build_script_path}/build-zlib.ps1"
	& "${build_script_path}/build-libpng.ps1"

	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.gz" `
		-out_dir_name "freetype"

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf

	make -j12
	make install
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
