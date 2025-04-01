# 导入 ffmpeg 库
# 首先使用
# include(${CMAKE_SOURCE_DIR}/cmake-import-libs-helper/import-ffmpeg.cmake)
# 包含本文件，获得本函数的定义，然后调用，让目标导入 ffmpeg 库。
function(target_import_ffmpeg target_name visibility)
	set(lib_name "ffmpeg")
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include/)
    target_auto_link_lib(${target_name} libavcodec $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavdevice $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavfilter $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavformat $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavutil $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libpostproc $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libswresample $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libswscale $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
endfunction()
