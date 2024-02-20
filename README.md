# cpp-lib-build-scripts
## 环境
需要设置环境变量：

- `libs_path ` - 编译后的安装路径
- `repos_path`  - 源代码储存路径
- `cpp_lib_build_scripts_path`  - 编译脚本的路径。（就是 cpp-lib-build-scripts 这里的编译脚本）

将这些添加到 windows 的环境变量中。

## 编译

需要一个库时，就到本项目根路径下的对应平台的目录下寻找编译脚本。例如 `msys2/build-ffmpeg.sh` 。编译完后就会安装到 `${libs_path}` 中。