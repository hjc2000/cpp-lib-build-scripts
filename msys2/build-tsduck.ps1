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
$source_path = "$repos_path/tsduck/tsduck-3.36-3528/"
$install_path = "$libs_path/tsduck"
$msvc_path = "$source_path/scripts/msvc"
Set-Location $msvc_path

Write-Host "清空 msvc-build-tsduck-jar.props 中的编译目标"
@"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

</Project>
"@ > "$msvc_path/msvc-build-tsduck-jar.props"

Write-Host "从 config.vcxproj 中删除     <CallTarget Targets='BuildTSDuckJar'/>"
@"
<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

  <!-- Project file to build the configuration files only -->

  <ImportGroup>
    <Import Project='msvc-common-begin.props'/>
  </ImportGroup>

  <PropertyGroup Label="Globals">
    <ProjectGuid>{C932660E-56D0-40FD-9A90-0123456789AB}</ProjectGuid>
    <Keyword>Win32Proj</Keyword>
    <RootNamespace>config</RootNamespace>
  </PropertyGroup>

  <!-- Build initial config files, as used in global solution file, before all other projects -->

  <Target Name='BuildInitialConfig' BeforeTargets='PrepareForBuild'>
    <CallTarget Targets='BuildConfigFiles'/>
    <CallTarget Targets='BuildDtvNames'/>
    <CallTarget Targets='BuildDektecNames'/>
    <CallTarget Targets='BuildTSDuckHeader'/>
  </Target>

  <!-- Build all config files, as called in build-config-files.ps1 -->

  <Target Name='BuildAllConfig'>
    <CallTarget Targets='BuildConfigFiles'/>
    <CallTarget Targets='BuildDtvNames'/>
    <CallTarget Targets='BuildDektecNames'/>
    <CallTarget Targets='BuildTSDuckHeader'/>
    <CallTarget Targets='BuildTablesModel'/>
  </Target>

  <ImportGroup>
    <Import Project='msvc-common-base.props' />
    <Import Project='msvc-use-dtapi.props'/>
    <Import Project='msvc-build-config-files.props'/>
    <Import Project='msvc-build-dtv-names.props'/>
    <Import Project='msvc-build-dektec-names.props'/>
    <Import Project='msvc-build-tsduck-header.props'/>
    <Import Project='msvc-build-tsduck-jar.props'/>
    <Import Project="msvc-common-end.props"/>
  </ImportGroup>

</Project>
"@ > "$msvc_path/config.vcxproj"

MSBuild.exe "$msvc_path/tsduckdll.vcxproj" /p:Configuration=Release /p:Platform=x64
if (-not $?)
{
	return 1
} 

# tsduck 编译完后没有安装脚本，得手动复制文件
New-Item -Path "$install_path/bin/" -ItemType Directory -Force
New-Item -Path "$install_path/lib/" -ItemType Directory -Force
New-Item -Path "$install_path/include/" -ItemType Directory -Force

Get-ChildItem -Path "$source_path/bin/Release-x64/*.dll" -Recurse | ForEach-Object {
	$file_name = [System.IO.Path]::GetFileName($_.FullName)
	Write-Host "install $file_name"
	Copy-Item -Path $_.FullName `
		-Destination "$install_path/bin/$file_name" `
		-Force `
		-Recurse
}

Get-ChildItem -Path "$source_path/bin/Release-x64/*.exe" -Recurse | ForEach-Object {
	$file_name = [System.IO.Path]::GetFileName($_.FullName)
	Write-Host "install $file_name"
	Copy-Item -Path $_.FullName `
		-Destination "$install_path/bin/$file_name" `
		-Force `
		-Recurse
}

Get-ChildItem -Path "$source_path/bin/Release-x64/*.lib" -Recurse | ForEach-Object {
	$file_name = [System.IO.Path]::GetFileName($_.FullName)
	Write-Host "install $file_name"
	Copy-Item -Path $_.FullName `
		-Destination "$install_path/lib/$file_name" `
		-Force `
		-Recurse
}

Get-ChildItem -Path "$source_path/src/libtsduck/*.h" -Recurse | ForEach-Object {
	$file_name = [System.IO.Path]::GetFileName($_.FullName)
	Write-Host "install $file_name"
	Copy-Item -Path $_.FullName `
		-Destination "$install_path/include/$file_name" `
		-Force `
		-Recurse
}
Get-ChildItem -Path "$source_path/bin/include/*.h" -Recurse | ForEach-Object {
	$file_name = [System.IO.Path]::GetFileName($_.FullName)
	Write-Host "install $file_name"
	Copy-Item -Path $_.FullName `
		-Destination "$install_path/include/$file_name" `
		-Force `
		-Recurse
}
