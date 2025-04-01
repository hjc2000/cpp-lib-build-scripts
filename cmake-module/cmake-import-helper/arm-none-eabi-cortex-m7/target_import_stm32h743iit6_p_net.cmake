include(target_import_lwip)

function(target_import_stm32h743iit6_p_net target_name visibility)
	set(lib_name "stm32h743iit6-p-net")
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)

	target_import_lwip(${target_name} ${visibility})
endfunction()
