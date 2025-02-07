$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/npcap"
$install_path = "$libs_path/npcap"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	<#
	可以从 https://download.qt.io/development_releases/prebuilt/libclang/qt/ 中选择一个链接进行下载，
	然后在浏览器的下载列表中获取下载链接。
	#>
	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://npcap.com/dist/npcap-sdk-1.13.zip" `
		-out_dir_name "npcap"

	try
	{
		Rename-Item -Path "$source_path/Lib" -NewName "$source_path/lib"
	}
	catch
	{

	}

	try
	{
		Move-Item -Path "$source_path/lib/x64/*" -Destination "$source_path/lib" -Force
	}
	catch
	{

	}

	try-remove-items.exe --paths "$source_path/lib/x64"
	try-remove-items.exe --paths "$source_path/lib/ARM64"
	Copy-Item -Path $source_path -Destination $install_path -Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
}
finally
{
	Pop-Location
}
