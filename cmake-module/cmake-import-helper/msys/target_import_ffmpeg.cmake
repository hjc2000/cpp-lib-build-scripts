# 导入 ffmpeg 库
# 首先使用
# include(${CMAKE_SOURCE_DIR}/cmake-import-libs-helper/import-ffmpeg.cmake)
# 包含本文件，获得本函数的定义，然后调用，让目标导入 ffmpeg 库。
function(target_import_ffmpeg target_name visibility)
	set(lib_name "ffmpeg")
    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
    target_auto_link_lib(${target_name} libavcodec ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavdevice ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavfilter ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavformat ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libavutil ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libpostproc ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libswresample ${libs_path}/${lib_name}/lib/)
    target_auto_link_lib(${target_name} libswscale ${libs_path}/${lib_name}/lib/)
endfunction()
