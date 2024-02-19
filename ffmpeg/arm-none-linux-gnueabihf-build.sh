sudo apt install nasm yasm diffutils pkg-config llvm

source_root_path=$(pwd)
install_path="${source_root_path}/install"

./arm-none-linux-gnueabihf-build-x264.sh &&
./arm-none-linux-gnueabihf-build-x265.sh &&
./arm-none-linux-gnueabihf-build-ffmpeg.sh &&

cd ${install_path}/lib &&
rm *.a
