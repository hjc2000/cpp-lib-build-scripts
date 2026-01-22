$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/aspnetcore-8.0.2/"
$install_path = "$libs_path/aspnetcore-8.0.2/"

Push-Location $repos_path
try
{
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://download.visualstudio.microsoft.com/download/pr/272dbea2-057e-4032-9857-7e00b476ceec/3c472df94b1c3f5e0d009cbccc9256a6/aspnetcore-runtime-8.0.2-linux-arm.tar.gz" `
		-out_dir_name "aspnetcore-8.0.2"

	# 准备好安装目录
	New-Item -Path "$install_path/bin" -ItemType Directory -Force

	# 将头文件复制到安装目录
	Copy-Item -Path "$source_path/*" `
		-Destination "$install_path/bin" `
		-Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{

}
