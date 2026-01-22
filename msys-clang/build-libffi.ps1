Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/prepare.ps1

	$source_path = "$repos_path/libffi/libffi-3.4.6"
	$install_path = "$libs_path/libffi"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	Set-Location $repos_path

	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz" `
		-out_dir_name "libffi"

	$env:CC = "clang"
	$env:CXX = "clang++"

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path"

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
