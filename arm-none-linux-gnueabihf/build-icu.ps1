$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/icu/icu4c/source/"
$install_path = "$libs_path/icu"
Push-Location $repos_path
try
{	
	@"
	& $project_root_path/linux/build-icu.ps1
"@ | pwsh

	get-git-repo.ps1 -git_url "https://github.com/unicode-org/icu.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--with-cross-build="$project_root_path/linux/.repos/icu/icu4c/source" > /dev/null

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
	Pop-Location
}
