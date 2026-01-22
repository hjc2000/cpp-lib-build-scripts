$ErrorActionPreference = "Stop"
Push-Location

try
{
	# 需要执行一下，设置msys环境变量，这样 pkg-config 才能识别出这是 msys ucrt64
	# 环境，这样才能找得到库。
	run-bash-cmd.ps1 "true"

	$env:Path = "C:\msys64\usr\bin\core_perl;" + $env:Path
	$env:CMAKE_PREFIX_PATH = "$total_install_path;C:/msys64/ucrt64/lib;C:/msys64/ucrt64"
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
