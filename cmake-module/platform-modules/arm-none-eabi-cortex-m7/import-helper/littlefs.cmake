function(target_import_littlefs target_name visibility)
	set(lib_name "littlefs")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")

	target_import_bsp_interface(${target_name} ${visibility})
endfunction()
