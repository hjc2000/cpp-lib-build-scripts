$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/openssl"
$install_path = "$libs_path/openssl"
$build_path = "$source_path/build" # cmake 项目才需要
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url "https://gitee.com/hughpenn23/openssl.git" `
		-branch_name openssl-3.1

	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./Configure \
	linux-armv4 \
	shared \
	--prefix="$install_path" \
	--cross-compile-prefix=arm-none-linux-gnueabihf-

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Copy-Item -Path $install_path/lib64 -Destination $install_path/lib -Force -Recurse
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw
}
finally
{

}
