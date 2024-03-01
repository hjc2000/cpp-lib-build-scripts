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
	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = 'arm-none-linux-gnueabihf-gcc'
	cpp = 'arm-none-linux-gnueabihf-g++'
	ar = 'arm-none-linux-gnueabihf-ar'
	ld = 'arm-none-linux-gnueabihf-ld'
	strip = 'arm-none-linux-gnueabihf-strip'
	pkg-config = 'pkg-config'

	[properties]
	sys_root='$total_install_path'

	[host_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = 'armv7-a'
	endian = 'little'

	[target_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = 'armv7-a'
	endian = 'little'
"@


	Set-Location $source_path
	meson setup build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini"

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
