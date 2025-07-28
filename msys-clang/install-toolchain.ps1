$build_script_path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. $build_script_path/../.base-script/prepare-for-building.ps1
. $build_script_path/prepare.ps1

pacman-ensure-packages @(
	"lua"
	"llvm"
	"mingw-w64-ucrt-x86_64-toolchain"
	"mingw-w64-ucrt-x86_64-nasm"
	"mingw-w64-ucrt-x86_64-yasm"
	"make"
	"autotools"
	"mingw-w64-ucrt-x86_64-7zip"
	"texinfo"
	"libtool"
	"mingw-w64-ucrt-x86_64-llvm"
	"mingw-w64-ucrt-x86_64-lld"
	"mingw-w64-ucrt-x86_64-clang"
	"mingw-w64-ucrt-x86_64-clang-libs"
)

python -m pip install --upgrade pip
pip install meson
