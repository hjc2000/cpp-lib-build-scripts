source_root_path=$(pwd)
install_path="${source_root_path}/install"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"${install_path}/lib/pkgconfig"

cd ffmpeg-6.1.1 &&

./configure \
--prefix="${install_path}" \
--pkg-config="/usr/bin/pkg-config" \
--extra-cflags="-I${install_path}/include" \
--extra-ldflags="-L${install_path}/lib" \
--enable-libx265 \
--enable-libx264 \
--enable-pic \
--enable-gpl \
--enable-shared \
--enable-cross-compile \
--cross-prefix=arm-none-linux-gnueabihf- \
--arch="arm" \
--target-os="linux" &&

make clean &&
make -j12 && make install

