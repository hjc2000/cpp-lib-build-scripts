$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/libxkbcommon/"
$install_path = "$libs_path/libxkbcommon/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Apt-Ensure-Packets @("wayland-protocols")

	# 构建依赖项
	& "${build_script_path}/build-wayland.ps1"
	& "${build_script_path}/build-icu.ps1"
	# 设置依赖项的 pkg-config
	$env:PKG_CONFIG_PATH = "$total_install_path/lib"
	Total-Install

	$env:LIBRARY_PATH = "$total_install_path/lib"


	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/xkbcommon/libxkbcommon.git"

	New-Empty-Dir $build_path

	$c_link_args = @"
	[
		'-L$total_install_path/lib',
		'$total_install_path/lib/liblzma.so.5',
		'$total_install_path/lib/libffi.so.8',
		'$total_install_path/lib/libz.so.1',
		'$total_install_path/lib/libiconv.so.2',
		'$total_install_path/lib/libxml2.so.2',
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
	cpu = 'armv7-a'
	endian = 'little'

	[target_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = 'armv7-a'
	endian = 'little'

	[built-in options]
	c_args = ['-I$total_install_path/include']
	cpp_args = ['-I$total_install_path/include']
	c_link_args = $c_link_args
	cpp_link_args = $c_link_args
"@

	Set-Location $source_path
	meson setup build/ `
		-Denable-bash-completion=false `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini" `
		-Denable-x11=false


	Set-Location $build_path
	ninja clean
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "编译失败"
	}

	ninja install
	
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw
}
finally
{
	Pop-Location
}
