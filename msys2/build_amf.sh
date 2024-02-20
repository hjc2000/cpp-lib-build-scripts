export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/amf"

cd ${repos_path} &&
get-repo.sh https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git &&
cd ${repos_path}/AMF/amf/public/include &&

amf_include_install_path=${install_path}/include/AMF/
mkdir -p ${amf_include_install_path} &&
cp -r ./* ${amf_include_install_path}