$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

$source_path = "$repos_path/SDL/"
$install_path = "$libs_path/SDL2/"
$build_path = "$source_path/build/"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url https://github.com/libsdl-org/SDL.git `
		-branch_name release-2.30.x


	New-Empty-Dir $build_path
	Create-Text-File -Path "$build_path/toolchain.cmake" `
		-Content @"
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x64)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_RC_COMPILER llvm-rc)
"@

	cmake -G "Ninja" $source_path `
		-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DSDL_SHARED=ON `
		-DSDL_STATIC=OFF

	ninja -j12
	ninja install

	# 修复 .pc 文件内的路径
	Fix-PC-Config-PC-File "${install_path}/lib/pkgconfig/sdl2.pc"

	# 将头文件移出来，不然它是处于 include/SDL2/ 内
	Move-Item -Path "${install_path}/include/SDL2/*" `
		-Destination "${install_path}/include/" `
		-Force
	Remove-Item "${install_path}/include/SDL2/"
}
catch
{
	<#Do this if a terminating exception happens#>
}
finally
{
	Pop-Location
}
