$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/FFmpeg"
$install_path = "$libs_path/ffmpeg"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	# 构建依赖项
	& "$build_script_path/build-x264.ps1"
	& "$build_script_path/build-x265.ps1"
	& "$build_script_path/build-xz.ps1"
	& "$build_script_path/build-openssl.ps1"
	& "$build_script_path/build-sdl2.ps1"
	& "$build_script_path/build-amf.ps1"
	& "$build_script_path/build-zlib.ps1"
	& "$build_script_path/build-bzip2.ps1"
	& "$build_script_path/build-libiconv.ps1"
	& "$build_script_path/build-srt.ps1"
	& "$build_script_path/build-librist.ps1"
	& "$build_script_path/build-speex.ps1"
	& "$build_script_path/build-openjpeg.ps1"

	Set-Location $repos_path
	git-get-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"

	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)

	./configure \
	--prefix="$(cygpath.exe $install_path)" \
	--extra-cflags="-DAMF_CORE_STATICTIC" \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libsrt \
	--enable-librist \
	--enable-libspeex \
	--enable-libopenjpeg \
	--enable-openssl \
	--enable-version3 \
	--enable-amf \
	--enable-pic \
	--enable-gpl \
	--enable-shared \
	--disable-static

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
}
finally
{
	Pop-Location
}
