include(target_import_freertos)
include(target_import_bsp_interface)

function(target_import_task target_name visibility)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/task/include/)
	target_auto_link_lib(${target_name} task $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/task/lib/)

	target_import_freertos(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
endfunction()
