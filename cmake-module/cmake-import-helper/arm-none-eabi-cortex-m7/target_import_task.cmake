include(target_import_freertos)
include(target_import_bsp_interface)

function(target_import_task target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/task/include/)
	target_auto_link_lib(${target_name} task ${libs_path}/task/lib/)

	target_import_freertos(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
endfunction()
