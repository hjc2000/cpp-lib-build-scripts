# cpp-lib-build-scripts
# 环境

需要设置环境变量：

- libs_path - 编译后的安装路径
- repos_path  - 源代码储存路径
- cpp_lib_build_scripts_path  - 编译脚本的路径（本项目的根路径）。

将这些添加到 windows 的环境变量中。

## linux 环境配置

在 linux 中可以在 ${HOME}/.bashrc 中添加以下内容

```bash
export cpp_lib_build_scripts_path=${HOME}/cpp-lib-build-scripts
export repos_path=${HOME}/lib_source
export libs_path=${HOME}/libs
```

然后创建这 3 个目录。在家目录中执行

```bash
mkdir -p ${HOME}/lib_source &&\
mkdir -p ${HOME}/libs
```

cpp-lib-build-scripts 不是用 mkdir 创建的，这个要克隆本项目的仓库来创建。


# 编译

需要一个库时，就到本项目根路径下的对应平台的目录下寻找编译脚本。例如 `msys2/build-ffmpeg.sh` 。编译完后就会安装到 `${libs_path}` 中。