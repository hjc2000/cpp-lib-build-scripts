source_root_path=$(pwd)
install_path="${source_root_path}/install/linux-gcc-install/"

get-repo.sh https://gitee.com/Qianshunan/x264.git &&
cd ${source_root_path}/x264 &&

./configure \
--prefix="${install_path}" \
--enable-shared \
--disable-opencl \
--enable-pic &&

make clean
make -j12 &&
make install