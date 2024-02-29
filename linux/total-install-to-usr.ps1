$ErrorActionPreference = "Stop"
$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

Push-Location
try
{
	Write-Host "首先安装到 .total-install"
	& $build_script_path/total-install.ps1

	Write-Host "接着安装到 /usr/"
	run-bash-cmd.ps1 @"
	sudo cp -a $build_script_path/.total-install/ /usr/
"@
}
catch
{
	throw
}
finally
{
	Pop-Location
}