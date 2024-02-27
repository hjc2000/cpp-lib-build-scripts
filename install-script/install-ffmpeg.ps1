$libs_to_install = @(
	"ffmpeg",
	"x264",
	"x265"
	"SDL2",
	"openssl"
)
if (is-msys.ps1)
{
	if (-not $env:install)
	{
		throw "不存在环境变量 install。"
	}
	
	foreach ($lib in $libs_to_install)
	{
		install-lib.ps1 -src_path "$env:libs_path/$lib" -dst_path $env:install
	}
}
else
{
	foreach ($lib in $libs_to_install)
	{
		install-lib.ps1 -src_path "$env:libs_path/$lib" -dst_path "/usr/"
	}
}