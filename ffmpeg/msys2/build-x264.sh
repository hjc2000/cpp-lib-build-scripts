install_path="${libs_path}/x264"
install_path=$(cygpath ${install_path})

cd ${repos_path} &&
get-repo.sh https://gitee.com/Qianshunan/x264.git &&
cd ${repos_path}/x264 &&

./configure \
--prefix="${install_path}" \
--enable-shared \
--disable-opencl \
--enable-pic &&

make -j12 &&
make install