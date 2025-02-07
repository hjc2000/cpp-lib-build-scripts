$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

Pacman-Ensure-Packages @(
	"lua"
	"llvm"
	# "mingw-w64-ucrt-x86_64-toolchain"
	"mingw-w64-ucrt-x86_64-nasm"
	"mingw-w64-ucrt-x86_64-yasm"
	"make"
	"autotools"
	"mingw-w64-ucrt-x86_64-7zip"
	"texinfo"
	"libtool"
)

python -m pip install --upgrade pip
pip install meson
