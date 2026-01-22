$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/prepare.ps1

	$source_path = "$repos_path/fftw/fftw-3.3.10"
	$install_path = "$libs_path/fftw"
	$build_path = "$source_path/jc_build"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://fftw.org/fftw-3.3.10.tar.gz" `
		-out_dir_name "fftw"

	New-Empty-Dir $build_path
	Set-Location $build_path

	cmake -G "Ninja" $source_path `
		-DCMAKE_C_COMPILER="clang" `
		-DCMAKE_CXX_COMPILER="clang++" `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path"

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
	Pop-Location
}
