function(target_import_tsduck target_name visibility)
	set(lib_name "tsduck")

    target_include_directories(${target_name} ${visibility} "${libs_path}/${lib_name}/include/")
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")

	target_compile_definitions(${target_name} PRIVATE TS_NO_SRT=1)
	target_compile_definitions(${target_name} PRIVATE TS_NO_RIST=1)
	target_import_base(${target_name} ${visibility})
	target_link_libraries(${target_name} ${visibility} winmm Userenv Ws2_32)
endfunction()
