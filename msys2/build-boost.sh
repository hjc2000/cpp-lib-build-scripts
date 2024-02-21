set -e

# 将依赖的环境变量转换成 msys 格式，然后导出。
export libs_path=$(cygpath ${libs_path})
export repos_path=$(cygpath ${repos_path})
export cpp_lib_build_scripts_path=$(cygpath ${cpp_lib_build_scripts_path})

install_path="${libs_path}/boost"

cd ${repos_path}
wget-repo.sh ${repos_path} https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0_rc1.tar.gz
if [ -d  ${repos_path}/boost_1_84_0/ ]; then
	# 因为 URL 是 boost_1_84_0_rc1，但解压后是 boost_1_84_0，所以需要移动。
	# 
	# 但是，如果已经移动过了，再次执行本脚本就会因为已经存在 boost_1_84_0_rc1 了，
	# wget-repo.sh 不执行下载解压，也就不会有 boost_1_84_0，所以移动会失败。
	# 所以需要先判断，然后才能移动。
	mv ${repos_path}/boost_1_84_0/ ${repos_path}/boost_1_84_0_rc1/
fi

mkdir -p ${install_path}/include/
cp -r ${repos_path}/boost_1_84_0_rc1/boost/* ${install_path}/include/