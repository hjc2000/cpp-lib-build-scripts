param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Push-Location $repos_path
wget-repo.ps1 -workspace_dir $repos_path `
	-repo_url https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.gz `
	-out_dir_name xz
$source_path = "$repos_path/xz/xz-5.4.6"
$build_path = "$source_path/build"
$install_path = "$libs_path/xz/"

New-Item -ItemType Directory -Path $build_path -Force
Remove-Item "$build_path/*" -Recurse -Force

# 创建文件 toolchain.cmake
New-Item -ItemType File -Path "$build_path/toolchain.cmake" -Force
$toolchain_file_content = @"
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x64)
set(CMAKE_RC_COMPILER llvm-rc)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
"@
$toolchain_file_content | Out-File -FilePath "$build_path/toolchain.cmake" -Encoding UTF8

Set-Location $build_path
cmake -G "Ninja" $source_path `
	-DCMAKE_TOOLCHAIN_FILE="$build_path/toolchain.cmake" `
	-DCMAKE_BUILD_TYPE=Release `
	-DCMAKE_INSTALL_PREFIX="${install_path}"

ninja -j12
ninja install

# 修复 .pc 文件内的路径
update-pc-prefix.ps1 "${install_path}/lib/pkgconfig/liblzma.pc"
Pop-Location