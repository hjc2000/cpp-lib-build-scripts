$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/harfbuzz/"
$install_path = "$libs_path/harfbuzz/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	& "${build_script_path}/build-glib.ps1"
	& "${build_script_path}/build-pcre2.ps1"
	& "${build_script_path}/build-icu.ps1"

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/harfbuzz/harfbuzz.git"

	New-Item -Path $build_path -ItemType Directory -Force | Out-Null
	Remove-Item "$build_path/*" -Recurse -Force

	$c_link_args = @"
	[
		'-L$total_install_path/lib',
		'-Wl,-rpath-link,$total_install_path/lib',
		'$total_install_path/lib/libz.so.1',
		'$total_install_path/lib/libbz2.so.1',
		'$total_install_path/lib/libpng16.so.16',
		'$total_install_path/lib/libiconv.so.2',
		'$total_install_path/lib/libpcre2-8.so.0',
		'$total_install_path/lib/libglib-2.0.so',
	]
"@.Replace("`r", " ").Replace("`n", " ").Replace("`t", " ")

	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	$(Get-Meson-Cross-File-Binaries -toolchain_prefix "arm-none-linux-gnueabihf-")

	[properties]
	pkg_config_libdir = '$total_install_path/lib/pkgconfig'

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
