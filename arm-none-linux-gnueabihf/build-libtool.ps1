$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/libtool/libtool-2.4.7"
$install_path = "$libs_path/libtool"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.gz" `
		-out_dir_name "libtool"

	run-bash-cmd.ps1 -cmd @"
	cd $source_path
	autoreconf -fi

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--enable-ltdl-install

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