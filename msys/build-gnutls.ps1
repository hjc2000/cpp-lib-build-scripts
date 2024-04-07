$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-msys.ps1

$source_path = "$repos_path/gnutls/gnutls-3.7.10"
$install_path = "$libs_path/gnutls"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Pacman-Ensure-Packages @(
		"mingw-w64-ucrt-x86_64-nettle"
		"mingw-w64-ucrt-x86_64-libtasn1"
		"mingw-w64-ucrt-x86_64-unbound"
		"mingw-w64-ucrt-x86_64-libidn2"
	)
	Build-Dependency "build-libunistring.ps1"

	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.10.tar.xz" `
		-out_dir_name "gnutls"

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)

	./configure \
	--prefix="$(cygpath.exe $install_path)" \
	--with-included-unistring

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/libunistring/bin"
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
	Auto-Ldd $install_path/bin
}
finally
{
	Pop-Location
}
