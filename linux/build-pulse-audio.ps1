$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& $build_script_path/build-libsndfile.ps1
	& $build_script_path/build-glib.ps1
	& $build_script_path/build-dbus.ps1
	$env:PKG_CONFIG_PATH = ""
	Append-Pkg-Config-Path -Path "$libs_path/glib/lib/x86_64-linux-gnu/pkgconfig"
	Append-Pkg-Config-Path -Path "$libs_path/libsndfile/lib/pkgconfig"
	Append-Pkg-Config-Path -Path "$libs_path/dbus/lib/pkgconfig"
	Write-Host "pkg-config 路径：$env:PKG_CONFIG_PATH"

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	New-Empty-Dir $build_path
	Set-Location $source_path
	meson setup build/ `
		-Dbashcompletiondir="$build_path" `
		--prefix="$install_path" `
		-Ddaemon=false `
		-Dtests=false `
		-Ddoxygen=false

	Set-Location $build_path
	ninja -j12
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
