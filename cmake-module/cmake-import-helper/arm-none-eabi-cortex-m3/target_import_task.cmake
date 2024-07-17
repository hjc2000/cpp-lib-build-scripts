include(target_import_freertos)
include(target_import_bsp_interface)

function(target_import_task target_name visibility)
	# 解决循环依赖，所以前面链接一次，然后链接本库，接着后面再链接一次
	target_import_bsp_interface(${target_name} ${visibility})

    target_include_directories(${target_name} ${visibility} ${libs_path}/task/include/)
    target_auto_link_lib(${target_name} task ${libs_path}/task/lib/)
    install_dll_dir(${libs_path}/task/bin/)
	
	target_import_freertos(${target_name} ${visibility})

	# 解决循环依赖，所以前面链接一次，然后链接本库，接着后面再链接一次
	target_import_bsp_interface(${target_name} ${visibility})
endfunction()
