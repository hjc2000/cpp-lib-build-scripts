$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/fontconfig/"
$install_path = "$libs_path/fontconfig/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://gitlab.freedesktop.org/fontconfig/fontconfig.git"

	New-Item -Path $build_path -ItemType Directory -Force | Out-Null
	Remove-Item "$build_path/*" -Recurse -Force

	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	$(Get-Meson-Cross-File-Binaries -toolchain_prefix "arm-none-linux-gnueabihf-gcc")

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
	c_args = ['-march=armv7-a', '-I$total_install_path/include']
	cpp_args = ['-march=armv7-a', '-I$total_install_path/include']
	c_link_args = ['-L$total_install_path/lib/', ]
	cpp_link_args = ['-L$total_install_path/lib/']
"@

	Set-Location $source_path
	meson setup build/ `
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini"

	Set-Location $build_path
	ninja -j12
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
