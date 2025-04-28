function(target_import_prd target_name visibility)
	set(lib_name "prd")
	target_include_directories(${target_name} ${visibility} "$ENV{cpp_lib_build_scripts_path}/arm-none-eabi-arm9-gcc14.2/.libs/${lib_name}/include/")
	target_add_source_files_recurse(${target_name} "$ENV{cpp_lib_build_scripts_path}/arm-none-eabi-arm9-gcc14.2/.libs/${lib_name}/obj/")

	target_import_c_bsp_interface(${target_name} ${visibility})
endfunction()
