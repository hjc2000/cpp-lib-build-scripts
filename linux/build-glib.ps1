$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/glib/"
$install_path = "$libs_path/glib/"
$build_path = "$source_path/build/"
Push-Location $repos_path

try
{
	Set-Location $repos_path
	get-git-repo.ps1 -git_url https://github.com/GNOME/glib.git

	New-Empty-Dir $build_path
	run-bash-cmd.ps1 @"
	set -e
	export PATH=$env:PATH
	export PKG_CONFIG_PATH=$env:PKG_CONFIG_PATH

	cd $source_path
	meson setup build/ \
		--prefix="$install_path"

	cd $build_path
	ninja -j12

	sudo su
	export PATH=$env:PATH
	export PKG_CONFIG_PATH=$env:PKG_CONFIG_PATH
	ninja install
	chmod 777 -R $install_path
	exit
"@
	
	$env:PKG_CONFIG_PATH = "$libs_path/glib/lib/x86_64-linux-gnu/pkgconfig:$env:PKG_CONFIG_PATH" 
}
catch
{
	throw
}
finally
{
	Pop-Location
}
