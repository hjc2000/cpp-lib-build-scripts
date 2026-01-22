$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/prepare.ps1

	$source_path = "$repos_path/libpng"
	$install_path = "$libs_path/libpng"
	$build_path = "$source_path/jc_build"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	& "$build_script_path/build-zlib.ps1"

	git-get-repo.ps1 -git_url "https://github.com/pnggroup/libpng.git"

	New-Empty-Dir -Path $build_path
	Set-Location $build_path

	cmake -G "Ninja" $source_path `
		-DCMAKE_C_COMPILER="gcc" `
		-DCMAKE_CXX_COMPILER="g++" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DPNG_SHARED=ON `
		-DPNG_STATIC=OFF

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}

	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install

	# 有些 dll 存在于 lib 目录，需要复制到 bin 目录
	$lib_dlls = Get-ChildItem -Path $install_path/lib/*.dll -Recurse
	foreach ($dll in $lib_dlls)
	{
		Copy-Item -Path $dll.FullName -Destination $install_path/bin -Force
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
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
