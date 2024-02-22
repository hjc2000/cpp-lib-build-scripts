$ErrorActionPreference = "Stop"

Set-Location ${repos_path}
get-git-repo.ps1 https://gitee.com/Qianshunan/x264.git
Set-Location ${repos_path}/x264

$install_path = "$libs_path/x264"
Write-Host $install_path

bash.exe -c "./configure \
--prefix=${install_path} \
--enable-shared \
--disable-opencl \
--enable-pic &&
exit
"

make -j12
make install

Write-Host "pc 文件的内容："
Get-Content $install_path/lib/pkgconfig/x264.pc