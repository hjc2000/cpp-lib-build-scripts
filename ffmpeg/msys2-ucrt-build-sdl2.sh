source_root_path=$(pwd)
install_path=${source_root_path}/install

get-repo.sh https://github.com/libsdl-org/SDL.git SDL2 &&
cd SDL &&
if [ ! -d "./build/" ]; then
	mkdir build
fi &&
cd build &&
rm -rf * &&
cmake -G "Unix Makefiles" .. \
-DCMAKE_INSTALL_PREFIX=${install_path} &&

make -j12 &&
make install
