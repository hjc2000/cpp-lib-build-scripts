$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/openssl"
$install_path = "$libs_path/openssl"
$build_path = "$source_path/build" # cmake 项目才需要
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://gitee.com/hughpenn23/openssl.git"

	# 编译后安装阶段依赖 Perl 中的 pod2man，但是它比较不同寻常，
	# 可执行文件不是在 bin 里面，而是在 bin 里面又创建了一个目录
	$env:Path = "C:\msys64\usr\bin\core_perl;" + $env:Path
	
	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./Configure shared \
	--prefix="$install_path" \
	--cross-compile-prefix=arm-none-linux-gnueabihf-

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
