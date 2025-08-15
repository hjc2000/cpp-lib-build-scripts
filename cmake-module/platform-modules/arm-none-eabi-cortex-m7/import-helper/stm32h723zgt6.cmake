# region target_import_stm32h723zgt6_hal

function(target_import_stm32h723zgt6_hal target_name visibility)
	target_compile_definitions(
		${target_name}
		${visibility}
		USE_HAL_DRIVER=1
		STM32H723xx=1
	)

	set(lib_name "stm32h723zgt6-hal")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")
endfunction()

# endregion


# region target_import_stm32h723zgt6_peripherals

function(target_import_stm32h723zgt6_peripherals target_name visibility)
	set(lib_name "stm32h723zgt6-peripherals")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")
endfunction()

# endregion


# region target_import_stm32h743_lvgl

function(target_import_stm32h743_lvgl target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/stm32h743-lvgl/include/)
	target_auto_link_lib(${target_name} stm32h743-lvgl ${libs_path}/stm32h743-lvgl/lib/)
endfunction()

# endregion


# region target_import_stm32h743iit6_p_net

function(target_import_stm32h743iit6_p_net target_name visibility)
	set(lib_name "stm32h743iit6-p-net")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")

	target_import_lwip(${target_name} ${visibility})
endfunction()

# endregion
