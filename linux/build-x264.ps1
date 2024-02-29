$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/x264/"
$install_path = "$libs_path/x264"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://gitee.com/Qianshunan/x264.git"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--enable-shared \
	--disable-opencl \
	--enable-pic

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
