function(target_import_pn target_name visibility)
	set(lib_name "pn")
    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")

	target_import_cb(${target_name} ${visibility})
	target_import_xhif(${target_name} ${visibility})
endfunction()
