$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libiconv/libiconv-1.17"
$install_path = "$libs_path/libiconv"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz" `
		-out_dir_name "libiconv"

	run-bash-cmd.ps1 -cmd @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path"

	make -j12
	make install
"@
		
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
