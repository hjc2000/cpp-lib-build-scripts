param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"
. $cpp_lib_build_scripts_path/ps-fun/import-fun.ps1
$source_path = "$repos_path/xz/"
$install_path = "$libs_path/xz/"
$build_path = "$source_path/build"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url https://github.com/tukaani-project/xz.git `
		-branch_name v5.6

	Prepare-And-CD-CMake-Build-Dir $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DBUILD_SHARED_LIBS=ON

	ninja -j12
	ninja install

	# 修复 .pc 文件内的路径
	update-pc-prefix.ps1 "${install_path}/lib/pkgconfig/liblzma.pc"
}
catch
{
	<#Do this if a terminating exception happens#>
}
finally
{
	Pop-Location
}