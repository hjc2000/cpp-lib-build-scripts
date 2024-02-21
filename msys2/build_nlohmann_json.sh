set -e

export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/nlohmann-json/include/nlohmann"

mkdir -p ${install_path}
cd ${install_path}

# 先删除旧的再下载新的。反正就一个文件，耗时不长。
rm json.hpp
wget https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp