source_root_path=$(pwd)
install_path="${source_root_path}/install/linux-gcc-install/"

get-repo.sh https://gitee.com/Qianshunan/x265_git.git &&
cd x265_git/source &&

if [ ! -d ./build/ ]; then
	mkdir build
fi &&

cd build && rm -rf *

cmake -G "Unix Makefiles" .. \
-DCMAKE_INSTALL_PREFIX="${install_path}" \
-DENABLE_SHARED=on \
-DENABLE_PIC=on \
-DENABLE_ASSEMBLY=off &&

make clean
make -j12 &&
make install