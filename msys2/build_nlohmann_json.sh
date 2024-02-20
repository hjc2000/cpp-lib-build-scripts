export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/nlohmann-json/include/nlohmann"

mkdir -p ${install_path} &&
cd ${install_path} &&
wget https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp