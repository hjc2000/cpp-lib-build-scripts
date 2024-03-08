$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/gdbm/gdbm-1.23"
$install_path = "$libs_path/gdbm"
Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.23.tar.gz" `
		-out_dir_name "gdbm"

	run-bash-cmd.ps1 -cmd @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf

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
