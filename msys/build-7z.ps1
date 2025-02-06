$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/clang/libclang"
$install_path = "$libs_path/clang"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://mirrors.tuna.tsinghua.edu.cn/qt/development_releases/prebuilt/libclang/qt/libclang-release_120-based-windows-mingw_64.7z" `
		-out_dir_name "clang"

	Copy-Item -Path $source_path `
		-Destination $install_path `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
	# Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
}
finally
{
	Pop-Location
}
