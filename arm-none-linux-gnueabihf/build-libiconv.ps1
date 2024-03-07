$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libiconv/libiconv-1.17"
$install_path = "$libs_path/libiconv/"
Push-Location $repos_path
try
{
	if (-not (Test-Path -Path "$source_path/Makefile" || Test-Path -Path "$source_path/makefile"))
	{
		wget-repo.ps1 -workspace_dir $repos_path `
			-repo_url "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz" `
			-out_dir_name "libiconv"

		run-bash-cmd.ps1 -cmd @"
		cd $source_path
	
		./configure \
		--prefix="$install_path" \
		--host=arm-none-linux-gnueabihf
"@					
	}

	run-bash-cmd.ps1 -cmd @"
	cd $source_path
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
