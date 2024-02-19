source_root_path=$(pwd)
install_path="${source_root_path}/linux-gcc-build-install/"

get-repo.sh https://github.com/tsduck/tsduck.git &&
cd ${source_root_path}/tsduck &&

# ./scripts/install-prerequisites.sh
# 这里面的很多依赖与系统的现有项冲突，所以就不要安装了。
# 经过测试，按照下文中的命令进行构建，禁用一些模块，就可以不用执行此脚本安装依赖。

make clean &&
#  Additional options which can be defined:
#
#  - NOTEST     : Do not build unitary tests.
#  - NODEKTEC   : No Dektec device support, remove dependency to DTAPI.
#  - NOHIDES    : No HiDes device support.
#  - NOVATEK    : No Vatek-based device support.
#  - NOCURL     : No HTTP support, remove dependency to libcurl.
#  - NOPCSC     : No smartcard support, remove dependency to pcsc-lite.
#  - NOSRT      : No SRT support, remove dependency to libsrt.
#  - NORIST     : No RIST support, remove dependency to librist.
#  - NOEDITLINE : No interactive line editing, remove dependency to libedit.
#  - NOGITHUB   : No version check, no download, no upgrade from GitHub.
#  - NOHWACCEL  : Disable hardware acceleration such as crypto instructions.
#  - NOPCSTD    : Remove the std=c++17 flag from libtsduck's pkg-config file.
make -j12 NOGITHUB=1 NOVATEK=1 NOTEST=1 NODEKTEC=1 NOHIDES=1 NOCURL=1 NOEDITLINE=1 NOSRT=1 NORIST=1 &&
make install SYSPREFIX=${install_path}
