function(target_import_freertos target_name visibility)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/freertos/include)
	target_auto_link_lib(${target_name} freertos $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/freertos/lib/)
endfunction()
