$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/prepare.ps1

	$source_path = "$repos_path/libunistring/libunistring-1.2"
	$install_path = "$libs_path/libunistring"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	& "$build_script_path/build-libiconv.ps1"

	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.2.tar.gz" `
		-out_dir_name "libunistring"

	run-bash-cmd.ps1 -cmd @"
	cd $(cygpath.exe $source_path)

	./autogen.sh

	./configure \
	--prefix=$(cygpath.exe $install_path)

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
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
