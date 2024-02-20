export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/ffmpeg"

# 编译依赖
${cpp_lib_build_scripts_path}/msys2/build-x264.sh &&
${cpp_lib_build_scripts_path}/msys2/build-x265.sh &&
${cpp_lib_build_scripts_path}/msys2/build-sdl2.sh &&
${cpp_lib_build_scripts_path}/msys2/build-amf.sh

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
--extra-cflags="-I${libs_path}/amf/include -DAMF_CORE_STATICTIC" \
--enable-libx264 \
--enable-libx265 \
--enable-amf \
--enable-pic \
--enable-gpl \
--enable-shared &&

make -j12 && make install