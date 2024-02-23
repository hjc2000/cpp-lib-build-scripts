param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location $repos_path
wget-repo.ps1 -workspace_dir $repos_path `
	-repo_url https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.gz `
	-out_dir_name xz
$source_path = "$repos_path/xz/xz-5.4.6"
$build_path = "$source_path/build"
$install_path = "$libs_path/xz/"
New-Item -ItemType Directory -Path $build_path -Force
Remove-Item "$build_path/*" -Recurse -Force
Set-Location $build_path

cmake -G "Ninja" $source_path `
	-DCMAKE_INSTALL_PREFIX="${install_path}"

ninja -j12
ninja install

# 修复 .pc 文件内的路径
update-pc-prefix.ps1 "${install_path}/lib/pkgconfig/liblzma.pc"
Get-Content "${install_path}/lib/pkgconfig/liblzma.pc"