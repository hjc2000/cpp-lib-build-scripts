$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/icu/icu4c/source/"
$install_path = "$libs_path/icu"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://github.com/unicode-org/icu.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	touch configure-help.txt
	./configure -h > configure-help.txt

	./configure \
	--prefix="$install_path" \
	--enable-icu-config

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
