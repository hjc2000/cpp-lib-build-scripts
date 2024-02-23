param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location $repos_path
get-git-repo.ps1 -git_url https://bitbucket.org/multicoreware/x265_git.git
$source_path = "$repos_path/x265_git/source"
$build_path = "$source_path/build/"
New-Item -ItemType Directory -Path $build_path -Force
Remove-Item "$build_path/*" -Recurse -Force
Set-Location $build_path

$install_path = "$libs_path/x265/"
cmake -G "Unix Makefiles" .. `
	-DCMAKE_INSTALL_PREFIX="${install_path}" `
	-DENABLE_SHARED=on `
	-DENABLE_PIC=on `
	-DENABLE_ASSEMBLY=off

make -j12
make install

# 修复 .pc 文件内的路径
update-pc-prefix.ps1 "${install_path}/lib/pkgconfig/x265.pc"
Get-Content "${install_path}/lib/pkgconfig/x265.pc"