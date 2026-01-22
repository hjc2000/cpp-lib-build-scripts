$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1

Push-Location

try
{
	Apt-Ensure-Packets @("stow")
	New-Item -Path $total_install_path -ItemType Directory -Force

	# 使用Get-ChildItem获取所有子目录，-Directory参数确保只获取目录
	$libs = Get-ChildItem -Path $libs_path -Directory
	foreach ($lib in $libs)
	{
		Install-Lib -src_path $lib -dst_path $total_install_path
	}

	Write-Host "正在 stow 安装到 $HOME/install"
	Set-Location $build_script_path
	stow -t "$HOME/install" $(Split-Path $total_install_path -Leaf)
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
