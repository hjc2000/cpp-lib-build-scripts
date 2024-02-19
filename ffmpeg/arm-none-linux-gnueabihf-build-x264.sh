source_root_path=$(pwd)
install_path="${source_root_path}/install"

cd x264-master &&

./configure \
--host=arm-none-linux-gnueabihf \
--cross-prefix=arm-none-linux-gnueabihf- \
--prefix="${install_path}" \
--enable-shared \
--disable-opencl \
--enable-pic &&

make clean
make -j12 &&
make install

