$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../base-script/prepare-for-building.ps1

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
}
catch
{

}
finally
{
	Pop-Location
}