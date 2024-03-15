# 准备好一个空的文件夹。如果文件夹本来就存在且里面有东西，则会删除所有内容
function New-Empty-Dir
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	
	# 创建 build 目录
	New-Item -Path $Path -ItemType Directory -Force | Out-Null
	Remove-Item "$Path/*" -Recurse -Force
}



function Create-Text-File
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$Path,
		[Parameter(Mandatory = $true)]
		[string]$Content
	)
	
	# 创建文件 toolchain.cmake
	New-Item -Path $Path -ItemType File -Force | Out-Null
	$Content | Out-File -FilePath $Path -Encoding UTF8	
}


# 安装一个库。
# 所谓的库，就是内含 lib, bin, include 等目录的一个目录。
# 安装就是将库的这些目录复制到指定的位置。在 linux 中复制时会保留符号链接。
function Install-Lib
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$src_path, # 库的路径

		[Parameter(Mandatory = $true)]
		[string]$dst_path, # 要将库安装到哪里

		[switch]$sudo # 是否用 sudo 执行复制。只有在 linux 中才有效。
	)
	$ErrorActionPreference = "Stop"

	Write-Host "将 $src_path 安装到 $dst_path"

	New-Item -Path $dst_path/bin/ -ItemType Directory -Force | Out-Null
	New-Item -Path $dst_path/lib/ -ItemType Directory -Force | Out-Null
	New-Item -Path $dst_path/include/ -ItemType Directory -Force | Out-Null
	New-Item -Path $dst_path/share/ -ItemType Directory -Force | Out-Null

	if ($IsWindows)
	{
		Copy-Item -Path "$src_path/*" -Destination "$dst_path/" -Force -Recurse
	}
	else
	{
		# linux 平台
		$copy_cmd = "cp -a"
		if ($sudo)
		{
			$copy_cmd = "sudo cp -a"
		}

		run-bash-cmd.ps1 @"
		set -e
		$copy_cmd $src_path/* $dst_path/
"@
	}
}


function Apt-Ensure-Packets
{
	param (
		[Parameter(Mandatory = $true)]
		[array]$packets
	)
		
	if (-not $IsLinux)
	{
		return
	}

	Push-Location
	try
	{
		foreach ($packet in $packets)
		{
			# 检查包是否已安装
			$installed = $(dpkg -l | grep "$packet")
			if (-not $installed)
			{
				# 如果此包没安装，使用 apt-get 安装。
				sudo apt-get install $packet -y
			}
		}		
	}
	catch
	{
		throw
	}
	finally
	{
		Pop-Location	
	}
}

function Total-Install
{
	& $build_script_path/total-install.ps1
}



function Get-Cmake-Set-Find-Lib-Path-String
{
	return @"
	set(CMAKE_EXE_LINKER_FLAGS 		"-Wl,-rpath-link,$total_install_path/lib:$total_install_path/usr/lib ${CMAKE_EXE_LINKER_FLAGS}" 	CACHE STRING "Linker flags for executables" 		FORCE)
	set(CMAKE_SHARED_LINKER_FLAGS 	"-Wl,-rpath-link,$total_install_path/lib:$total_install_path/usr/lib ${CMAKE_SHARED_LINKER_FLAGS}" 	CACHE STRING "Linker flags for shared libraries"	FORCE)

	# 指定查找程序、库、头文件时的根路径，防止在默认系统路径中查找
	set(CMAKE_FIND_ROOT_PATH "$total_install_path")
	# 设置查找路径的模式，确保仅在指定的根路径中查找
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
	set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

	include_directories(BEFORE "$total_install_path/include")
	link_directories(BEFORE "$total_install_path/lib")
"@
}

function New-Meson-Cross-File
{
	param (
		[string]$arch = "armv7-a",
		[string]$toolchain_prefix = "arm-none-linux-gnueabihf-",
		[string]$pkg_config_libdir = "",
		[string]$link_flags = "['-L$total_install_path/lib', '-Wl,-rpath-link,$total_install_path/lib:$total_install_path/usr/lib',]",
		[string]$c_std = "",
		[string]$cpp_std = ""
	)
	
	# meson 的
	#
	# [properties]
	# pkg_config_libdir = '$env:PKG_CONFIG_PATH'
	#
	# 会在调用 pkg-config 时传入 PKG_CONFIG_LIBDIR 环境变量，并设置为 pkg_config_libdir
	# 的值，这可以让 pkg-config 的默认查找目录，例如 /usr/lib/pkgconfig 被覆盖，从而在交叉
	# 编译时不会使用宿主机的库。
	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = '${toolchain_prefix}gcc'
	cpp = '${toolchain_prefix}g++'
	ar = '${toolchain_prefix}ar'
	ld = '${toolchain_prefix}ld'
	strip = '${toolchain_prefix}strip'
	pkg-config = 'pkg-config'

	[properties]
	pkg_config_libdir = '$($pkg_config_libdir ? $pkg_config_libdir : "$total_install_path/lib/pkgconfig")'

	[host_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = '$arch'
	endian = 'little'

	[target_machine]
	system = 'linux'
	cpu_family = 'arm'
	cpu = '$arch'
	endian = 'little'

	[built-in options]
	c_args = 	['-march=$arch', '-I$total_install_path/include', $($c_std ? "'-std=$c_std'," : "")]
	cpp_args = 	['-march=$arch', '-I$total_install_path/include', $($cpp_std ? "'-std=$cpp_std'," : "")]
	c_link_args = $link_flags
	cpp_link_args = $link_flags
"@
}

function Build-Dependency
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$script_name
	)

	# 启用另一个进程，不要让依赖项的构建脚本破坏当前环境的环境变量
	@"
	$build_script_path/$script_name
"@ | pwsh

	if ($LASTEXITCODE)
	{
		throw "$script_name 执行失败"
	}
}

function Fix-Pck-Config-Pc-Path
{
	try
	{
		$pc_files = Get-ChildItem -Path "$install_path/lib/pkgconfig/*.pc" -File -Recurse
		foreach ($pc_file in $pc_files)
		{
			cygpath-pkg-config-pc-path.exe $pc_file.FullName
		}
	}
	catch
	{
		Write-Host "cygpath-pkg-config-pc-path 失败。"
	}
}

# 从指定路径安装依赖的 dll 到自己的 $install_path 中。
# 会收集指定目录下的 dll 然后安装。收集过程是不递归的。
function Install-Dependent-Dlls-From-Dir
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$dll_dir	# dll 所在的路径。将从这里以非递归的方式收集 dll 文件。
	)
	
	$dlls = Get-ChildItem -Path "$dll_dir/*.dll" -File
	foreach ($dll in $dlls)
	{
		Copy-Item -Path $dll.FullName -Destination "$install_path/bin/" -Force
	}
}

function Install-Msys-Dlls
{
	param (
		[Parameter(Mandatory = $true)]
		[array]$msys_dlls	# msys 的 dll 的路径。需要使用 msys 的路径，而不是 windows 路径。
	)
	
	foreach ($msys_dll in $msys_dlls)
	{
		Copy-Item -Path $(cygpath.exe $msys_dll -w) `
			-Destination "$install_path/bin/" `
			-Force
	}
}