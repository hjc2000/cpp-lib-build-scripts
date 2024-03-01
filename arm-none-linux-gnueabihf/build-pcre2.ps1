$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/pcre2/"
$install_path = "$libs_path/pcre2/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url https://github.com/PCRE2Project/pcre2.git

	New-Empty-Dir $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)

	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)
"@

	# 切换到 build 目录开始构建
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DBUILD_SHARED_LIBS=ON

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