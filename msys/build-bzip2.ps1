$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/bzip2/bzip2-1.0.8/"
$install_path = "$libs_path/bzip2"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://sourceware.org/pub/bzip2/bzip2-latest.tar.gz" `
		-out_dir_name "bzip2"

	run-bash-cmd.ps1 -cmd @"
	cd $(cygpath.exe $source_path)

	alias gcc="clang"
	alias ar="llvm-ar"
	alias ranlib="llvm-ranlib"

	gcc -v
	make PREFIX=$(cygpath.exe $install_path) clean
	make PREFIX=$(cygpath.exe $install_path) -j12
	make PREFIX=$(cygpath.exe $install_path) install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	$pc_file_content = @"
prefix=$install_path
exec_prefix=`${prefix}
bindir=`${exec_prefix}/bin
libdir=`${exec_prefix}/lib
includedir=`${prefix}/include

Name: bzip2
Description: Lossless, block-sorting data compression
Version: 1.0.6
Libs: -L`${libdir} -lbz2
Cflags: -I`${includedir}
"@
	New-Item -Path $install_path/lib/pkgconfig/bzip2.pc -ItemType File -Force
	$pc_file_content | Out-File -FilePath $install_path/lib/pkgconfig/bzip2.pc

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
