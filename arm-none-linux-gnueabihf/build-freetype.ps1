$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/freetype/"
$install_path = "$libs_path/freetype/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	& "${build_script_path}/build-bzip2.ps1"
	& "${build_script_path}/build-libpng.ps1"
	& "${build_script_path}/build-zlib.ps1"

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/freetype/freetype.git"

	New-Item -Path $build_path -ItemType Directory -Force | Out-Null
	Remove-Item "$build_path/*" -Recurse -Force

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

	[built-in options]
	c_args = ['-march=armv4', '-I$total_install_path/include']
	cpp_args = ['-march=armv4', '-I$total_install_path/include']
	c_link_args = ['-L$total_install_path/lib/', ]
	cpp_link_args = ['-L$total_install_path/lib/']
"@

	Set-Location $source_path
	meson setup build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini"

	Set-Location $build_path
	ninja -j12 | Out-Null
	ninja install | Out-Null

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
