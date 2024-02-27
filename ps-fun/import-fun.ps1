# 准备好 cmake 项目的 build 目录，并切换到该目录。
# 并且会清空 build 目录。
function Prepare-And-CD-CMake-Build-Dir
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$desired_build_path
	)
	
	# 创建 build 目录
	New-Item -Path $desired_build_path -ItemType Directory -Force
	Remove-Item "$desired_build_path/*" -Recurse -Force
	Set-Location $desired_build_path
}