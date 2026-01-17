function(target_import_base_filesystem target_name visibility)
	set(lib_name "msys-base-filesystem")

    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
    target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)
endfunction()
