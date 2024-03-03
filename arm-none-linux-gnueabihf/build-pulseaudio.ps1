$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/pulseaudio/"
$install_path = "$libs_path/pulseaudio/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& "${build_script_path}/build-libsndfile.ps1"
	& "${build_script_path}/build-dbus.ps1"
	# 设置依赖项的 pkg-config
	Clear-PkgConfig-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/libsndfile"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/dbus"


	
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
		-Dbashcompletiondir="$build_path" `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Ddaemon=false `
		-Dtests=false `
		-Ddoxygen=false `
		-Dglib=disabled

	Set-Location $build_path
	ninja -j12
	ninja install

	Move-Item -Path "$install_path/lib/pulseaudio/*" `
		-Destination "$install_path/lib/" `
		-Force
	Remove-Item -Path "$install_path/lib/pulseaudio/" -Force -Recurse
}
catch
{
	throw
}
finally
{
	Pop-Location
}
