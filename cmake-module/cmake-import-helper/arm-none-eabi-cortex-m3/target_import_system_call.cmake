include(target_import_bsp_interface)

function(target_import_system_call target_name visibility)
	set(lib_name "system-call")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)

	target_link_libraries(${ProjectName} PUBLIC -Wl,--whole-archive)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)
	target_link_libraries(${ProjectName} PUBLIC -Wl,--no-whole-archive)

	target_import_bsp_interface(${target_name} ${visibility})
endfunction()
