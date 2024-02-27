# 将环境变量 libs 目录中的库安装到特定的目录。
# 安装到的目录取决于系统。在 windows 中，安装到 $env:install，
# 在 linux 中，安装到 /usr/
$libs_to_install = @(
	"ffmpeg", "x264", "x265", "SDL2", "openssl"
)
if ($IsWindows)
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
	# linux 平台
	foreach ($lib in $libs_to_install)
	{
		sudo pwsh -Command install-lib.ps1 -src_path "$env:libs_path/$lib" -dst_path "/usr/"
	}
}