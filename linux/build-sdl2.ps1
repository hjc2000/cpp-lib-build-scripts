$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/SDL/"
$install_path = "$libs_path/sdl2/"
$build_path = "$source_path/jc_build/"
if (Test-Path -Path $install_path)
{
	Write-Host "$install_path 已存在，不编译，直接返回。如需编译，请先删除目录。"
	return 0
}

Push-Location $repos_path
try
{
	# 通过 apt-get 安装依赖
	Apt-Ensure-Packets -packets @(
		"libasound2-dev",
		"libpulse-dev"
	)

	get-git-repo.ps1 -git_url "https://github.com/libsdl-org/SDL.git" `
		-branch_name "SDL2"

	New-Empty-Dir $build_path
	Set-Location $build_path
	cmake -G "Ninja" $source_path `
		-DCMAKE_BUILD_TYPE=Release `
		-DCMAKE_INSTALL_PREFIX="$install_path" `
		-DSDL_SHARED=ON `
		-DSDL_STATIC=OFF
		
	ninja -j12
	ninja install
		
	Install-Lib -src_path $install_path -dst_path $total_install_path
}
finally
{
	Pop-Location
}
