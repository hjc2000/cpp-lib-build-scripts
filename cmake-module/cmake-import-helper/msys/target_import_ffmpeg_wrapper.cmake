include(target_import_ffmpeg)
include(target_import_base)
include(target_import_pinvoke)

function(target_import_ffmpeg_wrapper target_name visibility)
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/ffmpeg-wrapper/include/)
	target_auto_link_lib(${target_name} ffmpeg-wrapper $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/ffmpeg-wrapper/lib/)

	target_import_ffmpeg(${target_name} ${visibility})
	target_import_base(${target_name} ${visibility})
	target_import_pinvoke(${target_name} ${visibility})
endfunction()
