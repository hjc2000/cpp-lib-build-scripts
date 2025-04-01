function(target_import_stm32h743iit6_hal target_name visibility)
	target_compile_definitions(
		${target_name}
		${visibility}
		USE_HAL_DRIVER=1
		STM32H743xx=1
	)

	set(lib_name "stm32h743iit6-hal")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)
endfunction()




function(target_import_stm32h743iit6_peripherals target_name visibility)
	set(lib_name stm32h743iit6-peripherals)
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_stm32h743iit6_hal(${target_name} PRIVATE)
	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
endfunction()







function(target_import_stm32h743_lvgl target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/stm32h743-lvgl/include/)
	target_auto_link_lib(${target_name} stm32h743-lvgl ${libs_path}/stm32h743-lvgl/lib/)
endfunction()




function(target_import_stm32h743iit6_isr target_name visibility)
	set(lib_name "stm32h743iit6-isr")
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")
endfunction()





function(target_import_stm32h743iit6_p_net target_name visibility)
	set(lib_name "stm32h743iit6-p-net")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_lwip(${target_name} ${visibility})
endfunction()
