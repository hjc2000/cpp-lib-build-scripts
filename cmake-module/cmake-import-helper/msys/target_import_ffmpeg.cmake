# 导入 ffmpeg 库
# 首先使用
# include(${CMAKE_SOURCE_DIR}/cmake-import-libs-helper/import-ffmpeg.cmake)
# 包含本文件，获得本函数的定义，然后调用，让目标导入 ffmpeg 库。
function(target_import_ffmpeg target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/ffmpeg/include/)
    target_auto_link_lib(${target_name} ${visibility} libavcodec ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libavdevice ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libavfilter ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libavformat ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libavutil ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libpostproc ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libswresample ${libs_path}/ffmpeg/lib/)
    target_auto_link_lib(${target_name} ${visibility} libswscale ${libs_path}/ffmpeg/lib/)

    install_dll_dir(${libs_path}/ffmpeg/bin/)
endfunction()
