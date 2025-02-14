$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

Push-Location
try
{
	New-Item -Path $total_install_path -ItemType Directory -Force

	# 使用Get-ChildItem获取所有子目录，-Directory 参数确保只获取目录
	$libs = Get-ChildItem -Path $libs_path -Directory
	foreach ($lib in $libs)
	{
		Install-Lib -src_path $lib -dst_path $total_install_path
	}
}
finally
{
	Pop-Location
}
