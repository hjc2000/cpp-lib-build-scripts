$ErrorActionPreference = "Stop"

# 本项目的根路径，也即 cpp-lib-build-scripts 这个目录的路径
$project_root_path = "$build_script_path/../"

$repos_path = "$build_script_path/.repos"
$libs_path = "$build_script_path/.libs"
$total_install_path = "$build_script_path/.total-install"

$env:PKG_CONFIG_PATH = "$total_install_path/lib/pkgconfig"

$default_pkg_config_libdir = "/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig"
$override_pkg_config_libdir = $env:PKG_CONFIG_PATH
$env:PKG_CONFIG_LIBDIR = $override_pkg_config_libdir

$env:LIBRARY_PATH = "$total_install_path/lib/"

New-Item -Path $repos_path -ItemType Directory -Force | Out-Null
New-Item -Path $libs_path -ItemType Directory -Force | Out-Null
New-Item -Path $total_install_path -ItemType Directory -Force | Out-Null

. $project_root_path/.base-script/import-functions.ps1
