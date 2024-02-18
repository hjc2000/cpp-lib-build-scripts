sudo apt install nasm yasm diffutils pkg-config llvm

source_root_path=$(pwd)
install_path="${source_root_path}/linux-localhost-install"

./linux-localhost-build-x264.sh &&
./linux-localhost-build-x265.sh &&
./linux-localhost-build-sdl2.sh &&
./linux-localhost-build-ffmpeg.sh

