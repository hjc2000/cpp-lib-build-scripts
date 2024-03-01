$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/dbus/"
$install_path = "$libs_path/dbus/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	& $build_script_path/build-libexpat.ps1
	Clear-Pkg-Config-Path
	Append-Pkg-Config-Path-Recurse -Path "$libs_path/libexpat"

	Set-Location $repos_path
	get-git-repo.ps1 -git_url https://gitlab.freedesktop.org/dbus/dbus.git `
		-branch_name dbus-1.14

	New-Empty-Dir $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)
	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)
"@

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DDBUS_SESSION_SOCKET_DIR="/tmp" `
		-DDBUS_WITH_GLIB=OFF

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
