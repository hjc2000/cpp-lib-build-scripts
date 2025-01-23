$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/cairo/"
$install_path = "$libs_path/cairo/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Apt-Ensure-Packets @("docbook-utils", "docbook", "docbook-to-man", "docbook-xml")

	# 构建依赖项
	& "$build_script_path/build-zlib.ps1"
	& "$build_script_path/build-libexpat.ps1"
	& "$build_script_path/build-glib.ps1"
	& "$build_script_path/build-libpng.ps1"
	& "$build_script_path/build-freetype.ps1"
	& "$build_script_path/build-libiconv.ps1"


	# 开始构建本体
	Set-Location $repos_path
	git-get-repo.ps1 -git_url "https://gitlab.freedesktop.org/cairo/cairo.git"

	New-Empty-Dir -Path $build_path
	New-Meson-Cross-File
	Set-Location $source_path
	meson setup jc_build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Dtests=disabled `
		-Dxlib=disabled

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
catch
{
	throw
}
finally
{
	Pop-Location
}
