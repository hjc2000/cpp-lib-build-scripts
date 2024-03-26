$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/wayland-protocols/"
$install_path = "$libs_path/wayland-protocols/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	# 构建依赖项
	Build-Dependency "build-wayland.ps1"

	
	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://gitlab.freedesktop.org/wayland/wayland-protocols.git"

	$env:PKG_CONFIG_LIBDIR = "${default_pkg_config_libdir}:${override_pkg_config_libdir}"

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

	# 因为 wayland-protocols 把 pkgconfig 目录放到 share 里面了，所以要
	# 把它复制到 lib 目录。
	New-Item -Path "$install_path/lib/pkgconfig" -ItemType Directory -Force
	Copy-Item -Path "$install_path/share/pkgconfig/*" `
		-Destination "$install_path/lib/pkgconfig" `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
