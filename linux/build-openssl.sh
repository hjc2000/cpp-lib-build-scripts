set -e
${cpp_lib_build_scripts_path}/linux/base-scripts/check-env-var.sh


install_path="${libs_path}/openssl"
cd ${repos_path}
get-repo.sh https://github.com/openssl/openssl.git
cd ${repos_path}/openssl


./Configure shared --prefix=${install_path}
make -j12
make install