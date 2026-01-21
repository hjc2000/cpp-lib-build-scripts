$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/di/include/boost"
$install_path = "$libs_path/boost"
if (Test-Path -Path "$install_path/include/boost/di")
{
	Write-Host "$install_path/include/boost/di 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url "https://github.com/boost-ext/di.git"

	# 不带星号是将 Path 的最后一级文件夹整个复制到目标路径。
	# 带了星号是将 Path 的最后一级文件夹的内容，不包括这个最后一级文件夹，给复制到目标路径。
	Copy-Item -Path $source_path/* `
		-Destination $install_path/include/boost `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
}
finally
{

}
