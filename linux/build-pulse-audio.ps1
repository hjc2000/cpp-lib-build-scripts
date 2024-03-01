$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	$env:PKG_CONFIG_PATH = ""
	& $build_script_path/build-libsndfile.ps1
	& $build_script_path/build-glib.ps1
	Write-Host "pkg-config 路径：$env:PKG_CONFIG_PATH"

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	New-Empty-Dir $build_path
	run-bash-cmd.ps1 @"
	set -e
	export PATH=$env:PATH
	export PKG_CONFIG_PATH=$env:PKG_CONFIG_PATH

	cd $source_path
	meson setup build/ \
		--prefix="$install_path" \
		-Ddaemon=false \
		-Dtests=false \
		-Ddoxygen=false \
		-Ddbus=disabled

	cd $build_path
	ninja -j12

	sudo su
	ninja install
	chmod 777 -R $install_path
	exit
"@
}
catch
{
	throw
}
finally
{
	Pop-Location
}
