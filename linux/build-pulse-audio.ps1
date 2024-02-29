$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Apt-Ensure-Packets @(
		"meson"
	)

	# 构建依赖项
	& $build_script_path/build-libsndfile.ps1
	& $build_script_path/build-libtool.ps1

	$env:PKG_CONFIG_PATH = 
	"$libs_path/libsndfile/lib/pkgconfig:"
	Write-Host $env:PKG_CONFIG_PATH

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	$env:LDFLAGS = "-L$libs_path/libtool/lib/ltdl.so.7:$env:LDFLAGS"
	$env:CFLAGS = "-I$libs_path/libtool/include:$env:CFLAGS"

	Set-Location $source_path
	meson setup build/ `
		--prefix=$install_path `
		-Ddisable-ltdl=true

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
