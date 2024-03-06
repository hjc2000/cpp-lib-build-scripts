$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/glib/"
$install_path = "$libs_path/glib/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	pip install packaging

	# 构建依赖项
	& "${build_script_path}/build-pcre2.ps1"
	& "${build_script_path}/build-libffi.ps1"
	& "${build_script_path}/build-zlib.ps1"
	& "${build_script_path}/build-libiconv.ps1"
	# 设置依赖项的 pkg-config
	$env:PKG_CONFIG_PATH = "$total_install_path/lib"
	Total-Install

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://gitlab.gnome.org/GNOME/glib.git"

	New-Item -Path $build_path -ItemType Directory -Force | Out-Null

	$c_link_args = @"
	[
		'-L$total_install_path/lib',
		'-Wl,--no-as-needed',
		'$total_install_path/lib/libiconv.so.2',
	]
"@.Replace("`r", " ").Replace("`n", " ").Replace("`t", " ")
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
	c_link_args = $c_link_args
	cpp_link_args = ['-L$total_install_path/lib', '-Wl,--no-as-needed']
"@

	Set-Location $source_path
	meson setup build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Dselinux=disabled `
		-Dlibmount=disabled


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
