$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/wayland/"
$install_path = "$libs_path/wayland/"
$build_path = "$source_path/build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Apt-Ensure-Packets @(
		"xsltproc", "xmlto",
		"xmlto", "graphviz", "doxygen"
	)

	# 构建依赖项
	Build-Dependency "build-libffi.ps1"
	Build-Dependency "build-libxml2.ps1"
	Build-Dependency "build-libexpat.ps1"


	

	# 开始构建本体
	Set-Location $repos_path

	# 使用 1.20.0 版本是因为交叉编译时需要宿主机的 wayland-scanner 可执行文件
	# 而 ubuntu22.04 的 apt 安装的最高只能到 1.20.0 版本。
	get-git-repo.ps1 -git_url "https://gitlab.freedesktop.org/wayland/wayland.git" `
		-branch_name "1.20.0"

	New-Item -Path $build_path -ItemType Directory -Force
	Remove-Item "$build_path/*" -Recurse -Force
	
	# meson 里面会利用 pkg-config 查找宿主机的 wayland-scanner 可执行文件。
	$env:PKG_CONFIG_LIBDIR = "${default_pkg_config_libdir}:${override_pkg_config_libdir}"
	New-Meson-Cross-File
	Set-Location $source_path
	meson setup build/ `
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
	Pop-Location
}
