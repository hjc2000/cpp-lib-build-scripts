param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"
. $cpp_lib_build_scripts_path/ps-fun/import-fun.ps1
$source_path = "$repos_path/x265_git/source"
$build_path = "$source_path/build/"
$install_path = "$libs_path/x265/"
Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url https://gitee.com/Qianshunan/x265_git.git

	New-Empty-Dir $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DENABLE_SHARED=on `
		-DENABLE_PIC=on `
		-DENABLE_ASSEMBLY=off

	ninja -j12
	ninja install


	# 修复 .pc 文件内的路径
	Fix-PC-Config-PC-File "$install_path/lib/pkgconfig/x265.pc"
}
catch
{

}
finally
{
	Pop-Location
}