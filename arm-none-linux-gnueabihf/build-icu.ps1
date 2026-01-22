$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/icu/icu4c/source/"
$install_path = "$libs_path/icu"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	@"
	$project_root_path/linux/build-icu.ps1
"@ | pwsh

	git-get-repo.ps1 -git_url "https://github.com/unicode-org/icu.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--with-cross-build="$project_root_path/linux/.repos/icu/icu4c/source" > /dev/null

	make clean
	make -j12 > /dev/null
	make install > /dev/null
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{

}
