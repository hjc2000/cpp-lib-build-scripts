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
	# 设置依赖项的 pkg-config
	Clear-PkgConfig-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/libsndfile"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/dbus"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/libtool"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/gdbm"
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/alsa-lib"
	Total-Install


	
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

	# '-L$total_install_path/lib' 是一定要的，否则等不到你强制链接库文件，meson.build
	# 脚本的依赖检查先报错了，没机会强制链接。
	c_link_args = ['-L$total_install_path/lib', '$total_install_path/lib/libgdbm.so.6', '$total_install_path/lib/libltdl.so.7']
	cpp_link_args = ['-L$total_install_path/lib']
"@

	Set-Location $source_path
	meson setup build/ `
		-Dbashcompletiondir="$build_path" `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Dtests=false `
		-Dglib=disabled `
		-Ddatabase="gdbm" `
		-Dudev=disabled `
		-Dgstreamer=disabled `
		-Dopenssl=disabled `
		-Dsystemd=disabled
	#-Ddaemon=false


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
