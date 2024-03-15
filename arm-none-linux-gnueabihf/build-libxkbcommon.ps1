$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/libxkbcommon/"
$install_path = "$libs_path/libxkbcommon/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Apt-Ensure-Packets @("wayland-protocols")

	# 构建依赖项
	Build-Dependency "build-wayland-protocols.ps1"
	Build-Dependency "build-icu.ps1"



	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/xkbcommon/libxkbcommon.git"

	New-Empty-Dir -Path $build_path
	$env:PKG_CONFIG_LIBDIR = "${default_pkg_config_libdir}:${override_pkg_config_libdir}"
	New-Meson-Cross-File
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
	Pop-Location
}
