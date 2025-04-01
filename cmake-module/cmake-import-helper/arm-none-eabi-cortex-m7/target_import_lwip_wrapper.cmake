include(target_import_lwip)

function(target_import_lwip_wrapper target_name visibility)
	set(lib_name "lwip-wrapper")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_lwip(${target_name} ${visibility})
endfunction()
