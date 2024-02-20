export libs_path=$(cygpath ${libs_path})
install_path="${libs_path}/ffmpeg"

cd ${repos_path} &&
get-repo.sh https://gitee.com/programmingwindows/FFmpeg.git release/6.1 &&
cd ${repos_path}/FFmpeg/ &&

export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${libs_path}/x264/lib/pkgconfig
export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${libs_path}/x265/lib/pkgconfig
export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${libs_path}/SDL2/lib/pkgconfig
echo $PKG_CONFIG_PATH
pkg-config --libs --cflags x264

./configure \
--prefix="${install_path}" \
--extra-cflags="-I${libs_path}/x264/include -DAMF_CORE_STATICTIC" \
--extra-ldflags="-L${libs_path}/x264/lib" \
--enable-libx264 \
--enable-libx265 \
--enable-pic \
--enable-gpl \
--enable-shared &&

make -j12 && make install