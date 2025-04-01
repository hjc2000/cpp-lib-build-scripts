function(target_import_stm32h743iit6_isr target_name visibility)
	set(lib_name "stm32h743iit6-isr")

	# 导入源码而不是预编译好的库
	target_import_src_root_path(${target_name} "${repos_path}/${lib_name}")

	target_import_base(${target_name} PUBLIC)
	target_import_bsp_interface(${target_name} PUBLIC)
	target_import_task(${target_name} PUBLIC)
	target_import_stm32h743iit6_hal(${target_name} PRIVATE)
endfunction()
