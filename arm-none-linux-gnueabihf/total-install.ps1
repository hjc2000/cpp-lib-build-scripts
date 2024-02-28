$ErrorActionPreference = "Stop"

Push-Location
try
{
	$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
	. $build_script_path/../base-script/import-functions.ps1

	New-Item -Path "$build_script_path/.total-install/" -ItemType Directory -Force

	# 使用Get-ChildItem获取所有子目录，-Directory参数确保只获取目录
	$libs = Get-ChildItem -Path $build_script_path/.libs/ -Directory
	foreach ($lib in $libs)
	{
		Install-Lib -src_path $lib -dst_path $build_script_path/.total-install/
	}
}
catch
{
	throw
}
finally
{
	Pop-Location
}
