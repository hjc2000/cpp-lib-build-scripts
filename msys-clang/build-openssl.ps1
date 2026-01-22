Push-Location

try
{
	$build_script_path = get-script-dir.ps1
	. $build_script_path/../.base-script/prepare-for-building.ps1
	. $build_script_path/prepare.ps1

	$source_path = "$repos_path/openssl/openssl-3.3.0-beta1"
	$install_path = "$libs_path/openssl"

	if (Test-Path -Path $install_path)
	{
		Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
		return 0
	}

	Clear-Host
	Set-Location $repos_path

	wget-repo.ps1 -workspace_dir $repos_path `
		-repo_url "https://www.openssl.org/source/openssl-3.3.0-beta1.tar.gz" `
		-out_dir_name "openssl"

	run-bash-cmd.ps1 @"
	cd $(cygpath.exe $source_path)

	./Configure shared \
	--prefix="$(cygpath.exe $install_path)"

	make clean
	make -j12
	make install
"@

	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	# openssl 的 pc 文件没有使用 prefix，这会导致库无法移动，因为路径都是写死的。
	# 使用了 prefix 后，pkg-config 会对路径的符合 prefix 的部分进行替换。
	$pc_files = Get-ChildItem -Path $install_path/lib64/pkgconfig/*.pc -Recurse
	foreach ($pc_file in $pc_files)
	{
		$prefix = "prefix=$(cygpath.exe $install_path)"
		$content = Get-Content -Path "$($pc_file.FullName)"

		$prefix | Set-Content -Path "$($pc_file.FullName)"
		$content | Add-Content -Path "$($pc_file.FullName)"
	}

	Copy-Item -Path $install_path/lib64 -Destination $install_path/lib -Force -Recurse

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
