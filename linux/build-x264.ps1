$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/x264/"
$install_path = "$libs_path/x264"

if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path

try
{
	git-get-repo.ps1 -git_url "https://gitee.com/Qianshunan/x264.git"

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

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw "
	$(get-script-position.ps1)
	$(${PSItem}.Exception.Message)
	"
}
finally
{
	Pop-Location
}
