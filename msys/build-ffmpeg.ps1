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

	
	Set-Location $repos_path
	get-git-repo.ps1 -git_url "https://github.com/FFmpeg/FFmpeg.git"

	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)

	./configure \
	--prefix="$(cygpath.exe $install_path)" \
	--extra-cflags="-I$(cygpath.exe $libs_path)/amf/include/ -DAMF_CORE_STATICTIC" \
	--enable-libx264 \
	--enable-libx265 \
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

	# 将 msys2 中的 dll 复制到安装目录
	# 可以用 ldd ffmpeg.exe | grep ucrt64 命令来查看有哪些依赖是来自 ucrt64 的
	$msys_dlls = @(
		"/ucrt64/bin/libgcc_s_seh-1.dll",
		"/ucrt64/bin/libbz2-1.dll",
		"/ucrt64/bin/libiconv-2.dll",
		"/ucrt64/bin/liblzma-5.dll",
		"/ucrt64/bin/libstdc++-6.dll",
		"/ucrt64/bin/libwinpthread-1.dll",
		"/ucrt64/bin/zlib1.dll"
	)
	Write-Host "正在复制 msys2 中的 dll 到 安装目录/bin"
	foreach ($msys_dll in $msys_dlls)
	{
		Copy-Item -Path $(cygpath.exe $msys_dll -w) `
			-Destination "$install_path/bin/" `
			-Force
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
