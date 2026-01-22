$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# 本项目的根路径，也即 cpp-lib-build-scripts 这个目录的路径
$build_script_path = $build_script_path.Replace("\", "/")
$project_root_path = "$build_script_path/../"

$repos_path = "$build_script_path/.repos"
$libs_path = "$build_script_path/.libs"
$total_install_path = "$build_script_path/.total-install"

# 设置环境变量
$env:PKG_CONFIG_PATH = "$total_install_path/lib/pkgconfig"
$env:LIBRARY_PATH = "$total_install_path/lib/"
$env:CMAKE_PREFIX_PATH = $total_install_path

New-Item -Path $repos_path -ItemType Directory -Force | Out-Null
New-Item -Path $libs_path -ItemType Directory -Force | Out-Null
New-Item -Path $total_install_path -ItemType Directory -Force | Out-Null

. $project_root_path/.base-script/import-functions.ps1
