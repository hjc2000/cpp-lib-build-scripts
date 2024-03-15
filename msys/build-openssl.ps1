$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

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
	get-git-repo.ps1 -git_url "https://gitee.com/hughpenn23/openssl.git"

	# 编译后安装阶段依赖 Perl 中的 pod2man，但是它比较不同寻常，
	# 可执行文件不是在 bin 里面，而是在 bin 里面又创建了一个目录
	$env:Path = "C:\msys64\usr\bin\core_perl;" + $env:Path
	
	run-bash-cmd.ps1 @"
	set -e
	cd $(cygpath.exe $source_path)

	./Configure shared \
	--prefix="$(cygpath.exe $install_path)"

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