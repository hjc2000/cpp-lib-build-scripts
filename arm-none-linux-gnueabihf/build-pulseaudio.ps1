$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Apt-Ensure-Packets @(
		"xsltproc", "xmlto",
		"xmlto", "graphviz", "doxygen"
	)

	# 构建依赖项
	& "${build_script_path}/build-libsndfile.ps1"
	& "${build_script_path}/build-dbus.ps1"
	& "${build_script_path}/build-libtool.ps1"
	& "${build_script_path}/build-gdbm.ps1"
	& "${build_script_path}/build-alsa-lib.ps1"
	& "${build_script_path}/build-glib.ps1"
	# 设置依赖项的 pkg-config
	$env:PKG_CONFIG_PATH = "$total_install_path/lib"
	Total-Install


	
	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	New-Empty-Dir -Path $build_path

	New-Meson-Cross-File
	Set-Location $source_path
	meson setup build/ `
		-Dbashcompletiondir="$build_path" `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Dtests=false `
		-Ddatabase="gdbm" `
		-Dudev=disabled `
		-Dgstreamer=disabled `
		-Dopenssl=disabled `
		-Dsystemd=disabled `
		-Dhal-compat=false
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
}
catch
{
	throw
}
finally
{
	Pop-Location
}
