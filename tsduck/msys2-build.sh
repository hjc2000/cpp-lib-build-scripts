source_root_path=$(pwd)
install_path="${source_root_path}/install/msys2-build-install/"

mkdir -p ${install_path}
cp -r ${source_root_path}/windows-prebuild-tsduck/* ${install_path}
