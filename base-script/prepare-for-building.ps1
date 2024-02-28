$ErrorActionPreference = "Stop"

. $build_script_path/../base-script/import-functions.ps1

$repos_path = "$build_script_path/.repos"
$libs_path = "$build_script_path/.libs"

New-Item -Path $repos_path -ItemType Directory -Force
New-Item -Path $libs_path -ItemType Directory -Force