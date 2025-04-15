function(target_import_reload_new target_name visibility)
	set(lib_name "reload-new")
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")
endfunction()
