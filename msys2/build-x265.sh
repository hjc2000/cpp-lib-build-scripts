export libs_path=$(cygpath ${libs_path})
install_path="${libs_path}/x265"

cd ${repos_path} &&
get-repo.sh https://gitee.com/Qianshunan/x265_git.git &&
cd ${repos_path}/x265_git/source &&

# 确保 build 目录存在
if [ ! -d ./build/ ]; then
	mkdir build
fi &&
cd build && rm -rf *

cmake -G "Unix Makefiles" .. \
-DCMAKE_INSTALL_PREFIX="${install_path}" \
-DENABLE_SHARED=on \
-DENABLE_PIC=on \
-DENABLE_ASSEMBLY=off &&

make -j12 &&
make install &&
cd ${libs_path}/x265/lib/pkgconfig &&
update-pc-prefix.sh x265.pc