$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/aspnetcore-8.0.2/"
$install_path = "$libs_path/aspnetcore-8.0.2/"

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-8.0.2-linux-arm32-binaries" `
		-out_dir_name "aspnetcore-8.0.2"

	# # 准备好安装目录
	# $amf_include_install_path = "$install_path/include/AMF/"
	# New-Item -Path $amf_include_install_path -ItemType Directory -Force
	
	# # 将头文件复制到安装目录
	# Copy-Item -Path "$source_path/amf/public/include/*" `
	# 	-Destination $amf_include_install_path `
	# 	-Force -Recurse

	# Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
