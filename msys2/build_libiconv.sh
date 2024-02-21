set -e

# 将依赖的环境变量转换成 msys 格式，然后导出。
export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/libiconv"

cd ${repos_path}
wget-repo.sh ${repos_path} https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
cd ${repos_path}/libiconv-1.17/

./configure --prefix=${install_path}

make -j12
make install
