$ErrorActionPreference = "Stop"

. $build_script_path/../.base-script/import-functions.ps1

$repos_path = "$build_script_path/.repos"
$libs_path = "$build_script_path/.libs"
$total_install_path = "$build_script_path/.total-install"

New-Item -Path $repos_path -ItemType Directory -Force
New-Item -Path $libs_path -ItemType Directory -Force
New-Item -Path $total_install_path -ItemType Directory -Force