set -e

export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/tsduck"

cd ${cpp_lib_build_scripts_path}/.prebuild/tsduck/
mkdir -p ${install_path}
cp -r ./* ${install_path}/