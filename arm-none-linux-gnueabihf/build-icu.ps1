$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/icu/icu4c/source/"
$install_path = "$libs_path/icu"
Push-Location $repos_path
try
{
	& $project_root_path/linux/build-icu.ps1

	get-git-repo.ps1 -git_url "https://github.com/unicode-org/icu.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	touch configure-help.txt
	./configure -h > configure-help.txt

	./configure \
	--prefix="$install_path" \
	--host=arm-none-linux-gnueabihf \
	--with-cross-build="$project_root_path/linux/.repos/icu/icu4c/source"

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
