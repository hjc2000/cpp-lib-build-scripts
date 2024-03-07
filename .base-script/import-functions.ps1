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


function Fix-PC-Config-PC-File
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$path_to_pc_file
	)
	
	# 检查文件是否存在
	if (-Not (Test-Path -Path $path_to_pc_file))
	{
		Write-Host "File not found: $path_to_pc_file"
		exit 1
	}
	
	# 读取prefix行并提取prefix路径
	$prefix_line = Get-Content $path_to_pc_file | Where-Object { $_ -match "^prefix=" }
	if (-not $prefix_line)
	{
		Write-Host "prefix line not found in file: $path_to_pc_file"
		exit 1
	}
	
	$old_prefix_path = $prefix_line -split "=" | Select-Object -Last 1
	
	# 使用 cygpath 转换旧的prefix路径
	$new_prefix_path = cygpath -u $old_prefix_path | Out-String | ForEach-Object { $_.Trim() }
	
	# 读取文件内容
	$content = Get-Content $path_to_pc_file -Raw
	
	# 替换文件中所有旧的prefix路径
	$new_content = $content -replace [regex]::Escape($old_prefix_path), $new_prefix_path
	
	# 保存修改后的文件内容
	$new_content | Set-Content $path_to_pc_file
	
	Write-Host "`n`n`n`n======================================================"
	Write-Host "Updated prefix in $path_to_pc_file to $new_prefix_path"
	Get-Content $path_to_pc_file
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
		if (Test-Path "$src_path/bin/")
		{
			Copy-Item -Path "$src_path/bin/*" -Destination "$dst_path/bin/" -Force -Recurse
		}

		if (Test-Path "$src_path/lib/*")
		{
			Copy-Item -Path "$src_path/lib/*" -Destination "$dst_path/lib/" -Force -Recurse
		}
		elseif (Test-Path -Path "$src_path/lib64")
		{
			Copy-Item -Path "$src_path/lib64/*" -Destination "$dst_path/lib/" -Force -Recurse
		}
		elseif (Test-Path -Path "$src_path/lib32")
		{
			Copy-Item -Path "$src_path/lib32/*" -Destination "$dst_path/lib/" -Force -Recurse
		}

		if (Test-Path "$src_path/include/")
		{
			Copy-Item -Path "$src_path/include/*" -Destination "$dst_path/include/" -Force -Recurse
		}

		if (Test-Path "$src_path/share/")
		{
			Copy-Item -Path "$src_path/share/*" -Destination "$dst_path/share/" -Force -Recurse
		}
	}
	else
	{
		# linux 平台
		$copy_cmd = "cp -a"
		if ($sudo)
		{
			$copy_cmd = "sudo cp -a"
		}

		# 下面是 bash 脚本
		run-bash-cmd.ps1 @"
		set -e

		if [ -d "$src_path/bin" ]; then
			$copy_cmd $src_path/bin/* $dst_path/bin/
		fi

		if [ -d "$src_path/lib" ]; then
			$copy_cmd "$src_path/lib/"* "$dst_path/lib/"
		elif [ -d "$src_path/lib64" ]; then
			$copy_cmd "$src_path/lib64/"* "$dst_path/lib/"
		elif [ -d "$src_path/lib32" ]; then
			$copy_cmd "$src_path/lib32/"* "$dst_path/lib/"
		fi

		if [ -d "$src_path/include" ]; then
			$copy_cmd $src_path/include/* $dst_path/include/
		fi

		if [ -d "$src_path/share" ]; then
			$copy_cmd $src_path/share/* $dst_path/share/
		fi
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


function Auto-Make
{
	aclocal
	autoconf
	automake --add-missing
}


function Get-Cmake-Set-Find-Lib-Path-String
{
	return @"
	set(CMAKE_EXE_LINKER_FLAGS 		"-Wl,-rpath-link,$total_install_path/lib ${CMAKE_EXE_LINKER_FLAGS}" 	CACHE STRING "Linker flags for executables" 		FORCE)
	set(CMAKE_SHARED_LINKER_FLAGS 	"-Wl,-rpath-link,$total_install_path/lib ${CMAKE_SHARED_LINKER_FLAGS}" 	CACHE STRING "Linker flags for shared libraries"	FORCE)

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
		[Parameter(Mandatory = $true)]
		[string]$link_flags,
		[string]$arch = "armv7-a",
		[string]$toolchain_prefix = "arm-none-linux-gnueabihf-"
	)
	
	$link_flags = $link_flags.Replace("`r", " ").Replace("`n", " ").Replace("`t", " ")


	$pkg_config_paths = "$env:PKG_CONFIG_PATH".Split(':')
	$pkg_config_path_array = "["
	foreach ($path in $pkg_config_paths)
	{
		$pkg_config_path_array += " '$path', "
	}

	$pkg_config_path_array += "]"
	Write-Host "==============================================================================="
	Write-Host "pkg_config_path_array - $pkg_config_path_array"
	Write-Host "-------------------------------------------------------------------------------"

	Create-Text-File -Path $build_path/cross_file.ini `
		-Content @"
	[binaries]
	c = '${toolchain_prefix}gcc'
	cpp = '${toolchain_prefix}g++'
	ar = '${toolchain_prefix}ar'
	ld = '${toolchain_prefix}ld'
	strip = '${toolchain_prefix}strip'
	pkg-config = 'pkg-config'
	cmake = 'cmake'

	[properties]
	pkg_config_libdir = $pkg_config_path_array

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
	c_args = ['-march=$arch', '-I$total_install_path/include']
	cpp_args = ['-march=$arch', '-I$total_install_path/include']
	c_link_args = $link_flags
	cpp_link_args = $link_flags
"@
}