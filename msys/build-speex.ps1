$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

$source_path = "$repos_path/speex"
$install_path = "$libs_path/speex"
$build_path = "$source_path/jc_build"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	git-get-repo.ps1 -git_url "https://gitlab.xiph.org/xiph/speex.git"

	New-Empty-Dir -Path $build_path

	New-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = 'gcc'
	cpp = 'g++'
	ar = 'ar'
	ld = 'ld'
	strip = 'strip'
	pkg-config = 'pkg-config'
"@

	Set-Location $source_path

	meson setup jc_build/ `
		--cross-file="$build_path/cross_file.ini" `
		--prefix="$install_path"

	if ($LASTEXITCODE)
	{
		throw "$source_path 配置失败"
	}

	Set-Location $build_path
	ninja -j12
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	ninja install
	Install-Lib -src_path $install_path -dst_path $total_install_path
	Install-Lib -src_path $install_path -dst_path $(cygpath.exe /ucrt64 -w)
}
finally
{
	Pop-Location
}
