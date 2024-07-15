include(target_import_ffmpeg)
include(target_import_base)
include(target_import_pinvoke)

function(target_import_ffmpeg_wrapper target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/ffmpeg-wrapper/include/)
	target_auto_link_lib(${target_name} ffmpeg-wrapper ${libs_path}/ffmpeg-wrapper/lib/)
    install_dll_dir(${libs_path}/ffmpeg-wrapper/bin/)
	
	target_import_ffmpeg(${target_name} ${visibility})
	target_import_base(${target_name} ${visibility})
	target_import_pinvoke(${target_name} ${visibility})
endfunction()
