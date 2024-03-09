$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/FFmpeg/"
$install_path = "$libs_path/ffmpeg/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	# 构建依赖项
	Build-Dependency "build-x264.ps1"
	Build-Dependency "build-x265.ps1"
	Build-Dependency "build-openssl.ps1"
	Build-Dependency "build-sdl2.ps1"

	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"

	run-bash-cmd.ps1 @"
	cd $source_path

	./configure \
	--prefix="$install_path" \
	--enable-sdl \
	--enable-libx264 \
	--enable-libx265 \
	--enable-openssl \
	--enable-version3 \
	--enable-pic \
	--enable-gpl \
	--enable-shared \
	--disable-static

	make clean
	make -j12
	make install
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
