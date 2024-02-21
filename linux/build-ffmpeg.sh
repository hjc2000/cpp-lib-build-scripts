set -e
current_path=$(pwd)
${current_path}/base_scripts/check-env-var.sh


install_path="${libs_path}/ffmpeg"
cd ${repos_path}
get-repo.sh https://gitee.com/programmingwindows/FFmpeg.git release/6.1
cd ${repos_path}/FFmpeg


./configure \
--prefix="${install_path}" \
--pkg-config="/usr/bin/pkg-config" \
--extra-cflags="-I${install_path}/include" \
--extra-ldflags="-L${install_path}/lib" \
--enable-libx265 \
--enable-libx264 \
--enable-pic \
--enable-gpl \
--enable-shared

make clean
make -j12
make install