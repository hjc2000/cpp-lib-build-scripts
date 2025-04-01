function(target_import_stm32h743iit6_isr target_name visibility)
	set(lib_name "stm32h743iit6-isr")
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")
endfunction()
