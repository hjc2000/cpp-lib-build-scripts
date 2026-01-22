$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/freetype/"
$install_path = "$libs_path/freetype/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	& "$build_script_path/build-bzip2.ps1"
	& "$build_script_path/build-libpng.ps1"
	& "$build_script_path/build-zlib.ps1"

	# 开始构建本体
	Set-Location $repos_path
	git-get-repo.ps1 -git_url "https://github.com/freetype/freetype.git"

	New-Empty-Dir -Path $build_path
	New-Meson-Cross-File
	Set-Location $source_path
	meson setup jc_build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini"

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}

	Set-Location $build_path
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{

}
