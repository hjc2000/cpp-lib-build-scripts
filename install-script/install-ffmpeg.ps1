if (-not $env:install)
{
	throw "不存在环境变量 install。"
}

if (is-msys.ps1)
{
	install-lib.ps1 -src_path "$env:libs_path/ffmpeg" -dst_path $env:install
	install-lib.ps1 -src_path "$env:libs_path/x264" -dst_path $env:install
	install-lib.ps1 -src_path "$env:libs_path/x265" -dst_path $env:install
	install-lib.ps1 -src_path "$env:libs_path/SDL2" -dst_path $env:install
	install-lib.ps1 -src_path "$env:libs_path/openssl" -dst_path $env:install
}
else
{
	install-lib.ps1 -src_path "$env:libs_path/ffmpeg" -dst_path "/usr/"
	install-lib.ps1 -src_path "$env:libs_path/x264" -dst_path "/usr/"
	install-lib.ps1 -src_path "$env:libs_path/x265" -dst_path "/usr/"
	install-lib.ps1 -src_path "$env:libs_path/SDL2" -dst_path "/usr/"
	install-lib.ps1 -src_path "$env:libs_path/openssl" -dst_path "/usr/"
}