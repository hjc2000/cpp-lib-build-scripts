$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1

$source_path = "$repos_path/SDL/"
$install_path = "$libs_path/sdl2/"
$build_path = "$source_path/build/"
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

	# 将头文件移出来，不然它是处于 include/SDL2/ 内
	Move-Item -Path "$install_path/include/SDL2/*" `
		-Destination "$install_path/include/" `
		-Force
	Remove-Item "$install_path/include/SDL2/"
}
catch
{
	throw
}
finally
{
	Pop-Location
}
