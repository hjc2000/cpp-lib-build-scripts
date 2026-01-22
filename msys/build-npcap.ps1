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

	try-remove-items --paths "$source_path/lib/x64"
	try-remove-items --paths "$source_path/lib/ARM64"
	Copy-Item -Path $source_path -Destination $install_path -Force -Recurse

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
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

}
