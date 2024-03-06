$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/freetype/freetype-2.7"
$install_path = "$libs_path/freetype/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.gz" `
		-out_dir_name "freetype"

	New-Empty-Dir $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
	set(CROSS_COMPILE_ARM 1)
	set(CMAKE_SYSTEM_NAME Linux)
	set(CMAKE_SYSTEM_PROCESSOR armv7-a)

	set(CMAKE_C_COMPILER arm-none-linux-gnueabihf-gcc)
	set(CMAKE_CXX_COMPILER arm-none-linux-gnueabihf-g++)

	# set(CMAKE_PREFIX_PATH "$total_install_path")
	set(CMAKE_FIND_ROOT_PATH "$total_install_path")
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
	set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

	include_directories("$total_install_path/include")
	link_directories("$total_install_path/lib")
	link_libraries(

	)
"@
	

	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DBUILD_SHARED_LIBS=ON

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
