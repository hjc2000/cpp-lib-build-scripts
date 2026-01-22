$ErrorActionPreference = "Stop"
Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1

	$source_path = "$repos_path/openssl"
	$install_path = "$libs_path/openssl"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Set-Location $repos_path

	git-get-repo.ps1 -git_url "https://gitee.com/hughpenn23/openssl.git"

	run-bash-cmd.ps1 @"
	set -e
	cd $source_path

	./Configure shared \
	--prefix="$install_path"

	make -j12
	make install
"@

	Copy-Item -Path $install_path/lib64 -Destination $install_path/lib -Force -Recurse
	Install-Lib -src_path $install_path -dst_path $total_install_path
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
