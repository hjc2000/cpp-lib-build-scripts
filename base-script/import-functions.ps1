# 准备好一个空的文件夹。如果文件夹本来就存在且里面有东西，则会删除所有内容
function New-Empty-Dir
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	
	# 创建 build 目录
	New-Item -Path $Path -ItemType Directory -Force
	Remove-Item "$Path/*" -Recurse -Force
	Set-Location $Path
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
	New-Item -Path $Path -ItemType File -Force
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

	New-Item -Path $dst_path/bin/ -ItemType Directory -Force
	New-Item -Path $dst_path/lib/ -ItemType Directory -Force
	New-Item -Path $dst_path/include/ -ItemType Directory -Force

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
"@
	}
}


function Apt-Ensure-Packet
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
		<#Do this if a terminating exception happens#>
	}
	finally
	{
		Pop-Location	
	}
}