$build_script_path = get-script-dir.ps1
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/curl"
$install_path = "$libs_path/curl"
$build_path = "$source_path/jc_build"

if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Clear-Host
Push-Location $repos_path

try
{
	& "$build_script_path/build-zlib.ps1"
	& "$build_script_path/build-libiconv.ps1"
	& "$build_script_path/build-openssl.ps1"
	& "$build_script_path/build-libssh2.ps1"

	pacman-ensure-packages @(
		"mingw-w64-ucrt-x86_64-icu"
		"mingw-w64-ucrt-x86_64-libpsl"
	)

	git-get-repo.ps1 -git_url "https://github.com/curl/curl.git"

	New-Empty-Dir $build_path
	Set-Location $build_path

	cmake -G "Ninja" $source_path `
		-DCMAKE_C_COMPILER="clang" `
		-DCMAKE_CXX_COMPILER="clang++" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DBUILD_SHARED_LIBS=ON `
		-DCURL_USE_OPENSSL=ON

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

}
