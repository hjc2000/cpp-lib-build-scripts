param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location ${repos_path}
get-git-repo.ps1 https://github.com/libsdl-org/SDL.git release-2.30.x

# 创建构建目录
New-Item -ItemType Directory -Path "${repos_path}/SDL/build/" -Force
Set-Location "${repos_path}/SDL/build/"

$install_path = "$libs_path/SDL2/"
cmake -G "Unix Makefiles" .. `
	-DCMAKE_BUILD_TYPE=Release `
	-DCMAKE_INSTALL_PREFIX="$install_path"

make -j12
make install

# 将头文件移出来，不然它是处于 include/SDL2/ 内
Move-Item -Path ${install_path}/include/SDL2/* `
	-Destination ${install_path}/include/ `
	-Force
Remove-Item ${install_path}/include/SDL2/