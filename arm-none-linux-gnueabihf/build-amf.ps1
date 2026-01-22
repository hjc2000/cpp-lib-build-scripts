$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/../.base-script/prepare-for-cross-building.ps1

	$source_path = "$repos_path/AMF_1/"
	$install_path = "$libs_path/amf/"

	Set-Location $repos_path

	git-get-repo.ps1 -git_url https://gitee.com/mirrors_GPUOpen-LibrariesAndSDKs/AMF_1.git

	# 准备好安装目录
	$amf_include_install_path = "$install_path/include/AMF/"
	New-Item -Path $amf_include_install_path -ItemType Directory -Force

	# 将头文件复制到安装目录
	Copy-Item -Path "$source_path/amf/public/include/*" `
		-Destination $amf_include_install_path `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
catch
{
	throw "
		$(get-script-position.ps1)
		$(${PSItem}.Exception.Message)
	"
}
finally
{
	Pop-Location
}
