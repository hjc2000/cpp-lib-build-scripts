function(target_import_lwip target_name visibility)
	set(lib_name "lwip")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_freertos_osal(${target_name} ${visibility})
endfunction()
