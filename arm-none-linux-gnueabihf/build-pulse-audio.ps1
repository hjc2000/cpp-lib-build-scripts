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
	& $build_script_path/build-libsndfile.ps1

	$PKG_CONFIG_PATH = "$libs_path/libsndfile/lib/pkgconfig:"
	$env:PKG_CONFIG_PATH = $PKG_CONFIG_PATH
	Write-Host $env:PKG_CONFIG_PATH

	# 开始构建本体
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/pulseaudio/pulseaudio.git"

	New-Empty-Dir -Path $build_path
	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = '$(which arm-none-linux-gnueabihf-gcc)'
	cpp = '$(which arm-none-linux-gnueabihf-g++)'
	ar = '$(which arm-none-linux-gnueabihf-ar)'
	ld = '$(which arm-none-linux-gnueabihf-ld)'
	strip = '$(which arm-none-linux-gnueabihf-strip)'
	pkgconfig = '$(which /usr/bin/pkg-config)'

	[built-in options]
	c_args = ['-march=armv7-a']
	c_link_args = ['-march=armv7-a']

	[properties]
	needs_exe_wrapper = true

	[host_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = 'armv7-a'
	endian = 'little'
"@

	$PATH = $env:PATH

	run-bash-cmd.ps1 @"
	cd $source_path
	export PATH=$PATH
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH

	meson setup build/ \
		--prefix="$install_path" \
		--cross-file="$build_path/cross_file.ini" \
		-Ddaemon=false \
		-Dtests=false \
		-Ddoxygen=false

	cd $build_path
	ninja -j12

	sudo su
	ninja install
	chmod 777 -R $install_path
	exit
"@
}
catch
{
	throw
}
finally
{
	Pop-Location
}
