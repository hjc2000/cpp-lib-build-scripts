$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/poco"
$install_path = "$libs_path/poco"
$build_path = "$source_path/jc_build"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	& "$build_script_path/build-zlib.ps1"

	Pacman-Ensure-Packages @(
		"mingw-w64-ucrt-x86_64-libutf8proc"
		"mingw-w64-ucrt-x86_64-pcre2"
	)

	git-get-repo.ps1 -git_url "https://github.com/pocoproject/poco.git"

	New-Empty-Dir -Path $build_path
	Set-Location $build_path

	cmake -G "Ninja" $source_path `
		-DCMAKE_C_COMPILER="gcc" `
		-DCMAKE_CXX_COMPILER="g++" `
		-DCMAKE_C_STANDARD=17 `
		-DCMAKE_CXX_STANDARD=20 `
		-DCMAKE_MC_COMPILER="C:\msys64\ucrt64\bin\windmc.exe" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DPOCO_UNBUNDLED=ON

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}

	ninja -j12 -v
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install
	# Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
