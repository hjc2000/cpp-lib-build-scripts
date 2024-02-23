param (
	[string]$libs_path = $env:libs_path,
	[string]$repos_path = $env:repos_path,
	[string]$cpp_lib_build_scripts_path = $env:cpp_lib_build_scripts_path
)
$ErrorActionPreference = "Stop"

Set-Location $repos_path
wget-repo.ps1 -workspace_dir $repos_path `
	-repo_url https://github.com/tsduck/tsduck/archive/refs/tags/v3.36-3528.tar.gz `
	-out_dir_name tsduck
$source_path = "$repos_path/tsduck/tsduck-3.36-3528/src/libtsduck"
$install_path = "$libs_path/tsduck"
Set-Location $source_path

make clean
make -j12 `
	CXX="g++" `
	CC="gcc" `
	GCC="gcc" `
	LD="ld" `
	AR="ar" `
	NOGITHUB=1 NOVATEK=1 NOTEST=1 `
	NODEKTEC=1 NOHIDES=1 NOCURL=1 `
	NOEDITLINE=1 NOSRT=1 NORIST=1
make install SYSPREFIX=${install_path}
