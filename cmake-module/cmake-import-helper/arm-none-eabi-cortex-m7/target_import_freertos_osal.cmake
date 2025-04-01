include(target_import_freertos)

function(target_import_freertos_osal target_name visibility)
	set(lib_name "freertos-osal")
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)

	target_import_freertos(${target_name} ${visibility})
endfunction()
