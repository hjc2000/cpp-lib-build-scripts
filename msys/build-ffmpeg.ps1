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
	Build-Dependency "build-amf.ps1"
	Build-Dependency "build-xz.ps1"
	Build-Dependency "build-zlib.ps1"
	Build-Dependency "build-bzip2.ps1"
	Build-Dependency "build-libiconv.ps1"
	Build-Dependency "build-webp.ps1"
	Build-Dependency "build-srt.ps1"
	Build-Dependency "build-librist.ps1"
	Build-Dependency "build-speex.ps1"
	Build-Dependency "build-openjpeg.ps1"

	
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"

	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)

	./configure \
	--prefix="$(cygpath.exe $install_path)" \
	--extra-cflags="-DAMF_CORE_STATICTIC" \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libwebp \
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

	Install-Msys-Dlls @(
		"/ucrt64/bin/libgcc_s_seh-1.dll",
		"/ucrt64/bin/libstdc++-6.dll",
		"/ucrt64/bin/libwinpthread-1.dll"
	)
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/x264/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/x265/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/openssl/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/sdl2/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/xz/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/zlib/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/bzip2/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/libiconv/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/webp/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/srt/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/librist/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/speex/bin"
	Install-Dependent-Dlls-From-Dir -dll_dir "$libs_path/openjpeg/bin"

	Fix-Pck-Config-Pc-Path
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe "/ucrt64" -w)

	ldd $install_path/bin/ffmpeg.exe
}
finally
{
	Pop-Location
}
