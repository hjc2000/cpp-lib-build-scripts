sudo apt install nasm yasm diffutils pkg-config llvm

source_root_path=$(pwd)
install_path="${source_root_path}/install/linux-gcc-install"

./linux-gcc-build-x264.sh &&
./linux-gcc-build-x265.sh &&
./linux-gcc-build-sdl2.sh &&
./linux-gcc-build-ffmpeg.sh