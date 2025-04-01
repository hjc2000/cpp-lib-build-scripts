include(target_import_sdl2)
include(target_import_base)
include(target_import_ffmpeg_wrapper)

function(target_import_sdl2_wrapper target_name visibility)
	set(lib_name "sdl2-wrapper")
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include/)
	target_auto_link_lib(${target_name} ${lib_name} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)

	target_import_sdl2(${target_name} ${visibility})
	target_import_base(${target_name} ${visibility})
	target_import_ffmpeg_wrapper(${target_name} ${visibility})
endfunction()
