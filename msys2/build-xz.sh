# 将依赖的环境变量转换成 msys 格式，然后导出。
export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/xz"

cd ${repos_path} &&
get-repo.sh https://github.com/xz-mirror/xz.git &&
cd ${repos_path}/xz/ &&


# 确保 build 目录存在
if [ ! -d ./build/ ]; then
	mkdir build
fi &&
cd build && rm -rf *

cmake -G "Unix Makefiles" .. \
-DCMAKE_INSTALL_PREFIX="${install_path}" \
-DBUILD_SHARED_LIBS=ON &&

make -j12 &&
make install