$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libdecor/"
$install_path = "$libs_path/libdecor/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 构建依赖项
	& "${build_script_path}/build-wayland.ps1"
	& "${build_script_path}/build-dbus.ps1"
	& "${build_script_path}/build-cairo.ps1"
	# 设置依赖项的 pkg-config
	Clear-PkgConfig-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/wayland"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/dbus"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/cairo"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/libpng"
	Total-Install


	
	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/neonkore/libdecor.git"

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
	cpu = 'armv4'
	endian = 'little'

	[target_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = 'armv4'
	endian = 'little'

	# 如果不设置低于 avmv6 的版本，编译时就会报内联汇编有不可能的约束。
	[built-in options]
	c_args = ['-march=armv4', '-I$total_install_path/include']
	cpp_args = ['-march=armv4', '-I$total_install_path/include']
	c_link_args = ['-L$total_install_path/lib']
	cpp_link_args = ['-L$total_install_path/lib']
"@

	Set-Location $source_path
	meson setup build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini"

	Set-Location $build_path
	ninja clean
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
