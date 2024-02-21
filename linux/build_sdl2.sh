set -e
current_path=$(pwd)
${current_path}/base_scripts/check_env_var.sh
install_path="${libs_path}/SDL2"

sudo apt install libxext-dev

cd ${repos_path}
get-repo.sh https://gitee.com/mycn027b/SDL.git SDL2
cd ${repos_path}/SDL/

if [ ! -d "./build/" ]; then
	mkdir build
fi
cd build

cmake -G "Unix Makefiles" .. \
-DCMAKE_INSTALL_PREFIX=${install_path}

make clean
make -j12
make install

mv ${install_path}/include/SDL2/* ${install_path}/include/
rm -rf ${install_path}/include/SDL2