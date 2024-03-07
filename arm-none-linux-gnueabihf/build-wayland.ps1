$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/wayland/"
$install_path = "$libs_path/wayland/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	Apt-Ensure-Packets @(
		"xsltproc", "xmlto",
		"xmlto", "graphviz", "doxygen"
	)

	# 构建依赖项
	& "${build_script_path}/build-libffi.ps1"
	& "${build_script_path}/build-libxml2.ps1"
	& "${build_script_path}/build-libexpat.ps1"

	

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://gitlab.freedesktop.org/wayland/wayland.git" `
		-branch_name "1.20.0"

	New-Item -Path $build_path -ItemType Directory -Force
	Remove-Item "$build_path/*" -Recurse -Force
	

	# '$total_install_path/lib/libexpat.so.1',
	# '$total_install_path/lib/libxml2.so.2',
	$c_link_args = @"
	[
		'-L$total_install_path/lib',
		'$total_install_path/lib/libffi.so.8',
		'$total_install_path/lib/libz.so.1',
		'$total_install_path/lib/libiconv.so.2',
		'$total_install_path/lib/liblzma.so.5',
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
		--prefix="$install_path" `
		--cross-file="$build_path/cross_file.ini"
	if ($LASTEXITCODE)
	{
		throw "配置失败"
	}	

	Set-Location $build_path
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
	Write-Host @"
	需要将构建脚本的 error('clock_gettime not found') 注释掉
"@
	throw
}
finally
{
	Pop-Location
}
