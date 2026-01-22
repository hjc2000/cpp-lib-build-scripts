$ErrorActionPreference = "Stop"
Push-Location

try
{
	../msys-clang/install-toolchain.ps1
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
