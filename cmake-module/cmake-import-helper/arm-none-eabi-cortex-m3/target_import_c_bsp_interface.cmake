function(target_import_c_bsp_interface target_name visibility)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/c-bsp-interface/include/)
	target_auto_link_lib(${target_name} c-bsp-interface $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/c-bsp-interface/lib/)
endfunction()
