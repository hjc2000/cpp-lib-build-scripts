# 简介

一些常用的 C/C++ 库的自动化构建脚本。

# msys2 环境搭建

## 安装 msys2

[msys2 官网链接](https://www.msys2.org/)

下载安装后需要在环境变量 `Path` 中添加如下路径：

```powershell
C:/msys64/home/satli/bin
C:/msys64/ucrt64/bin
C:/msys64/usr/bin
```

其中 `satli` 是安装 msys2 时自动根据当前 windows 用户的用户名创建的一个 msys2 用户家目录。需要根据自己的实际情况进行调整，不要死板地将 `C:/msys64/home/satli/bin` 原封不动地添加到自己的 `Path` 中。



安装 msys2 后，在使用本项目的脚本来构建第三方库的时候可能还会缺一些工具，这时候需要用 pacman 命令安装。

## 安装 visual studio2022

安装时要选择 C++ 的桌面开发，并且要安装 clang 工具链。然后在环境变量 `Path` 中添加如下路径：

```powershell
C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/Llvm/x64/bin
C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja
C:/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin
```

## 安装 cmake

安装完后在环境变量 `Path` 中添加如下路径：

```powershell
C:/Program Files/CMake/bin
```

不要使用 msys2 中的 pacman 安装的 cmake。如果已经这么做了，先卸载，然后到 cmake 官网下载 windows 安装包。

## 安装 python3

不要用 pacman 安装 python，如果已经装了，先卸载，然后下载 windows 的安装包进行安装。也可以用微软应用商店进行安装。在商店里搜索 python3。

## 部署 my_shell

克隆仓库：

```
https://github.com/hjc2000/my_shell.git
```

然后将这个脚本的目录添加到环境变量 `Path ` 中。

## 安装 powershell7

不要用 windows 自带的 powershell，这个版本比较旧。安装完后需要执行：

```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```

这样才能执行 ps1 脚本，否则会被以安全为理由阻止执行。

## 安装 cygpath-pkg-config-pc-path 可执行文件

克隆仓库

```
https://github.com/hjc2000/video.git
```

里面有一个 C# 的控制台项目，名为 cygpath-pkg-config-pc-path。编译后发布到一个你喜欢的目录下。记得将该目录添加到环境变量 `Path` 中。



需要 `cygpath-pkg-config-pc-path` 这个命令是因为在 msys2 中编译 cmake 的项目时，如果这些项目生成 pkg-config 的 .pc 文件，它里面的路径的是 windows 风格的。这会导致其他项目，例如使用 configure 的项目无法解析这种路径。所以需要修复这种风格的路径，将它变成 msys2 风格的。

# linux 环境搭建

首先要安装 powershell7，可以参考微软的文档。其他软件在使用过程中逐渐安装就行了。缺啥补啥。
