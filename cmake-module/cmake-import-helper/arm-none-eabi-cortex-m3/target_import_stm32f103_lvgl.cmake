function(target_import_stm32f103_lvgl target_name visibility)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/stm32f103-lvgl/include/)
	target_auto_link_lib(${target_name} stm32f103-lvgl $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/stm32f103-lvgl/lib/)
endfunction()
