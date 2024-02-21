set -e

# 将依赖的环境变量转换成 msys 格式，然后导出。
export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/xz"

cd ${repos_path}
wget-repo.sh ${repos_path} https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.gz
cd ${repos_path}/xz-5.4.6/


# 确保 build 目录存在
if [ ! -d ./build/ ]; then
	mkdir build
fi
cd build

cmake -G "Unix Makefiles" .. \
-DCMAKE_INSTALL_PREFIX="${install_path}" \
-DBUILD_SHARED_LIBS=ON

make -j12
make install
cd ${install_path}/bin
cp liblzma.dll liblzma-5.dll

# 修复 .pc 文件内的路径
cd ${install_path}/lib/pkgconfig
update-pc-prefix.sh liblzma.pc