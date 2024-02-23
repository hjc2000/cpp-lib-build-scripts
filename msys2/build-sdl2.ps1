param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location ${repos_path}
get-git-repo.ps1 -git_url https://github.com/libsdl-org/SDL.git `
	-branch_name release-2.30.x
$source_path = "${repos_path}/SDL/"
$build_path = "$source_path/build/"
$install_path = "$libs_path/SDL2/"
New-Item -ItemType Directory -Path $build_path -Force
Set-Location $build_path
Remove-Item -Path "$build_path/*" -Recurse -Force

# 创建文件 toolchain.cmake
New-Item -ItemType File -Path "$build_path/toolchain.cmake" -Force
$toolchain_file_content = @"
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x64)
set(CMAKE_RC_COMPILER llvm-rc)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
"@
$toolchain_file_content | Out-File -FilePath toolchain.cmake -Encoding UTF8

cmake -G "Ninja" $source_path `
	-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
	-DCMAKE_BUILD_TYPE=Release `
	-DCMAKE_INSTALL_PREFIX="$install_path" `
	-DSDL_SHARED=ON `
	-DSDL_STATIC=OFF

ninja -j12
ninja install

# 修复 .pc 文件内的路径
update-pc-prefix.ps1 "${install_path}/lib/pkgconfig/sdl2.pc"
Write-Host "`n`n`n========================================"
Write-Host "pc 文件的内容："
Get-Content "${install_path}/lib/pkgconfig/sdl2.pc"

# 将头文件移出来，不然它是处于 include/SDL2/ 内
Move-Item -Path "${install_path}/include/SDL2/*" `
	-Destination "${install_path}/include/" `
	-Force
Remove-Item "${install_path}/include/SDL2/"