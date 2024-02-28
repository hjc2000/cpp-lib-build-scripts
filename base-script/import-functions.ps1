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