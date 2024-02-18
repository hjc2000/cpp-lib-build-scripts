source_root_path=$(pwd)
install_path=${source_root_path}/msys2-ucrt-build-install/

get-repo.sh https://gitee.com/mycn027b/SDL.git SDL2 &&
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

cd ${install_path}/include/SDL2 &&
mv * ${install_path}/include/ &&
cd ${install_path}/include/ &&
rm -rf SDL2/
