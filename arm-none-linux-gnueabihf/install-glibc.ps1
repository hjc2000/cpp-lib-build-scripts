$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-linux-gnueabihf/"
$install_path = "$libs_path/glibc/"

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz" `
		-out_dir_name "arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-linux-gnueabihf"

	# # 准备好安装目录
	# New-Item -Path "$install_path/bin" -ItemType Directory -Force
	
	# # 将头文件复制到安装目录
	# Copy-Item -Path "$source_path/*" `
	# 	-Destination "$install_path/bin" `
	# 	-Force -Recurse

	# Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
