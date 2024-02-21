set -e
${cpp_lib_build_scripts_path}/linux/base-scripts/check-env-var.sh


install_path="${libs_path}/ffmpeg"
cd ${repos_path}
get-repo.sh https://gitee.com/programmingwindows/FFmpeg.git release/6.1
cd ${repos_path}/FFmpeg

# 编译依赖
${cpp_lib_build_scripts_path}/linux/build-x264.sh
${cpp_lib_build_scripts_path}/linux/build-x265.sh
${cpp_lib_build_scripts_path}/linux/build-sdl2.sh
${cpp_lib_build_scripts_path}/linux/build-openssl.sh

export PKG_CONFIG_PATH=""
export PKG_CONFIG_PATH=${libs_path}/x264/lib/pkgconfig:${PKG_CONFIG_PATH}
export PKG_CONFIG_PATH=${libs_path}/x265/lib/pkgconfig:${PKG_CONFIG_PATH}
export PKG_CONFIG_PATH=${libs_path}/SDL2/lib/pkgconfig:${PKG_CONFIG_PATH}
export PKG_CONFIG_PATH=${libs_path}/openssl/lib64/pkgconfig:${PKG_CONFIG_PATH}


./configure \
--prefix="${install_path}" \
--enable-libx265 \
--enable-libx264 \
--enable-pic \
--enable-openssl \
--enable-gpl \
--enable-version3 \
--enable-shared

make clean
make -j12
make install