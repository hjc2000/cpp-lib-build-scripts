source_root_path=$(pwd)
install_path="${source_root_path}/linux-localhost-install/"

get-repo.sh https://github.com/tsduck/tsduck.git &&
cd ${source_root_path}/tsduck &&

# ./scripts/install-prerequisites.sh
# 这里面的很多依赖与系统的现有项冲突，所以就不要安装了。
# 经过测试，按照下文中的命令进行构建，禁用一些模块，就可以不用执行此脚本安装依赖。

make -j12 \
NOGITHUB=1 \
NOVATEK=1 \
NOTEST=1 \
NODEKTEC=1 \
NOHIDES=1 \
NOCURL=1 \
NOEDITLINE=1 \
NOSRT=1 \
NOPCSC=1 &&
make install SYSPREFIX=${install_path}