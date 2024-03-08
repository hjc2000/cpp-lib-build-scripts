$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
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
	Build-Dependency "build-libsndfile.ps1"
	Build-Dependency "build-dbus.ps1"
	Build-Dependency "build-libtool.ps1"
	Build-Dependency "build-gdbm.ps1"
	Build-Dependency "build-alsa-lib.ps1"
	Build-Dependency "build-glib.ps1"



	
	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	New-Empty-Dir -Path $build_path
	New-Meson-Cross-File -arch "armv4"
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
