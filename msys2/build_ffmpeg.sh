# 将依赖的环境变量转换成 msys 格式，然后导出。
export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/ffmpeg"

cd ${repos_path} &&
get-repo.sh https://gitee.com/programmingwindows/FFmpeg.git release/6.1 &&
cd ${repos_path}/FFmpeg/ &&


# 编译依赖
${cpp_lib_build_scripts_path}/msys2/build_x264.sh &&
${cpp_lib_build_scripts_path}/msys2/build_x265.sh &&
${cpp_lib_build_scripts_path}/msys2/build_sdl2.sh &&
${cpp_lib_build_scripts_path}/msys2/build_amf.sh

export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${libs_path}/x264/lib/pkgconfig
export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${libs_path}/x265/lib/pkgconfig
export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${libs_path}/SDL2/lib/pkgconfig

./configure \
--prefix="${install_path}" \
--extra-cflags="-I${libs_path}/amf/include -DAMF_CORE_STATICTIC" \
--enable-libx264 \
--enable-libx265 \
--enable-amf \
--enable-pic \
--enable-gpl \
--enable-shared &&

make clean &&
make -j12 && make install

# 将 msys2 中的 dll 复制到安装目录
# 可以用 ldd ffmpeg.exe | grep ucrt64 命令来查看有哪些依赖是来自 ucrt64 的
cp /ucrt64/bin/libstdc++-6.dll ${install_path}/bin/
cp /ucrt64/bin/libwinpthread-1.dll ${install_path}/bin/
cp /ucrt64/bin/zlib1.dll ${install_path}/bin/
cp /ucrt64/bin/libgcc_s_seh-1.dll ${install_path}/bin/
cp /ucrt64/bin/libbz2-1.dll ${install_path}/bin/
cp /ucrt64/bin/libiconv-2.dll ${install_path}/bin/
cp /ucrt64/bin/liblzma-5.dll ${install_path}/bin/