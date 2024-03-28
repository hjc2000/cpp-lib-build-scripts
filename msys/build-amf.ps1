$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-msys.ps1

$source_path = "$repos_path/AMF/"
$install_path = "$libs_path/amf/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	get-git-repo.ps1 -git_url "https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git"

	# 准备好安装目录
	$amf_include_install_path = "$install_path/include/AMF/"
	New-Item -Path $amf_include_install_path -ItemType Directory -Force
	
	# 将头文件复制到安装目录
	Copy-Item -Path "$source_path/amf/public/include/*" `
		-Destination $amf_include_install_path `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
	Auto-Ldd $install_path/bin
}
finally
{
	Pop-Location
}
