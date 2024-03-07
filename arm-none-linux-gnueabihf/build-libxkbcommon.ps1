$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libxkbcommon/"
$install_path = "$libs_path/libxkbcommon/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Apt-Ensure-Packets @("wayland-protocols")

	# 构建依赖项
	& "${build_script_path}/build-wayland.ps1"
	& "${build_script_path}/build-icu.ps1"
	# 设置依赖项的 pkg-config
	$env:PKG_CONFIG_PATH = "$total_install_path/lib"
	Total-Install

	$env:LIBRARY_PATH = "$total_install_path/lib"


	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/xkbcommon/libxkbcommon.git"

	New-Empty-Dir $build_path

	New-Meson-Cross-File -link_flags @"
	[
		'-L$total_install_path/lib',
		'-Wl,-rpath-link,$total_install_path/lib',
	]
"@

	Set-Location $source_path
	meson setup build/ `
		-Denable-bash-completion=false `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Denable-x11=false
	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}	

	Set-Location $build_path
	ninja clean
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
