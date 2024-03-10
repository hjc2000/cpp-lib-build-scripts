$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/../.base-script/prepare-for-cross-building.ps1

$source_path = "$repos_path/openssh-portable/"
$install_path = "$libs_path/ssh"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	Build-Dependency "build-openssl.ps1"
	Build-Dependency "build-zlib.ps1"

	get-git-repo.ps1 -git_url "https://github.com/openssh/openssh-portable.git"
	Set-Location $source_path
	Auto-Make

	# 执行命令进行构建
	run-bash-cmd.ps1 @"
	cd $source_path
	
	./configure \
	--prefix="" \
	--host=arm-none-linux-gnueabihf \
	--with-zlib="$total_install_path" \
	--with-ssl-dir="$total_install_path"

	make clean
	make -j12
	sudo $(which make) install
"@
	if ($LASTEXITCODE)
	{
		throw "$source_path 编译失败"
	}

	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
