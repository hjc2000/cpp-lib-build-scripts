function(target_import_bsp_interface target_name visibility)
	set(lib_name "bsp-interface")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_base(${target_name} PUBLIC)
	target_import_boost(${target_name} PUBLIC)
endfunction()
