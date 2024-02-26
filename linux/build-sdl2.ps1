param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

# 通过 apt 安装依赖
$dependent_libs = @(
	"libasound2-dev",
	"libpulse-dev"
)
foreach ($lib in $dependent_libs)
{
	sudo apt install $lib
}

Push-Location $repos_path
git clone https://gitee.com/mycn027b/SDL.git --branch release-2.30.x
$source_path = "${repos_path}/SDL/"
$build_path = "$source_path/build/"
$install_path = "$libs_path/SDL2/"

# 创建构建目录
New-Item -Path $build_path -ItemType Directory -Force

Set-Location $build_path
cmake -G "Ninja" $source_path `
	-DCMAKE_BUILD_TYPE=Release `
	-DCMAKE_INSTALL_PREFIX="$install_path"

ninja -j12
ninja install

# 将头文件移出来，不然它是处于 include/SDL2/ 内
Move-Item -Path ${install_path}/include/SDL2/* `
	-Destination ${install_path}/include/ `
	-Force
Remove-Item ${install_path}/include/SDL2/
Pop-Location