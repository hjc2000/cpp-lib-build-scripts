$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/x265_git/source"
$install_path = "$libs_path/x265/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url https://gitee.com/Qianshunan/x265_git.git

	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_INSTALL_PREFIX="${install_path}" `
		-DENABLE_SHARED=on `
		-DENABLE_PIC=on `
		-DENABLE_ASSEMBLY=off

	ninja -j12
	ninja install
		
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}