$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

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
	Clear-Pkg-Config-Path

	& $build_script_path/build-libsndfile.ps1
	Append-Pkg-Config-Path -Path "$libs_path/libsndfile/lib/pkgconfig"

	& $build_script_path/build-dbus.ps1
	Append-Pkg-Config-Path -Path "$libs_path/dbus/lib/pkgconfig"



	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	New-Empty-Dir -Path $build_path
	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = 'arm-none-linux-gnueabihf-gcc'
	cpp = 'arm-none-linux-gnueabihf-g++'
	ar = 'arm-none-linux-gnueabihf-ar'
	ld = 'arm-none-linux-gnueabihf-ld'
	strip = 'arm-none-linux-gnueabihf-strip'
	pkg-config = 'pkg-config'

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
		--cross-file="$build_path/cross_file.ini" `
		-Ddaemon=false `
		-Dtests=false `
		-Ddoxygen=false `
		-Ddbus=disabled

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
