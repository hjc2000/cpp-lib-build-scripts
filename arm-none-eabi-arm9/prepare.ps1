$ErrorActionPreference = "Stop"
Push-Location

try
{

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
