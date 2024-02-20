source_root_path=$(pwd)
install_path="${source_root_path}/install/linux-gcc-install"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"${install_path}/lib/pkgconfig"

get-repo.sh https://gitee.com/programmingwindows/FFmpeg.git release/6.1 &&
cd FFmpeg &&

./configure \
--prefix="${install_path}" \
--pkg-config="/usr/bin/pkg-config" \
--extra-cflags="-I${install_path}/include" \
--extra-ldflags="-L${install_path}/lib" \
--enable-libx265 \
--enable-libx264 \
--enable-pic \
--enable-gpl \
--enable-shared &&

make clean &&
make -j12 && make install