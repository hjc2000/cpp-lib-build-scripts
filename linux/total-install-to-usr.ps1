$ErrorActionPreference = "Stop"
$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

Push-Location
try
{
	& $build_script_path/total-install.ps1
	
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