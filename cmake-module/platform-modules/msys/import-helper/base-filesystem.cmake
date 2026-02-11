function(target_import_base_filesystem target_name visibility)
	set(lib_name "msys-base-filesystem")

    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")

	target_import_base(${target_name} ${visibility})
endfunction()
