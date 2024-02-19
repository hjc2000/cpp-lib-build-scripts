# 记录当前路径。接下来要分别进入 bin 和 lib 目录删除文件
root_path=$(pwd)

# 进入 lib 目录删除文件
cd lib &&
rm -rf \
libx265.* \
libx264.* \
libswscale.* \
libswresample.so.* \
libavcodec.* \
libavdevice.* \
libavfilter.* \
libavformat.* \
libavutil.* \
libpostproc.* 

# 进入 bin 目录删除文件
cd ${root_path} &&
cd bin &&
rm -rf \
ffmpeg \
ffprobe \
x264 \
x265
